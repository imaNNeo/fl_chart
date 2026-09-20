import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../hints.dart';

/// The hints of the scatter chart properties.
final scatterHints = <String, PropertyHint>{
  // ScatterChartData
  'ScatterChartData.errorIndicatorData': PropertyHint(
    requires: {
      'scatterSpots': Preset(
        '[ScatterSpot(2, 2.4, xError: FlErrorRange.symmetric(0.4), yError: FlErrorRange.symmetric(0.6)), ...]',
        [
          ScatterSpot(
            2,
            2.4,
            xError: const FlErrorRange.symmetric(0.4),
            yError: const FlErrorRange.symmetric(0.6),
          ),
          ScatterSpot(
            5,
            5,
            xError: const FlErrorRange.symmetric(0.7),
            yError: const FlErrorRange(lowerBy: 1, upperBy: 0.3),
          ),
          ScatterSpot(
            8,
            3.2,
            xError: const FlErrorRange.symmetric(0.5),
            yError: const FlErrorRange.symmetric(0.5),
          ),
        ],
      ),
    },
    presets: const [
      Preset(
        'FlErrorIndicatorData(painter: (input) => FlSimpleErrorPainter(lineColor: Colors.amber, capLength: 14))',
        FlErrorIndicatorData<ScatterChartSpotErrorRangeCallbackInput>(
          painter: _amberErrorPainter,
        ),
      ),
      Preset(
        'FlErrorIndicatorData(show: false)',
        FlErrorIndicatorData<ScatterChartSpotErrorRangeCallbackInput>(
          show: false,
        ),
      ),
    ],
  ),
  'ScatterChartData.scatterSpots': PropertyHint(
    presets: [
      Preset('[ScatterSpot(2, 2), ScatterSpot(5, 5), ScatterSpot(8, 3)]', [
        ScatterSpot(2, 2),
        ScatterSpot(5, 5),
        ScatterSpot(8, 3),
      ]),
    ],
  ),
  'ScatterChartData.titlesData': const PropertyHint(
    presets: [Preset('FlTitlesData(show: false)', FlTitlesData(show: false))],
  ),
  'ScatterChartData.scatterTouchData': PropertyHint(
    presets: [
      Preset(
        'ScatterTouchData(enabled: false)',
        ScatterTouchData(enabled: false),
      ),
    ],
  ),
  'ScatterChartData.showingTooltipIndicators': PropertyHint(
    requires: {
      'scatterTouchData': Preset(
        'ScatterTouchData(handleBuiltInTouches: false)',
        ScatterTouchData(handleBuiltInTouches: false),
      ),
    },
    presets: const [
      Preset('[2]', [2]),
      Preset('[2, 6]', [2, 6]),
    ],
  ),
  'ScatterChartData.gridData': const PropertyHint(
    presets: [
      Preset('FlGridData(show: false)', FlGridData(show: false)),
      Preset('FlGridData()', FlGridData()),
    ],
  ),
  'ScatterChartData.borderData': PropertyHint(
    presets: [
      Preset(
        'FlBorderData(border: Border.all(color: Colors.white24))',
        FlBorderData(border: Border.all(color: Colors.white24)),
      ),
    ],
  ),
  'ScatterChartData.minX': const PropertyHint(min: -3, max: 3),
  'ScatterChartData.maxX': const PropertyHint(min: 8, max: 14),
  'ScatterChartData.baselineX': const PropertyHint(min: 0, max: 1),
  'ScatterChartData.minY': const PropertyHint(min: -3, max: 3),
  'ScatterChartData.maxY': const PropertyHint(min: 5, max: 12),
  'ScatterChartData.baselineY': const PropertyHint(min: 0, max: 1),
  'ScatterChartData.clipData': const PropertyHint(
    requires: {'maxX': 6.0},
    presets: [
      Preset('FlClipData.all()', FlClipData.all()),
      Preset('FlClipData.none()', FlClipData.none()),
    ],
  ),
  'ScatterChartData.scatterLabelSettings': PropertyHint(
    presets: [
      Preset(
        'ScatterLabelSettings(showLabel: true)',
        ScatterLabelSettings(showLabel: true),
      ),
    ],
  ),
  'ScatterChartData.rotationQuarterTurns': const PropertyHint(min: 0, max: 3),

  // ScatterSpot
  'ScatterSpot.x': const PropertyHint(min: 0, max: 10),
  'ScatterSpot.y': const PropertyHint(min: 0, max: 7),
  'ScatterSpot.dotPainter': PropertyHint(
    presets: [
      Preset(
        'FlDotCirclePainter(radius: 20, color: Colors.cyan, strokeWidth: 3, strokeColor: Colors.white)',
        FlDotCirclePainter(
          radius: 20,
          color: Colors.cyan,
          strokeWidth: 3,
          strokeColor: Colors.white,
        ),
      ),
      Preset(
        'FlDotSquarePainter(size: 24, color: Colors.amber, strokeWidth: 0)',
        FlDotSquarePainter(size: 24, color: Colors.amber, strokeWidth: 0),
      ),
      Preset(
        'FlDotCrossPainter(size: 20, width: 4, color: Colors.pinkAccent)',
        FlDotCrossPainter(size: 20, width: 4, color: Colors.pinkAccent),
      ),
    ],
  ),
  'ScatterSpot.xError': const PropertyHint(
    presets: [
      Preset(
        'FlErrorRange(lowerBy: 0.8, upperBy: 0.8)',
        FlErrorRange(lowerBy: 0.8, upperBy: 0.8),
      ),
    ],
  ),
  'ScatterSpot.yError': const PropertyHint(
    presets: [
      Preset(
        'FlErrorRange(lowerBy: 0.5, upperBy: 1)',
        FlErrorRange(lowerBy: 0.5, upperBy: 1),
      ),
    ],
  ),

  // ScatterTouchData
  'ScatterTouchData.touchTooltipData': const PropertyHint(
    presets: [
      Preset(
        'ScatterTouchTooltipData(getTooltipColor: (spot) => Colors.deepPurple, tooltipBorderRadius: BorderRadius.all(Radius.circular(16)))',
        ScatterTouchTooltipData(
          getTooltipColor: _deepPurple,
          tooltipBorderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    ],
  ),
  'ScatterTouchData.mouseCursorResolver': const PropertyHint(
    presets: [
      Preset('(event, response) => SystemMouseCursors.click', _clickCursor),
    ],
    note: 'Hover the chart to see the cursor.',
  ),
  'ScatterTouchData.longPressDuration': const PropertyHint(
    presets: [
      Preset('Duration(milliseconds: 100)', Duration(milliseconds: 100)),
      Preset('Duration(seconds: 2)', Duration(seconds: 2)),
    ],
  ),
  'ScatterTouchData.touchCallback': const PropertyHint(
    presets: [
      Preset(
        "(event, response) => debugPrint('\${event.runtimeType}')",
        _printTouch,
      ),
    ],
    note: 'It prints into the browser console, it changes nothing here.',
  ),
  'ScatterTouchData.touchSpotThreshold': const PropertyHint(min: 0, max: 40),

  // ScatterTouchTooltipData
  'ScatterTouchTooltipData.tooltipBorderRadius': const PropertyHint(
    presets: [
      Preset('BorderRadius.zero', BorderRadius.zero),
      Preset(
        'BorderRadius.all(Radius.circular(16))',
        BorderRadius.all(Radius.circular(16)),
      ),
    ],
  ),
  'ScatterTouchTooltipData.tooltipPadding': const PropertyHint(
    presets: [
      Preset('EdgeInsets.all(4)', EdgeInsets.all(4)),
      Preset('EdgeInsets.all(20)', EdgeInsets.all(20)),
    ],
  ),
  'ScatterTouchTooltipData.tooltipHorizontalOffset': const PropertyHint(
    min: -60,
    max: 60,
  ),
  'ScatterTouchTooltipData.maxContentWidth': const PropertyHint(
    min: 20,
    max: 200,
  ),
  'ScatterTouchTooltipData.getTooltipItems': const PropertyHint(
    presets: [
      Preset(
        "(spot) => ScatterTooltipItem('x: \${spot.x}, y: \${spot.y}', textStyle: TextStyle(color: Colors.amber))",
        _amberTooltipItem,
      ),
    ],
  ),
  'ScatterTouchTooltipData.rotateAngle': const PropertyHint(min: 0, max: 360),
  'ScatterTouchTooltipData.tooltipBorder': const PropertyHint(
    presets: [
      Preset(
        'BorderSide(color: Colors.white, width: 2)',
        BorderSide(color: Colors.white, width: 2),
      ),
    ],
  ),
  'ScatterTouchTooltipData.getTooltipColor': const PropertyHint(
    presets: [Preset('(spot) => Colors.deepPurple', _deepPurple)],
  ),

  // ScatterTooltipItem
  'ScatterTooltipItem.textStyle': const PropertyHint(
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
  'ScatterTooltipItem.bottomMargin': const PropertyHint(min: 0, max: 40),
  'ScatterTooltipItem.textAlign': const PropertyHint(
    requires: {'text': 'Spot\n5.2, 5.6'},
  ),
  'ScatterTooltipItem.children': const PropertyHint(
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

  // ScatterLabelSettings
  'ScatterLabelSettings.getLabelTextStyleFunction': const PropertyHint(
    requires: {'showLabel': true},
    presets: [
      Preset(
        '(index, spot) => TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)',
        _amberLabel,
      ),
    ],
  ),
  'ScatterLabelSettings.getLabelFunction': const PropertyHint(
    requires: {'showLabel': true},
    presets: [Preset("(index, spot) => '#\$index'", _indexLabel)],
  ),
};

ScatterTooltipItem _amberTooltipItem(ScatterSpot spot) => ScatterTooltipItem(
  'x: ${spot.x}, y: ${spot.y}',
  textStyle: const TextStyle(color: Colors.amber),
);

Color _deepPurple(ScatterSpot spot) => Colors.deepPurple;

TextStyle _amberLabel(int index, ScatterSpot spot) =>
    const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold);

String _indexLabel(int index, ScatterSpot spot) => '#$index';

MouseCursor _clickCursor(FlTouchEvent event, ScatterTouchResponse? response) =>
    SystemMouseCursors.click;

void _printTouch(FlTouchEvent event, ScatterTouchResponse? response) =>
    debugPrint('${event.runtimeType}');

FlSpotErrorRangePainter _amberErrorPainter(
  ScatterChartSpotErrorRangeCallbackInput input,
) => FlSimpleErrorPainter(lineColor: Colors.amber, capLength: 14);
