import 'package:flutter_test/flutter_test.dart';
import 'package:aratel_mobile/models/ai_agent_models.dart';

void main() {
  group('AiAgent Models Tests', () {
    test('ReservationDetails fromJson and toJson', () {
      final json = {
        'facility': '스카이라운지',
        'party_size': 2,
        'status': 'CONFIRMED',
      };
      final details = ReservationDetails.fromJson(json);

      expect(details.facility, '스카이라운지');
      expect(details.partySize, 2);
      expect(details.status, 'CONFIRMED');

      final serialized = details.toJson();
      expect(serialized['facility'], '스카이라운지');
      expect(serialized['party_size'], 2);
    });

    test('AiAgentRequest and AiAgentResponse', () {
      const req = AiAgentRequest(message: '라운지 조식 2명 예약해줘');
      final reqJson = req.toJson();
      expect(reqJson['message'], '라운지 조식 2명 예약해줘');
      expect(AiAgentRequest.fromJson(reqJson).message, req.message);

      final resJson = {
        'reply': '네, 디에이치 방배 스카이라운지 조식 2명 예약이 완료되었습니다.',
        'action_executed': 'RESERVE_BREAKFAST',
        'reservation_details': {
          'facility': '스카이라운지',
          'party_size': 2,
          'status': 'CONFIRMED'
        }
      };

      final res = AiAgentResponse.fromJson(resJson);
      expect(res.reply, contains('완료되었습니다'));
      expect(res.actionExecuted, 'RESERVE_BREAKFAST');
      expect(res.reservationDetails?.facility, '스카이라운지');

      final resSerialized = res.toJson();
      expect(resSerialized['action_executed'], 'RESERVE_BREAKFAST');
    });
  });
}
