import 'package:flutter/material.dart';
import '../models/club_deal_models.dart';
import '../services/club_deal_service.dart';

class ClubDealWorkflowWidget extends StatefulWidget {
  final ClubDealService? clubDealService;

  const ClubDealWorkflowWidget({super.key, this.clubDealService});

  @override
  State<ClubDealWorkflowWidget> createState() => _ClubDealWorkflowWidgetState();
}

class _ClubDealWorkflowWidgetState extends State<ClubDealWorkflowWidget> {
  late final ClubDealService _service;
  bool _isLoading = true;
  String? _errorMessage;
  List<ClubDeal> _deals = [];

  @override
  void initState() {
    super.initState();
    _service = widget.clubDealService ?? ClubDealService();
    _fetchDeals();
  }

  Future<void> _fetchDeals() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await _service.getClubDeals();
      setState(() {
        _deals = res.clubDeals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '클럽 딜 목록을 불러올 수 없습니다: $e';
        _isLoading = false;
      });
    }
  }

  void _showOrderModal(ClubDeal deal) {
    double sliderValue = 0.0;
    final maxLimit = deal.pointDiscountLimit > 0 ? deal.pointDiscountLimit.toDouble() : 1000.0;
    final divisions = (maxLimit / 1000.0).clamp(1, 100).toInt();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161920),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final usedPoints = sliderValue.toInt();
            final cashAmount = (deal.dealPrice - usedPoints).clamp(0, deal.dealPrice);

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'VVIP 클럽딜 공동 구매',
                        style: TextStyle(color: Color(0xFFD4AF37), fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white54),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(deal.itemName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('${deal.brand} | 할인가: ${deal.dealPrice}원 (원가 ${deal.originalPrice}원)', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1115),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('포인트 차감 슬라이더', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                            Text('${usedPoints.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} P', style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: const Color(0xFFD4AF37),
                            inactiveTrackColor: Colors.grey[800],
                            thumbColor: const Color(0xFFD4AF37),
                            overlayColor: const Color(0xFFD4AF37).withOpacity(0.2),
                          ),
                          child: Slider(
                            key: const Key('point_calculator_slider'),
                            value: sliderValue,
                            min: 0.0,
                            max: maxLimit,
                            divisions: divisions,
                            label: '${usedPoints}P',
                            onChanged: (val) {
                              setModalState(() {
                                sliderValue = val;
                              });
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('0 P', style: TextStyle(color: Colors.grey, fontSize: 11)),
                            Text('최대 ${maxLimit.toInt()} P', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('최종 결제 금액:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('${cashAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}원', style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      key: const Key('confirm_order_button'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        try {
                          final res = await _service.placeOrder(
                            deal.id,
                            ClubDealOrderRequest(usedPoints: usedPoints, cashAmount: cashAmount),
                          );
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('주문이 완료되었습니다 (주문번호: ${res.orderId}, 잔여포인트 ${res.remainingPoints}P)'),
                              ),
                            );
                            _fetchDeals();
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('주문 실패: $e')),
                            );
                          }
                        }
                      },
                      child: const Text('공동구매 신청하기', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: _fetchDeals,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
              child: const Text('재시도', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _deals.length,
      itemBuilder: (context, index) {
        final deal = _deals[index];
        final progressRatio = deal.currentParticipants / deal.minParticipants;

        return Card(
          color: const Color(0xFF161920),
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('VVIP CLUB DEAL', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, color: Colors.orangeAccent, size: 14),
                        const SizedBox(width: 4),
                        const Text('⏱️ 딜 종료 14:25:38', style: TextStyle(color: Colors.orangeAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(deal.itemName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${deal.brand} 프라이빗 공동 오더', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('${deal.dealPrice}원', style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text(
                      '${deal.originalPrice}원',
                      style: const TextStyle(color: Colors.grey, fontSize: 13, decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progressRatio.clamp(0.0, 1.0),
                  backgroundColor: const Color(0xFF0F1115),
                  color: const Color(0xFFD4AF37),
                  minHeight: 6,
                ),
                const SizedBox(height: 4),
                Text(
                  '참여 현황: ${deal.currentParticipants} / ${deal.minParticipants}명 달성',
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 12),
                _buildOrderStatusStepper(deal.status),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: Key('deal_order_button_${deal.id}'),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
                    onPressed: () => _showOrderModal(deal),
                    child: const Text('클럽 딜 참가', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderStatusStepper(String status) {
    int currentStep = 2;
    if (status.contains('COMPLETED') || status.contains('설치완료')) {
      currentStep = 4;
    } else if (status.contains('SHIPPING') || status.contains('직배송')) {
      currentStep = 3;
    } else if (status.contains('CONFIRMED') || status.contains('수량확정')) {
      currentStep = 2;
    }

    final steps = ['주문 완료', '단지 수량 확정', '이탈리아 직배송', '전문 기사 방문 설치'];
    final timestamps = ['08.13 14:00', '08.14 09:00', '예정 08.20', '예정 08.25'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1115),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('주문 이력 라이브 타임라인', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(steps.length, (idx) {
              final stepNum = idx + 1;
              final isPassed = stepNum <= currentStep;
              final isCurrent = stepNum == currentStep;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: isCurrent
                                ? const Color(0xFFD4AF37)
                                : (isPassed ? const Color(0xFF4CAF50) : const Color(0xFF222630)),
                            child: Text(
                              '$stepNum',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: (isCurrent || isPassed) ? Colors.black : Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            steps[idx],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                              color: isCurrent
                                  ? const Color(0xFFD4AF37)
                                  : (isPassed ? Colors.white70 : Colors.grey),
                            ),
                          ),
                          Text(
                            timestamps[idx],
                            style: const TextStyle(fontSize: 8, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    if (idx < steps.length - 1)
                      Container(
                        width: 10,
                        height: 2,
                        color: isPassed ? const Color(0xFF4CAF50) : const Color(0xFF222630),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
