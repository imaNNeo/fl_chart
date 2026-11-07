import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The size every chart is laid out at, so runs are comparable.
const chartSize = Size(800, 400);

/// One benchmark scenario: a chart and what happens to it on each frame.
///
/// A scenario is created fresh for every run, so it can hold state
/// (a mouse, a controller) between [setUp], [step] and [tearDown].
abstract class Scenario {
  /// Short, stable id. It is the key in the results files, so don't rename it.
  String get name;

  /// One line on what the scenario does.
  String get description;

  /// The chart widget type, used to find the chart on screen.
  Type get chartType;

  Widget build();

  Future<void> setUp(WidgetTester tester) async {}

  /// Called once before each frame is pumped.
  Future<void> step(WidgetTester tester, int frame);

  Future<void> tearDown(WidgetTester tester) async {}
}

/// Moves a mouse over the chart, one small move per frame, like a user
/// hovering on desktop or web.
abstract class _HoverScenario extends Scenario {
  TestGesture? _mouse;
  late Rect _rect;

  /// Where the mouse is on [frame], inside the chart's [rect].
  Offset positionAt(Rect rect, int frame) {
    // 0.5 px per frame: several frames in a row hover the same spot.
    final travel = rect.width - 80;
    final x = (frame * 0.5) % (2 * travel);
    final dx = x < travel ? x : 2 * travel - x;
    return Offset(rect.left + 40 + dx, rect.center.dy);
  }

  @override
  Future<void> setUp(WidgetTester tester) async {
    _rect = tester.getRect(find.byType(chartType));
    _mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await _mouse!.addPointer(location: positionAt(_rect, 0));
  }

  @override
  Future<void> step(WidgetTester tester, int frame) =>
      _mouse!.moveTo(positionAt(_rect, frame));

  @override
  Future<void> tearDown(WidgetTester tester) async {
    await _mouse?.removePointer();
    _mouse = null;
  }
}

/// Pans a chart that is zoomed in, one step per frame.
abstract class _PanScenario extends Scenario {
  _PanScenario(this.scale);

  final double scale;
  final controller = TransformationController();

  @override
  Future<void> setUp(WidgetTester tester) async => _setOffset(0);

  @override
  Future<void> step(WidgetTester tester, int frame) async => _setOffset(frame);

  void _setOffset(int frame) {
    // Travels across the whole zoomed width and back, 12 px per frame.
    final travel = chartSize.width * (scale - 1);
    final x = (frame * 12.0) % (2 * travel);
    final dx = x < travel ? x : 2 * travel - x;
    controller.value = Matrix4.diagonal3Values(scale, scale, 1)
      ..setTranslationRaw(-dx, 0, 0);
  }

  @override
  Future<void> tearDown(WidgetTester tester) async => controller.dispose();
}

List<FlSpot> randomWalk(int count, int seed) {
  final random = Random(seed);
  var y = 50.0;
  return List.generate(count, (i) {
    y = (y + random.nextDouble() * 4 - 2).clamp(0, 100).toDouble();
    return FlSpot(i.toDouble(), y);
  });
}

LineChartData lineData({
  required int bars,
  required int spots,
  int seed = 1,
  bool showDots = false,
}) {
  const colors = [Colors.blue, Colors.orange, Colors.green];
  return LineChartData(
    minY: 0,
    maxY: 100,
    lineBarsData: List.generate(bars, (i) {
      final color = colors[i % colors.length];
      return LineChartBarData(
        spots: randomWalk(spots, seed * 10 + i),
        isCurved: true,
        color: color,
        barWidth: 2,
        dotData: FlDotData(show: showDots),
        // A filled area under the first line, the common dashboard look.
        belowBarData: BarAreaData(
          show: i == 0,
          color: color.withValues(alpha: 0.2),
        ),
      );
    }),
  );
}

