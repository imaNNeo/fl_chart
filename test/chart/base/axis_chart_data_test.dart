
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AxisChartData data equality check',() {

    VerticalRangeAnnotation verticalRangeAnnotation1 = VerticalRangeAnnotation(
      color: Colors.green,
      x2: 12,
      x1: 12.1
    );
    VerticalRangeAnnotation verticalRangeAnnotation2 = VerticalRangeAnnotation(
      color: Colors.green,
      x2: 12,
      x1: 12.1
    );

    HorizontalRangeAnnotation horizontalRangeAnnotation1 = HorizontalRangeAnnotation(
      color: Colors.green,
      y2: 12,
      y1: 12.1
    );
    HorizontalRangeAnnotation horizontalRangeAnnotation2 = HorizontalRangeAnnotation(
      color: Colors.green,
      y2: 12,
      y1: 12.1
    );

    RangeAnnotations rangeAnnotations1 = RangeAnnotations(
      horizontalRangeAnnotations: [
        horizontalRangeAnnotation1,
        horizontalRangeAnnotation2,
      ],
      verticalRangeAnnotations: [
        verticalRangeAnnotation1,
        verticalRangeAnnotation2,
      ]
    );
    RangeAnnotations rangeAnnotations2 = RangeAnnotations(
      horizontalRangeAnnotations: [
        horizontalRangeAnnotation1,
        horizontalRangeAnnotation2,
      ],
      verticalRangeAnnotations: [
        verticalRangeAnnotation1,
        verticalRangeAnnotation2,
      ]
    );

    FlLine flLine1 = FlLine(color: Colors.green, strokeWidth: 1, dashArray: [1, 2, 3]);
    FlLine flLine1_clone = FlLine(color: Colors.green, strokeWidth: 1, dashArray: [1, 2, 3]);

    Function(double) checkToShowLine = (value) => true;
    Function(double) getDrawingLine = (value) => FlLine();

    FlSpot flSpot1 = FlSpot(1, 1);
    FlSpot flSpot1_clone = flSpot1.copyWith();

    FlSpot flSpot2 = FlSpot(4, 2);
    FlSpot flSpot2_clone = flSpot2.copyWith();

    Function(double value) getTitles = (value) => 'sallam';

    SideTitles sideTitles1 = SideTitles(
      margin: 1,
      reservedSize: 10,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: getTitles,
      interval: 12,
      rotateAngle: 11,
    );
    SideTitles sideTitles1_clone = SideTitles(
      margin: 1,
      reservedSize: 10,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: getTitles,
      interval: 12,
      rotateAngle: 11,
    );
    SideTitles sideTitles2 = SideTitles(
      margin: 1,
      reservedSize: 10,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: null,
      interval: 12,
      rotateAngle: 11,
    );
    SideTitles sideTitles3 = SideTitles(
      margin: 4,
      reservedSize: 10,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: getTitles,
      interval: 12,
      rotateAngle: 11,
    );
    SideTitles sideTitles4 = SideTitles(
      margin: 1,
      reservedSize: 11,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: getTitles,
      interval: 12,
      rotateAngle: 11,
    );
    SideTitles sideTitles5 = SideTitles(
      margin: 1,
      reservedSize: 10,
      textStyle: TextStyle(color: Colors.red),
      showTitles: false,
      getTitles: getTitles,
      interval: 12,
      rotateAngle: 11,
    );
    SideTitles sideTitles6 = SideTitles(
      margin: 1,
      reservedSize: 10,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: getTitles,
      interval: 12,
      rotateAngle: 13,
    );

    FlTitlesData flTitlesData1 = FlTitlesData(
      show: true,
      bottomTitles: sideTitles1,
      topTitles: sideTitles2,
      rightTitles: sideTitles3,
      leftTitles: sideTitles4,
    );
    FlTitlesData flTitlesData1_clone = FlTitlesData(
      show: true,
      bottomTitles: sideTitles1_clone,
      topTitles: sideTitles2,
      rightTitles: sideTitles3,
      leftTitles: sideTitles4,
    );
    FlTitlesData flTitlesData2 = FlTitlesData(
      show: true,
      bottomTitles: null,
      topTitles: sideTitles2,
      rightTitles: sideTitles3,
      leftTitles: sideTitles4,
    );
    FlTitlesData flTitlesData3 = FlTitlesData(
      show: true,
      bottomTitles: sideTitles1,
      topTitles: null,
      rightTitles: sideTitles3,
      leftTitles: sideTitles4,
    );
    FlTitlesData flTitlesData4 = FlTitlesData(
      show: true,
      bottomTitles: sideTitles1,
      topTitles: sideTitles2,
      rightTitles: null,
      leftTitles: sideTitles4,
    );
    FlTitlesData flTitlesData5 = FlTitlesData(
      show: true,
      bottomTitles: sideTitles1,
      topTitles: sideTitles2,
      rightTitles: sideTitles3,
      leftTitles: null,
    );
    FlTitlesData flTitlesData6 = FlTitlesData(
      show: false,
      bottomTitles: sideTitles1,
      topTitles: sideTitles2,
      rightTitles: sideTitles3,
      leftTitles: sideTitles4,
    );

    AxisTitle axisTitle1 = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 12,
      margin: 33,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );
    AxisTitle axisTitle1_clone = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 12,
      margin: 33,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );

    AxisTitle axisTitle2 = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 33,
      margin: 33,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );
    AxisTitle axisTitle3 = AxisTitle(
      textStyle: TextStyle(color: Colors.red),
      reservedSize: 12,
      margin: 33,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );
    AxisTitle axisTitle4 = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 12,
      margin: 11,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );
    AxisTitle axisTitle5 = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 12,
      margin: 33,
      showTitle: false,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );
    AxisTitle axisTitle6 = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 12,
      margin: 33,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.left,
    );
    AxisTitle axisTitle7 = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 12,
      margin: 33,
      showTitle: true,
      titleText: 'sallamm',
      textAlign: TextAlign.right,
    );
    AxisTitle axisTitle8 = AxisTitle(
      textStyle: null,
      reservedSize: 12,
      margin: 33,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );

    FlAxisTitleData flAxisTitleData1 = FlAxisTitleData(
      show: true,
      topTitle: axisTitle1,
      rightTitle: axisTitle2,
      leftTitle: axisTitle3,
      bottomTitle: axisTitle4,
    );
    FlAxisTitleData flAxisTitleData1_clone = FlAxisTitleData(
      show: true,
      topTitle: axisTitle1_clone,
      rightTitle: axisTitle2,
      leftTitle: axisTitle3,
      bottomTitle: axisTitle4,
    );
    FlAxisTitleData flAxisTitleData2 = FlAxisTitleData(
      show: true,
      topTitle: null,
      rightTitle: axisTitle2,
      leftTitle: axisTitle3,
      bottomTitle: axisTitle4,
    );
    FlAxisTitleData flAxisTitleData3 = FlAxisTitleData(
      show: true,
      topTitle: axisTitle1,
      rightTitle: null,
      leftTitle: axisTitle3,
      bottomTitle: axisTitle4,
    );
    FlAxisTitleData flAxisTitleData4 = FlAxisTitleData(
      show: true,
      topTitle: axisTitle1,
      rightTitle: axisTitle2,
      leftTitle: null,
      bottomTitle: axisTitle4,
    );
    FlAxisTitleData flAxisTitleData5 = FlAxisTitleData(
      show: true,
      topTitle: axisTitle1,
      rightTitle: axisTitle2,
      leftTitle: axisTitle3,
      bottomTitle: null,
    );
    FlAxisTitleData flAxisTitleData6 = FlAxisTitleData(
      show: false,
      topTitle: axisTitle1,
      rightTitle: axisTitle2,
      leftTitle: axisTitle3,
      bottomTitle: axisTitle4,
    );
    FlAxisTitleData flAxisTitleData7 = FlAxisTitleData(
      show: true,
      topTitle: axisTitle1,
      rightTitle: axisTitle2,
      leftTitle: axisTitle4,
      bottomTitle: axisTitle3,
    );
    FlAxisTitleData flAxisTitleData8 = FlAxisTitleData(
      show: true,
      topTitle: axisTitle4,
      rightTitle: axisTitle2,
      leftTitle: axisTitle3,
      bottomTitle: axisTitle1,
    );


    test('FlAxisTitleData equality test', () {
      expect(flAxisTitleData1 == flAxisTitleData1_clone, true);
      expect(flAxisTitleData1 == flAxisTitleData2, false);
      expect(flAxisTitleData1 == flAxisTitleData3, false);
      expect(flAxisTitleData1 == flAxisTitleData4, false);
      expect(flAxisTitleData1 == flAxisTitleData5, false);
      expect(flAxisTitleData1 == flAxisTitleData6, false);
      expect(flAxisTitleData1 == flAxisTitleData7, false);
      expect(flAxisTitleData1 == flAxisTitleData8, false);
    });

    test('AxisTitle equality test', () {
      expect(axisTitle1 == axisTitle1_clone, true);
      expect(axisTitle1 == axisTitle2, false);
      expect(axisTitle1 == axisTitle3, false);
      expect(axisTitle1 == axisTitle4, false);
      expect(axisTitle1 == axisTitle5, false);
      expect(axisTitle1 == axisTitle6, false);
      expect(axisTitle1 == axisTitle7, false);
      expect(axisTitle1 == axisTitle8, false);
    });

    test('FlTitlesData equality test', () {
      expect(flTitlesData1 == flTitlesData1_clone, true);
      expect(flTitlesData1 == flTitlesData2, false);
      expect(flTitlesData1 == flTitlesData3, false);
      expect(flTitlesData1 == flTitlesData4, false);
      expect(flTitlesData1 == flTitlesData5, false);
      expect(flTitlesData1 == flTitlesData6, false);
    });

    test('SideTitles equality test', () {
      expect(sideTitles1 == sideTitles1_clone, true);
      expect(sideTitles1 == sideTitles2, false);
      expect(sideTitles1 == sideTitles3, false);
      expect(sideTitles1 == sideTitles4, false);
      expect(sideTitles1 == sideTitles5, false);
      expect(sideTitles1 == sideTitles6, false);
    });

    test('FlSpot equality test', () {
      expect(flSpot1 == flSpot1_clone, true);

      expect(flSpot1 == flSpot2, false);

      expect(flSpot2 == flSpot2_clone, true);
    });

    test('FlGridData equality test', () {
      FlGridData sample1 = FlGridData(
        show: true,
        verticalInterval: 12,
        horizontalInterval: 22,
        drawVerticalLine: false,
        drawHorizontalLine: true,
        checkToShowVerticalLine: checkToShowLine,
        checkToShowHorizontalLine: null,
        getDrawingHorizontalLine: getDrawingLine,
        getDrawingVerticalLine: null,
      );

      FlGridData sample2 = FlGridData(
        show: true,
        verticalInterval: 12,
        horizontalInterval: 22,
        drawVerticalLine: false,
        drawHorizontalLine: true,
        checkToShowVerticalLine: checkToShowLine,
        checkToShowHorizontalLine: null,
        getDrawingHorizontalLine: getDrawingLine,
        getDrawingVerticalLine: null,
      );

      expect(sample1 == sample2, true);
    });

    test('FlLine equality test', () {

      expect(flLine1 == flLine1_clone, true);

      expect(flLine1 == FlLine(color: Colors.green, strokeWidth: 1.001, dashArray: [1, 2, 3]), false);

      expect(flLine1 == FlLine(color: Colors.green, strokeWidth: 1, dashArray: [1,]), false);

      expect(flLine1 == FlLine(color: Colors.green, strokeWidth: 1, dashArray: []), false);

      expect(flLine1 == FlLine(color: Colors.green, strokeWidth: 1, dashArray: null), false);

      expect(flLine1 == FlLine(color: Colors.white, strokeWidth: 1, dashArray: [1, 2, 3]), false);

      expect(flLine1 == FlLine(color: Colors.green, strokeWidth: 100, dashArray: [1, 2, 3]), false);

    });

    test('RangeAnnotations equality test', () {

      expect(rangeAnnotations1 == rangeAnnotations2, true);

      expect(rangeAnnotations1 == RangeAnnotations(
        horizontalRangeAnnotations: [
          horizontalRangeAnnotation2,
          horizontalRangeAnnotation1,
        ],
        verticalRangeAnnotations: [
          verticalRangeAnnotation2,
          verticalRangeAnnotation1,
        ]
      ), true);

      expect(rangeAnnotations1 == RangeAnnotations(
        horizontalRangeAnnotations: [
          horizontalRangeAnnotation2,
        ],
        verticalRangeAnnotations: [
          verticalRangeAnnotation2,
        ]
      ), false);

      expect(rangeAnnotations1 == RangeAnnotations(
        horizontalRangeAnnotations: [],
        verticalRangeAnnotations: [
          verticalRangeAnnotation1,
          verticalRangeAnnotation2,
        ]
      ), false);

      expect(rangeAnnotations1 == RangeAnnotations(
        horizontalRangeAnnotations: [
          horizontalRangeAnnotation1,
          horizontalRangeAnnotation2,
        ],
        verticalRangeAnnotations: [
          verticalRangeAnnotation1,
          VerticalRangeAnnotation(
            color: Colors.green,
            x2: 12.01,
            x1: 12.1
          ),
        ]
      ), false);

    });

    test('HorizontalRangeAnnotation equality test', () {

      expect(horizontalRangeAnnotation1 == horizontalRangeAnnotation2, true);

      expect(horizontalRangeAnnotation1 == HorizontalRangeAnnotation(
        color: Colors.green,
        y2: 12.1,
        y1: 12.1
      ), false);

      expect(horizontalRangeAnnotation1 == HorizontalRangeAnnotation(
        color: Colors.green,
        y2: 12.0,
        y1: 12.1
      ), true);

      expect(horizontalRangeAnnotation1 == HorizontalRangeAnnotation(
        color: Colors.green,
        y2: 12.1,
        y1: 12.0
      ), false);

      expect(horizontalRangeAnnotation1 == HorizontalRangeAnnotation(
        color: Colors.green.withOpacity(0.5),
        y2: 12.0,
        y1: 12.1
      ), false);

    });

    test('VerticalRangeAnnotation equality test', () {

      expect(verticalRangeAnnotation1 == verticalRangeAnnotation2, true);

      expect(verticalRangeAnnotation1 == VerticalRangeAnnotation(
        color: Colors.green,
        x2: 12.1,
        x1: 12.1
      ), false);

      expect(verticalRangeAnnotation1 == VerticalRangeAnnotation(
        color: Colors.green,
        x2: 12.0,
        x1: 12.1
      ), true);

      expect(verticalRangeAnnotation1 == VerticalRangeAnnotation(
        color: Colors.green,
        x2: 12.1,
        x1: 12.0
      ), false);

      expect(verticalRangeAnnotation1 == VerticalRangeAnnotation(
        color: Colors.green.withOpacity(0.5),
        x2: 12.0,
        x1: 12.1
      ), false);

    });

  });

}