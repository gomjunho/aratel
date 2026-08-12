import 'package:flutter/material.dart';
import '../models/insights_models.dart';
import '../services/insights_service.dart';

class InsightsScreen extends StatefulWidget {
  final InsightsService? insightsService;

  const InsightsScreen({super.key, this.insightsService});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late final InsightsService _service;
  bool _isLoading = true;
  String? _errorMessage;
  InsightsResponse? _data;

  @override
  void initState() {
    super.initState();
    _service = widget.insightsService ?? InsightsService();
    _fetchInsights();
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
                Text('입주 예정 물량: ${data.supplyGasIndex.upcomingSupplyUnits}세대', style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(data.supplyGasIndex.analysisSummary, style: TextStyle(color: Colors.grey[300], fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Asil Scatter Chart Container
          const Text('아실 층수별 실거래가 산점도', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            height: 180,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF161920),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomPaint(
              painter: _ScatterChartPainter(transactions: data.transactions),
            ),
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

class _ScatterChartPainter extends CustomPainter {
  final List<TransactionItem> transactions;

  _ScatterChartPainter({required this.transactions});

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;

    final dotPaint = Paint()
      ..color = const Color(0xFFD4AF37)
      ..style = PaintingStyle.fill;

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

      canvas.drawCircle(Offset(x, y), 8, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ScatterChartPainter oldDelegate) => true;
}
