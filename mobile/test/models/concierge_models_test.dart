import 'package:flutter_test/flutter_test.dart';
import 'package:aratel_mobile/models/concierge_models.dart';

void main() {
  group('Concierge Models Tests', () {
    test('ConciergeReservationRequest and ConciergeReservationResponse', () {
      const req = ConciergeReservationRequest(
        serviceType: 'WOORI_TWO_CHAIRS',
        preferredDate: '2026-08-20',
        notes: '자산 증여 및 외환 법률 상담 희망',
      );

      final reqJson = req.toJson();
      expect(reqJson['service_type'], 'WOORI_TWO_CHAIRS');
      expect(reqJson['preferred_date'], '2026-08-20');
      expect(reqJson['notes'], '자산 증여 및 외환 법률 상담 희망');
      expect(ConciergeReservationRequest.fromJson(reqJson).serviceType, 'WOORI_TWO_CHAIRS');

      final resJson = {
        'reservation_id': 'res_7710',
        'service_type': 'WOORI_TWO_CHAIRS',
        'status': 'CONFIRMED',
        'assigned_consultant': '우리은행 TWO CHAIRS 수석 자산관리사',
      };

      final res = ConciergeReservationResponse.fromJson(resJson);
      expect(res.reservationId, 'res_7710');
      expect(res.serviceType, 'WOORI_TWO_CHAIRS');
      expect(res.status, 'CONFIRMED');
      expect(res.assignedConsultant, contains('수석 자산관리사'));
      expect(res.toJson()['reservation_id'], 'res_7710');
    });
  });
}
