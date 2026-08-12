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

    // Tap on Verification tab
    await tester.tap(find.byIcon(Icons.verified_user_rounded));
    await tester.pumpAndSettle();
    expect(find.text('자산 인증 센터'), findsOneWidget);

    // Tap on Lounge tab
    await tester.tap(find.byIcon(Icons.forum_rounded));
    await tester.pump();
    expect(find.text('하이엔드 암호화 라운지'), findsOneWidget);

    // Tap on Atelier tab
    await tester.tap(find.byIcon(Icons.view_in_ar_rounded));
    await tester.pump();
    expect(find.text('AI 아뜰리에 3D 평면도'), findsOneWidget);

    // Tap on Concierge tab
    await tester.tap(find.byIcon(Icons.room_service_rounded));
    await tester.pump();
    expect(find.text('VIP 컨시어지 서비스'), findsOneWidget);

    // Tap on Insights tab
    await tester.tap(find.byIcon(Icons.analytics_rounded));
    await tester.pump();
    expect(find.text('실거래가 & 공급 물량 인사이트'), findsOneWidget);
  });
}
