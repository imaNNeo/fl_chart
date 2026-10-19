import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../hosts.dart';
import '../theme.dart';
import 'line.dart';

/// The hosts of the classes shared by the charts, shown in a line chart.
final baseHosts = <String, Host>{
  'FlBorderData': Host(
    instance: () => FlBorderData(border: Border.all(color: Colors.white24)),
    build: (border) => _chart(borderData: border as FlBorderData),
  ),
  'FlTitlesData': Host(
    instance: () => sampleTitles,
    build: (titles) => _chart(titlesData: titles as FlTitlesData),
  ),
  'AxisTitles': Host(
    instance: () => const AxisTitles(
      axisNameWidget: Text('Sales', style: TextStyle(color: AppColors.muted)),
      axisNameSize: 20,
      sideTitles: SideTitles(showTitles: true, reservedSize: 28, interval: 1),
    ),
    build: (axisTitles) => _chart(
      titlesData: sampleTitles.copyWith(leftTitles: axisTitles as AxisTitles),
    ),
  ),
  'SideTitles': Host(
    instance: () =>
        const SideTitles(showTitles: true, reservedSize: 28, interval: 1),
    build: (sideTitles) => _chart(
      titlesData: sampleTitles.copyWith(
        leftTitles: AxisTitles(sideTitles: sideTitles as SideTitles),
      ),
    ),
  ),
  'FlGridData': Host(
    instance: () => const FlGridData(),
    build: (grid) => _chart(gridData: grid as FlGridData),
  ),
  'FlLine': Host(
    instance: () => const FlLine(color: Colors.white24, strokeWidth: 1),
    build: (line) => _chart(
      gridData: FlGridData(
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (_) => line as FlLine,
      ),
    ),
    note: 'Used here for the horizontal grid lines.',
  ),
  'FlSpot': Host(
    instance: () => sampleSpots[4],
    build: (spot) => _chart(
      bars: [
        sampleBar().copyWith(spots: [...sampleSpots]..[4] = spot as FlSpot),
      ],
    ),
    note: 'The fifth spot of the line.',
  ),
  'FlErrorRange': Host(
    instance: () => const FlErrorRange(lowerBy: 0.5, upperBy: 0.8),
    build: (range) => _chart(
      bars: [
        sampleBar().copyWith(
          spots: [
            for (final spot in sampleSpots)
              spot.copyWith(yError: range as FlErrorRange),
          ],
        ),
      ],
    ),
    note: 'The y error range of every spot.',
  ),
  'RangeAnnotations': Host(
    instance: () =>
        RangeAnnotations(horizontalRangeAnnotations: [_horizontalRange()]),
    build: (ranges) => _chart(rangeAnnotations: ranges as RangeAnnotations),
  ),
  'HorizontalRangeAnnotation': Host(
    instance: _horizontalRange,
    build: (range) => _chart(
      rangeAnnotations: RangeAnnotations(
        horizontalRangeAnnotations: [range as HorizontalRangeAnnotation],
      ),
    ),
  ),
  'VerticalRangeAnnotation': Host(
    instance: _verticalRange,
    build: (range) => _chart(
      rangeAnnotations: RangeAnnotations(
        verticalRangeAnnotations: [range as VerticalRangeAnnotation],
      ),
    ),
  ),
  'ExtraLinesData': Host(
    instance: () => ExtraLinesData(
      horizontalLines: [_horizontalLine()],
      verticalLines: [_verticalLine()],
    ),
    build: (extraLines) => _chart(extraLinesData: extraLines as ExtraLinesData),
  ),
  'HorizontalLine': Host(
    instance: _horizontalLine,
    build: (line) => _chart(
      extraLinesData: ExtraLinesData(horizontalLines: [line as HorizontalLine]),
    ),
  ),
  'VerticalLine': Host(
    instance: _verticalLine,
    build: (line) => _chart(
      extraLinesData: ExtraLinesData(verticalLines: [line as VerticalLine]),
    ),
  ),
  'SizedPicture': Host(
    instance: samplePicture,
    build: (picture) => _chart(
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          _horizontalLine(sizedPicture: picture as SizedPicture),
        ],
      ),
    ),
    note: 'The picture is drawn at the left side of the line.',
  ),
  'SideTitleFitInsideData': Host(
    instance: () => const SideTitleFitInsideData(
      enabled: true,
      axisPosition: 0,
      parentAxisSize: 0,
      distanceFromEdge: 0,
    ),
    build: (fitInside) => _chart(
      titlesData: sampleTitles.copyWith(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: 3,
            getTitlesWidget: (value, meta) => SideTitleWidget(
              meta: meta,
              fitInside: SideTitleFitInsideData.fromTitleMeta(
                meta,
                enabled: (fitInside as SideTitleFitInsideData).enabled,
                distanceFromEdge: fitInside.distanceFromEdge,
              ),
              child: Text(
                meta.formattedValue,
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    ),
    note:
        'Enable it to keep the first and last label inside the axis. '
        '`parentAxisSize` and `axisPosition` come from the `TitleMeta` here.',
  ),
  'HorizontalLineLabel': Host(
    instance: () => HorizontalLineLabel(
      show: true,
      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
    ),
    build: (label) => _chart(
      extraLinesData: ExtraLinesData(
        horizontalLines: [_horizontalLine(label: label as HorizontalLineLabel)],
      ),
    ),
  ),
  'VerticalLineLabel': Host(
    instance: () => VerticalLineLabel(
      show: true,
      style: const TextStyle(
        color: Colors.pinkAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    build: (label) => _chart(
      extraLinesData: ExtraLinesData(
        verticalLines: [_verticalLine(label: label as VerticalLineLabel)],
      ),
    ),
  ),
};

HorizontalRangeAnnotation _horizontalRange() => HorizontalRangeAnnotation(
  y1: 2,
  y2: 4,
  color: AppColors.primary.withValues(alpha: 0.15),
);

VerticalRangeAnnotation _verticalRange() => VerticalRangeAnnotation(
  x1: 3,
  x2: 6,
  color: AppColors.secondary.withValues(alpha: 0.2),
);

HorizontalLine _horizontalLine({
  HorizontalLineLabel? label,
  SizedPicture? sizedPicture,
}) => HorizontalLine(
  y: 4.5,
  color: Colors.amber,
  strokeWidth: 2,
  dashArray: [6, 4],
  label: label,
  sizedPicture: sizedPicture,
);

VerticalLine _verticalLine({VerticalLineLabel? label}) => VerticalLine(
  x: 7,
  color: Colors.pinkAccent,
  strokeWidth: 2,
  dashArray: [6, 4],
  label: label,
);

Widget _chart({
  List<LineChartBarData>? bars,
  FlBorderData? borderData,
  FlTitlesData? titlesData,
  FlGridData? gridData,
  RangeAnnotations? rangeAnnotations,
  ExtraLinesData? extraLinesData,
}) {
  final chart = sampleChart(bars: bars, lineTouchData: noBuiltInTouches);
  return LineChart(
    chart.copyWith(
      borderData: borderData,
      titlesData: titlesData,
      gridData: gridData,
      rangeAnnotations: rangeAnnotations,
      extraLinesData: extraLinesData,
    ),
  );
}

/// A picture the extra lines can draw, without shipping an asset.
SizedPicture samplePicture() {
  final recorder = ui.PictureRecorder();
  Canvas(recorder).drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(0, 0, 18, 18),
      const Radius.circular(4),
    ),
    Paint()..color = Colors.amber,
  );
  return SizedPicture(recorder.endRecording(), 18, 18);
}

/// An image the extra lines can draw, without shipping an asset.
ui.Image sampleImage() {
  final recorder = ui.PictureRecorder();
  Canvas(
    recorder,
  ).drawCircle(const Offset(9, 9), 9, Paint()..color = AppColors.secondary);
  return recorder.endRecording().toImageSync(18, 18);
}
