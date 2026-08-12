import 'package:flutter/material.dart';
import '../models/concierge_models.dart';
import '../services/concierge_service.dart';

class ConciergeScreen extends StatefulWidget {
  final ConciergeService? conciergeService;

  const ConciergeScreen({super.key, this.conciergeService});

  @override
  State<ConciergeScreen> createState() => _ConciergeScreenState();
}

class _ConciergeScreenState extends State<ConciergeScreen> {
  late final ConciergeService _service;
  String _selectedServiceType = 'WOORI_TWO_CHAIRS';
  final TextEditingController _dateController = TextEditingController(text: '2026-08-20');
  final TextEditingController _notesController = TextEditingController();
  bool _isSubmitting = false;
  ConciergeReservationResponse? _reservationResult;

  final Map<String, Map<String, dynamic>> _serviceOptions = {
    'WOORI_TWO_CHAIRS': {
      'title': 'WOORI TWO CHAIRS 자산관리',
      'subtitle': '우리은행 수석 자산관리사 1:1 패밀리오피스 & 증여/외환 컨설팅',
      'icon': Icons.account_balance_rounded,
    },
    'LUXURY_PEST_CONTROL': {
      'title': '하이엔드 주거 방역 & 위생',
      'subtitle': '초미세 항균 드라이 폼 & 바이러스 완전 멸균 솔루션',
      'icon': Icons.cleaning_services_rounded,
    },
    'HEALTH_CHECKUP': {
      'title': '프리미엄 정밀 건강검진',
      'subtitle': 'VIP 전용 쾌적 패스트트랙 정밀 검진 예약',
      'icon': Icons.local_hospital_rounded,
    },
    'ART_SUBSCRIPTION': {
      'title': '럭셔리 아트 구독 & 도슨트',
      'subtitle': '세계적인 거장 작품 렌탈 및 맞춤형 도슨트 큐레이션',
      'icon': Icons.palette_rounded,
    },
  };

  @override
  void initState() {
    super.initState();
    _service = widget.conciergeService ?? ConciergeService();
  }

  Future<void> _submitReservation() async {
    final date = _dateController.text.trim();
    if (date.isEmpty || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final res = await _service.createReservation(
        ConciergeReservationRequest(
          serviceType: _selectedServiceType,
          preferredDate: date,
          notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        ),
      );

      if (mounted) {
        setState(() {
          _reservationResult = res;
          _isSubmitting = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('예약 신청 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        title: const Text('VIP 컨시어지 서비스', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF161920),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('프라이빗 웰니스 & 컨시어지 선택', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._serviceOptions.entries.map((entry) {
              final key = entry.key;
              final info = entry.value;
              final isSelected = _selectedServiceType == key;

              return Card(
                key: Key('service_card_$key'),
                color: isSelected ? const Color(0xFF222630) : const Color(0xFF161920),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? const Color(0xFFD4AF37) : Colors.transparent,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap: () => setState(() => _selectedServiceType = key),
                  leading: CircleAvatar(
                    backgroundColor: isSelected ? const Color(0xFFD4AF37) : const Color(0xFF0F1115),
                    child: Icon(info['icon'] as IconData, color: isSelected ? Colors.black : const Color(0xFFD4AF37)),
                  ),
                  title: Text(info['title'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  subtitle: Text(info['subtitle'] as String, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFFD4AF37)) : null,
                ),
              );
            }),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF161920),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('예약 일시 & 요청 사항', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('preferred_date_input'),
                    controller: _dateController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: '희망 일자 (YYYY-MM-DD)',
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('reservation_notes_input'),
                    controller: _notesController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: '추가 요청사항 (자산상담 분야, 주거 타입 등)',
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      key: const Key('submit_reservation_button'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _isSubmitting ? null : _submitReservation,
                      child: _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text('컨시어지 예약 신청', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
            if (_reservationResult != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF4CAF50)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
                        SizedBox(width: 8),
                        Text('예약 확정 완료', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('예약 번호: ${_reservationResult!.reservationId}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    Text('배정 담당자: ${_reservationResult!.assignedConsultant}', style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('상태: ${_reservationResult!.status}', style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
