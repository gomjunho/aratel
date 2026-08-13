import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/insights_models.dart';
import '../services/insights_service.dart';

class InsightsScreen extends StatefulWidget {
  final InsightsService? insightsService;

  const InsightsScreen({super.key, this.insightsService});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> with SingleTickerProviderStateMixin {
  late final InsightsService _service;
  late final AnimationController _glowController;
  bool _isLoading = true;
  String? _errorMessage;
  InsightsResponse? _data;
  RangeValues _floorRange = const RangeValues(1, 35);

  @override
  void initState() {
    super.initState();
    _service = widget.insightsService ?? InsightsService();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _fetchInsights();
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _fetchInsights() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await _service.getInsights();
      setState(() {
        _data = res;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '인사이트 데이터를 불러올 수 없습니다: $e';
        _isLoading = false;
      });
    }
  }

  String _formatPrice(int price) {
    final billions = price / 100000000;
    return '${billions.toStringAsFixed(1)}억';
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toUpperCase()) {
      case 'LOW':
        return Colors.greenAccent;
      case 'MEDIUM':
        return Colors.orangeAccent;
      case 'HIGH':
        return Colors.redAccent;
      default:
        return const Color(0xFFD4AF37);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        title: const Text('실거래가 & 공급 물량 인사이트', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF161920),
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)));
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchInsights,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
              child: const Text('재시도', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    }

    final data = _data!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF161920),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.analytics_rounded, color: Color(0xFFD4AF37), size: 36),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.complexName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const Text('아실(ASIL) 빅데이터 분석 리포트', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Supply Gas Risk Index Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF161920),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('입주 물량 독성 지수 (Supply Gas Index)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getRiskColor(data.supplyGasIndex.riskLevel).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '공급 가스 리스크: ${data.supplyGasIndex.riskLevel}',
                        style: TextStyle(color: _getRiskColor(data.supplyGasIndex.riskLevel), fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('입주 예정 물량: ${data.supplyGasIndex.upcomingSupplyUnits}세대', style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(data.supplyGasIndex.analysisSummary, style: TextStyle(color: Colors.grey[300], fontSize: 13)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Animated Risk Gauge Meter Visualizer
                    SizedBox(
                      width: 70,
                      height: 50,
                      child: CustomPaint(
                        painter: _RiskGaugePainter(
                          riskLevel: data.supplyGasIndex.riskLevel,
                          color: _getRiskColor(data.supplyGasIndex.riskLevel),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Asil Scatter Chart Container
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('아실 층수별 실거래가 산점도', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              Text('층수 필터: ${_floorRange.start.round()}층 ~ ${_floorRange.end.round()}층', style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12)),
            ],
          ),
          RangeSlider(
            key: const Key('floor_range_slider'),
            values: _floorRange,
            min: 1,
            max: 35,
            divisions: 34,
            activeColor: const Color(0xFFD4AF37),
            inactiveColor: const Color(0xFF222630),
            onChanged: (RangeValues newValues) {
              setState(() {
                _floorRange = newValues;
              });
            },
          ),
          const SizedBox(height: 4),
          AnimatedBuilder(
            animation: _glowController,
            builder: (context, child) {
              final filteredTx = data.transactions.where((t) {
                return t.floor >= _floorRange.start && t.floor <= _floorRange.end;
              }).toList();

              return Container(
                height: 180,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF161920),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomPaint(
                  painter: _GlowScatterChartPainter(
                    transactions: filteredTx,
                    glowIntensity: _glowController.value,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Transaction list
          const Text('최근 실거래 기록', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...data.transactions.map((tx) {
            return Card(
              color: const Color(0xFF161920),
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF222630),
                  child: Text('${tx.floor}층', style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                title: Text(_formatPrice(tx.price), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text('계약일: ${tx.dealDate}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                trailing: const Icon(Icons.show_chart, color: Colors.greenAccent),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _GlowScatterChartPainter extends CustomPainter {
  final List<TransactionItem> transactions;
  final double glowIntensity;

  _GlowScatterChartPainter({required this.transactions, required this.glowIntensity});

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;

    // Draw grid lines
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), axisPaint);
    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), axisPaint);

    if (transactions.isEmpty) return;

    final maxFloor = transactions.map((t) => t.floor).reduce((a, b) => a > b ? a : b).toDouble();
    final minFloor = transactions.map((t) => t.floor).reduce((a, b) => a < b ? a : b).toDouble();
    final maxPrice = transactions.map((t) => t.price).reduce((a, b) => a > b ? a : b).toDouble();
    final minPrice = transactions.map((t) => t.price).reduce((a, b) => a < b ? a : b).toDouble();

    for (final tx in transactions) {
      final xRatio = maxFloor == minFloor ? 0.5 : (tx.floor - minFloor) / (maxFloor - minFloor);
      final yRatio = maxPrice == minPrice ? 0.5 : (tx.price - minPrice) / (maxPrice - minPrice);

      final x = 20 + xRatio * (size.width - 40);
      final y = size.height - (20 + yRatio * (size.height - 40));
      final center = Offset(x, y);

      // Outer glow halo
      final glowRadius = 14.0 + glowIntensity * 8.0;
      final glowOpacity = 0.15 + glowIntensity * 0.25;
      final glowPaint = Paint()
        ..color = const Color(0xFFD4AF37).withOpacity(glowOpacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius * 0.6);
      canvas.drawCircle(center, glowRadius, glowPaint);

      // Particle ring
      final particlePaint = Paint()
        ..color = const Color(0xFFD4AF37).withOpacity(0.5 + glowIntensity * 0.3)
        ..style = PaintingStyle.fill;
      for (int i = 0; i < 6; i++) {
        final angle = (i / 6) * 2 * math.pi + glowIntensity * math.pi;
        final px = x + math.cos(angle) * (10.0 + glowIntensity * 4.0);
        final py = y + math.sin(angle) * (10.0 + glowIntensity * 4.0);
        canvas.drawCircle(Offset(px, py), 2.0, particlePaint);
      }

      // Core dot
      final dotPaint = Paint()
        ..color = const Color(0xFFD4AF37)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, 6, dotPaint);

      // Inner shine
      final shinePaint = Paint()
        ..color = Colors.white.withOpacity(0.4 + glowIntensity * 0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x - 2, y - 2), 2.5, shinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GlowScatterChartPainter oldDelegate) =>
      oldDelegate.glowIntensity != glowIntensity;
}

class _RiskGaugePainter extends CustomPainter {
  final String riskLevel;
  final Color color;

  _RiskGaugePainter({required this.riskLevel, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.85);
    final radius = math.min(size.width / 2, size.height);

    final bgPaint = Paint()
      ..color = const Color(0xFF222630)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final gaugePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    // Draw background arc (180 degrees)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 4),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );

    // Calculate risk ratio
    double ratio = 0.25;
    if (riskLevel.toUpperCase() == 'MEDIUM') ratio = 0.6;
    if (riskLevel.toUpperCase() == 'HIGH') ratio = 0.9;

    // Draw active arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 4),
      math.pi,
      math.pi * ratio,
      false,
      gaugePaint,
    );

    // Draw pointer needle
    final needleAngle = math.pi + math.pi * ratio;
    final needlePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;
    canvas.drawLine(
      center,
      Offset(
        center.dx + (radius - 10) * math.cos(needleAngle),
        center.dy + (radius - 10) * math.sin(needleAngle),
      ),
      needlePaint,
    );
    canvas.drawCircle(center, 3, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _RiskGaugePainter oldDelegate) =>
      oldDelegate.riskLevel != riskLevel || oldDelegate.color != color;
}