BarChartData barData() => BarChartData(
  maxY: 100,
  barGroups: List.generate(40, (i) {
    final random = Random(i);
    return BarChartGroupData(
      x: i,
      barRods: List.generate(3, (j) {
        final value = 10 + random.nextDouble() * 85;
        return BarChartRodData(
          toY: value,
          width: 4,
          color: [Colors.blue, Colors.orange, Colors.green][j],
          label: BarChartRodLabel(
            show: true,
            text: value.toStringAsFixed(0),
            style: const TextStyle(fontSize: 8),
          ),
        );
      }),
    );
  }),
);

CandlestickChartData candlestickData() => CandlestickChartData(
  candlestickSpots: () {
    final random = Random(7);
    var price = 100.0;
    return List.generate(1500, (i) {
      final open = price;
      final close = open + random.nextDouble() * 6 - 3;
      final high = max(open, close) + random.nextDouble() * 2;
      final low = min(open, close) - random.nextDouble() * 2;
      price = close;
      return CandlestickSpot(
        x: i.toDouble(),
        open: open,
        high: high,
        low: low,
        close: close,
      );
    });
  }(),
);

ScatterChartData scatterData() => ScatterChartData(
  minX: 0,
  maxX: 100,
  minY: 0,
  maxY: 100,
  scatterSpots: () {
    final random = Random(3);
    return List.generate(
      2000,
      (_) => ScatterSpot(random.nextDouble() * 100, random.nextDouble() * 100),
    );
  }(),
);

PieChartData pieData({
  int touched = -1,
  BaseTouchCallback<PieTouchResponse>? touchCallback,
}) => PieChartData(
  sectionsSpace: 2,
  centerSpaceRadius: 50,
  pieTouchData: PieTouchData(touchCallback: touchCallback),
  sections: List.generate(10, (i) {
    return PieChartSectionData(
      value: 5.0 + i * 3,
      radius: i == touched ? 90 : 80,
      color: Colors.primaries[i % Colors.primaries.length],
      borderSide: const BorderSide(color: Colors.white, width: 1),
      title: '$i',
    );
  }),
);

class LineHoverScenario extends _HoverScenario {
  final _data = lineData(bars: 3, spots: 300);

  @override
  String get name => 'line_hover';

  @override
  String get description =>
      'Mouse hover over a line chart, 3 lines x 300 spots';

  @override
  Type get chartType => LineChart;

  @override
  Widget build() => LineChart(_data);
}

class LineLargeHoverScenario extends _HoverScenario {
  final _data = lineData(bars: 3, spots: 5000);

  @override
  String get name => 'line_large_hover';

  @override
  String get description =>
      'Mouse hover over a large line chart, 3 lines x 5000 spots';

  @override
  Type get chartType => LineChart;

  @override
  Widget build() => LineChart(_data);
}

class LineAnimationScenario extends Scenario {
  final _dataA = lineData(bars: 3, spots: 2000, seed: 1);
  final _dataB = lineData(bars: 3, spots: 2000, seed: 2);
  final _version = ValueNotifier(0);

  @override
  String get name => 'line_animation';

  @override
  String get description =>
      'Implicit animation between two data sets, 3 lines x 2000 spots';

  @override
  Type get chartType => LineChart;

  @override
  Widget build() => ValueListenableBuilder<int>(
    valueListenable: _version,
    builder: (context, version, _) => LineChart(
      version.isEven ? _dataA : _dataB,
      duration: const Duration(milliseconds: 600),
    ),
  );

  @override
  Future<void> step(WidgetTester tester, int frame) async {
    // A new target every 40 frames, so most frames are mid-animation.
    if (frame % 40 == 0) _version.value++;
  }

  @override
  Future<void> tearDown(WidgetTester tester) async => _version.dispose();
}

class LineParentRebuildScenario extends Scenario {
  final _data = lineData(bars: 3, spots: 300);
  final _tick = ValueNotifier(0);

  @override
  String get name => 'line_parent_rebuild';

  @override
  String get description =>
      'The parent rebuilds every frame with the same data (no visual change)';

