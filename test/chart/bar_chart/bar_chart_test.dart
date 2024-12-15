import 'package:fl_chart/src/chart/bar_chart/bar_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_data.dart';
import 'package:fl_chart/src/chart/base/axis_chart/scale_axis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget({
    required BarChartData data,
    ScaleAxis scaleAxis = ScaleAxis.none,
  }) {
    return MaterialApp(
      home: BarChart(
        data,
        scaleAxis: scaleAxis,
      ),
    );
  }

  group('BarChart', () {
    group('throws AssertionError for', () {
      final verticallyScalableAlignments = [
        BarChartAlignment.start,
        BarChartAlignment.center,
        BarChartAlignment.end,
      ];
      for (final alignment in verticallyScalableAlignments) {
        testWidgets(
          'ScaleAxis.horizontal with $alignment',
          (WidgetTester tester) async {
            expect(
              () => tester.pumpWidget(
                createTestWidget(
                  data: BarChartData(
                    alignment: alignment,
                  ),
                  scaleAxis: ScaleAxis.horizontal,
                ),
              ),
              throwsAssertionError,
            );
          },
        );
      }

      for (final alignment in verticallyScalableAlignments) {
        testWidgets(
          'ScaleAxis.free with $alignment',
          (WidgetTester tester) async {
            expect(
              () => tester.pumpWidget(
                createTestWidget(
                  data: BarChartData(
                    alignment: alignment,
                  ),
                  scaleAxis: ScaleAxis.free,
                ),
              ),
              throwsAssertionError,
            );
          },
        );
      }
    });

    group('allows passing', () {
      for (final alignment in BarChartAlignment.values) {
        testWidgets(
          'ScaleAxis.none with $alignment',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              createTestWidget(
                data: BarChartData(alignment: alignment),
                // ignore: avoid_redundant_argument_values
                scaleAxis: ScaleAxis.none,
              ),
            );
          },
        );
      }

      for (final alignment in BarChartAlignment.values) {
        testWidgets(
          'ScaleAxis.vertical with $alignment',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              createTestWidget(
                data: BarChartData(alignment: alignment),
                scaleAxis: ScaleAxis.vertical,
              ),
            );
          },
        );
      }

      final scalableAlignments = [
        BarChartAlignment.spaceAround,
        BarChartAlignment.spaceBetween,
        BarChartAlignment.spaceEvenly,
      ];

      for (final alignment in scalableAlignments) {
        testWidgets(
          'ScaleAxis.free with $alignment',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              createTestWidget(
                data: BarChartData(alignment: alignment),
                scaleAxis: ScaleAxis.free,
              ),
            );
          },
        );
      }

      for (final alignment in scalableAlignments) {
        testWidgets(
          'ScaleAxis.horizontal with $alignment',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              createTestWidget(
                data: BarChartData(alignment: alignment),
                scaleAxis: ScaleAxis.horizontal,
              ),
            );
          },
        );
      }
    });
  });
}
