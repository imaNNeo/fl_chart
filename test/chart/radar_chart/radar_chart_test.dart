import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_renderer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final data = RadarChartData(
    dataSets: [
      RadarDataSet(
        dataEntries: const [
          RadarEntry(value: 1),
          RadarEntry(value: 2),
          RadarEntry(value: 3),
        ],
      ),
    ],
  );

  group('RadarChart', () {
    testWidgets(
        'Provides modified initial data when animation is enabled (by default)',
        (tester) async {
      final key = GlobalKey();
      final renderKey = GlobalKey();

      await tester.pumpWidget(
        _RadarChartScaffold(chartKey: key, renderKey: renderKey, data: data),
      );

      final state = key.currentState! as AnimatedWidgetBaseState;

      // Pre-animation:
      expect(state.animation.value, 0.0);
      expect(state.animation.status, AnimationStatus.forward);
      expect(
        _getCurrentRadarChartLeaf(renderKey).data,
        data.copyWith(scaleFactor: 0),
      );

      await tester.pumpAndSettle();

      // Post-animation:
      expect(state.animation.value, 1.0);
      expect(state.animation.status, AnimationStatus.completed);
      expect(_getCurrentRadarChartLeaf(renderKey).data, data);
    });

    testWidgets(
        "Doesn't provide modified initial data when animation is disabled",
        (tester) async {
      final key = GlobalKey();
      final renderKey = GlobalKey();

      await tester.pumpWidget(
        _RadarChartScaffold(
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
      expect(_getCurrentRadarChartLeaf(renderKey).data, data);

      await tester.pumpAndSettle();

      // Post-animation:
      expect(state.animation.value, 0.0);
      expect(state.animation.status, AnimationStatus.dismissed);
      expect(_getCurrentRadarChartLeaf(renderKey).data, data);
    });
  });
}

const viewSize = Size(400, 400);

RadarChartLeaf _getCurrentRadarChartLeaf(GlobalKey key) =>
    key.currentContext!.widget as RadarChartLeaf;

class _RadarChartScaffold extends StatelessWidget {
  const _RadarChartScaffold({
    required this.chartKey,
    required this.renderKey,
    required this.data,
    this.initialAnimationConfiguration = const InitialAnimationConfiguration(),
  });

  final Key chartKey;
  final Key renderKey;
  final RadarChartData data;
  final InitialAnimationConfiguration initialAnimationConfiguration;

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: viewSize.width,
              height: viewSize.height,
              child: RadarChart(
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
