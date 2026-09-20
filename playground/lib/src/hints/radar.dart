import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../hints.dart';
import '../hosts/radar.dart';

/// The hints of the radar chart properties.
final radarHints = <String, PropertyHint>{
  // RadarChartData
  'RadarChartData.dataSets': PropertyHint(
    sample:
        '[RadarDataSet(dataEntries: [RadarEntry(value: 4), RadarEntry(value: 3), ...], borderColor: Color(0xff50e4ff), ...), RadarDataSet(...)]',
    presets: [
      Preset('[dataSet1]', [sampleDataSets().first]),
    ],
  ),
  'RadarChartData.radarBorderData': const PropertyHint(
    sample: 'BorderSide(color: Colors.white24)',
    presets: [_thickBorder],
  ),
  'RadarChartData.getTitle': const PropertyHint(
    sample: '(index, angle) => RadarChartTitle(text: titles[index])',
    presets: [
      Preset(
        "(index, angle) => RadarChartTitle(text: 'Axis \$index', angle: angle)",
        _rotatedTitle,
      ),
    ],
  ),
  'RadarChartData.titleTextStyle': const PropertyHint(
    sample: 'TextStyle(color: Colors.white, fontSize: 12)',
    presets: [_amberText],
  ),
  'RadarChartData.titlePositionPercentageOffset': const PropertyHint(
    min: 0,
    max: 1,
  ),
  'RadarChartData.tickCount': const PropertyHint(min: 1, max: 6),
  'RadarChartData.ticksTextStyle': const PropertyHint(
    sample: 'TextStyle(color: Color(0xffa3aecb), fontSize: 10)',
    presets: [_amberText],
  ),
  'RadarChartData.tickBorderData': const PropertyHint(
    sample: 'BorderSide(color: Colors.white10)',
    presets: [_thickBorder],
  ),
  'RadarChartData.gridBorderData': const PropertyHint(
    sample: 'BorderSide(color: Colors.white24)',
    presets: [_thickBorder],
  ),
  'RadarChartData.radarTouchData': PropertyHint(
    presets: [
      Preset('RadarTouchData(enabled: false)', RadarTouchData(enabled: false)),
    ],
  ),
  'RadarChartData.borderData': PropertyHint(
    presets: [
      Preset(
        'FlBorderData(show: true, border: Border.all(color: Colors.white24))',
        FlBorderData(show: true, border: Border.all(color: Colors.white24)),
      ),
    ],
  ),

  // RadarDataSet
  'RadarDataSet.dataEntries': const PropertyHint(
    sample:
        '[RadarEntry(value: 4), RadarEntry(value: 3), RadarEntry(value: 5), ...]',
    presets: [
      Preset(
        '[RadarEntry(value: 5), RadarEntry(value: 5), RadarEntry(value: 5), RadarEntry(value: 5), RadarEntry(value: 5), RadarEntry(value: 5)]',
        [
          RadarEntry(value: 5),
          RadarEntry(value: 5),
          RadarEntry(value: 5),
          RadarEntry(value: 5),
          RadarEntry(value: 5),
          RadarEntry(value: 5),
        ],
      ),
    ],
  ),
  'RadarDataSet.fillGradient': const PropertyHint(
    presets: [
      Preset(
        'RadialGradient(colors: [Colors.transparent, Colors.cyan])',
        RadialGradient(colors: [Colors.transparent, Colors.cyan]),
      ),
    ],
  ),
  'RadarDataSet.borderWidth': const PropertyHint(min: 0, max: 8),
  'RadarDataSet.entryRadius': const PropertyHint(min: 0, max: 10),

  // RadarEntry
  'RadarEntry.value': const PropertyHint(min: 0, max: 6),

  // RadarTouchData
  'RadarTouchData.mouseCursorResolver': const PropertyHint(
    presets: [
      Preset('(event, response) => SystemMouseCursors.click', _clickCursor),
    ],
    note: 'Hover the chart to see the cursor.',
  ),
  'RadarTouchData.longPressDuration': const PropertyHint(
    presets: [
      Preset('Duration(milliseconds: 100)', Duration(milliseconds: 100)),
      Preset('Duration(seconds: 2)', Duration(seconds: 2)),
    ],
  ),
  'RadarTouchData.touchCallback': const PropertyHint(
    presets: [
      Preset(
        "(event, response) => debugPrint('\${event.runtimeType}')",
        _printTouch,
      ),
    ],
    note: 'It prints into the browser console, it changes nothing here.',
  ),
  'RadarTouchData.touchSpotThreshold': const PropertyHint(min: 0, max: 40),

  // RadarChartTitle
  'RadarChartTitle.children': const PropertyHint(
    presets: [
      Preset(
        "[TextSpan(text: ' (km/h)', style: TextStyle(color: Colors.amber))]",
        [
          TextSpan(
            text: ' (km/h)',
            style: TextStyle(color: Colors.amber),
          ),
        ],
      ),
    ],
  ),
  'RadarChartTitle.angle': const PropertyHint(min: -90, max: 90),
  'RadarChartTitle.positionPercentageOffset': const PropertyHint(
    min: 0,
    max: 1,
  ),
};

const _thickBorder = Preset(
  'BorderSide(color: Colors.cyan, width: 3)',
  BorderSide(color: Colors.cyan, width: 3),
);

const _amberText = Preset(
  'TextStyle(color: Colors.amber, fontSize: 14)',
  TextStyle(color: Colors.amber, fontSize: 14),
);

RadarChartTitle _rotatedTitle(int index, double angle) =>
    RadarChartTitle(text: 'Axis $index', angle: angle);

MouseCursor _clickCursor(FlTouchEvent event, RadarTouchResponse? response) =>
    SystemMouseCursors.click;

void _printTouch(FlTouchEvent event, RadarTouchResponse? response) =>
    debugPrint('${event.runtimeType}');
