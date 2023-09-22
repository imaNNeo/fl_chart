import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_renderer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final data = BarChartData(
    barTouchData: BarTouchData(enabled: false),
    barGroups: [
      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 3)]),
      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 8)]),
      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 5)]),
    ],
  );

  group('BarChart', () {
    testWidgets(
        'Provides modified initial data when animation is enabled (by default)',
        (tester) async {
      final key = GlobalKey();
      final renderKey = GlobalKey();

      await tester.pumpWidget(
        _BarChartScaffold(
          chartKey: key,
          renderKey: renderKey,
          data: data,
          initialAnimationConfiguration:
              const InitialAnimationConfiguration(initialValue: 0),
        ),
      );

      final state = key.currentState! as AnimatedWidgetBaseState;

      // Pre-animation:
      expect(state.animation.value, 0.0);
      expect(state.animation.status, AnimationStatus.forward);
      expect(
        _getCurrentBarChartLeaf(renderKey).data,
        data.copyWith(
          barGroups: [
            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 0)]),
            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 0)]),
            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 0)]),
          ],
        ),
      );

      await tester.pumpAndSettle();

      // Post-animation:
      expect(state.animation.value, 1.0);
      expect(state.animation.status, AnimationStatus.completed);
      expect(_getCurrentBarChartLeaf(renderKey).data, data);
    });

    testWidgets(
        "Doesn't provide modified initial data when animation is disabled",
        (tester) async {
      final key = GlobalKey();
      final renderKey = GlobalKey();

      await tester.pumpWidget(
        _BarChartScaffold(
          chartKey: key,
          renderKey: renderKey,
          data: data,
          initialAnimationConfiguration:
              const InitialAnimationConfiguration(enabled: false),
        ),
      );

      final state = key.currentState! as AnimatedWidgetBaseState;

      // Pre-animation:
      expect(state.animation.value, 0.0);
      expect(state.animation.status, AnimationStatus.dismissed);
      expect(_getCurrentBarChartLeaf(renderKey).data, data);

      await tester.pumpAndSettle();

      // Post-animation:
      expect(state.animation.value, 0.0);
      expect(state.animation.status, AnimationStatus.dismissed);
      expect(_getCurrentBarChartLeaf(renderKey).data, data);
    });
  });
}

const viewSize = Size(400, 400);

BarChartLeaf _getCurrentBarChartLeaf(GlobalKey key) =>
    key.currentContext!.widget as BarChartLeaf;

class _BarChartScaffold extends StatelessWidget {
  const _BarChartScaffold({
    required this.chartKey,
    required this.renderKey,
    required this.data,
    this.initialAnimationConfiguration = const InitialAnimationConfiguration(),
  });

  final Key chartKey;
  final Key renderKey;
  final BarChartData data;
  final InitialAnimationConfiguration initialAnimationConfiguration;

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: viewSize.width,
              height: viewSize.height,
              child: BarChart(
                chartRendererKey: renderKey,
                key: chartKey,
                initialAnimationConfiguration: initialAnimationConfiguration,
                data,
              ),
            ),
          ),
        ),
      );
}
