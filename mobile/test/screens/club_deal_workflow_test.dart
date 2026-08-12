import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:aratel_mobile/screens/club_deal_workflow.dart';
import 'package:aratel_mobile/services/club_deal_service.dart';

void main() {
  group('ClubDealWorkflow Widget Tests', () {
    testWidgets('renders deal list, calculates discount points, places order', (WidgetTester tester) async {
      final mockClient = MockClient((request) async {
        if (request.method == 'GET' && request.url.path == '/api/v1/club_deals') {
          return http.Response(
            jsonEncode({
              'club_deals': [
                {
                  'id': 'deal_552',
                  'brand': 'B&B Italia',
                  'item_name': 'Camaleonda Sofa VVIP Club Deal',
                  'original_price': 18500000,
                  'deal_price': 14200000,
                  'point_discount_limit': 1000000,
                  'min_participants': 5,
                  'current_participants': 3,
                  'status': 'OPEN'
                }
              ]
            }),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        } else if (request.method == 'POST' && request.url.path == '/api/v1/club_deals/deal_552/order') {
          return http.Response(
            jsonEncode({
              'order_id': 'ord_9901',
              'status': 'ORDER_PLACED',
              'remaining_points': 450000
            }),
            201,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }
        return http.Response('Not Found', 404);
      });

      final service = ClubDealService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClubDealWorkflowWidget(clubDealService: service),
          ),
        ),
      );

      // Loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();

      // Check deal card
      expect(find.text('Camaleonda Sofa VVIP Club Deal'), findsOneWidget);
      expect(find.textContaining('3 / 5명 달성'), findsOneWidget);

      // Tap buy / joint order button
      final buyBtn = find.byKey(const Key('deal_order_button_deal_552'));
      expect(buyBtn, findsOneWidget);
      await tester.tap(buyBtn);
      await tester.pumpAndSettle();

      // Verify order modal fields
      expect(find.text('클럽딜 공동 구매 신청'), findsOneWidget);
      final pointsInput = find.byKey(const Key('points_input_field'));
      expect(pointsInput, findsOneWidget);

      await tester.enterText(pointsInput, '500000');
      await tester.pumpAndSettle();

      // Submit order
      final confirmBtn = find.byKey(const Key('confirm_order_button'));
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      // Check success snackbar
      expect(find.textContaining('ord_9901'), findsOneWidget);
    });

    testWidgets('handles error state gracefully on load failure', (WidgetTester tester) async {
      final mockClient = MockClient((request) async {
        return http.Response('Error', 500);
      });

      final service = ClubDealService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClubDealWorkflowWidget(clubDealService: service),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.textContaining('클럽 딜 목록을 불러올 수 없습니다'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
