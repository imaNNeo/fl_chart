import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/gauge_chart/gauge_chart_renderer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GaugeChart widget', () {
    testWidgets('builds with initial data and renders leaf', (tester) async {
      final data = GaugeChartData(
        rings: const [
          GaugeProgressRing(value: 0.4, color: Colors.red, width: 8),
        ],
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(),
            child: GaugeChart(data),
          ),
        ),
      );

      expect(find.byType(GaugeChart), findsOneWidget);
      expect(find.byType(GaugeChartLeaf), findsOneWidget);
    });

    testWidgets(
      'updates tween when data changes (implicit animation)',
      (tester) async {
        final dataA = GaugeChartData(
          rings: const [
            GaugeProgressRing(value: 0.2, color: Colors.red, width: 6),
          ],
          sweepAngle: 180,
        );

        final dataB = GaugeChartData(
          rings: const [
            GaugeProgressRing(value: 0.8, color: Colors.blue, width: 10),
          ],
          startDegreeOffset: 30,
        );

        Widget build(GaugeChartData d) => Directionality(
              textDirection: TextDirection.ltr,
              child: MediaQuery(
                data: const MediaQueryData(),
                child: GaugeChart(
                  d,
                  // Short animation for test speed
                  duration: const Duration(milliseconds: 50),
                ),
              ),
            );

        await tester.pumpWidget(build(dataA));
        expect(find.byType(GaugeChartLeaf), findsOneWidget);

        // Update with new data should start an implicit animation
        await tester.pumpWidget(build(dataB));

        // Advance half of the animation
        await tester.pump(const Duration(milliseconds: 25));
        expect(find.byType(GaugeChartLeaf), findsOneWidget);

        // Finish the animation
        await tester.pumpAndSettle();
        expect(find.byType(GaugeChartLeaf), findsOneWidget);
      },
    );
  });
}
