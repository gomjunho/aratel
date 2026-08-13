import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:aratel_mobile/screens/login_screen.dart';
import 'package:aratel_mobile/services/auth_service.dart';

void main() {
  group('AuthService & LoginScreen Tests', () {
    test('AuthService login returns AuthUser on HTTP 200', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'token': 'mock_jwt_token_123',
            'user_id': 'usr_1001',
            'name': '홍길동',
            'tier': 'DIAMOND',
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = AuthService(client: mockClient);
      final user = await service.login('usr_1001', 'password123');

      expect(user.token, 'mock_jwt_token_123');
      expect(user.userId, 'usr_1001');
      expect(AuthService.isAuthenticated, isTrue);
      expect(AuthService.authHeaders['Authorization'], 'Bearer mock_jwt_token_123');
    });

    test('AuthService register returns AuthUser on HTTP 201', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'token': 'mock_jwt_token_new',
            'user_id': 'usr_new',
            'name': '신규회원',
            'tier': 'BRONZE',
          }),
          201,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = AuthService(client: mockClient);
      final user = await service.register('new@aratel.com', 'password123', '신규회원');

      expect(user.token, 'mock_jwt_token_new');
      expect(user.userId, 'usr_new');
    });

    testWidgets('LoginScreen renders and toggles register mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      expect(find.text('ARATEL VVIP 로그인'), findsOneWidget);
      expect(find.byKey(const Key('login_user_id_field')), findsOneWidget);

      await tester.tap(find.byKey(const Key('toggle_auth_mode_button')));
      await tester.pump();

      expect(find.text('ARATEL 회원가입'), findsOneWidget);
    });
  });
}
