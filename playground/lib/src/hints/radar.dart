import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../hints.dart';
import '../hosts/radar.dart';

/// The hints of the radar chart properties.
final radarHints = <String, PropertyHint>{
  // RadarChartData
  'RadarChartData.dataSets': PropertyHint(
    presets: [
      Preset('[dataSet1]', [sampleDataSets().first]),
    ],
  ),
  'RadarChartData.radarBorderData': const PropertyHint(presets: [_thickBorder]),
  'RadarChartData.getTitle': const PropertyHint(
    presets: [
      Preset(
        "(index, angle) => RadarChartTitle(text: 'Axis \$index', angle: angle)",
        _rotatedTitle,
      ),
    ],
  ),
  'RadarChartData.titleTextStyle': const PropertyHint(presets: [_amberText]),
  'RadarChartData.titlePositionPercentageOffset': const PropertyHint(
    min: 0,
    max: 1,
  ),
  'RadarChartData.tickCount': const PropertyHint(min: 1, max: 6),
  'RadarChartData.ticksTextStyle': const PropertyHint(presets: [_amberText]),
  'RadarChartData.tickBorderData': const PropertyHint(presets: [_thickBorder]),
  'RadarChartData.gridBorderData': const PropertyHint(presets: [_thickBorder]),
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
