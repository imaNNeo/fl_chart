import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../hints.dart';
import '../hosts/bar.dart';

/// The hints of the bar chart properties.
final barHints = <String, PropertyHint>{
  // BarChartData
  'BarChartData.barGroups': PropertyHint(
    presets: [
      Preset(
        '[BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 3), BarChartRodData(toY: 5)]), ...]',
        [
          for (final x in [0, 1, 2])
            BarChartGroupData(
              x: x,
              barRods: [sampleRod(3.0 + x), sampleRod(5.0 - x)],
            ),
        ],
      ),
    ],
  ),
  'BarChartData.groupsSpace': const PropertyHint(
    min: 0,
    max: 40,
    requires: {'alignment': BarChartAlignment.center},
  ),
  'BarChartData.maxY': const PropertyHint(min: 6, max: 12),
  'BarChartData.minY': const PropertyHint(min: -3, max: 0),
  'BarChartData.baselineY': const PropertyHint(min: 0, max: 1),
  'BarChartData.titlesData': const PropertyHint(
    presets: [Preset('FlTitlesData(show: false)', FlTitlesData(show: false))],
  ),
  'BarChartData.barTouchData': const PropertyHint(
    presets: [
      Preset('BarTouchData(enabled: false)', BarTouchData(enabled: false)),
    ],
    note: 'Hover or touch the bars.',
  ),
  'BarChartData.gridData': const PropertyHint(
    presets: [
      Preset('FlGridData(show: false)', FlGridData(show: false)),
      Preset('FlGridData()', FlGridData()),
    ],
  ),
  'BarChartData.borderData': PropertyHint(
    presets: [
      Preset(
        'FlBorderData(border: Border.all(color: Colors.white24))',
        FlBorderData(border: Border.all(color: Colors.white24)),
      ),
    ],
  ),
  'BarChartData.rangeAnnotations': PropertyHint(
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
  'BarChartData.extraLinesData': PropertyHint(
    presets: [
      Preset(
        'ExtraLinesData(horizontalLines: [HorizontalLine(y: 4.5, color: Colors.amber, dashArray: [6, 4])])',
        ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 4.5,
              color: Colors.amber,
              dashArray: const [6, 4],
            ),
          ],
        ),
      ),
    ],
  ),
  'BarChartData.rotationQuarterTurns': const PropertyHint(min: 0, max: 3),

  // BarChartGroupData
  'BarChartGroupData.x': const PropertyHint(min: 0, max: 9),
  'BarChartGroupData.barRods': PropertyHint(
    presets: [
      Preset(
        '[BarChartRodData(toY: 6.5), BarChartRodData(toY: 4), BarChartRodData(toY: 2)]',
        [sampleRod(6.5), sampleRod(4), sampleRod(2)],
      ),
    ],
  ),
  'BarChartGroupData.barsSpace': const PropertyHint(min: 0, max: 20),
  'BarChartGroupData.showingTooltipIndicators': const PropertyHint(
    presets: [
      Preset('[0]', [0]),
      Preset('[0, 1]', [0, 1]),
    ],
  ),

  // BarChartRodData
  'BarChartRodData.fromY': const PropertyHint(min: 0, max: 3),
  'BarChartRodData.toY': const PropertyHint(min: 0, max: 7),
  'BarChartRodData.toYErrorRange': const PropertyHint(
    presets: [
      Preset(
        'FlErrorRange(lowerBy: 0.8, upperBy: 0.6)',
        FlErrorRange(lowerBy: 0.8, upperBy: 0.6),
      ),
    ],
  ),
  'BarChartRodData.gradient': const PropertyHint(
    requires: {'color': null},
    presets: [
      Preset(
        'LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.cyan, Colors.purpleAccent])',
        LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.cyan, Colors.purpleAccent],
        ),
      ),
    ],
  ),
  'BarChartRodData.width': const PropertyHint(min: 2, max: 40),
  'BarChartRodData.borderRadius': const PropertyHint(
    presets: [
      Preset('BorderRadius.zero', BorderRadius.zero),
      Preset('null', null),
    ],
  ),
  'BarChartRodData.borderSide': const PropertyHint(presets: [_border]),
  'BarChartRodData.borderDashArray': const PropertyHint(
    requires: {'borderSide': _border},
    presets: [
      Preset('[4, 4]', [4, 4]),
    ],
  ),
  'BarChartRodData.backDrawRodData': PropertyHint(
    presets: [
      Preset(
        'BackgroundBarChartRodData(show: true, toY: 7, color: Colors.white10)',
        BackgroundBarChartRodData(show: true, toY: 7, color: Colors.white10),
      ),
    ],
  ),
  'BarChartRodData.rodStackItems': PropertyHint(
    presets: [
      Preset(
        '[BarChartRodStackItem(0, 2, Colors.cyan), BarChartRodStackItem(2, 4, Colors.purpleAccent), BarChartRodStackItem(4, 5.6, Colors.amber)]',
        [
          BarChartRodStackItem(0, 2, Colors.cyan),
          BarChartRodStackItem(2, 4, Colors.purpleAccent),
          BarChartRodStackItem(4, 5.6, Colors.amber),
        ],
      ),
    ],
  ),
  'BarChartRodData.label': const PropertyHint(
    presets: [
      Preset(
        "BarChartRodLabel(text: '5.6', style: TextStyle(color: Colors.white))",
        BarChartRodLabel(
          text: '5.6',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ],
  ),

  // BackgroundBarChartRodData
  'BackgroundBarChartRodData.fromY': const PropertyHint(min: 0, max: 3),
  'BackgroundBarChartRodData.toY': const PropertyHint(min: 0, max: 7),
  'BackgroundBarChartRodData.gradient': const PropertyHint(
    requires: {'color': null},
    presets: [
      Preset(
        'LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.white24, Colors.transparent])',
        LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.white24, Colors.transparent],
        ),
      ),
    ],
  ),

  // BarChartRodStackItem
  'BarChartRodStackItem.color': const PropertyHint(nullable: false),
  'BarChartRodStackItem.fromY': const PropertyHint(min: 0, max: 6),
  'BarChartRodStackItem.toY': const PropertyHint(min: 0, max: 6),
  'BarChartRodStackItem.gradient': const PropertyHint(
    requires: {'color': null},
    presets: [
      Preset(
        'LinearGradient(colors: [Colors.cyan, Colors.blue])',
        LinearGradient(colors: [Colors.cyan, Colors.blue]),
      ),
    ],
  ),
  'BarChartRodStackItem.labelStyle': const PropertyHint(
    requires: {'label': 'Base'},
    presets: [
      Preset(
        'TextStyle(color: Colors.black, fontWeight: FontWeight.bold)',
        TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    ],
  ),
  'BarChartRodStackItem.borderSide': const PropertyHint(presets: [_border]),

  // BarChartRodLabel
  'BarChartRodLabel.style': const PropertyHint(presets: _labelStyles),
  'BarChartRodLabel.angle': const PropertyHint(min: -90, max: 90),
  'BarChartRodLabel.offset': const PropertyHint(
    presets: [
      Preset('Offset(0, 24)', Offset(0, 24)),
      Preset('Offset(12, 0)', Offset(12, 0)),
    ],
  ),

  // FlLabel
  'FlLabel.style': const PropertyHint(presets: _labelStyles),
  'FlLabel.angle': const PropertyHint(min: -90, max: 90),

  // BarTouchData
  'BarTouchData.touchExtraThreshold': const PropertyHint(
    presets: [Preset('EdgeInsets.all(24)', EdgeInsets.all(24))],
  ),
  'BarTouchData.allowTouchBarBackDraw': const PropertyHint(
    note: 'Needs a background rod (backDrawRodData) to touch.',
  ),

  // BarTouchTooltipData
  'BarTouchTooltipData.tooltipBorderRadius': const PropertyHint(
    presets: [
      Preset('BorderRadius.zero', BorderRadius.zero),
      Preset(
        'BorderRadius.all(Radius.circular(16))',
        BorderRadius.all(Radius.circular(16)),
      ),
    ],
  ),
  'BarTouchTooltipData.tooltipPadding': const PropertyHint(
    presets: [
      Preset('EdgeInsets.all(4)', EdgeInsets.all(4)),
      Preset('EdgeInsets.all(20)', EdgeInsets.all(20)),
    ],
  ),
  'BarTouchTooltipData.tooltipMargin': const PropertyHint(min: -40, max: 40),
  'BarTouchTooltipData.tooltipHorizontalOffset': const PropertyHint(
    min: -60,
    max: 60,
  ),
  'BarTouchTooltipData.maxContentWidth': const PropertyHint(min: 20, max: 200),
  'BarTouchTooltipData.getTooltipItem': const PropertyHint(
    presets: [
      Preset(
        "(group, groupIndex, rod, rodIndex) => BarTooltipItem('\${rod.toY}', TextStyle(color: Colors.amber))",
        _amberTooltipItem,
      ),
    ],
  ),
  'BarTouchTooltipData.getTooltipColor': const PropertyHint(
    presets: [Preset('(group) => Colors.deepPurple', _deepPurple)],
  ),
  'BarTouchTooltipData.rotateAngle': const PropertyHint(min: 0, max: 360),
  'BarTouchTooltipData.tooltipBorder': const PropertyHint(presets: [_border]),

  // BarTooltipItem
  'BarTooltipItem.textStyle': const PropertyHint(presets: _labelStyles),
  'BarTooltipItem.children': const PropertyHint(
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
};

const _border = Preset(
  'BorderSide(color: Colors.white, width: 2)',
  BorderSide(color: Colors.white, width: 2),
);

const _labelStyles = [
  Preset(
    'TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold)',
    TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold),
  ),
];

BarTooltipItem _amberTooltipItem(
  BarChartGroupData group,
  int groupIndex,
  BarChartRodData rod,
  int rodIndex,
) => BarTooltipItem('${rod.toY}', const TextStyle(color: Colors.amber));

Color _deepPurple(BarChartGroupData group) => Colors.deepPurple;
