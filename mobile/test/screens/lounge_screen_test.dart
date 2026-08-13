import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:aratel_mobile/screens/lounge_screen.dart';
import 'package:aratel_mobile/services/lounge_service.dart';

void main() {
  group('LoungeScreen Widget Tests', () {
    late LoungeService loungeService;

    testWidgets('renders post list and allows creating post', (WidgetTester tester) async {
      final mockClient = MockClient((request) async {
        if (request.method == 'GET' && request.url.path == '/api/v1/lounge/posts') {
          return http.Response(
            jsonEncode({
              'posts': [
                {
                  'id': 'post_7001',
                  'anonymous_nickname': '은밀한 자산가 42',
                  'verified_badge': 'VERIFIED_OWNER',
                  'tier': 'DIAMOND',
                  'complex_name': '디에이치 방배',
                  'title': '2026 하반기 종합소득세 및 증여 절세 노하우',
                  'content_encrypted': 'EncryptedBodyPayload...',
                  'is_diamond_weighted': true,
                  'trust_score': 98,
                  'created_at': '2026-08-13T01:50:00Z'
                }
              ]
            }),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        } else if (request.method == 'POST' && request.url.path == '/api/v1/lounge/posts') {
          return http.Response(
            jsonEncode({
              'id': 'post_7002',
              'clean_signal_verified': true,
              'earned_points': 50,
              'status': 'PUBLISHED',
            }),
            201,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }
        return http.Response('Not Found', 404);
      });

      loungeService = LoungeService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: LoungeScreen(loungeService: loungeService),
        ),
      );

      // Loading state
      expect(find.byKey(const Key('skeleton_loader')), findsOneWidget);
      await tester.pumpAndSettle();

      // Check displayed post
      expect(find.text('2026 하반기 종합소득세 및 증여 절세 노하우'), findsOneWidget);
      expect(find.textContaining('은밀한 자산가 42'), findsOneWidget);
      expect(find.textContaining('DIAMOND'), findsOneWidget);
      expect(find.textContaining('신뢰도 98점'), findsOneWidget);

      // Tap floating action button to create post
      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);
      await tester.tap(fab);
      await tester.pumpAndSettle();

      // Check dialog fields
      expect(find.text('익명 게시글 작성'), findsOneWidget);
      final titleField = find.byKey(const Key('post_title_input'));
      final contentField = find.byKey(const Key('post_content_input'));

      await tester.enterText(titleField, '새 게시글');
      await tester.enterText(contentField, '새 게시글 내용입니다.');
      await tester.pumpAndSettle();

      final submitBtn = find.byKey(const Key('submit_post_button'));
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      // Check success snackbar
      expect(find.textContaining('게시글이 게시되었습니다'), findsOneWidget);
    });

    testWidgets('handles error state gracefully', (WidgetTester tester) async {
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      loungeService = LoungeService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: LoungeScreen(loungeService: loungeService),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('게시글을 불러올 수 없습니다'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget); // Refresh/Retry button
    });

    testWidgets('renders filter chips and skeleton loader when loading', (WidgetTester tester) async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'posts': []}),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      loungeService = LoungeService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: LoungeScreen(loungeService: loungeService),
        ),
      );

      // Loading state displays skeleton loader
      expect(find.byKey(const Key('skeleton_loader')), findsOneWidget);
      await tester.pumpAndSettle();

      // Sub-tab filter chips are visible
      expect(find.text('전체 모아보기'), findsOneWidget);
      expect(find.text('VVIP 암호화'), findsOneWidget);
    });
  });
}
