import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:aratel_mobile/services/ai_agent_service.dart';
import 'package:aratel_mobile/models/ai_agent_models.dart';

void main() {
  group('AiAgentService Tests', () {
    test('sendDialogue returns AiAgentResponse on 200', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/v1/ai/agent_dialogue');
        expect(request.method, 'POST');
        final body = jsonDecode(request.body);
        expect(body['message'], '라운지 조식 2명 예약해줘');

        return http.Response(
          jsonEncode({
            'reply': '네, 디에이치 방배 스카이라운지 조식 2명 예약이 완료되었습니다.',
            'action_executed': 'RESERVE_BREAKFAST',
            'reservation_details': {
              'facility': '스카이라운지',
              'party_size': 2,
              'status': 'CONFIRMED'
            }
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = AiAgentService(client: mockClient);
      final response = await service.sendDialogue(
        const AiAgentRequest(message: '라운지 조식 2명 예약해줘'),
      );

      expect(response.reply, contains('예약이 완료되었습니다'));
      expect(response.actionExecuted, 'RESERVE_BREAKFAST');
      expect(response.reservationDetails?.partySize, 2);
    });

    test('sendDialogue throws Exception on error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server error', 500);
      });

      final service = AiAgentService(client: mockClient);
      expect(
        () => service.sendDialogue(const AiAgentRequest(message: '예약')),
        throwsException,
      );
    });
  });
}
