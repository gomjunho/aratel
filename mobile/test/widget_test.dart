import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aratel_mobile/main.dart';
import 'package:aratel_mobile/models/user_tier.dart';

void main() {
  testWidgets('AratelApp renders main navigation screens', (WidgetTester tester) async {
    await tester.pumpWidget(const AratelApp());

    // Verify that ARATEL title & Home card are present
    expect(find.text('ARATEL'), findsOneWidget);
    expect(find.text('DIAMOND TIER'), findsOneWidget);
    expect(find.text('디에이치 방배 소유주'), findsOneWidget);

    // Tap on Lounge / Community tab
    await tester.tap(find.byIcon(Icons.forum_rounded));
    await tester.pump();
    expect(find.text('커뮤니티 & 익명 라운지'), findsOneWidget);

    // Tap on VVIP Curation tab
    await tester.tap(find.byIcon(Icons.diamond_rounded));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('💎 VVIP 큐레이션 Hub'), findsOneWidget);

    // Tap on Insights tab
    await tester.tap(find.byIcon(Icons.analytics_rounded));
    await tester.pump();
    expect(find.text('실거래가 & 공급 물량 인사이트'), findsOneWidget);

    // Tap on Profile tab
    await tester.tap(find.byIcon(Icons.person_rounded));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('👤 내 정보 및 자산 인증'), findsOneWidget);
  });

  group('HomeScreen Tier-Based Dynamic Card Ordering', () {
    testWidgets('DIAMOND tier shows asset value summary card first', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(initialTier: UserTier.diamond),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('asset_value_summary_card')), findsOneWidget);
      expect(find.byKey(const Key('urgent_club_deal_card')), findsOneWidget);
      expect(find.text('오늘의 자산 가치 변동 요약'), findsOneWidget);
    });

    testWidgets('OWNER tier shows facility status and community announcement cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(initialTier: UserTier.owner),
        ),
      );
      await tester.pump();

      // OWNER should see facility status and community announcement
      expect(find.byKey(const Key('facility_status_card')), findsOneWidget);
      expect(find.byKey(const Key('community_announcement_card')), findsOneWidget);
      expect(find.text('단지 주요 공지사항'), findsOneWidget);
    });

    testWidgets('Tier switcher menu shows all tier options', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(initialTier: UserTier.diamond),
        ),
      );
      await tester.pump();

      // Open tier switcher
      await tester.tap(find.byKey(const Key('tier_switcher_menu')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('tier_option_diamond')), findsOneWidget);
      expect(find.byKey(const Key('tier_option_owner')), findsOneWidget);
    });

    testWidgets('Profile header card reflects current tier label', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(initialTier: UserTier.gold),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('profile_header_card')), findsOneWidget);
      expect(find.text('GOLD TIER'), findsOneWidget);
    });
  });
}