  @override
  Type get chartType => LineChart;

  @override
  Widget build() => ValueListenableBuilder<int>(
    valueListenable: _tick,
    builder: (context, tick, _) => LineChart(_data),
  );

  @override
  Future<void> step(WidgetTester tester, int frame) async => _tick.value++;

  @override
  Future<void> tearDown(WidgetTester tester) async => _tick.dispose();
}

class LineZoomedPanScenario extends _PanScenario {
  LineZoomedPanScenario() : super(8);

  final _data = lineData(bars: 2, spots: 2000, showDots: true);

  @override
  String get name => 'line_zoomed_pan';

  @override
  String get description =>
      'Panning a line chart zoomed 8x, 2 lines x 2000 spots with dots';

  @override
  Type get chartType => LineChart;

  @override
  Widget build() => LineChart(
    _data,
    transformationConfig: FlTransformationConfig(
      scaleAxis: FlScaleAxis.horizontal,
      maxScale: 20,
      transformationController: controller,
    ),
  );
}

class BarHoverScenario extends _HoverScenario {
  final _data = barData();

  @override
  String get name => 'bar_hover';

  @override
  String get description =>
      'Mouse hover over a bar chart, 40 groups x 3 rods with labels';

  @override
  Type get chartType => BarChart;

  @override
  Widget build() => BarChart(_data);
}

class CandlestickZoomedPanScenario extends _PanScenario {
  CandlestickZoomedPanScenario() : super(10);

  final _data = candlestickData();

  @override
  String get name => 'candlestick_zoomed_pan';

  @override
  String get description =>
      'Panning a candlestick chart zoomed 10x, 1500 candles';

  @override
  Type get chartType => CandlestickChart;

  @override
  Widget build() => CandlestickChart(
    _data,
    transformationConfig: FlTransformationConfig(
      scaleAxis: FlScaleAxis.horizontal,
      maxScale: 20,
      transformationController: controller,
    ),
  );
}

class ScatterHoverScenario extends _HoverScenario {
  final _data = scatterData();

  @override
  String get name => 'scatter_hover';

  @override
  String get description => 'Mouse hover over a scatter chart, 2000 spots';

  @override
  Type get chartType => ScatterChart;

  @override
  Widget build() => ScatterChart(_data);
}

class PieHoverScenario extends _HoverScenario {
  final _touched = ValueNotifier(-1);

  @override
  String get name => 'pie_hover';

  @override
  String get description =>
      'Mouse circling a pie chart with sectionsSpace and borders, the touched section grows';

  @override
  Type get chartType => PieChart;

  @override
  Offset positionAt(Rect rect, int frame) {
    // Circles through the sections, 1 degree per frame.
    final angle = frame * pi / 180;
    return rect.center + Offset(cos(angle), sin(angle)) * 90;
  }

  @override
  Widget build() => ValueListenableBuilder<int>(
    valueListenable: _touched,
    builder: (context, touched, _) => PieChart(
      pieData(
        touched: touched,
        touchCallback: (event, response) {
          final index = response?.touchedSection?.touchedSectionIndex ?? -1;
          if (index != _touched.value) _touched.value = index;
        },
      ),
    ),
  );

  @override
  Future<void> tearDown(WidgetTester tester) async {
    await super.tearDown(tester);
    _touched.dispose();
  }
}

/// Every scenario, created fresh. Keep the order stable: it is the order
/// of the results tables.
List<Scenario> createScenarios() => [
  LineHoverScenario(),
  LineLargeHoverScenario(),
  LineAnimationScenario(),
  LineParentRebuildScenario(),
  LineZoomedPanScenario(),
  BarHoverScenario(),
  CandlestickZoomedPanScenario(),
  ScatterHoverScenario(),
  PieHoverScenario(),
];

/// A fresh instance of the scenario called [name].
Scenario createScenario(String name) =>
    createScenarios().firstWhere((scenario) => scenario.name == name);
