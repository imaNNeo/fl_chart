import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../hints.dart';

/// The hints of the pie chart properties.
final pieHints = <String, PropertyHint>{
  // PieChartData
  'PieChartData.sections': PropertyHint(
    presets: [
      Preset(
        "[PieChartSectionData(value: 70, title: '70%', color: Colors.cyan), PieChartSectionData(value: 30, title: '30%', color: Colors.pinkAccent)]",
        [
          PieChartSectionData(value: 70, title: '70%', color: Colors.cyan),
          PieChartSectionData(
            value: 30,
            title: '30%',
            color: Colors.pinkAccent,
          ),
        ],
      ),
    ],
  ),
  'PieChartData.centerSpaceRadius': const PropertyHint(min: 0, max: 80),
  'PieChartData.sectionsSpace': const PropertyHint(min: 0, max: 12),
  'PieChartData.startDegreeOffset': const PropertyHint(min: 0, max: 360),
  'PieChartData.pieTouchData': PropertyHint(
    presets: [
      Preset('PieTouchData(enabled: false)', PieTouchData(enabled: false)),
    ],
  ),
  'PieChartData.borderData': PropertyHint(
    presets: [
      Preset(
        'FlBorderData(show: true, border: Border.all(color: Colors.white24))',
        FlBorderData(show: true, border: Border.all(color: Colors.white24)),
      ),
    ],
  ),

  // PieChartSectionData
  'PieChartSectionData.value': const PropertyHint(min: 5, max: 80),
  'PieChartSectionData.gradient': const PropertyHint(
    presets: [
      Preset(
        'LinearGradient(colors: [Colors.cyan, Colors.purpleAccent])',
        LinearGradient(colors: [Colors.cyan, Colors.purpleAccent]),
      ),
    ],
  ),
  'PieChartSectionData.radius': const PropertyHint(min: 20, max: 100),
  'PieChartSectionData.titleStyle': const PropertyHint(
    presets: [
      Preset(
        'TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)',
        TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
  'PieChartSectionData.borderSide': const PropertyHint(
    presets: [
      Preset(
        'BorderSide(color: Colors.white, width: 3)',
        BorderSide(color: Colors.white, width: 3),
      ),
    ],
  ),
  'PieChartSectionData.cornerRadius': const PropertyHint(min: 0, max: 20),
  'PieChartSectionData.badgeWidget': const PropertyHint(presets: [_badge]),
  'PieChartSectionData.titlePositionPercentageOffset': const PropertyHint(
    min: 0,
    max: 1.2,
  ),
  'PieChartSectionData.badgePositionPercentageOffset': const PropertyHint(
    min: 0,
    max: 1.2,
    requires: {'badgeWidget': _badge},
  ),
  'PieChartSectionData.segments': PropertyHint(
    presets: [
      Preset(
        '[PieChartStackSegmentData(fromRadius: 40, toRadius: 60, color: Colors.white30)]',
        [
          PieChartStackSegmentData(
            fromRadius: 40,
            toRadius: 60,
            color: Colors.white30,
          ),
        ],
      ),
    ],
  ),

  // PieChartStackSegmentData
  'PieChartStackSegmentData.fromRadius': const PropertyHint(min: 0, max: 60),
  'PieChartStackSegmentData.toRadius': const PropertyHint(min: 0, max: 60),
  'PieChartStackSegmentData.gradient': const PropertyHint(
    presets: [
      Preset(
        'LinearGradient(colors: [Colors.white54, Colors.transparent])',
        LinearGradient(colors: [Colors.white54, Colors.transparent]),
      ),
    ],
  ),

  // PieTouchData
  'PieTouchData.mouseCursorResolver': const PropertyHint(
    presets: [
      Preset('(event, response) => SystemMouseCursors.click', _clickCursor),
    ],
    note: 'Hover the chart to see the cursor.',
  ),
  'PieTouchData.longPressDuration': const PropertyHint(
    presets: [
      Preset('Duration(milliseconds: 100)', Duration(milliseconds: 100)),
      Preset('Duration(seconds: 2)', Duration(seconds: 2)),
    ],
  ),
  'PieTouchData.touchCallback': const PropertyHint(
    presets: [
      Preset(
        "(event, response) => debugPrint('\${event.runtimeType}')",
        _printTouch,
      ),
    ],
    note: 'It prints into the browser console, it changes nothing here.',
  ),
};

const _badge = Preset(
  'CircleAvatar(radius: 14, backgroundColor: Colors.white, child: Icon(Icons.star, size: 18, color: Colors.amber))',
  CircleAvatar(
    radius: 14,
    backgroundColor: Colors.white,
    child: Icon(Icons.star, size: 18, color: Colors.amber),
  ),
);

MouseCursor _clickCursor(FlTouchEvent event, PieTouchResponse? response) =>
    SystemMouseCursors.click;

void _printTouch(FlTouchEvent event, PieTouchResponse? response) =>
    debugPrint('${event.runtimeType}');
