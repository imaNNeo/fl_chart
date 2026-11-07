import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'scenarios.dart';

/// Hosts a scenario's chart at [chartSize], the same way in every run.
Widget hostScenario(Scenario scenario) => MaterialApp(
  debugShowCheckedModeBanner: false,
  home: Scaffold(
    body: Center(
      child: SizedBox.fromSize(size: chartSize, child: scenario.build()),
    ),
  ),
);

/// What one scenario measured. All times are per frame, in milliseconds.
class ScenarioResult {
  ScenarioResult({
    required this.name,
    required this.description,
    required this.frames,
    required this.frameMs,
    required this.buildMs,
    required this.layoutMs,
    required this.paintMs,
    required this.chartPaintMs,
    required this.chartPaints,
    required this.rebuilds,
  });

  final String name;
  final String description;
  final int frames;

  /// Wall time of each frame: the scenario's step and the whole pump.
  final List<double> frameMs;

  /// Totals over all frames, from the framework's timeline blocks.
  final double buildMs;
  final double layoutMs;
  final double paintMs;

  /// Time spent in the chart render objects' own paint.
  final double chartPaintMs;

  /// How many times a chart render object painted.
  final int chartPaints;

  /// How many widgets were rebuilt.
  final int rebuilds;

  Map<String, Object> toJson() => {
    'description': description,
    'frames': frames,
    'frame_ms_median': _round(_percentile(frameMs, 0.5)),
    'frame_ms_p90': _round(_percentile(frameMs, 0.9)),
    'frame_ms_mean': _round(frameMs.reduce((a, b) => a + b) / frames),
    'build_ms_per_frame': _round(buildMs / frames),
    'layout_ms_per_frame': _round(layoutMs / frames),
    'paint_ms_per_frame': _round(paintMs / frames),
    'chart_paint_ms_per_frame': _round(chartPaintMs / frames),
    'chart_paints_per_frame': _round(chartPaints / frames),
    'rebuilds_per_frame': _round(rebuilds / frames),
  };
}

double _round(double value) => (value * 1000).round() / 1000;

double _percentile(List<double> values, double p) {
  final sorted = [...values]..sort();
  final index = ((sorted.length - 1) * p).round();
  return sorted[index];
}

/// Runs the scenario [rounds] times and keeps the fastest round.
///
/// Each round makes a fresh scenario with [create], pumps [warmup] untimed
/// frames, then [frames] timed ones. Each frame is the scenario's step plus a
/// 16 ms pump. Keeping the fastest round filters out noise from the machine
/// (GC, other processes); the counts are the same in every round.
///
/// This runs in a debug-mode `flutter test`, so the absolute numbers are
/// higher than in a release build: compare runs with each other, not with a
/// frame budget.
Future<ScenarioResult> runScenario(
  WidgetTester tester,
  Scenario Function() create, {
  int rounds = 3,
  int warmup = 60,
  int frames = 400,
}) async {
  ScenarioResult? best;
  for (var round = 0; round < rounds; round++) {
    final result = await _runRound(tester, create(), warmup, frames);
    if (best == null ||
        _percentile(result.frameMs, 0.5) < _percentile(best.frameMs, 0.5)) {
      best = result;
    }
  }
  return best!;
}

Future<ScenarioResult> _runRound(
  WidgetTester tester,
  Scenario scenario,
  int warmup,
  int frames,
) async {
  tester.view
    ..physicalSize = const Size(1000, 600)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(hostScenario(scenario));
  await scenario.setUp(tester);
  await tester.pump();

  const frameInterval = Duration(milliseconds: 16);
  for (var i = 0; i < warmup; i++) {
    await scenario.step(tester, i);
    await tester.pump(frameInterval);
  }

  var rebuilds = 0;
  final frameMs = <double>[];
  final stopwatch = Stopwatch();

  debugProfilePaintsEnabled = true;
  debugOnRebuildDirtyWidget = (_, _) => rebuilds++;
  FlutterTimeline.debugCollectionEnabled = true;
  FlutterTimeline.debugReset();
  try {
    for (var i = 0; i < frames; i++) {
      stopwatch
        ..reset()
        ..start();
      await scenario.step(tester, warmup + i);
      await tester.pump(frameInterval);
      stopwatch.stop();
      frameMs.add(stopwatch.elapsedMicroseconds / 1000);
    }
  } finally {
    debugProfilePaintsEnabled = false;
    debugOnRebuildDirtyWidget = null;
  }
  final timings = FlutterTimeline.debugCollect();
  FlutterTimeline.debugCollectionEnabled = false;

  double total(bool Function(String name) test) => timings.aggregatedBlocks
      .where((block) => test(block.name))
      // Timeline durations are in microseconds.
      .fold(0.0, (sum, block) => sum + block.duration / 1000);

  // The chart render objects are RenderLineChart, RenderBarChart, ...
  bool isChart(String name) => RegExp(r'^Render\w+Chart$').hasMatch(name);
  final chartPaints = timings.aggregatedBlocks
      .where((block) => isChart(block.name))
      .fold(0, (sum, block) => sum + block.count);

  await scenario.tearDown(tester);
  // Unmount, so the next scenario starts clean.
  await tester.pumpWidget(const SizedBox());

  return ScenarioResult(
    name: scenario.name,
    description: scenario.description,
    frames: frames,
    frameMs: frameMs,
    buildMs: total((name) => name == 'BUILD'),
    layoutMs: total((name) => name.startsWith('LAYOUT')),
    paintMs: total((name) => name.startsWith('PAINT')),
    chartPaintMs: total(isChart),
    chartPaints: chartPaints,
    rebuilds: rebuilds,
  );
}

/// Writes the results to `results/<label>.json` and prints a summary.
void writeResults(String label, List<ScenarioResult> results) {
  final json = {
    'label': label,
    'kind': 'cpu',
    'date': DateTime.now().toUtc().toIso8601String(),
    'dart': Platform.version.split(' ').first,
    'scenarios': {for (final r in results) r.name: r.toJson()},
  };
  final file = File('results/$label.json')..createSync(recursive: true);
  file.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(json)}\n',
  );

  final buffer = StringBuffer()
    ..writeln()
    ..writeln('Results for "$label" (ms per frame, debug mode):')
    ..writeln(
      'scenario                  frame(med)  frame(p90)   build   paint  chart-paint  paints  rebuilds',
    );
  for (final r in results) {
    final j = r.toJson();
    buffer.writeln(
      '${r.name.padRight(26)}'
      '${'${j['frame_ms_median']}'.padLeft(10)}'
      '${'${j['frame_ms_p90']}'.padLeft(12)}'
      '${'${j['build_ms_per_frame']}'.padLeft(8)}'
      '${'${j['paint_ms_per_frame']}'.padLeft(8)}'
      '${'${j['chart_paint_ms_per_frame']}'.padLeft(13)}'
      '${'${j['chart_paints_per_frame']}'.padLeft(8)}'
      '${'${j['rebuilds_per_frame']}'.padLeft(10)}',
    );
  }
  buffer.writeln('Saved to ${file.path}');
  debugPrint(buffer.toString());
}
