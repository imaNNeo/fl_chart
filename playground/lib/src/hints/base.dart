import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../hints.dart';
import '../hosts/base.dart';

/// The hints of the properties of the classes shared by the charts.
final baseHints = <String, PropertyHint>{
  // FlBorderData
  'FlBorderData.border': const PropertyHint(
    presets: [
      Preset(
        'Border(bottom: BorderSide(color: Colors.white54, width: 2), left: BorderSide(color: Colors.white54, width: 2))',
        Border(
          bottom: BorderSide(color: Colors.white54, width: 2),
          left: BorderSide(color: Colors.white54, width: 2),
        ),
      ),
      Preset(
        'Border.all(color: Colors.cyan, width: 3)',
        Border.fromBorderSide(BorderSide(color: Colors.cyan, width: 3)),
      ),
    ],
  ),

  // FlTitlesData
  'FlTitlesData.leftTitles': _axisTitlesPresets,
  'FlTitlesData.topTitles': _axisTitlesPresets,
  'FlTitlesData.rightTitles': _axisTitlesPresets,
  'FlTitlesData.bottomTitles': _axisTitlesPresets,

  // AxisTitles
  'AxisTitles.axisNameSize': const PropertyHint(min: 0, max: 40),
  'AxisTitles.axisNameWidget': const PropertyHint(
    presets: [
      Preset(
        "Text('Revenue (\$k)', style: TextStyle(color: Colors.amber))",
        Text('Revenue (\$k)', style: TextStyle(color: Colors.amber)),
      ),
    ],
  ),
  'AxisTitles.sideTitles': const PropertyHint(
    presets: [Preset('SideTitles()', SideTitles())],
  ),

  // SideTitles
  'SideTitles.getTitlesWidget': const PropertyHint(
    presets: [
      Preset(
        "(value, meta) => SideTitleWidget(meta: meta, child: Text('\${value.toInt()}k', style: TextStyle(color: Colors.amber)))",
        _thousandsTitle,
      ),
    ],
  ),
  'SideTitles.reservedSize': const PropertyHint(min: 0, max: 60),
  'SideTitles.interval': const PropertyHint(min: 0.5, max: 3),
  'SideTitles.minIncluded': const PropertyHint(requires: {'interval': 2.5}),
  'SideTitles.maxIncluded': const PropertyHint(requires: {'interval': 2.5}),

  // FlGridData
  'FlGridData.horizontalInterval': const PropertyHint(min: 0.5, max: 3),
  'FlGridData.verticalInterval': const PropertyHint(min: 0.5, max: 3),
  'FlGridData.getDrawingHorizontalLine': const PropertyHint(
    presets: [
      Preset(
        '(value) => FlLine(color: Colors.white12, strokeWidth: 1)',
        _thinLine,
      ),
    ],
  ),
  'FlGridData.getDrawingVerticalLine': const PropertyHint(
    presets: [
      Preset(
        '(value) => FlLine(color: Colors.white12, strokeWidth: 1)',
        _thinLine,
      ),
    ],
  ),
  'FlGridData.checkToShowHorizontalLine': const PropertyHint(
    presets: [Preset('(value) => value % 2 == 0', _isEven)],
  ),
  'FlGridData.checkToShowVerticalLine': const PropertyHint(
    presets: [Preset('(value) => value % 2 == 0', _isEven)],
  ),

  // FlLine
  'FlLine.gradient': const PropertyHint(
    requires: {'color': null},
    presets: [
      Preset(
        'LinearGradient(colors: [Colors.cyan, Colors.purpleAccent])',
        LinearGradient(colors: [Colors.cyan, Colors.purpleAccent]),
      ),
    ],
  ),
  'FlLine.strokeWidth': const PropertyHint(min: 0, max: 6),
  'FlLine.dashArray': const PropertyHint(
    presets: [
      Preset('[8, 4]', [8, 4]),
      Preset('[2, 4]', [2, 4]),
    ],
  ),

  // FlSpot
  'FlSpot.x': const PropertyHint(min: 3, max: 5),
  'FlSpot.y': const PropertyHint(min: 0, max: 7),
  'FlSpot.xError': const PropertyHint(
    presets: [
      Preset(
        'FlErrorRange(lowerBy: 0.5, upperBy: 0.5)',
        FlErrorRange(lowerBy: 0.5, upperBy: 0.5),
      ),
    ],
  ),
  'FlSpot.yError': const PropertyHint(
    presets: [
      Preset(
        'FlErrorRange(lowerBy: 0.5, upperBy: 1)',
        FlErrorRange(lowerBy: 0.5, upperBy: 1),
      ),
    ],
  ),

  // FlErrorRange
  'FlErrorRange.lowerBy': const PropertyHint(min: 0, max: 2),
  'FlErrorRange.upperBy': const PropertyHint(min: 0, max: 2),

  // RangeAnnotations
  'RangeAnnotations.horizontalRangeAnnotations': PropertyHint(
    presets: [
      Preset(
        '[HorizontalRangeAnnotation(y1: 5, y2: 6, color: Colors.green.withValues(alpha: 0.2))]',
        [
          HorizontalRangeAnnotation(
            y1: 5,
            y2: 6,
            color: Colors.green.withValues(alpha: 0.2),
          ),
        ],
      ),
    ],
  ),
  'RangeAnnotations.verticalRangeAnnotations': PropertyHint(
    presets: [
      Preset(
        '[VerticalRangeAnnotation(x1: 3, x2: 6, color: Colors.purple.withValues(alpha: 0.2))]',
        [
          VerticalRangeAnnotation(
            x1: 3,
            x2: 6,
            color: Colors.purple.withValues(alpha: 0.2),
          ),
        ],
      ),
    ],
  ),

  // HorizontalRangeAnnotation
  'HorizontalRangeAnnotation.y1': const PropertyHint(min: 0, max: 7),
  'HorizontalRangeAnnotation.y2': const PropertyHint(min: 0, max: 7),
  'HorizontalRangeAnnotation.gradient': const PropertyHint(
    requires: {'color': null},
    presets: [_rangeGradient],
  ),

  // VerticalRangeAnnotation
  'VerticalRangeAnnotation.x1': const PropertyHint(min: 0, max: 10),
  'VerticalRangeAnnotation.x2': const PropertyHint(min: 0, max: 10),
  'VerticalRangeAnnotation.gradient': const PropertyHint(
    requires: {'color': null},
    presets: [_rangeGradient],
  ),

  // ExtraLinesData
  'ExtraLinesData.horizontalLines': PropertyHint(
    presets: [
      Preset('[HorizontalLine(y: 2, color: Colors.green, strokeWidth: 3)]', [
        HorizontalLine(y: 2, color: Colors.green, strokeWidth: 3),
      ]),
    ],
  ),
  'ExtraLinesData.verticalLines': PropertyHint(
    presets: [
      Preset('[VerticalLine(x: 3, color: Colors.green, strokeWidth: 3)]', [
        VerticalLine(x: 3, color: Colors.green, strokeWidth: 3),
      ]),
    ],
  ),

  // SizedPicture
  'SizedPicture.picture': PropertyHint(
    presets: [
      Preset('myPicture // a rounded amber square', samplePicture().picture),
    ],
  ),
  'SizedPicture.width': const PropertyHint(min: 8, max: 48),
  'SizedPicture.height': const PropertyHint(min: 8, max: 48),

  // SideTitleFitInsideData
  'SideTitleFitInsideData.distanceFromEdge': const PropertyHint(
    min: 0,
    max: 24,
    requires: {'enabled': true},
  ),
  'SideTitleFitInsideData.axisPosition': const PropertyHint(
    note:
        'It comes from the `TitleMeta` of the title, editing it does nothing here.',
  ),
  'SideTitleFitInsideData.parentAxisSize': const PropertyHint(
    note:
        'It comes from the `TitleMeta` of the title, editing it does nothing here.',
  ),

  // HorizontalLine
  'HorizontalLine.y': const PropertyHint(min: 0, max: 7),
  'HorizontalLine.gradient': const PropertyHint(
    requires: {'color': null},
    presets: [_lineGradient],
  ),
  'HorizontalLine.strokeWidth': const PropertyHint(min: 0, max: 8),
  'HorizontalLine.sizedPicture': PropertyHint(
    presets: [
      Preset(
        'mySizedPicture // a rounded amber square, 18 by 18',
        samplePicture(),
      ),
    ],
  ),
  'HorizontalLine.image': PropertyHint(
    presets: [Preset('myImage // a purple circle, 18 by 18', sampleImage())],
  ),
  'HorizontalLine.dashArray': const PropertyHint(presets: [_dashes]),
  'HorizontalLine.label': PropertyHint(
    presets: [
      Preset(
        "HorizontalLineLabel(show: true, labelResolver: (line) => 'Target')",
        HorizontalLineLabel(show: true, labelResolver: (line) => 'Target'),
      ),
    ],
  ),
  'HorizontalLine.strokeCap': const PropertyHint(
    requires: {'strokeWidth': 8.0, 'dashArray': null},
  ),

  // VerticalLine
  'VerticalLine.x': const PropertyHint(min: 0, max: 10),
  'VerticalLine.gradient': const PropertyHint(
    requires: {'color': null},
    presets: [_lineGradient],
  ),
  'VerticalLine.strokeWidth': const PropertyHint(min: 0, max: 8),
  'VerticalLine.sizedPicture': PropertyHint(
    presets: [
      Preset(
        'SizedPicture(picture, 18, 18) // a rounded amber square',
        samplePicture(),
      ),
    ],
  ),
  'VerticalLine.image': PropertyHint(
    presets: [Preset('ui.Image // a purple circle, 18 by 18', sampleImage())],
  ),
  'VerticalLine.dashArray': const PropertyHint(presets: [_dashes]),
  'VerticalLine.label': PropertyHint(
    presets: [
      Preset(
        "VerticalLineLabel(show: true, labelResolver: (line) => 'Today')",
        VerticalLineLabel(show: true, labelResolver: (line) => 'Today'),
      ),
    ],
  ),
  'VerticalLine.strokeCap': const PropertyHint(
    requires: {'strokeWidth': 8.0, 'dashArray': null},
  ),

  // HorizontalLineLabel
  'HorizontalLineLabel.padding': const PropertyHint(presets: _paddings),
  'HorizontalLineLabel.style': const PropertyHint(presets: _labelStyles),
  'HorizontalLineLabel.alignment': const PropertyHint(presets: _alignments),
  'HorizontalLineLabel.labelResolver': const PropertyHint(
    presets: [Preset("(line) => 'Target: \${line.y}'", _horizontalTarget)],
  ),

  // VerticalLineLabel
  'VerticalLineLabel.padding': const PropertyHint(presets: _paddings),
  'VerticalLineLabel.style': const PropertyHint(presets: _labelStyles),
  'VerticalLineLabel.alignment': const PropertyHint(presets: _alignments),
  'VerticalLineLabel.labelResolver': const PropertyHint(
    presets: [Preset("(line) => 'x = \${line.x}'", _verticalTarget)],
  ),
};

