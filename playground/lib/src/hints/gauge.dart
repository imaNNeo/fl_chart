import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../hints.dart';
import '../hosts/gauge.dart';
import '../theme.dart';

/// The hints of the gauge chart properties.
final gaugeHints = <String, PropertyHint>{
  // GaugeChartData
  'GaugeChartData.rings': PropertyHint(
    presets: [
      Preset(
        '[GaugeProgressRing(value: 72, color: Colors.cyan, strokeCap: StrokeCap.round)]',
        [
          GaugeProgressRing(
            value: 72,
            color: AppColors.primary,
            strokeCap: StrokeCap.round,
          ),
        ],
      ),
      Preset(
        '[GaugeZonesRing(zones: [...]), GaugeProgressRing(value: 72, color: Colors.cyan)]',
        [
          GaugeZonesRing(zones: sampleZones()),
          const GaugeProgressRing(value: 72, color: AppColors.primary),
        ],
      ),
    ],
  ),
  // The sample rings span 0 to 100, the scale has to keep containing them.
  'GaugeChartData.minValue': const PropertyHint(min: -50, max: 0),
  'GaugeChartData.maxValue': const PropertyHint(min: 100, max: 200),
  'GaugeChartData.startDegreeOffset': const PropertyHint(min: -360, max: 0),
  'GaugeChartData.sweepAngle': const PropertyHint(min: 90, max: 360),
  'GaugeChartData.defaultRingWidth': const PropertyHint(min: 4, max: 40),
  'GaugeChartData.ringsSpace': const PropertyHint(min: 0, max: 20),
  'GaugeChartData.ticks': PropertyHint(
    presets: [
      Preset(
        'GaugeTicks(count: 6, painter: GaugeTickLinePainter(color: Colors.white54), labelBuilder: (value) => value.toStringAsFixed(0))',
        GaugeTicks(
          count: 6,
          painter: const GaugeTickLinePainter(color: AppColors.muted),
          labelBuilder: _wholeNumber,
          labelStyle: const TextStyle(color: AppColors.muted, fontSize: 11),
        ),
      ),
    ],
  ),
  'GaugeChartData.pointers': const PropertyHint(
    presets: [
      Preset(
        '[GaugePointer(value: 72, painter: GaugePointerNeedlePainter(color: Colors.cyan))]',
        [
          GaugePointer(
            value: 72,
            painter: GaugePointerNeedlePainter(color: AppColors.primary),
          ),
        ],
      ),
    ],
  ),
  'GaugeChartData.markers': const PropertyHint(
    presets: [
      Preset(
        "[GaugeMarker(value: 80, painter: GaugeMarkerLinePainter(color: Colors.white, label: 'target'))]",
        [
          GaugeMarker(
            value: 80,
            painter: GaugeMarkerLinePainter(
              color: Colors.white,
              length: 26,
              label: 'target',
              labelStyle: TextStyle(color: AppColors.muted, fontSize: 11),
            ),
          ),
        ],
      ),
    ],
  ),
  'GaugeChartData.touchData': PropertyHint(
    presets: [
      Preset('GaugeTouchData(enabled: false)', GaugeTouchData(enabled: false)),
    ],
  ),
  'GaugeChartData.borderData': PropertyHint(
    presets: [
      Preset(
        'FlBorderData(show: true, border: Border.all(color: Colors.white24))',
        FlBorderData(show: true, border: Border.all(color: Colors.white24)),
      ),
    ],
  ),

  // GaugeProgressRing
  'GaugeProgressRing.value': const PropertyHint(min: 0, max: 100),
  'GaugeProgressRing.width': const PropertyHint(min: 4, max: 40),

  // GaugeZonesRing
  'GaugeZonesRing.zones': PropertyHint(
    presets: [
      Preset(
        '[GaugeZone(from: 0, to: 60, color: Colors.green), GaugeZone(from: 60, to: 100, color: Colors.red)]',
        const [
          GaugeZone(from: 0, to: 60, color: Color(0xFF4CD964)),
          GaugeZone(from: 60, to: 100, color: Color(0xFFFF6B6B)),
        ],
      ),
      Preset(
        '[GaugeZone(from: 0, to: 45, color: Colors.green), GaugeZone(from: 45, to: 80, color: Colors.amber), GaugeZone(from: 80, to: 100, color: Colors.red)]',
        sampleZones(),
      ),
    ],
  ),
  'GaugeZonesRing.zonesSpace': const PropertyHint(min: 0, max: 30),
  'GaugeZonesRing.width': const PropertyHint(min: 4, max: 40),

  // GaugeZone
  'GaugeZone.from': const PropertyHint(min: 0, max: 45),
  'GaugeZone.to': const PropertyHint(min: 0, max: 45),

  // GaugeTicks
  'GaugeTicks.count': const PropertyHint(min: 2, max: 12),
  'GaugeTicks.offset': const PropertyHint(min: -30, max: 30),
  'GaugeTicks.painter': const PropertyHint(
    presets: [
      Preset(
        'GaugeTickLinePainter(length: 12, thickness: 3, color: Colors.white)',
        GaugeTickLinePainter(length: 12, thickness: 3, color: Colors.white),
      ),
      Preset(
        'GaugeTickCirclePainter(radius: 4, color: Colors.cyan)',
        GaugeTickCirclePainter(radius: 4, color: AppColors.primary),
      ),
    ],
  ),
  'GaugeTicks.checkToShowTick': const PropertyHint(
    presets: [
      Preset('GaugeTicks.showAll', GaugeTicks.showAll),
      Preset('GaugeTicks.hideEndpoints', GaugeTicks.hideEndpoints),
    ],
  ),
  'GaugeTicks.labelBuilder': const PropertyHint(
    presets: [
      Preset('(value) => value.toStringAsFixed(0)', _wholeNumber),
      Preset("(value) => '\${value.toStringAsFixed(0)}%'", _percent),
    ],
  ),
  'GaugeTicks.labelStyle': const PropertyHint(
    presets: [
      Preset(
        'TextStyle(color: Colors.cyan, fontSize: 14, fontWeight: FontWeight.bold)',
        TextStyle(
          color: AppColors.primary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
  'GaugeTicks.labelOffset': const PropertyHint(min: -20, max: 30),

  // GaugePointer
  'GaugePointer.value': const PropertyHint(min: 0, max: 100),
  'GaugePointer.painter': const PropertyHint(
    presets: [
      Preset(
        'GaugePointerNeedlePainter(length: 60, width: 8, tailLength: 14, color: Colors.white)',
        GaugePointerNeedlePainter(
          length: 60,
          width: 8,
          tailLength: 14,
          color: Colors.white,
        ),
      ),
      Preset(
        'GaugePointerCirclePainter(radius: 8, color: Colors.cyan)',
        GaugePointerCirclePainter(radius: 8, color: AppColors.primary),
      ),
    ],
  ),

  // GaugeMarker
  'GaugeMarker.value': const PropertyHint(min: 0, max: 100),
  'GaugeMarker.offset': const PropertyHint(min: -30, max: 30),
  'GaugeMarker.painter': const PropertyHint(
    presets: [
      Preset(
        'GaugeMarkerLinePainter(length: 26, color: Colors.white, alignment: GaugeMarkerLineAlignment.centered)',
        GaugeMarkerLinePainter(length: 26, color: Colors.white),
      ),
      Preset(
        "GaugeMarkerLinePainter(length: 26, color: Colors.cyan, label: 'target', labelSide: GaugeMarkerLabelSide.outward)",
        GaugeMarkerLinePainter(
          length: 26,
          color: AppColors.primary,
          label: 'target',
          labelStyle: TextStyle(color: AppColors.muted, fontSize: 11),
        ),
      ),
    ],
  ),

  // GaugeTouchData
  'GaugeTouchData.mouseCursorResolver': const PropertyHint(
    presets: [
      Preset('(event, response) => SystemMouseCursors.click', _clickCursor),
    ],
    note: 'Hover the chart to see the cursor.',
  ),
  'GaugeTouchData.longPressDuration': const PropertyHint(
    presets: [
      Preset('Duration(milliseconds: 100)', Duration(milliseconds: 100)),
      Preset('Duration(seconds: 2)', Duration(seconds: 2)),
    ],
  ),
  'GaugeTouchData.touchCallback': const PropertyHint(
    presets: [
      Preset(
        "(event, response) => debugPrint('\${event.runtimeType}')",
        _printTouch,
      ),
    ],
    note: 'It prints into the browser console, it changes nothing here.',
  ),
};

String _wholeNumber(double value) => value.toStringAsFixed(0);

String _percent(double value) => '${value.toStringAsFixed(0)}%';

MouseCursor _clickCursor(FlTouchEvent event, GaugeTouchResponse? response) =>
    SystemMouseCursors.click;

void _printTouch(FlTouchEvent event, GaugeTouchResponse? response) =>
    debugPrint('${event.runtimeType}');
