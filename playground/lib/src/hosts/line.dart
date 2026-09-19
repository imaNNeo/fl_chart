import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../hosts.dart';
import '../theme.dart';

/// The hosts of the line chart classes.
final lineHosts = <String, Host>{
  'LineChartData': Host(
    instance: sampleChart,
    build: (data) => LineChart(data as LineChartData),
    note: 'Hover or touch the chart to see its tooltips.',
  ),
  'LineChartBarData': Host(
    instance: sampleBar,
    build: (bar) => _chart([bar as LineChartBarData]),
  ),
  'LineChartStepData': Host(
    instance: () => const LineChartStepData(),
    build: (step) => _chart([
      sampleBar().copyWith(
        isStepLineChart: true,
        lineChartStepData: step as LineChartStepData,
      ),
    ]),
  ),
  'BetweenBarsData': Host(
    instance: () => BetweenBarsData(
      fromIndex: 0,
      toIndex: 1,
      color: AppColors.secondary.withValues(alpha: 0.3),
    ),
    build: (between) => LineChart(
      sampleChart(
        bars: [sampleBar(), otherBar()],
        betweenBarsData: [between as BetweenBarsData],
        lineTouchData: noBuiltInTouches,
      ),
    ),
  ),
  'BarAreaData': Host(
    instance: () => BarAreaData(
      show: true,
      color: AppColors.primary.withValues(alpha: 0.2),
    ),
    build: (area) =>
        _chart([sampleBar().copyWith(belowBarData: area as BarAreaData)]),
  ),
  'BarAreaSpotsLine': Host(
    instance: () => const BarAreaSpotsLine(show: true),
    build: (spotsLine) => _chart([
      sampleBar().copyWith(
        belowBarData: BarAreaData(
          show: true,
          color: AppColors.primary.withValues(alpha: 0.15),
          cutOffY: 2,
          applyCutOffY: true,
          spotsLine: spotsLine as BarAreaSpotsLine,
        ),
      ),
    ]),
  ),
  'FlDotData': Host(
    instance: () => const FlDotData(),
    build: (dots) => _chart([sampleBar().copyWith(dotData: dots as FlDotData)]),
  ),
  'LineTouchData': Host(
    instance: () => const LineTouchData(),
    build: (touch) =>
        LineChart(sampleChart(lineTouchData: touch as LineTouchData)),
    note: 'Hover or touch the chart.',
  ),
  'LineTouchTooltipData': Host(
    instance: () => const LineTouchTooltipData(),
    build: (tooltip) => LineChart(
      sampleChart(
        lineTouchData: LineTouchData(
          handleBuiltInTouches: false,
          touchTooltipData: tooltip as LineTouchTooltipData,
        ),
        showingTooltipIndicators: [tooltipAt(4)],
      ),
    ),
  ),
  'LineTooltipItem': Host(
    instance: () => const LineTooltipItem(
      'Sales: 5.4',
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    build: (item) => LineChart(
      sampleChart(
        lineTouchData: LineTouchData(
          handleBuiltInTouches: false,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) => [
              for (final _ in spots) item as LineTooltipItem,
            ],
          ),
        ),
        showingTooltipIndicators: [tooltipAt(4)],
      ),
    ),
  ),
  'TouchedSpotIndicatorData': Host(
    instance: () => TouchedSpotIndicatorData(
      const FlLine(color: Colors.white70, strokeWidth: 2, dashArray: [4, 4]),
      FlDotData(
        getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
          radius: 6,
          color: AppColors.primary,
          strokeWidth: 2,
          strokeColor: Colors.white,
        ),
      ),
    ),
    build: (indicator) => LineChart(
      sampleChart(
        bars: [
          sampleBar().copyWith(showingIndicators: [4]),
        ],
        lineTouchData: LineTouchData(
          handleBuiltInTouches: false,
          getTouchedSpotIndicator: (bar, indices) => [
            for (final _ in indices) indicator as TouchedSpotIndicatorData,
          ],
        ),
      ),
    ),
  ),
  'ShowingTooltipIndicators': Host(
    instance: () => tooltipAt(4),
    build: (tooltip) => LineChart(
      sampleChart(
        lineTouchData: noBuiltInTouches,
        showingTooltipIndicators: [tooltip as ShowingTooltipIndicators],
      ),
    ),
  ),
};

const sampleSpots = [
  FlSpot(0, 3),
  FlSpot(1, 1.8),
  FlSpot(2, 4.2),
  FlSpot(3, 3.1),
  FlSpot(4, 5.4),
  FlSpot(5, 3.8),
  FlSpot(6, 4.6),
  FlSpot(7, 2.6),
  FlSpot(8, 4.9),
  FlSpot(9, 3.7),
  FlSpot(10, 5.9),
];

const otherSpots = [
  FlSpot(0, 1.2),
  FlSpot(1, 0.8),
  FlSpot(2, 2.1),
  FlSpot(3, 1.4),
  FlSpot(4, 2.9),
  FlSpot(5, 1.9),
  FlSpot(6, 2.4),
  FlSpot(7, 1.1),
  FlSpot(8, 2.6),
  FlSpot(9, 1.6),
  FlSpot(10, 3.1),
];

/// Built-in touches replace the tooltips and indicators that a demo shows.
const noBuiltInTouches = LineTouchData(handleBuiltInTouches: false);

LineChartBarData sampleBar() =>
    LineChartBarData(spots: sampleSpots, color: AppColors.primary, barWidth: 3);

LineChartBarData otherBar() => LineChartBarData(
  spots: otherSpots,
  color: AppColors.secondary,
  barWidth: 3,
);

LineBarSpot spotAt(int index) {
  final bar = sampleBar();
  return LineBarSpot(bar, 0, bar.spots[index]);
}

ShowingTooltipIndicators tooltipAt(int index) =>
    ShowingTooltipIndicators([spotAt(index)]);

/// The chart the demos live in, styled like the website.
LineChartData sampleChart({
  List<LineChartBarData>? bars,
  List<BetweenBarsData> betweenBarsData = const [],
  LineTouchData lineTouchData = const LineTouchData(),
  List<ShowingTooltipIndicators> showingTooltipIndicators = const [],
}) => LineChartData(
  lineBarsData: bars ?? [sampleBar()],
  betweenBarsData: betweenBarsData,
  lineTouchData: lineTouchData,
  showingTooltipIndicators: showingTooltipIndicators,
  minY: 0,
  maxY: 7,
  gridData: FlGridData(
    drawVerticalLine: false,
    horizontalInterval: 1,
    getDrawingHorizontalLine: (_) =>
        const FlLine(color: AppColors.border, strokeWidth: 1),
  ),
  borderData: FlBorderData(show: false),
  titlesData: sampleTitles,
);

/// The titles of [sampleChart].
const sampleTitles = FlTitlesData(
  topTitles: AxisTitles(),
  rightTitles: AxisTitles(),
  leftTitles: AxisTitles(
    sideTitles: SideTitles(showTitles: true, reservedSize: 28, interval: 1),
  ),
  bottomTitles: AxisTitles(
    sideTitles: SideTitles(showTitles: true, reservedSize: 24, interval: 2),
  ),
);

Widget _chart(List<LineChartBarData> bars) =>
    LineChart(sampleChart(bars: bars, lineTouchData: noBuiltInTouches));
