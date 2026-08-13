import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aratel_mobile/main.dart';

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
}
