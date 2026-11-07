// The painters are internal API of fl_chart. This benchmark calls them
// directly, so it measures the drawing code without the widget pipeline.
// ignore_for_file: implementation_imports
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/candlestick_chart/candlestick_chart_painter.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_painter.dart';
import 'package:fl_chart/src/chart/pie_chart/pie_chart_painter.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'scenarios.dart';

/// Paints one chart into [canvas] at [chartSize].
typedef PaintChart = void Function(BuildContext context, Canvas canvas);

/// One painter benchmark: a chart's painter called directly.
class PainterCase {
  PainterCase(this.name, this.description, this.paint);

  final String name;
  final String description;
  final PaintChart paint;
}

PaintHolder<D> _holder<D extends BaseChartData>(D data, [Rect? virtualRect]) =>
    PaintHolder(data, data, TextScaler.noScaling, virtualRect);

CanvasWrapper _wrap(Canvas canvas) => CanvasWrapper(canvas, chartSize);

/// A virtual rect for a chart zoomed [scale] times horizontally, panned to
/// its middle.
Rect _zoomed(double scale) {
  final width = chartSize.width * scale;
  return Rect.fromLTWH(
    -(width - chartSize.width) / 2,
    0,
    width,
    chartSize.height,
  );
}

List<PainterCase> createPainterCases() {
  final line = lineData(bars: 3, spots: 5000).copyWith(minX: 0, maxX: 4999);
  final lineZoomed = lineData(
    bars: 2,
    spots: 2000,
    showDots: true,
  ).copyWith(minX: 0, maxX: 1999);
  final bar = barData().copyWith(minY: 0);
  final candles = candlestickData();
  final candleXs = candles.candlestickSpots.map((s) => s.x);
  final candleLows = candles.candlestickSpots.map((s) => s.low);
  final candleHighs = candles.candlestickSpots.map((s) => s.high);
  final candlesBounded = candles.copyWith(
    minX: candleXs.reduce((a, b) => a < b ? a : b),
    maxX: candleXs.reduce((a, b) => a > b ? a : b),
    minY: candleLows.reduce((a, b) => a < b ? a : b),
    maxY: candleHighs.reduce((a, b) => a > b ? a : b),
  );
  final scatter = scatterData();
  final pie = pieData();

  final linePainter = LineChartPainter();
  final barPainter = BarChartPainter();
  final candlestickPainter = CandlestickChartPainter();
  final scatterPainter = ScatterChartPainter();
  final piePainter = PieChartPainter();

  return [
    PainterCase(
      'line_paint',
      'LineChartPainter, 3 lines x 5000 spots, one filled area',
      (context, canvas) =>
          linePainter.paint(context, _wrap(canvas), _holder(line)),
    ),
    PainterCase(
      'line_zoomed_paint',
      'LineChartPainter zoomed 8x, 2 lines x 2000 spots with dots',
      (context, canvas) => linePainter.paint(
        context,
        _wrap(canvas),
        _holder(lineZoomed, _zoomed(8)),
      ),
    ),
    PainterCase(
      'bar_paint',
      'BarChartPainter, 40 groups x 3 rods with labels',
      (context, canvas) =>
          barPainter.paint(context, _wrap(canvas), _holder(bar)),
    ),
    PainterCase(
      'candlestick_zoomed_paint',
      'CandlestickChartPainter zoomed 10x, 1500 candles',
      (context, canvas) => candlestickPainter.paint(
        context,
        _wrap(canvas),
        _holder(candlesBounded, _zoomed(10)),
      ),
    ),
    PainterCase(
      'scatter_paint',
      'ScatterChartPainter, 2000 spots',
      (context, canvas) =>
          scatterPainter.paint(context, _wrap(canvas), _holder(scatter)),
    ),
    PainterCase(
      'pie_paint',
      'PieChartPainter, 10 sections with sectionsSpace and borders',
      (context, canvas) =>
          piePainter.paint(context, _wrap(canvas), _holder(pie)),
    ),
  ];
}

