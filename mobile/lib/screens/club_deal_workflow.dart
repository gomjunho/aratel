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
    final pointsController = TextEditingController(text: '0');

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161920),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final usedPoints = int.tryParse(pointsController.text) ?? 0;
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
                  Text(
                    '클럽딜 공동 구매 신청',
                    style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(deal.itemName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('${deal.brand} | 할인가: ${deal.dealPrice}원 (원가 ${deal.originalPrice}원)', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 16),
                  TextField(
                    key: const Key('points_input_field'),
                    controller: pointsController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: '사용할 ARATEL 포인트 (최대 ${deal.pointDiscountLimit}P)',
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    ),
                    onChanged: (val) {
                      setModalState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('최종 현금 결제 금액:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text('$cashAmount원', style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 18, fontWeight: FontWeight.bold)),
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
                    Text(deal.status, style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 12)),
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
    int currentStep = 1;
    if (status.contains('COMPLETED') || status.contains('배송완료')) {
      currentStep = 4;
    } else if (status.contains('SHIPPING') || status.contains('배송중')) {
      currentStep = 3;
    } else if (status.contains('ORDERED') || status.contains('주문완료')) {
      currentStep = 2;
    }

    final steps = ['모집중', '주문완료', '배송중', '배송완료'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1115),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (idx) {
          final stepNum = idx + 1;
          final isPassed = stepNum <= currentStep;
          final isCurrent = stepNum == currentStep;

          return Row(
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: isCurrent
                        ? const Color(0xFFD4AF37)
                        : (isPassed ? const Color(0xFF4CAF50) : const Color(0xFF222630)),
                    child: Text(
                      '$stepNum',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: (isCurrent || isPassed) ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    steps[idx],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isCurrent
                          ? const Color(0xFFD4AF37)
                          : (isPassed ? Colors.white70 : Colors.grey),
                    ),
                  ),
                ],
              ),
              if (idx < steps.length - 1)
                Container(
                  width: 20,
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  color: isPassed ? const Color(0xFF4CAF50) : const Color(0xFF222630),
                ),
            ],
          );
        }),
      ),
    );
  }
}
