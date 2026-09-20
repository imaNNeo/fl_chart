import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../hints.dart';
import '../hosts/line.dart';
import '../theme.dart';

/// The hints of the line chart properties.
final lineHints = <String, PropertyHint>{
  'LineChartData.lineBarsData': PropertyHint(
    presets: [
      Preset('[bar1, bar2]', [sampleBar(), otherBar()]),
    ],
  ),
  'LineChartData.betweenBarsData': PropertyHint(
    requires: {
      'lineBarsData': Preset('[bar1, bar2]', [sampleBar(), otherBar()]),
    },
    presets: [
      Preset('[BetweenBarsData(fromIndex: 0, toIndex: 1)]', [
        BetweenBarsData(fromIndex: 0, toIndex: 1),
      ]),
    ],
  ),
  'LineChartData.titlesData': const PropertyHint(
    presets: [
      Preset('FlTitlesData(show: false)', FlTitlesData(show: false)),
      Preset('FlTitlesData()', FlTitlesData()),
    ],
  ),
  'LineChartData.extraLinesData': PropertyHint(
    presets: [
      Preset(
        'ExtraLinesData(horizontalLines: [HorizontalLine(y: 4, color: Colors.amber, dashArray: [6, 4])])',
        ExtraLinesData(
          horizontalLines: [
            HorizontalLine(y: 4, color: Colors.amber, dashArray: const [6, 4]),
          ],
        ),
      ),
    ],
  ),
  'LineChartData.lineTouchData': const PropertyHint(
    presets: [
      Preset('LineTouchData(enabled: false)', LineTouchData(enabled: false)),
    ],
    note: 'Hover or touch the chart.',
  ),
  'LineChartData.showingTooltipIndicators': PropertyHint(
    requires: {
      'lineTouchData': const Preset(
        'LineTouchData(handleBuiltInTouches: false)',
        noBuiltInTouches,
      ),
    },
    presets: [
      Preset(
        '[ShowingTooltipIndicators([LineBarSpot(bar, 0, bar.spots[4])])]',
        [tooltipAt(4)],
      ),
      Preset(
        '[ShowingTooltipIndicators([LineBarSpot(bar, 0, bar.spots[2])]), ShowingTooltipIndicators([LineBarSpot(bar, 0, bar.spots[8])])]',
        [tooltipAt(2), tooltipAt(8)],
      ),
    ],
  ),
  'LineChartData.gridData': const PropertyHint(
    presets: [
      Preset('FlGridData(show: false)', FlGridData(show: false)),
      Preset('FlGridData()', FlGridData()),
    ],
  ),
  'LineChartData.borderData': PropertyHint(
    presets: [
      Preset('FlBorderData()', FlBorderData()),
      Preset(
        'FlBorderData(border: Border.all(color: Colors.white24))',
        FlBorderData(border: Border.all(color: Colors.white24)),
      ),
    ],
  ),
  'LineChartData.rangeAnnotations': PropertyHint(
    presets: [
      Preset(
        'RangeAnnotations(horizontalRangeAnnotations: [HorizontalRangeAnnotation(y1: 2, y2: 4, color: Colors.white10)])',
        RangeAnnotations(
          horizontalRangeAnnotations: [
            HorizontalRangeAnnotation(y1: 2, y2: 4, color: Colors.white10),
          ],
        ),
      ),
    ],
  ),
  'LineChartData.minX': const PropertyHint(min: -3, max: 3),
  'LineChartData.maxX': const PropertyHint(min: 7, max: 14),
  'LineChartData.baselineX': const PropertyHint(min: 0, max: 1),
  'LineChartData.minY': const PropertyHint(min: -3, max: 3),
  'LineChartData.maxY': const PropertyHint(min: 5, max: 12),
  'LineChartData.baselineY': const PropertyHint(min: 0, max: 1),
  'LineChartData.clipData': const PropertyHint(
    requires: {'maxY': 5.0},
    presets: [
      Preset('FlClipData.all()', FlClipData.all()),
      Preset('FlClipData.vertical()', FlClipData.vertical()),
      Preset('FlClipData.horizontal()', FlClipData.horizontal()),
    ],
  ),
  'LineChartData.rotationQuarterTurns': const PropertyHint(min: 0, max: 3),

  // LineChartBarData
  'LineChartBarData.errorIndicatorData': const PropertyHint(
    requires: {
      'spots': Preset(
        '[FlSpot(0, 3, yError: FlErrorRange.symmetric(0.5)), FlSpot(2, 4.2, yError: FlErrorRange.symmetric(0.8)), ...]',
        _spotsWithError,
      ),
    },
    presets: [
      Preset(
        'FlErrorIndicatorData(painter: (input) => FlSimpleErrorPainter(lineColor: Colors.amber, capLength: 14))',
        FlErrorIndicatorData<LineChartSpotErrorRangeCallbackInput>(
          painter: _amberErrorPainter,
        ),
      ),
      Preset(
        'FlErrorIndicatorData(show: false)',
        FlErrorIndicatorData<LineChartSpotErrorRangeCallbackInput>(show: false),
      ),
    ],
    note: 'The spots of the line carry an `yError` range here.',
  ),
  'LineChartBarData.spots': const PropertyHint(
    presets: [
      Preset(
        '[FlSpot(0, 3), FlSpot(1, 1.8), FlSpot(2, 4.2), FlSpot.nullSpot, FlSpot(4, 5.4), FlSpot(5, 3.8)]',
        [
          FlSpot(0, 3),
          FlSpot(1, 1.8),
          FlSpot(2, 4.2),
          FlSpot.nullSpot,
          FlSpot(4, 5.4),
          FlSpot(5, 3.8),
        ],
      ),
    ],
  ),
  'LineChartBarData.gradient': const PropertyHint(
    requires: {'color': null},
    presets: [_gradient, _verticalGradient],
  ),
  'LineChartBarData.gradientArea': const PropertyHint(
    requires: {'color': null, 'gradient': _verticalGradient},
  ),
  'LineChartBarData.barWidth': const PropertyHint(min: 0, max: 12),
  'LineChartBarData.curveSmoothness': const PropertyHint(
    min: 0,
    max: 1,
    requires: {'isCurved': true},
  ),
  'LineChartBarData.preventCurveOverShooting': const PropertyHint(
    requires: {'isCurved': true, 'spots': _stairSpots},
    note: 'The curve overshoots between the flat steps.',
  ),
  'LineChartBarData.preventCurveOvershootingThreshold': const PropertyHint(
    min: 0,
    max: 20,
    requires: {
      'isCurved': true,
      'preventCurveOverShooting': true,
      'spots': _stairSpots,
    },
  ),
  'LineChartBarData.isStrokeCapRound': const PropertyHint(
    requires: {'barWidth': 12.0},
  ),
  'LineChartBarData.isStrokeJoinRound': const PropertyHint(
    requires: {'barWidth': 12.0},
  ),
  'LineChartBarData.belowBarData': PropertyHint(
    presets: [
      Preset(
        'BarAreaData(show: true, color: Colors.cyan.withValues(alpha: 0.2))',
        BarAreaData(show: true, color: Colors.cyan.withValues(alpha: 0.2)),
      ),
    ],
  ),
  'LineChartBarData.aboveBarData': PropertyHint(
    presets: [
      Preset(
        'BarAreaData(show: true, color: Colors.purple.withValues(alpha: 0.2))',
        BarAreaData(show: true, color: Colors.purple.withValues(alpha: 0.2)),
      ),
    ],
  ),
  'LineChartBarData.dotData': const PropertyHint(
    presets: [Preset('FlDotData(show: false)', FlDotData(show: false))],
  ),
  'LineChartBarData.showingIndicators': const PropertyHint(
    presets: [
      Preset('[4]', [4]),
      Preset('[2, 8]', [2, 8]),
    ],
  ),
  'LineChartBarData.dashArray': const PropertyHint(
    presets: [
      Preset('[8, 4]', [8, 4]),
      Preset('[2, 4]', [2, 4]),
      Preset('[12, 4, 2, 4]', [12, 4, 2, 4]),
    ],
  ),
  'LineChartBarData.shadow': const PropertyHint(
    presets: [
      Preset(
        'Shadow(color: Colors.black, blurRadius: 8, offset: Offset(0, 6))',
        Shadow(color: Colors.black, blurRadius: 8, offset: Offset(0, 6)),
      ),
    ],
  ),
  'LineChartBarData.lineChartStepData': const PropertyHint(
    requires: {'isStepLineChart': true},
    presets: [
      Preset(
        'LineChartStepData(stepDirection: LineChartStepData.stepDirectionForward)',
        LineChartStepData(
          stepDirection: LineChartStepData.stepDirectionForward,
        ),
      ),
      Preset(
        'LineChartStepData(stepDirection: LineChartStepData.stepDirectionBackward)',
        LineChartStepData(
          stepDirection: LineChartStepData.stepDirectionBackward,
        ),
      ),
    ],
  ),

  // LineChartStepData
  'LineChartStepData.stepDirection': const PropertyHint(min: 0, max: 1),

  // BetweenBarsData
  'BetweenBarsData.fromIndex': const PropertyHint(min: 0, max: 1),
  'BetweenBarsData.toIndex': const PropertyHint(min: 0, max: 1),
  'BetweenBarsData.gradient': const PropertyHint(
    requires: {'color': null},
    presets: [_gradient, _verticalGradient],
  ),

  // BarAreaData
  'BarAreaData.gradient': PropertyHint(
    requires: const {'color': null},
    presets: [_areaGradient],
  ),
  'BarAreaData.spotsLine': const PropertyHint(
    presets: [
      Preset('BarAreaSpotsLine(show: true)', BarAreaSpotsLine(show: true)),
    ],
  ),
  'BarAreaData.cutOffY': const PropertyHint(
    min: 0,
    max: 6,
    requires: {'applyCutOffY': true},
  ),
  'BarAreaData.applyCutOffY': const PropertyHint(requires: {'cutOffY': 3.0}),

  // BarAreaSpotsLine
  'BarAreaSpotsLine.flLineStyle': const PropertyHint(
    presets: [
      Preset(
        'FlLine(color: Colors.white54, strokeWidth: 1, dashArray: [4, 4])',
        FlLine(color: Colors.white54, strokeWidth: 1, dashArray: [4, 4]),
      ),
      Preset(
        'FlLine(color: Colors.cyan, strokeWidth: 4)',
        FlLine(color: Colors.cyan, strokeWidth: 4),
      ),
    ],
  ),
  'BarAreaSpotsLine.checkToShowSpotLine': const PropertyHint(
    presets: [Preset('(spot) => spot.x % 2 == 0', _isEvenSpot)],
  ),

  // FlDotData
  'FlDotData.checkToShowDot': const PropertyHint(
    presets: [Preset('(spot, bar) => spot.x % 2 == 0', _isEvenSpotOfBar)],
  ),
  'FlDotData.getDotPainter': const PropertyHint(
    presets: [
      Preset(
        '(spot, percent, bar, index) => FlDotCirclePainter(radius: 6, color: Colors.white, strokeWidth: 3, strokeColor: Colors.cyan)',
        _circleDot,
      ),
      Preset(
        '(spot, percent, bar, index) => FlDotSquarePainter(size: 10, color: Colors.amber, strokeWidth: 0)',
        _squareDot,
      ),
      Preset(
        '(spot, percent, bar, index) => FlDotCrossPainter(size: 10, color: Colors.pinkAccent)',
        _crossDot,
      ),
    ],
  ),

  // LineTouchData
  'LineTouchData.touchSpotThreshold': const PropertyHint(min: 0, max: 60),
  'LineTouchData.touchTooltipData': PropertyHint(
    presets: [
      Preset(
        'LineTouchTooltipData(getTooltipColor: (spot) => Colors.deepPurple, tooltipBorderRadius: BorderRadius.all(Radius.circular(16)))',
        const LineTouchTooltipData(
          getTooltipColor: _deepPurple,
          tooltipBorderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    ],
  ),
  'LineTouchData.getTouchedSpotIndicator': const PropertyHint(
    presets: [
      Preset(
        '(bar, indexes) => [for (final _ in indexes) TouchedSpotIndicatorData(FlLine(color: Colors.amber, strokeWidth: 3), FlDotData())]',
        _amberIndicators,
      ),
    ],
  ),
  'LineTouchData.mouseCursorResolver': const PropertyHint(
    presets: [
      Preset('(event, response) => SystemMouseCursors.click', _clickCursor),
    ],
    note: 'Hover the chart to see the cursor.',
  ),
  'LineTouchData.longPressDuration': const PropertyHint(
    presets: [
      Preset('Duration(milliseconds: 100)', Duration(milliseconds: 100)),
      Preset('Duration(seconds: 2)', Duration(seconds: 2)),
    ],
  ),
  'LineTouchData.touchCallback': const PropertyHint(
    presets: [
      Preset(
        '(event, response) => debugPrint("\${event.runtimeType} on \${response?.lineBarSpots?.first.y}")',
        _printTouch,
      ),
    ],
    note: 'It prints into the browser console, it changes nothing here.',
  ),
  'LineTouchData.distanceCalculator': const PropertyHint(
    presets: [
      Preset(
        '(touchPoint, spotPixelCoordinates) => (touchPoint - spotPixelCoordinates).distance',
        _euclideanDistance,
      ),
    ],
  ),
  'LineTouchData.getTouchLineEnd': const PropertyHint(
    presets: [Preset('(bar, spotIndex) => double.infinity', _toTheTop)],
  ),
  'LineTouchData.getTouchLineStart': const PropertyHint(
    presets: [
      Preset('(bar, spotIndex) => bar.spots[spotIndex].y', _fromTheSpot),
    ],
    requires: {
      'getTouchLineEnd': Preset(
        '(bar, spotIndex) => double.infinity',
        _toTheTop,
      ),
    },
  ),

  // LineTouchTooltipData
  'LineTouchTooltipData.tooltipBorderRadius': const PropertyHint(
    presets: [
      Preset('BorderRadius.zero', BorderRadius.zero),
      Preset(
        'BorderRadius.all(Radius.circular(16))',
        BorderRadius.all(Radius.circular(16)),
      ),
    ],
  ),
  'LineTouchTooltipData.tooltipPadding': const PropertyHint(
    presets: [
      Preset('EdgeInsets.all(4)', EdgeInsets.all(4)),
      Preset('EdgeInsets.all(20)', EdgeInsets.all(20)),
    ],
  ),
  'LineTouchTooltipData.tooltipMargin': const PropertyHint(min: 0, max: 40),
  'LineTouchTooltipData.tooltipHorizontalOffset': const PropertyHint(
    min: -60,
    max: 60,
  ),
  'LineTouchTooltipData.maxContentWidth': const PropertyHint(min: 40, max: 200),
  'LineTouchTooltipData.getTooltipItems': const PropertyHint(
    presets: [
      Preset(
        "(spots) => spots.map((spot) => LineTooltipItem('\${spot.y}', TextStyle(color: Colors.amber))).toList()",
        _amberTooltipItems,
      ),
    ],
  ),
  'LineTouchTooltipData.getTooltipColor': const PropertyHint(
    presets: [Preset('(spot) => Colors.deepPurple', _deepPurple)],
  ),
  'LineTouchTooltipData.rotateAngle': const PropertyHint(min: 0, max: 360),
  'LineTouchTooltipData.tooltipBorder': const PropertyHint(
    presets: [
      Preset(
        'BorderSide(color: Colors.cyan, width: 2)',
        BorderSide(color: Colors.cyan, width: 2),
      ),
    ],
  ),

  // LineTooltipItem
  'LineTooltipItem.textStyle': const PropertyHint(
    presets: [
      Preset(
        'TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold)',
        TextStyle(
          color: Colors.amber,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      Preset(
        'TextStyle(color: Colors.white, fontStyle: FontStyle.italic)',
        TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
      ),
    ],
  ),
  'LineTooltipItem.textAlign': const PropertyHint(
    requires: {'text': 'Sales\nMarch, 2026'},
  ),
  'LineTooltipItem.children': const PropertyHint(
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

  // TouchedSpotIndicatorData
  'TouchedSpotIndicatorData.indicatorBelowLine': const PropertyHint(
    presets: [
      Preset(
        'FlLine(color: Colors.amber, strokeWidth: 4)',
        FlLine(color: Colors.amber, strokeWidth: 4),
      ),
    ],
  ),
  'TouchedSpotIndicatorData.touchedSpotDotData': const PropertyHint(
    presets: [Preset('FlDotData(show: false)', FlDotData(show: false))],
  ),

  // ShowingTooltipIndicators
  'ShowingTooltipIndicators.showingSpots': PropertyHint(
    presets: [
      Preset(
        '[LineBarSpot(bar, 0, bar.spots[2]), LineBarSpot(bar, 0, bar.spots[3])]',
        [spotAt(2), spotAt(3)],
      ),
    ],
  ),
};

const _gradient = Preset(
  'LinearGradient(colors: [Colors.cyan, Colors.purpleAccent])',
  LinearGradient(colors: [Colors.cyan, Colors.purpleAccent]),
);

const _verticalGradient = Preset(
  'LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.amber, Colors.pinkAccent])',
  LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.amber, Colors.pinkAccent],
  ),
);

final _areaGradient = Preset(
  'LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.cyan.withValues(alpha: 0.4), Colors.transparent])',
  LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.primary.withValues(alpha: 0.4), Colors.transparent],
  ),
);

const _stairSpots = [
  FlSpot(0, 1),
  FlSpot(1, 1),
  FlSpot(2, 1),
  FlSpot(3, 5),
  FlSpot(4, 5),
  FlSpot(5, 5),
  FlSpot(6, 2),
  FlSpot(7, 2),
  FlSpot(8, 2),
  FlSpot(9, 6),
  FlSpot(10, 6),
];

bool _isEvenSpot(FlSpot spot) => spot.x % 2 == 0;

bool _isEvenSpotOfBar(FlSpot spot, LineChartBarData bar) => spot.x % 2 == 0;

FlDotPainter _circleDot(
  FlSpot spot,
  double percent,
  LineChartBarData bar,
  int index,
) => FlDotCirclePainter(
  radius: 6,
  color: Colors.white,
  strokeWidth: 3,
  strokeColor: Colors.cyan,
);

FlDotPainter _squareDot(
  FlSpot spot,
  double percent,
  LineChartBarData bar,
  int index,
) => FlDotSquarePainter(size: 10, color: Colors.amber, strokeWidth: 0);

FlDotPainter _crossDot(
  FlSpot spot,
  double percent,
  LineChartBarData bar,
  int index,
) => FlDotCrossPainter(size: 10, color: Colors.pinkAccent);

double _euclideanDistance(Offset touchPoint, Offset spotPixelCoordinates) =>
    (touchPoint - spotPixelCoordinates).distance;

double _toTheTop(LineChartBarData bar, int spotIndex) => double.infinity;

double _fromTheSpot(LineChartBarData bar, int spotIndex) =>
    bar.spots[spotIndex].y;

List<LineTooltipItem> _amberTooltipItems(List<LineBarSpot> spots) => [
  for (final spot in spots)
    LineTooltipItem('${spot.y}', const TextStyle(color: Colors.amber)),
];

Color _deepPurple(LineBarSpot spot) => Colors.deepPurple;

const _spotsWithError = [
  FlSpot(0, 3, yError: FlErrorRange.symmetric(0.5)),
  FlSpot(2, 4.2, yError: FlErrorRange.symmetric(0.8)),
  FlSpot(4, 5.4, yError: FlErrorRange(lowerBy: 1, upperBy: 0.4)),
  FlSpot(6, 4.6, yError: FlErrorRange.symmetric(0.6)),
  FlSpot(8, 5.2, yError: FlErrorRange.symmetric(0.3)),
];

FlSpotErrorRangePainter _amberErrorPainter(
  LineChartSpotErrorRangeCallbackInput input,
) => FlSimpleErrorPainter(lineColor: Colors.amber, capLength: 14);

List<TouchedSpotIndicatorData> _amberIndicators(
  LineChartBarData bar,
  List<int> indexes,
) => [
  for (final _ in indexes)
    TouchedSpotIndicatorData(
      const FlLine(color: Colors.amber, strokeWidth: 3),
      FlDotData(
        getDotPainter: (spot, percent, bar, index) =>
            FlDotCirclePainter(radius: 6, color: Colors.amber),
      ),
    ),
];

MouseCursor _clickCursor(FlTouchEvent event, LineTouchResponse? response) =>
    SystemMouseCursors.click;

void _printTouch(FlTouchEvent event, LineTouchResponse? response) => debugPrint(
  '${event.runtimeType} on ${response?.lineBarSpots?.firstOrNull?.y}',
);
