import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:aratel_mobile/screens/concierge_screen.dart';
import 'package:aratel_mobile/services/concierge_service.dart';

void main() {
  group('ConciergeScreen Widget Tests', () {
    testWidgets('renders service options and submits TWO CHAIRS reservation', (WidgetTester tester) async {
      final mockClient = MockClient((request) async {
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

      await tester.pumpWidget(
        MaterialApp(
          home: ConciergeScreen(conciergeService: service),
        ),
      );

      // Check header and service options
      expect(find.text('VIP 컨시어지 서비스'), findsOneWidget);
      expect(find.textContaining('WOORI TWO CHAIRS'), findsOneWidget);
      expect(find.textContaining('주거 방역'), findsOneWidget);
      expect(find.textContaining('건강검진'), findsOneWidget);
      expect(find.textContaining('아트 구독'), findsOneWidget);

      // Select WOORI TWO CHAIRS service
      final twoChairsCard = find.byKey(const Key('service_card_WOORI_TWO_CHAIRS'));
      expect(twoChairsCard, findsOneWidget);
      await tester.tap(twoChairsCard);
      await tester.pumpAndSettle();

      // Fill in date and notes
      final dateInput = find.byKey(const Key('preferred_date_input'));
      final notesInput = find.byKey(const Key('reservation_notes_input'));

      await tester.enterText(dateInput, '2026-08-20');
      await tester.enterText(notesInput, '자산 증여 및 외환 법률 상담 희망');
      await tester.pumpAndSettle();

      // Submit reservation
      final submitBtn = find.byKey(const Key('submit_reservation_button'));
      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      // Check confirmation dialog / view
      expect(find.text('예약 확정 완료'), findsOneWidget);
      expect(find.textContaining('우리은행 TWO CHAIRS 수석 자산관리사'), findsOneWidget);
      expect(find.textContaining('res_7710'), findsOneWidget);
    });

    testWidgets('handles error gracefully when reservation fails', (WidgetTester tester) async {
      final mockClient = MockClient((request) async {
        return http.Response('Error', 500);
      });

      final service = ConciergeService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: ConciergeScreen(conciergeService: service),
        ),
      );

      final dateInput = find.byKey(const Key('preferred_date_input'));
      await tester.enterText(dateInput, '2026-08-20');
      final submitBtn = find.byKey(const Key('submit_reservation_button'));
      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      expect(find.textContaining('예약 신청 중 오류가 발생했습니다'), findsOneWidget);
    });
  });
}
