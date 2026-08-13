import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:aratel_mobile/screens/insights_screen.dart';
import 'package:aratel_mobile/screens/concierge_screen.dart';
import 'package:aratel_mobile/services/insights_service.dart';

void main() {
  group('InsightsScreen Widget Tests', () {
    testWidgets('renders Asil scatter chart data and supply gas index risk card', (WidgetTester tester) async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'complex_name': '디에이치 방배',
            'transactions': [
              {'floor': 15, 'price': 2850000000, 'deal_date': '2026-07-15'},
              {'floor': 3, 'price': 2510000000, 'deal_date': '2026-07-10'}
            ],
            'supply_gas_index': {
              'risk_level': 'LOW',
              'upcoming_supply_units': 450,
              'analysis_summary': '향후 2년간 주변 과잉 공급 물량이 적어 자산 가치가 매우 안정적입니다.'
            }
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = InsightsService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: InsightsScreen(insightsService: service),
        ),
      );

      // Loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Use pump instead of pumpAndSettle to avoid infinite AnimationController loop
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(milliseconds: 100));

      // Check header and content
      expect(find.text('실거래가 & 공급 물량 인사이트'), findsOneWidget);
      expect(find.textContaining('층수별 산점도 줌 슬라이더'), findsOneWidget);
      expect(find.textContaining('15층'), findsOneWidget);
      expect(find.textContaining('3층'), findsOneWidget);
      expect(find.textContaining('28.5억'), findsOneWidget);

      // Check Supply Gas Index Card
      expect(find.textContaining('상세 리포트: LOW'), findsOneWidget);
      expect(find.textContaining('입주 예정 물량: 450세대'), findsOneWidget);
      expect(find.textContaining('향후 2년간 주변 과잉 공급 물량이 적어'), findsOneWidget);
    });

    testWidgets('handles error state gracefully on load failure', (WidgetTester tester) async {
      final mockClient = MockClient((request) async {
        return http.Response('Error', 500);
      });

      final service = InsightsService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: InsightsScreen(insightsService: service),
        ),
      );

      // Use pump instead of pumpAndSettle to avoid infinite AnimationController loop
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.textContaining('인사이트 데이터를 불러올 수 없습니다'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('renders area size filter chips', (WidgetTester tester) async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'complex_name': '디에이치 방배',
            'transactions': [],
            'supply_gas_index': {
              'risk_level': 'LOW',
              'upcoming_supply_units': 450,
              'analysis_summary': '요약'
            }
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = InsightsService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: InsightsScreen(insightsService: service),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      expect(find.text('84㎡ (34평)'), findsOneWidget);
      expect(find.text('164㎡ (펜트하우스)'), findsOneWidget);
    });

    testWidgets('renders VIP concierge CTA card at the bottom', (WidgetTester tester) async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'complex_name': '디에이치 방배',
            'transactions': [
              {'floor': 10, 'price': 2700000000, 'deal_date': '2026-07-01'}
            ],
            'supply_gas_index': {
              'risk_level': 'HIGH',
              'upcoming_supply_units': 1200,
              'analysis_summary': '공급 과잌'
            }
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = InsightsService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: InsightsScreen(insightsService: service),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(milliseconds: 100));

      // Scroll to bottom to reveal CTA card
      await tester.dragUntilVisible(
        find.byKey(const Key('insights_concierge_cta_card')),
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      expect(find.byKey(const Key('insights_concierge_cta_card')), findsOneWidget);
      expect(find.byKey(const Key('insights_concierge_cta_button')), findsOneWidget);
      expect(find.text('1:1 자산관리 상담 예약하기'), findsOneWidget);
    });

    testWidgets('ConciergeScreen shows insight context banner when launched with context', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ConciergeScreen(
            insightComplexName: '디에이치 방배',
            insightAreaType: '84㎡',
            insightContext: '[인사이트 연동] 테스트 콘텍스트',
          ),
        ),
      );

      await tester.pump();
      expect(find.byKey(const Key('insight_context_banner')), findsOneWidget);
      expect(find.textContaining('디에이치 방배'), findsWidgets);
      expect(find.textContaining('인사이트 연동 상담 요청'), findsOneWidget);
    });
  });
}
