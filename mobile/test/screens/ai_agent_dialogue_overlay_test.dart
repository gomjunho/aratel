import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:aratel_mobile/screens/ai_agent_dialogue_overlay.dart';
import 'package:aratel_mobile/services/ai_agent_service.dart';

void main() {
  group('AiAgentDialogueOverlay Widget Tests', () {
    testWidgets('sends message and displays AI reply with reservation details', (WidgetTester tester) async {
      final mockClient = MockClient((request) async {
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

      final aiService = AiAgentService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AiAgentDialogueOverlay(aiAgentService: aiService),
          ),
        ),
      );

      // Verify overlay title
      expect(find.text('ARATEL AI 에이전트'), findsOneWidget);

      // Input dialogue message
      final input = find.byKey(const Key('ai_input_field'));
      expect(input, findsOneWidget);
      await tester.enterText(input, '라운지 조식 2명 예약해줘');
      await tester.pumpAndSettle();

      final sendBtn = find.byKey(const Key('ai_send_button'));
      await tester.tap(sendBtn);
      await tester.pumpAndSettle();

      // Verify conversation responses
      expect(find.text('라운지 조식 2명 예약해줘'), findsOneWidget);
      expect(find.textContaining('완료되었습니다'), findsOneWidget);
      expect(find.textContaining('실행 액션: RESERVE_BREAKFAST'), findsOneWidget);
      expect(find.textContaining('시설: 스카이라운지 (2명)'), findsOneWidget);
    });

    testWidgets('displays error message on service failure', (WidgetTester tester) async {
      final mockClient = MockClient((request) async {
        return http.Response('Error', 500);
      });

      final aiService = AiAgentService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AiAgentDialogueOverlay(aiAgentService: aiService),
          ),
        ),
      );

      final input = find.byKey(const Key('ai_input_field'));
      await tester.enterText(input, '오류 테스트');
      await tester.tap(find.byKey(const Key('ai_send_button')));
      await tester.pumpAndSettle();

      expect(find.textContaining('AI 응답 처리 중 오류가 발생했습니다'), findsOneWidget);
    });
  });
}
