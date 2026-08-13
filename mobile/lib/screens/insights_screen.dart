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
  String _selectedArea = 'ALL';
  double _zoomLevel = 1.0;

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

  void _showSupplyGasDetailSheet() {
    final data = _data?.supplyGasIndex;
    if (data == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161920),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('공급 물량 독성 지수 상세 리포트', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close, color: Colors.white54), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const SizedBox(height: 12),
              Text('입주 예정 물량: ${data.upcomingSupplyUnits}세대', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('공급가스 위험 단계: ${data.riskLevel}', style: TextStyle(color: _getRiskColor(data.riskLevel), fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(data.analysisSummary, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F1115),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFFD4AF37), size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '아실 빅데이터 엔진이 인근 반경 3km 내 입주예정 단지 분양권 전매 물량을 실시간 산출합니다.',
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTransactionDetailModal(TransactionItem tx) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF161920),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.4)),
          ),
          title: const Text('실거래 상세 계약 정보', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 16, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('거래가: ${_formatPrice(tx.price)} (${tx.price}원)', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('계약일자: ${tx.dealDate}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
              Text('층수: ${tx.floor}층 (고층 프리미엄)', style: const TextStyle(color: Colors.grey, fontSize: 13)),
              Text('전용면적: ${_selectedArea == 'ALL' ? '84㎡' : _selectedArea}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
              Text('단지명: ${_data?.complexName ?? "디에이치 방배"}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('확인', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
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

          // Supply Gas Risk Index Card with Clickable Badge
          InkWell(
            key: const Key('supply_gas_card_button'),
            onTap: _showSupplyGasDetailSheet,
            borderRadius: BorderRadius.circular(12),
            child: Container(
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
                          '상세 리포트: ${data.supplyGasIndex.riskLevel}',
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
          ),
          const SizedBox(height: 20),

          // Area Size Filter Switcher Chips
          const Text('평형별 세그먼트 스위처', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildAreaChip('ALL', '전체 평형'),
                const SizedBox(width: 6),
                _buildAreaChip('59㎡', '59㎡ (25평)'),
                const SizedBox(width: 6),
                _buildAreaChip('84㎡', '84㎡ (34평)'),
                const SizedBox(width: 6),
                _buildAreaChip('114㎡', '114㎡ (45평)'),
                const SizedBox(width: 6),
                _buildAreaChip('164㎡', '164㎡ (펜트하우스)'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Zoom Scale & Floor Range
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('층수별 산점도 줌 슬라이더', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.zoom_out, color: Color(0xFFD4AF37), size: 20),
                    onPressed: () {
                      setState(() {
                        _zoomLevel = (_zoomLevel - 0.25).clamp(1.0, 3.0);
                      });
                    },
                  ),
                  Text('${_zoomLevel.toStringAsFixed(1)}x', style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.zoom_in, color: Color(0xFFD4AF37), size: 20),
                    onPressed: () {
                      setState(() {
                        _zoomLevel = (_zoomLevel + 0.25).clamp(1.0, 3.0);
                      });
                    },
                  ),
                ],
              ),
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
                child: GestureDetector(
                  onTapUp: (details) {
                    if (filteredTx.isNotEmpty) {
                      _showTransactionDetailModal(filteredTx.first);
                    }
                  },
                  child: CustomPaint(
                    painter: _GlowScatterChartPainter(
                      transactions: filteredTx,
                      glowIntensity: _glowController.value,
                      zoomLevel: _zoomLevel,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Transaction list
          const Text('최근 실거래 기록', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...data.transactions.where((t) => t.floor >= _floorRange.start && t.floor <= _floorRange.end).map((tx) {
            return Card(
              color: const Color(0xFF161920),
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                onTap: () => _showTransactionDetailModal(tx),
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

  Widget _buildAreaChip(String value, String label) {
    final isSelected = _selectedArea == value;
    return ChoiceChip(
      key: Key('area_chip_$value'),
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white70,
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedColor: const Color(0xFFD4AF37),
      backgroundColor: const Color(0xFF161920),
      onSelected: (_) {
        setState(() {
          _selectedArea = value;
        });
      },
    );
  }
}

class _GlowScatterChartPainter extends CustomPainter {
  final List<TransactionItem> transactions;
  final double glowIntensity;
  final double zoomLevel;

  _GlowScatterChartPainter({
    required this.transactions,
    required this.glowIntensity,
    required this.zoomLevel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;

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

      final rawX = 20 + xRatio * (size.width - 40);
      final rawY = size.height - (20 + yRatio * (size.height - 40));

      final centerX = size.width / 2;
      final centerY = size.height / 2;

      final x = centerX + (rawX - centerX) * zoomLevel;
      final y = centerY + (rawY - centerY) * zoomLevel;
      final center = Offset(x, y);

      // Outer glow halo
      final glowRadius = (14.0 + glowIntensity * 8.0) * zoomLevel;
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
        final px = x + math.cos(angle) * (10.0 + glowIntensity * 4.0) * zoomLevel;
        final py = y + math.sin(angle) * (10.0 + glowIntensity * 4.0) * zoomLevel;
        canvas.drawCircle(Offset(px, py), 2.0 * zoomLevel, particlePaint);
      }

      // Core dot
      final dotPaint = Paint()
        ..color = const Color(0xFFD4AF37)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, 6 * zoomLevel, dotPaint);

      // Inner shine
      final shinePaint = Paint()
        ..color = Colors.white.withOpacity(0.4 + glowIntensity * 0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x - 2, y - 2), 2.5 * zoomLevel, shinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GlowScatterChartPainter oldDelegate) =>
      oldDelegate.glowIntensity != glowIntensity || oldDelegate.zoomLevel != zoomLevel;
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

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 4),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );

    double ratio = 0.25;
    if (riskLevel.toUpperCase() == 'MEDIUM') ratio = 0.6;
    if (riskLevel.toUpperCase() == 'HIGH') ratio = 0.9;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 4),
      math.pi,
      math.pi * ratio,
      false,
      gaugePaint,
    );

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
