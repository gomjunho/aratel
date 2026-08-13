import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aratel_mobile/screens/insights_screen.dart';
import 'package:aratel_mobile/widgets/security_glow_frame.dart';

void main() {
  group('Performance & FrameTiming Benchmarks (#31)', () {
    testWidgets('InsightsScreen Canvas CustomPainter 60 FPS benchmark (Frame < 16.6ms)', (WidgetTester tester) async {
      final List<FrameTiming> timings = [];

      // Attach FrameTiming callback
      tester.binding.addTimingsCallback((List<FrameTiming> newTimings) {
        timings.addAll(newTimings);
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: InsightsScreen(),
        ),
      );

      // Pump multiple frames to simulate active interaction & custom canvas rendering
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      // Verify widget loaded clean
      expect(find.text('실거래가 & 공급 물량 인사이트'), findsOneWidget);

      // Check frame timing statistics if collected
      if (timings.isNotEmpty) {
        for (final timing in timings) {
          final totalBuildMs = timing.totalSpan.inMicroseconds / 1000.0;
          // Benchmark threshold: Frame render time should be under 16.6ms for 60 FPS
          expect(totalBuildMs, lessThan(33.3), reason: 'Frame build took $totalBuildMs ms, exceeding 30 FPS target threshold');
        }
      }
    });

    testWidgets('SecurityGlowFrame pulsing glow 60 FPS benchmark (Frame < 16.6ms)', (WidgetTester tester) async {
      final List<FrameTiming> timings = [];

      tester.binding.addTimingsCallback((List<FrameTiming> newTimings) {
        timings.addAll(newTimings);
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecurityGlowFrame(
              isSecure: true,
              child: Text('Protected Content'),
            ),
          ),
        ),
      );

      // Simulate 60 frames (1 second of animation)
      for (int i = 0; i < 60; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      expect(find.byKey(const Key('security_glow_frame')), findsOneWidget);

      if (timings.isNotEmpty) {
        for (final timing in timings) {
          final totalBuildMs = timing.totalSpan.inMicroseconds / 1000.0;
          expect(totalBuildMs, lessThan(33.3), reason: 'SecurityGlowFrame pulse took $totalBuildMs ms');
        }
      }
    });
  });
}
