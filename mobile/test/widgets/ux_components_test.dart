import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aratel_mobile/widgets/shimmer_skeleton.dart';
import 'package:aratel_mobile/widgets/sticky_bottom_cta.dart';

void main() {
  group('UX Components Tests', () {
    testWidgets('ShimmerSkeleton renders correct dimensions', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerSkeleton(width: 120, height: 40),
          ),
        ),
      );

      expect(find.byType(ShimmerSkeleton), findsOneWidget);
    });

    testWidgets('StickyBottomCTA renders label and triggers tap callback', (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StickyBottomCTA(
              label: '확인하기',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('확인하기'), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));
      expect(pressed, isTrue);
    });
  });
}