/// What one painter case measured, in milliseconds per paint.
class PainterResult {
  PainterResult(this.name, this.description, this.paintMs, this.rasterMs);

  final String name;
  final String description;

  /// Time to record one paint into a picture (CPU, UI thread work).
  final List<double> paintMs;

  /// Time to rasterize that picture into an image (the engine's raster
  /// work, in the test's software renderer).
  final List<double> rasterMs;

  Map<String, Object> toJson() => {
    'description': description,
    'paint_ms_median': _round(_median(paintMs)),
    'raster_ms_median': _round(_median(rasterMs)),
  };
}

double _round(double value) => (value * 1000).round() / 1000;

double _median(List<double> values) {
  final sorted = [...values]..sort();
  return sorted[sorted.length ~/ 2];
}

/// Paints [paintCase] [iterations] times per round, and rasterizes
/// [rasterSamples] of those pictures. Keeps the fastest of [rounds] rounds.
Future<PainterResult> runPainterCase(
  WidgetTester tester,
  PainterCase paintCase, {
  int rounds = 3,
  int iterations = 200,
  int rasterSamples = 20,
}) async {
  late BuildContext context;
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (c) {
          context = c;
          return const SizedBox();
        },
      ),
    ),
  );

  ui.Picture record() {
    final recorder = ui.PictureRecorder();
    paintCase.paint(context, Canvas(recorder));
    return recorder.endRecording();
  }

  // Warm up the JIT.
  for (var i = 0; i < 30; i++) {
    record().dispose();
  }

  List<double>? bestPaint;
  List<double>? bestRaster;
  final stopwatch = Stopwatch();
  for (var round = 0; round < rounds; round++) {
    final paintMs = <double>[];
    for (var i = 0; i < iterations; i++) {
      stopwatch
        ..reset()
        ..start();
      final picture = record();
      stopwatch.stop();
      paintMs.add(stopwatch.elapsedMicroseconds / 1000);
      picture.dispose();
    }

    final rasterMs = <double>[];
    await tester.runAsync(() async {
      for (var i = 0; i < rasterSamples; i++) {
        final picture = record();
        stopwatch
          ..reset()
          ..start();
        final image = await picture.toImage(
          chartSize.width.toInt(),
          chartSize.height.toInt(),
        );
        stopwatch.stop();
        rasterMs.add(stopwatch.elapsedMicroseconds / 1000);
        image.dispose();
        picture.dispose();
      }
    });

    if (bestPaint == null || _median(paintMs) < _median(bestPaint)) {
      bestPaint = paintMs;
    }
    if (bestRaster == null || _median(rasterMs) < _median(bestRaster)) {
      bestRaster = rasterMs;
    }
  }
  return PainterResult(
    paintCase.name,
    paintCase.description,
    bestPaint!,
    bestRaster!,
  );
}

/// Writes the results to `results/<label>.painters.json` and prints them.
void writePainterResults(String label, List<PainterResult> results) {
  final json = {
    'label': label,
    'kind': 'painter',
    'date': DateTime.now().toUtc().toIso8601String(),
    'dart': Platform.version.split(' ').first,
    'scenarios': {for (final r in results) r.name: r.toJson()},
  };
  final file = File('results/$label.painters.json')
    ..createSync(recursive: true);
  file.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(json)}\n',
  );

  final buffer = StringBuffer()
    ..writeln()
    ..writeln('Painter results for "$label" (ms, debug mode):')
    ..writeln('case                        paint(med)  raster(med)');
  for (final r in results) {
    final j = r.toJson();
    buffer.writeln(
      '${r.name.padRight(28)}'
      '${'${j['paint_ms_median']}'.padLeft(10)}'
      '${'${j['raster_ms_median']}'.padLeft(13)}',
    );
  }
  buffer.writeln('Saved to ${file.path}');
  debugPrint(buffer.toString());
}
