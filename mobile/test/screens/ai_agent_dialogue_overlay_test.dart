import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:aratel_mobile/screens/ai_agent_dialogue_overlay.dart';
import 'package:aratel_mobile/services/ai_agent_service.dart';
import 'package:aratel_mobile/models/screen_context.dart';

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
      await tester.pump(const Duration(milliseconds: 300));

      final sendBtn = find.byKey(const Key('ai_send_button'));
      await tester.tap(sendBtn);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 300));

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
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.textContaining('AI 응답 처리 중 오류가 발생했습니다'), findsOneWidget);
    });

    group('Context-Aware AI Tests (#30)', () {
      testWidgets('shows context banner when screenContext is provided', (WidgetTester tester) async {
        final mockClient = MockClient((request) async {
          return http.Response(
            jsonEncode({'reply': '인사이트 화면 관련 답변입니다.', 'action_executed': 'NONE'}),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        });

        final aiService = AiAgentService(client: mockClient);
        const ctx = ScreenContext(tabIndex: 3, screenName: '자산증식 인사이트');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AiAgentDialogueOverlay(
                aiAgentService: aiService,
                screenContext: ctx,
              ),
            ),
          ),
        );
        await tester.pump();

        // Context banner should be visible
        expect(find.byKey(const Key('ai_context_banner')), findsOneWidget);
        expect(find.textContaining('자산증식 인사이트'), findsWidgets);
      });

      testWidgets('no context banner without screenContext', (WidgetTester tester) async {
        final mockClient = MockClient((request) async {
          return http.Response(
            jsonEncode({'reply': '기본 답변', 'action_executed': 'NONE'}),
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
        await tester.pump();

        expect(find.byKey(const Key('ai_context_banner')), findsNothing);
      });

      testWidgets('context-aware greeting references screen name', (WidgetTester tester) async {
        final mockClient = MockClient((request) async {
          return http.Response(
            jsonEncode({'reply': '답변', 'action_executed': 'NONE'}),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        });

        final aiService = AiAgentService(client: mockClient);
        const ctx = ScreenContext(tabIndex: 2, screenName: 'VVIP 큐레이션');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AiAgentDialogueOverlay(
                aiAgentService: aiService,
                screenContext: ctx,
              ),
            ),
          ),
        );
        await tester.pump();

        // Greeting should mention the current screen name
        expect(find.textContaining('VVIP 큐레이션'), findsWidgets);
      });

      testWidgets('proactive suggestion chips are context-specific', (WidgetTester tester) async {
        final mockClient = MockClient((request) async {
          return http.Response(
            jsonEncode({'reply': '답변', 'action_executed': 'NONE'}),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        });

        final aiService = AiAgentService(client: mockClient);
        // Tab 3 = 자산증식 인사이트 → should show insights-specific chips
        const ctx = ScreenContext(tabIndex: 3, screenName: '자산증식 인사이트');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AiAgentDialogueOverlay(
                aiAgentService: aiService,
                screenContext: ctx,
              ),
            ),
          ),
        );
        await tester.pump();

        // Chips row present
        expect(find.byKey(const Key('ai_suggestion_chips_row')), findsOneWidget);
        // Insights-specific chip
        expect(find.textContaining('공급가스 지수'), findsOneWidget);
      });

      testWidgets('1-tap chip sends message immediately', (WidgetTester tester) async {
        String? capturedMessage;
        final mockClient = MockClient((request) async {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          capturedMessage = body['message'] as String;
          return http.Response(
            jsonEncode({'reply': '리스크 지수 분석 완료', 'action_executed': 'INSIGHTS_QUERY'}),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        });

        final aiService = AiAgentService(client: mockClient);
        const ctx = ScreenContext(tabIndex: 3, screenName: '자산증식 인사이트');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AiAgentDialogueOverlay(
                aiAgentService: aiService,
                screenContext: ctx,
              ),
            ),
          ),
        );
        await tester.pump();

        // Tap the risk chip (chip key = first 4 chars of chip text = '리스크 ')
        await tester.tap(find.widgetWithText(ActionChip, '리스크 지수 높은 단지 어디야'));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 300));

        expect(capturedMessage, contains('리스크'));
        expect(find.textContaining('리스크 지수 분석 완료'), findsOneWidget);
      });

      testWidgets('screen_context is included in API request payload', (WidgetTester tester) async {
        Map<String, dynamic>? capturedBody;
        final mockClient = MockClient((request) async {
          capturedBody = jsonDecode(request.body) as Map<String, dynamic>;
          return http.Response(
            jsonEncode({'reply': '확인', 'action_executed': 'NONE'}),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        });

        final aiService = AiAgentService(client: mockClient);
        const ctx = ScreenContext(
          tabIndex: 1,
          screenName: '커뮤니티 라운지',
          metadata: {'category': 'anonymous'},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AiAgentDialogueOverlay(
                aiAgentService: aiService,
                screenContext: ctx,
              ),
            ),
          ),
        );
        await tester.pump();

        await tester.enterText(find.byKey(const Key('ai_input_field')), '테스트');
        await tester.tap(find.byKey(const Key('ai_send_button')));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 300));

        // Verify screen_context was serialized and sent
        expect(capturedBody, isNotNull);
        expect(capturedBody!['screen_context'], isNotNull);
        expect(capturedBody!['screen_context']['tab_index'], equals(1));
        expect(capturedBody!['screen_context']['screen_name'], equals('커뮤니티 라운지'));
      });
    });
  });
}
