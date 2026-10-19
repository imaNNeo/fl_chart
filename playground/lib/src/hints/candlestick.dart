import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../hints.dart';

/// The hints of the candlestick chart properties (and of the touch
/// indicator of the axis based charts).
final candlestickHints = <String, PropertyHint>{
  // CandlestickChartData
  'CandlestickChartData.candlestickSpots': PropertyHint(
    sample:
        '[CandlestickSpot(x: 1, open: 3.2, high: 4, low: 3, close: 3.8), CandlestickSpot(x: 2, open: 3.8, high: 4.4, low: 3.6, close: 4.2), ...]',
    presets: [
      Preset(
        '[CandlestickSpot(x: 1, open: 3, high: 5, low: 2.5, close: 4.5), CandlestickSpot(x: 2, open: 4.5, high: 6, low: 4, close: 4.2)]',
        [
          CandlestickSpot(x: 1, open: 3, high: 5, low: 2.5, close: 4.5),
          CandlestickSpot(x: 2, open: 4.5, high: 6, low: 4, close: 4.2),
        ],
      ),
    ],
  ),
  'CandlestickChartData.candlestickPainter': PropertyHint(
    presets: [
      Preset(
        'DefaultCandlestickPainter(candlestickStyleProvider: (spot, index) => CandlestickStyle(lineColor: ..., bodyFillColor: spot.close >= spot.open ? Colors.green : Colors.red, ...))',
        DefaultCandlestickPainter(candlestickStyleProvider: _greenAndRed),
      ),
    ],
  ),
  'CandlestickChartData.titlesData': const PropertyHint(
    sample:
        'FlTitlesData(topTitles: AxisTitles(), rightTitles: AxisTitles(), leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28, interval: 1)), bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 24, interval: 2)))',
    presets: [Preset('FlTitlesData(show: false)', FlTitlesData(show: false))],
  ),
  'CandlestickChartData.candlestickTouchData': PropertyHint(
    presets: [
      Preset(
        'CandlestickTouchData(enabled: false)',
        CandlestickTouchData(enabled: false),
      ),
    ],
  ),
  'CandlestickChartData.showingTooltipIndicators': PropertyHint(
    requires: {
      'candlestickTouchData': Preset(
        'CandlestickTouchData(handleBuiltInTouches: false)',
        CandlestickTouchData(handleBuiltInTouches: false),
      ),
    },
    presets: const [
      Preset('[4]', [4]),
      Preset('[2, 7]', [2, 7]),
    ],
  ),
  'CandlestickChartData.gridData': const PropertyHint(
    sample:
        'FlGridData(drawVerticalLine: false, horizontalInterval: 1, getDrawingHorizontalLine: (_) => FlLine(color: Color(0x1affffff), strokeWidth: 1))',
    presets: [
      Preset('FlGridData(show: false)', FlGridData(show: false)),
      Preset('FlGridData()', FlGridData()),
    ],
  ),
  'CandlestickChartData.borderData': PropertyHint(
    sample: 'FlBorderData(show: false)',
    presets: [
      Preset(
        'FlBorderData(border: Border.all(color: Colors.white24))',
        FlBorderData(border: Border.all(color: Colors.white24)),
      ),
    ],
  ),
  'CandlestickChartData.minX': const PropertyHint(min: -2, max: 4),
  'CandlestickChartData.maxX': const PropertyHint(min: 8, max: 14),
  'CandlestickChartData.baselineX': const PropertyHint(min: 0, max: 1),
  'CandlestickChartData.minY': const PropertyHint(min: 0, max: 4),
  'CandlestickChartData.maxY': const PropertyHint(min: 5, max: 10),
  'CandlestickChartData.baselineY': const PropertyHint(min: 0, max: 1),
  'CandlestickChartData.rangeAnnotations': PropertyHint(
    presets: [
      Preset(
        'RangeAnnotations(horizontalRangeAnnotations: [HorizontalRangeAnnotation(y1: 4, y2: 5, color: Colors.white10)])',
        RangeAnnotations(
          horizontalRangeAnnotations: [
            HorizontalRangeAnnotation(y1: 4, y2: 5, color: Colors.white10),
          ],
        ),
      ),
    ],
  ),
  'CandlestickChartData.clipData': const PropertyHint(
    requires: {'maxY': 5.0},
    presets: [Preset('FlClipData.all()', FlClipData.all())],
  ),
  'CandlestickChartData.rotationQuarterTurns': const PropertyHint(
    min: 0,
    max: 3,
  ),
  'CandlestickChartData.touchedPointIndicator': PropertyHint(
    requires: {
      'candlestickTouchData': Preset(
        'CandlestickTouchData(handleBuiltInTouches: false)',
        CandlestickTouchData(handleBuiltInTouches: false),
      ),
    },
    presets: [
      Preset(
        'AxisSpotIndicator(x: 5, y: 5.1, painter: AxisLinesIndicatorPainter(...))',
        AxisSpotIndicator(
          x: 5,
          y: 5.1,
          painter: AxisLinesIndicatorPainter(
            verticalLineProvider: (x) =>
                VerticalLine(x: x, color: Colors.amber),
            horizontalLineProvider: (y) =>
                HorizontalLine(y: y, color: Colors.amber),
          ),
        ),
      ),
    ],
  ),

  // CandlestickSpot
  'CandlestickSpot.x': const PropertyHint(min: 0, max: 11),
  'CandlestickSpot.open': const PropertyHint(min: 2, max: 7),
  'CandlestickSpot.high': const PropertyHint(min: 2, max: 7),
  'CandlestickSpot.low': const PropertyHint(min: 2, max: 7),
  'CandlestickSpot.close': const PropertyHint(min: 2, max: 7),

  // CandlestickTouchData
  'CandlestickTouchData.touchTooltipData': PropertyHint(
    presets: [
      Preset(
        'CandlestickTouchTooltipData(getTooltipColor: (spot) => Colors.deepPurple, tooltipBorderRadius: BorderRadius.all(Radius.circular(16)))',
        CandlestickTouchTooltipData(
          getTooltipColor: _deepPurple,
          tooltipBorderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    ],
  ),
  'CandlestickTouchData.mouseCursorResolver': const PropertyHint(
    presets: [
      Preset('(event, response) => SystemMouseCursors.click', _clickCursor),
    ],
    note: 'Hover the chart to see the cursor.',
  ),
  'CandlestickTouchData.longPressDuration': const PropertyHint(
    presets: [
      Preset('Duration(milliseconds: 100)', Duration(milliseconds: 100)),
      Preset('Duration(seconds: 2)', Duration(seconds: 2)),
    ],
  ),
  'CandlestickTouchData.touchCallback': const PropertyHint(
    presets: [
      Preset(
        "(event, response) => debugPrint('\${event.runtimeType}')",
        _printTouch,
      ),
    ],
    note: 'It prints into the browser console, it changes nothing here.',
  ),
  'CandlestickTouchData.touchSpotThreshold': const PropertyHint(
    min: 0,
    max: 40,
  ),

  // CandlestickTouchTooltipData
  'CandlestickTouchTooltipData.tooltipBorderRadius': const PropertyHint(
    presets: [
      Preset('BorderRadius.zero', BorderRadius.zero),
      Preset(
        'BorderRadius.all(Radius.circular(16))',
        BorderRadius.all(Radius.circular(16)),
      ),
    ],
  ),
  'CandlestickTouchTooltipData.tooltipPadding': const PropertyHint(
    presets: [
      Preset('EdgeInsets.all(4)', EdgeInsets.all(4)),
      Preset('EdgeInsets.all(20)', EdgeInsets.all(20)),
    ],
  ),
  'CandlestickTouchTooltipData.tooltipHorizontalOffset': const PropertyHint(
    min: -60,
    max: 60,
  ),
  'CandlestickTouchTooltipData.maxContentWidth': const PropertyHint(
    min: 20,
    max: 200,
  ),
  'CandlestickTouchTooltipData.rotateAngle': const PropertyHint(
    min: 0,
    max: 360,
  ),
  'CandlestickTouchTooltipData.tooltipBorder': const PropertyHint(
    presets: [
      Preset(
        'BorderSide(color: Colors.white, width: 2)',
        BorderSide(color: Colors.white, width: 2),
      ),
    ],
  ),
  'CandlestickTouchTooltipData.getTooltipColor': const PropertyHint(
    presets: [Preset('(spot) => Colors.deepPurple', _deepPurple)],
  ),

  'CandlestickTouchTooltipData.getTooltipItems': const PropertyHint(
    presets: [
      Preset(
        "(painter, spot, index) => CandlestickTooltipItem('close \${spot.close}', textStyle: TextStyle(color: Colors.amber))",
        _tooltipItem,
      ),
    ],
  ),

  // CandlestickTooltipItem
  'CandlestickTooltipItem.textStyle': const PropertyHint(
    sample: 'TextStyle(color: Colors.white, fontWeight: FontWeight.bold)',
    presets: [
      Preset(
        'TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold)',
        TextStyle(
          color: Colors.amber,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
  'CandlestickTooltipItem.bottomMargin': const PropertyHint(min: 0, max: 40),
  'CandlestickTooltipItem.children': const PropertyHint(
    presets: [
      Preset(
        "[TextSpan(text: ' +12%', style: TextStyle(color: Colors.greenAccent))]",
        [
          TextSpan(
            text: ' +12%',
            style: TextStyle(color: Colors.greenAccent),
          ),
        ],
      ),
    ],
  ),

  // AxisSpotIndicator
  'AxisSpotIndicator.x': const PropertyHint(min: 1, max: 10),
  'AxisSpotIndicator.y': const PropertyHint(min: 2, max: 7),
  'AxisSpotIndicator.painter': PropertyHint(
    sample:
        'AxisLinesIndicatorPainter(verticalLineProvider: (x) => VerticalLine(x: x, color: Colors.white54, dashArray: [4, 4]), horizontalLineProvider: (y) => HorizontalLine(y: y, color: Colors.white54, dashArray: [4, 4]))',
    presets: [
      Preset(
        'AxisLinesIndicatorPainter(verticalLineProvider: (x) => VerticalLine(x: x, color: Colors.amber, strokeWidth: 3), horizontalLineProvider: (y) => null)',
        AxisLinesIndicatorPainter(
          verticalLineProvider: (x) =>
              VerticalLine(x: x, color: Colors.amber, strokeWidth: 3),
          horizontalLineProvider: (y) => null,
        ),
      ),
    ],
  ),
};

CandlestickStyle _greenAndRed(CandlestickSpot spot, int index) {
  final color = spot.close >= spot.open ? Colors.green : Colors.red;
  return CandlestickStyle(
    lineColor: color,
    lineWidth: 1,
    bodyStrokeColor: color,
    bodyStrokeWidth: 1,
    bodyFillColor: color,
    bodyWidth: 10,
    bodyRadius: 2,
  );
}

Color _deepPurple(CandlestickSpot spot) => Colors.deepPurple;

MouseCursor _clickCursor(
  FlTouchEvent event,
  CandlestickTouchResponse? response,
) => SystemMouseCursors.click;

void _printTouch(FlTouchEvent event, CandlestickTouchResponse? response) =>
    debugPrint('${event.runtimeType}');

CandlestickTooltipItem? _tooltipItem(
  FlCandlestickPainter painter,
  CandlestickSpot spot,
  int index,
) => CandlestickTooltipItem(
  'close ${spot.close}',
  textStyle: const TextStyle(color: Colors.amber),
);