const _axisTitlesPresets = PropertyHint(
  presets: [
    Preset('AxisTitles()', AxisTitles()),
    Preset(
      'AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28))',
      AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
    ),
  ],
);

const _rangeGradient = Preset(
  'LinearGradient(colors: [Colors.cyan, Colors.transparent])',
  LinearGradient(colors: [Colors.cyan, Colors.transparent]),
);

const _lineGradient = Preset(
  'LinearGradient(colors: [Colors.amber, Colors.pinkAccent])',
  LinearGradient(colors: [Colors.amber, Colors.pinkAccent]),
);

const _dashes = Preset('[2, 4]', [2, 4]);

const _paddings = [
  Preset('EdgeInsets.zero', EdgeInsets.zero),
  Preset('EdgeInsets.all(16)', EdgeInsets.all(16)),
];

const _labelStyles = [
  Preset(
    'TextStyle(color: Colors.white, fontSize: 18)',
    TextStyle(color: Colors.white, fontSize: 18),
  ),
];

const _alignments = [
  Preset('Alignment.topRight', Alignment.topRight),
  Preset('Alignment.bottomLeft', Alignment.bottomLeft),
  Preset('Alignment.center', Alignment.center),
];

Widget _thousandsTitle(double value, TitleMeta meta) => SideTitleWidget(
  meta: meta,
  child: Text('${value.toInt()}k', style: const TextStyle(color: Colors.amber)),
);

FlLine _thinLine(double value) =>
    const FlLine(color: Colors.white12, strokeWidth: 1);

bool _isEven(double value) => value % 2 == 0;

String _horizontalTarget(HorizontalLine line) => 'Target: ${line.y}';

String _verticalTarget(VerticalLine line) => 'x = ${line.x}';
