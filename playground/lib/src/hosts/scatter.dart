import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../hosts.dart';
import '../theme.dart';
import 'line.dart';

/// The hosts of the scatter chart classes.
final scatterHosts = <String, Host>{
  'ScatterChartData': Host(
    instance: sampleScatterChart,
    build: (data) => ScatterChart(data as ScatterChartData),
    note: 'Hover or touch the spots.',
  ),
  'ScatterSpot': Host(
    instance: () => sampleScatterSpots()[2],
    build: (spot) => ScatterChart(
      sampleScatterChart(
        spots: [...sampleScatterSpots()]..[2] = spot as ScatterSpot,
      ),
    ),
    note: 'The amber spot at (4, 3.2).',
  ),
  'ScatterTouchData': Host(
    instance: ScatterTouchData.new,
    build: (touch) => ScatterChart(
      sampleScatterChart(scatterTouchData: touch as ScatterTouchData),
    ),
    note: 'Hover or touch the spots.',
  ),
  'ScatterTouchTooltipData': Host(
    instance: () => const ScatterTouchTooltipData(),
    build: (tooltip) => ScatterChart(
      sampleScatterChart(
        scatterTouchData: ScatterTouchData(
          handleBuiltInTouches: false,
          touchTooltipData: tooltip as ScatterTouchTooltipData,
        ),
        showingTooltipIndicators: [3],
      ),
    ),
  ),
  'ScatterTooltipItem': Host(
    instance: () => ScatterTooltipItem(
      '5.2, 5.6',
      textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    build: (item) => ScatterChart(
      sampleScatterChart(
        scatterTouchData: ScatterTouchData(
          handleBuiltInTouches: false,
          touchTooltipData: ScatterTouchTooltipData(
            getTooltipItems: (spot) => item as ScatterTooltipItem,
          ),
        ),
        showingTooltipIndicators: [3],
      ),
    ),
  ),
  'ScatterLabelSettings': Host(
    instance: () => ScatterLabelSettings(
      showLabel: true,
      getLabelFunction: (index, spot) => '${spot.y}',
      getLabelTextStyleFunction: (index, spot) =>
          const TextStyle(color: Colors.white, fontSize: 11),
    ),
    build: (labels) => ScatterChart(
      sampleScatterChart(scatterLabelSettings: labels as ScatterLabelSettings),
    ),
  ),
};

List<ScatterSpot> sampleScatterSpots() => [
  for (final (x, y, radius, color) in [
    (1.5, 2.2, 10.0, AppColors.primary),
    (2.8, 4.6, 6.0, AppColors.secondary),
    (4.0, 3.2, 14.0, Colors.amber),
    (5.2, 5.6, 8.0, AppColors.primary),
    (6.4, 1.8, 12.0, Colors.pinkAccent),
    (7.6, 4.2, 6.0, AppColors.secondary),
    (8.8, 5.2, 10.0, Colors.amber),
    (3.4, 6.2, 5.0, Colors.pinkAccent),
  ])
    ScatterSpot(
      x,
      y,
      dotPainter: FlDotCirclePainter(
        radius: radius,
        color: color.withValues(alpha: 0.85),
      ),
    ),
];

/// The chart the scatter demos live in, styled like the website.
ScatterChartData sampleScatterChart({
  List<ScatterSpot>? spots,
  ScatterTouchData? scatterTouchData,
  List<int> showingTooltipIndicators = const [],
  ScatterLabelSettings? scatterLabelSettings,
}) => ScatterChartData(
  scatterSpots: spots ?? sampleScatterSpots(),
  scatterTouchData: scatterTouchData,
  showingTooltipIndicators: showingTooltipIndicators,
  scatterLabelSettings: scatterLabelSettings,
  minX: 0,
  maxX: 10,
  minY: 0,
  maxY: 7,
  gridData: FlGridData(
    horizontalInterval: 1,
    verticalInterval: 1,
    getDrawingHorizontalLine: (_) =>
        const FlLine(color: AppColors.border, strokeWidth: 1),
    getDrawingVerticalLine: (_) =>
        const FlLine(color: AppColors.border, strokeWidth: 1),
  ),
  borderData: FlBorderData(show: false),
  titlesData: sampleTitles,
);
