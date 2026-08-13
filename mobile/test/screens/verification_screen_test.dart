import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:aratel_mobile/screens/verification_screen.dart';
import 'package:aratel_mobile/services/verification_service.dart';
import 'package:aratel_mobile/services/security_service.dart';

void main() {
  const baseUrl = 'https://api.aratel.com';
  const jsonHeaders = {'content-type': 'application/json; charset=utf-8'};

  Widget buildTestableWidget({
    required VerificationService verificationService,
    required SecurityService securityService,
  }) {
    return MaterialApp(
      home: VerificationScreen(
        verificationService: verificationService,
        securityService: securityService,
      ),
    );
  }

  void configureTestSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
  }

  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  group('VerificationScreen Widget Tests', () {
    late SecurityService securityService;

    setUp(() {
      securityService = SecurityService();
    });

    testWidgets('renders initial Step 1 Identity Auth UI and handles user tier load error silently', (WidgetTester tester) async {
      configureTestSurface(tester);
      final mockClient = MockClient((request) async {
        if (request.url.path.contains('/users/me/tier')) {
          return http.Response('Server Error', 500);
        }
        return http.Response(
          jsonEncode({
            'user_id': 'usr_1001',
            'tier': 'GOLD',
            'badges': ['VERIFIED_OWNER'],
            'complex_name': '디에이치 방배',
            'building_unit': '101동 1502호',
            'security_profile': {'screen_capture_prevented': true, 'privacy_masked': true},
          }),
          200,
          headers: jsonHeaders,
        );
      });

      final service = VerificationService(baseUrl: baseUrl, client: mockClient);

      await tester.pumpWidget(buildTestableWidget(
        verificationService: service,
        securityService: securityService,
      ));
      await tester.pumpAndSettle();

      expect(find.text('자산 인증 센터'), findsOneWidget);
      expect(find.text('휴대폰 본인확인'), findsWidgets);
    });

    testWidgets('completes Step 1 Identity Auth and moves to Step 2 Registry Sync', (WidgetTester tester) async {
      configureTestSurface(tester);
      final mockClient = MockClient((request) async {
        if (request.url.path.contains('/users/me/tier')) {
          return http.Response(
            jsonEncode({
              'user_id': 'usr_1001',
              'tier': 'UNVERIFIED',
              'badges': [],
              'complex_name': '미인증',
              'building_unit': '-',
              'security_profile': {'screen_capture_prevented': true, 'privacy_masked': true},
            }),
            200,
            headers: jsonHeaders,
          );
        }
        if (request.url.path.contains('/auth/identity_verify')) {
          return http.Response(
            jsonEncode({
              'status': 'success',
              'verification_token': 'ver_tok_8f9a2b1c',
              'masked_name': '홍*동',
              'verified_at': '2026-08-13T01:32:00Z',
            }),
            200,
            headers: jsonHeaders,
          );
        }
        return http.Response('Not Found', 404);
      });

      final service = VerificationService(baseUrl: baseUrl, client: mockClient);

      await tester.pumpWidget(buildTestableWidget(
        verificationService: service,
        securityService: securityService,
      ));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('input_name')), '홍길동');
      await tester.enterText(find.byKey(const Key('input_phone')), '01012345678');
      await tester.enterText(find.byKey(const Key('input_birth')), '19800101');
      await tapAndSettle(tester, find.byKey(const Key('btn_identity_verify')));

      expect(find.text('1분 자동 등기부 연동'), findsWidgets);
      expect(find.byKey(const Key('input_complex_name')), findsOneWidget);
      expect(find.byKey(const Key('input_building_number')), findsOneWidget);
      expect(find.byKey(const Key('input_unit_number')), findsOneWidget);
    });

    testWidgets('completes Step 2 Registry Sync and moves to Step 3 Evidence & Delegated Access', (WidgetTester tester) async {
      configureTestSurface(tester);
      final mockClient = MockClient((request) async {
        if (request.url.path.contains('/users/me/tier')) {
          return http.Response(
            jsonEncode({
              'user_id': 'usr_1001',
              'tier': 'UNVERIFIED',
              'badges': [],
              'complex_name': '미인증',
              'building_unit': '-',
              'security_profile': {'screen_capture_prevented': true, 'privacy_masked': true},
            }),
            200,
            headers: jsonHeaders,
          );
        }
        if (request.url.path.contains('/auth/identity_verify')) {
          return http.Response(
            jsonEncode({
              'status': 'success',
              'verification_token': 'ver_tok_8f9a2b1c',
              'masked_name': '홍*동',
              'verified_at': '2026-08-13T01:32:00Z',
            }),
            200,
            headers: jsonHeaders,
          );
        }
        if (request.url.path.contains('/verification/trust_api_sync')) {
          return http.Response(
            jsonEncode({
              'status': 'VERIFIED',
              'owner_name_masked': '홍*동',
              'ownership_percentage': 100,
              'badge': 'VERIFIED_OWNER',
              'assigned_tier': 'GOLD',
              'verified_at': '2026-08-13T01:32:05Z',
            }),
            200,
            headers: jsonHeaders,
          );
        }
        return http.Response('Not Found', 404);
      });

      final service = VerificationService(baseUrl: baseUrl, client: mockClient);

      await tester.pumpWidget(buildTestableWidget(
        verificationService: service,
        securityService: securityService,
      ));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('input_name')), '홍길동');
      await tester.enterText(find.byKey(const Key('input_phone')), '01012345678');
      await tester.enterText(find.byKey(const Key('input_birth')), '19800101');
      await tapAndSettle(tester, find.byKey(const Key('btn_identity_verify')));

      await tester.enterText(find.byKey(const Key('input_complex_name')), '디에이치 방배');
      await tester.enterText(find.byKey(const Key('input_building_number')), '101동');
      await tester.enterText(find.byKey(const Key('input_unit_number')), '1502호');
      await tapAndSettle(tester, find.byKey(const Key('btn_trust_api_sync')));

      expect(find.text('VVIP 자산 증빙 & 권한 위임'), findsWidgets);
    });

    testWidgets('handles Trust API Sync error gracefully', (WidgetTester tester) async {
      configureTestSurface(tester);
      final mockClient = MockClient((request) async {
        if (request.url.path.contains('/verification/trust_api_sync')) {
          return http.Response('Sync failed', 500);
        }
        return http.Response(
          jsonEncode({
            'status': 'success',
            'verification_token': 'ver_tok_8f9a2b1c',
            'masked_name': '홍*동',
            'verified_at': '2026-08-13T01:32:00Z',
          }),
          200,
          headers: jsonHeaders,
        );
      });

      final service = VerificationService(baseUrl: baseUrl, client: mockClient);

      await tester.pumpWidget(buildTestableWidget(
        verificationService: service,
        securityService: securityService,
      ));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('input_name')), '홍길동');
      await tapAndSettle(tester, find.byKey(const Key('btn_identity_verify')));

      await tapAndSettle(tester, find.byKey(const Key('btn_trust_api_sync')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('submits Tier Evidence in Step 3 and handles error', (WidgetTester tester) async {
      configureTestSurface(tester);
      bool causeError = false;
      final mockClient = MockClient((request) async {
        if (request.url.path.contains('/verification/tier_evidence')) {
          if (causeError) return http.Response('Error', 400);
          return http.Response(
            jsonEncode({
              'submission_id': 'sub_4412',
              'status': 'UNDER_REVIEW',
              'target_tier': 'DIAMOND',
              'submitted_at': '2026-08-13T01:32:15Z',
            }),
            202,
            headers: jsonHeaders,
          );
        }
        return http.Response(
          jsonEncode({
            'user_id': 'usr_1001',
            'tier': 'GOLD',
            'badges': ['VERIFIED_OWNER'],
            'complex_name': '디에이치 방배',
            'building_unit': '101동 1502호',
            'security_profile': {'screen_capture_prevented': true, 'privacy_masked': true},
          }),
          200,
          headers: jsonHeaders,
        );
      });

      final service = VerificationService(baseUrl: baseUrl, client: mockClient);

      await tester.pumpWidget(buildTestableWidget(
        verificationService: service,
        securityService: securityService,
      ));
      await tester.pumpAndSettle();

      await tapAndSettle(tester, find.text('증빙 제출'));

      await tester.enterText(find.byKey(const Key('input_doc_url')), 'https://storage.aratel.com/docs/income.pdf');
      await tester.enterText(find.byKey(const Key('input_instagram')), '@vip_user');
      await tester.enterText(find.byKey(const Key('input_referral')), 'DIAMOND_777');
      await tapAndSettle(tester, find.byKey(const Key('btn_submit_evidence')));

      expect(find.text('증빙 제출 완료 (UNDER_REVIEW)'), findsOneWidget);

      causeError = true;
      await tapAndSettle(tester, find.byKey(const Key('btn_submit_evidence')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('requests Delegated Access in Step 3 and handles error', (WidgetTester tester) async {
      configureTestSurface(tester);
      bool causeError = false;
      final mockClient = MockClient((request) async {
        if (request.url.path.contains('/verification/delegated_access')) {
          if (causeError) return http.Response('Error', 400);
          return http.Response(
            jsonEncode({
              'delegation_id': 'del_9981',
              'status': 'PENDING_OWNER_APPROVAL',
              'requested_at': '2026-08-13T01:32:10Z',
            }),
            201,
            headers: jsonHeaders,
          );
        }
        return http.Response(
          jsonEncode({
            'user_id': 'usr_1001',
            'tier': 'GOLD',
            'badges': ['VERIFIED_OWNER'],
            'complex_name': '디에이치 방배',
            'building_unit': '101동 1502호',
            'security_profile': {'screen_capture_prevented': true, 'privacy_masked': true},
          }),
          200,
          headers: jsonHeaders,
        );
      });

      final service = VerificationService(baseUrl: baseUrl, client: mockClient);

      await tester.pumpWidget(buildTestableWidget(
        verificationService: service,
        securityService: securityService,
      ));
      await tester.pumpAndSettle();

      await tapAndSettle(tester, find.text('증빙 제출'));
      await tapAndSettle(tester, find.byKey(const Key('tab_delegated_access')));

      await tester.enterText(find.byKey(const Key('input_relationship')), 'FAMILY');
      await tester.enterText(find.byKey(const Key('input_delegated_doc_url')), 'https://storage.aratel.com/docs/family.pdf');
      await tapAndSettle(tester, find.byKey(const Key('btn_request_delegation')));

      expect(find.text('위임 신청 완료 (PENDING_OWNER_APPROVAL)'), findsOneWidget);

      causeError = true;
      await tapAndSettle(tester, find.byKey(const Key('btn_request_delegation')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('approves and rejects Delegated Access in Step 3 and handles error', (WidgetTester tester) async {
      configureTestSurface(tester);
      bool causeError = false;
      final mockClient = MockClient((request) async {
        if (request.url.path.contains('/verification/delegated_access/del_9981/approve')) {
          if (causeError) return http.Response('Error', 400);
          final body = jsonDecode(request.body);
          final approved = body['approved'] as bool;
          return http.Response(
            jsonEncode({
              'delegation_id': 'del_9981',
              'status': approved ? 'APPROVED' : 'REJECTED',
              'granted_badge': approved ? 'RESIDENT' : null,
              'role': approved ? 'RESIDENT' : null,
            }),
            200,
            headers: jsonHeaders,
          );
        }
        return http.Response(
          jsonEncode({
            'user_id': 'usr_1001',
            'tier': 'GOLD',
            'badges': ['VERIFIED_OWNER'],
            'complex_name': '디에이치 방배',
            'building_unit': '101동 1502호',
            'security_profile': {'screen_capture_prevented': true, 'privacy_masked': true},
          }),
          200,
          headers: jsonHeaders,
        );
      });

      final service = VerificationService(baseUrl: baseUrl, client: mockClient);

      await tester.pumpWidget(buildTestableWidget(
        verificationService: service,
        securityService: securityService,
      ));
      await tester.pumpAndSettle();

      await tapAndSettle(tester, find.text('증빙 제출'));
      await tapAndSettle(tester, find.byKey(const Key('tab_owner_approval')));

      await tester.enterText(find.byKey(const Key('input_delegation_id')), 'del_9981');
      await tapAndSettle(tester, find.byKey(const Key('btn_approve_delegation')));
      expect(find.text('위임 승인 완료 (APPROVED)'), findsOneWidget);

      await tapAndSettle(tester, find.byKey(const Key('btn_reject_delegation')));
      expect(find.text('위임 승인 완료 (REJECTED)'), findsOneWidget);

      causeError = true;
      await tapAndSettle(tester, find.byKey(const Key('btn_approve_delegation')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('toggles Security Layer screen capture prevention and privacy masking', (WidgetTester tester) async {
      configureTestSurface(tester);
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'user_id': 'usr_1001',
            'tier': 'DIAMOND',
            'badges': ['VERIFIED_OWNER', 'DIAMOND_BLACK'],
            'complex_name': '디에이치 방배',
            'building_unit': '101동 1502호',
            'security_profile': {'screen_capture_prevented': true, 'privacy_masked': true},
          }),
          200,
          headers: jsonHeaders,
        );
      });

      final service = VerificationService(baseUrl: baseUrl, client: mockClient);

      await tester.pumpWidget(buildTestableWidget(
        verificationService: service,
        securityService: securityService,
      ));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('switch_screen_capture')), findsOneWidget);
      expect(find.byKey(const Key('switch_privacy_masking')), findsOneWidget);

      await tapAndSettle(tester, find.byKey(const Key('switch_screen_capture')));
      expect(securityService.isScreenCapturePrevented, false);

      await tapAndSettle(tester, find.byKey(const Key('switch_privacy_masking')));
      expect(securityService.isPrivacyMasked, false);
    });

    testWidgets('renders 1-Tap retry button and triggers Trust API sync', (WidgetTester tester) async {
      configureTestSurface(tester);
      final mockClient = MockClient((request) async {
        if (request.url.path.contains('/verification/trust_api_sync')) {
          return http.Response(
            jsonEncode({
              'status': 'VERIFIED',
              'owner_name_masked': '홍*동',
              'ownership_percentage': 100,
              'badge': 'VERIFIED_OWNER',
              'assigned_tier': 'GOLD',
              'verified_at': '2026-08-13T01:32:05Z',
            }),
            200,
            headers: jsonHeaders,
          );
        }
        return http.Response(
          jsonEncode({
            'user_id': 'usr_1001',
            'tier': 'UNVERIFIED',
            'badges': [],
            'complex_name': '미인증',
            'building_unit': '-',
            'security_profile': {'screen_capture_prevented': true, 'privacy_masked': true},
          }),
          200,
          headers: jsonHeaders,
        );
      });

      final service = VerificationService(baseUrl: baseUrl, client: mockClient);

      await tester.pumpWidget(buildTestableWidget(
        verificationService: service,
        securityService: securityService,
      ));
      await tester.pumpAndSettle();

      await tapAndSettle(tester, find.text('2. 등기부 연동'));
      expect(find.byKey(const Key('btn_1tap_retry')), findsOneWidget);

      await tapAndSettle(tester, find.byKey(const Key('btn_1tap_retry')));
      expect(find.text('VVIP 자산 증빙 & 권한 위임'), findsWidgets);
    });
  });
}
