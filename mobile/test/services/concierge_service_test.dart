import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:aratel_mobile/services/concierge_service.dart';
import 'package:aratel_mobile/models/concierge_models.dart';

void main() {
  group('ConciergeService Tests', () {
    test('createReservation returns ConciergeReservationResponse on 201', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/v1/concierge/reservations');
        expect(request.method, 'POST');
        final body = jsonDecode(request.body);
        expect(body['service_type'], 'WOORI_TWO_CHAIRS');

        return http.Response(
          jsonEncode({
            'reservation_id': 'res_7710',
            'service_type': 'WOORI_TWO_CHAIRS',
            'status': 'CONFIRMED',
            'assigned_consultant': '우리은행 TWO CHAIRS 수석 자산관리사'
          }),
          201,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = ConciergeService(client: mockClient);
      final res = await service.createReservation(
        const ConciergeReservationRequest(
          serviceType: 'WOORI_TWO_CHAIRS',
          preferredDate: '2026-08-20',
          notes: '상담 희망',
        ),
      );

      expect(res.reservationId, 'res_7710');
      expect(res.status, 'CONFIRMED');
      expect(res.assignedConsultant, contains('자산관리사'));
    });

    test('createReservation throws Exception on error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      final service = ConciergeService(client: mockClient);
      expect(
        () => service.createReservation(
          const ConciergeReservationRequest(
            serviceType: 'HEALTH_CHECKUP',
            preferredDate: '2026-08-20',
          ),
        ),
        throwsException,
      );
    });
  });
}
