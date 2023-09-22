import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_renderer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final data = LineChartData(
    lineTouchData: const LineTouchData(enabled: false),
    lineBarsData: [
      LineChartBarData(spots: const [FlSpot(0, 3), FlSpot(1, 1), FlSpot(2, 2)]),
    ],
  );

  group('LineChart', () {
    testWidgets(
        'Provides modified initial data when animation is enabled (by default)',
        (tester) async {
      final key = GlobalKey();
      final renderKey = GlobalKey();

      await tester.pumpWidget(
        _LineChartScaffold(
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
        _getCurrentLineChartLeaf(renderKey).data,
        data.copyWith(
          lineBarsData: [
            LineChartBarData(
              spots: const [FlSpot.zero, FlSpot(1, 0), FlSpot(2, 0)],
            ),
          ],
        ),
      );

      await tester.pumpAndSettle();

      // Post-animation:
      expect(state.animation.value, 1.0);
      expect(state.animation.status, AnimationStatus.completed);
      expect(_getCurrentLineChartLeaf(renderKey).data, data);
    });

    testWidgets(
        "Doesn't provide modified initial data when animation is disabled",
        (tester) async {
      final key = GlobalKey();
      final renderKey = GlobalKey();

      await tester.pumpWidget(
        _LineChartScaffold(
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
      expect(_getCurrentLineChartLeaf(renderKey).data, data);

      await tester.pumpAndSettle();

      // Post-animation:
      expect(state.animation.value, 0.0);
      expect(state.animation.status, AnimationStatus.dismissed);
      expect(_getCurrentLineChartLeaf(renderKey).data, data);
    });
  });
}

const viewSize = Size(400, 400);

LineChartLeaf _getCurrentLineChartLeaf(GlobalKey key) =>
    key.currentContext!.widget as LineChartLeaf;

class _LineChartScaffold extends StatelessWidget {
  const _LineChartScaffold({
    required this.chartKey,
    required this.renderKey,
    required this.data,
    this.initialAnimationConfiguration = const InitialAnimationConfiguration(),
  });

  final Key chartKey;
  final Key renderKey;
  final LineChartData data;
  final InitialAnimationConfiguration initialAnimationConfiguration;

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: viewSize.width,
              height: viewSize.height,
              child: LineChart(
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
