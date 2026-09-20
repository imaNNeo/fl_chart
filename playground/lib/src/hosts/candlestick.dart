import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../hosts.dart';
import '../theme.dart';

/// The hosts of the candlestick chart classes (and of the touch indicator
/// of the axis based charts, which the candlestick chart uses).
final candlestickHosts = <String, Host>{
  'CandlestickChartData': Host(
    instance: sampleCandlestickChart,
    build: (data) => CandlestickChart(data as CandlestickChartData),
    note: 'Hover or touch the candles.',
  ),
  'CandlestickSpot': Host(
    instance: () => sampleCandles()[4],
    build: (spot) => CandlestickChart(
      sampleCandlestickChart(
        spots: [...sampleCandles()]..[4] = spot as CandlestickSpot,
      ),
    ),
    note: 'The fifth candle.',
  ),
  'CandlestickTouchData': Host(
    instance: CandlestickTouchData.new,
    build: (touch) => CandlestickChart(
      sampleCandlestickChart(touchData: touch as CandlestickTouchData),
    ),
    note: 'Hover or touch the candles.',
  ),
  'CandlestickTouchTooltipData': Host(
    instance: () => CandlestickTouchTooltipData(),
    build: (tooltip) => CandlestickChart(
      sampleCandlestickChart(
        touchData: CandlestickTouchData(
          handleBuiltInTouches: false,
          touchTooltipData: tooltip as CandlestickTouchTooltipData,
        ),
        showingTooltipIndicators: [4],
      ),
    ),
  ),
  'CandlestickTooltipItem': Host(
    instance: () => CandlestickTooltipItem(
      'Open 4.2\nClose 5.1',
      textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    build: (item) => CandlestickChart(
      sampleCandlestickChart(
        touchData: CandlestickTouchData(
          handleBuiltInTouches: false,
          touchTooltipData: CandlestickTouchTooltipData(
            getTooltipItems: (painter, spot, index) =>
                item as CandlestickTooltipItem,
          ),
        ),
        showingTooltipIndicators: [4],
      ),
    ),
  ),
  'AxisSpotIndicator': Host(
    instance: () => AxisSpotIndicator(
      x: 5,
      y: 5.1,
      painter: AxisLinesIndicatorPainter(
        verticalLineProvider: (x) =>
            VerticalLine(x: x, color: Colors.white54, dashArray: [4, 4]),
        horizontalLineProvider: (y) =>
            HorizontalLine(y: y, color: Colors.white54, dashArray: [4, 4]),
      ),
    ),
    build: (indicator) => CandlestickChart(
      sampleCandlestickChart(
        touchData: CandlestickTouchData(handleBuiltInTouches: false),
        touchedPointIndicator: indicator as AxisSpotIndicator,
      ),
    ),
    note: 'The indicator the candlestick chart shows on the touched point.',
  ),
};

const _candles = [
  (1.0, 3.2, 4.0, 3.0, 3.8),
  (2.0, 3.8, 4.4, 3.6, 4.2),
  (3.0, 4.2, 4.6, 3.4, 3.6),
  (4.0, 3.6, 4.2, 3.2, 4.0),
  (5.0, 4.2, 5.4, 4.0, 5.1),
  (6.0, 5.1, 5.6, 4.6, 4.8),
  (7.0, 4.8, 5.2, 4.2, 4.4),
  (8.0, 4.4, 5.8, 4.3, 5.6),
  (9.0, 5.6, 6.0, 5.2, 5.4),
  (10.0, 5.4, 5.6, 4.8, 5.0),
];

List<CandlestickSpot> sampleCandles() => [
  for (final (x, open, high, low, close) in _candles)
    CandlestickSpot(x: x, open: open, high: high, low: low, close: close),
];

/// The chart the candlestick demos live in, styled like the website.
CandlestickChartData sampleCandlestickChart({
  List<CandlestickSpot>? spots,
  CandlestickTouchData? touchData,
  List<int> showingTooltipIndicators = const [],
  AxisSpotIndicator? touchedPointIndicator,
}) => CandlestickChartData(
  candlestickSpots: spots ?? sampleCandles(),
  candlestickTouchData: touchData,
  showingTooltipIndicators: showingTooltipIndicators,
  touchedPointIndicator: touchedPointIndicator,
  minY: 2,
  maxY: 7,
  gridData: FlGridData(
    drawVerticalLine: false,
    horizontalInterval: 1,
    getDrawingHorizontalLine: (_) =>
        const FlLine(color: AppColors.border, strokeWidth: 1),
  ),
  borderData: FlBorderData(show: false),
  titlesData: const FlTitlesData(
    topTitles: AxisTitles(),
    rightTitles: AxisTitles(),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: true, reservedSize: 28, interval: 1),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: true, reservedSize: 24, interval: 2),
    ),
  ),
);
