import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/gauge_chart/gauge_chart_renderer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data_pool.dart';

void main() {
  group('GaugeChart widget', () {
    testWidgets('builds with initial data and renders leaf', (tester) async {
      final data = GaugeChartData(
        value: 0.4,
        strokeWidth: 8,
        startAngle: 0,
        endAngle: 270,
        valueColor: const SimpleGaugeColor(color: MockData.color0),
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

    testWidgets('updates tween when data changes (implicit animation)',
        (tester) async {
      final dataA = GaugeChartData(
        value: 0.2,
        strokeWidth: 6,
        startAngle: 0,
        endAngle: 180,
        valueColor: const SimpleGaugeColor(color: Colors.red),
      );

      final dataB = GaugeChartData(
        value: 0.8,
        strokeWidth: 10,
        startAngle: 30,
        endAngle: 300,
        valueColor: const SimpleGaugeColor(color: Colors.blue),
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

      // Update with new data should start an implicit animation (tween is updated)
      await tester.pumpWidget(build(dataB));

      // Advance half of the animation, widget should still be present
      await tester.pump(const Duration(milliseconds: 25));
      expect(find.byType(GaugeChartLeaf), findsOneWidget);

      // Finish the animation
      await tester.pumpAndSettle();
      expect(find.byType(GaugeChartLeaf), findsOneWidget);
    });
  });
}
