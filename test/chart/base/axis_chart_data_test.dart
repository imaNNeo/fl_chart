import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AxisChartData data equality check', () {
    final VerticalRangeAnnotation verticalRangeAnnotation1 =
        VerticalRangeAnnotation(color: Colors.green, x2: 12, x1: 12.1);
    final VerticalRangeAnnotation verticalRangeAnnotation2 =
        VerticalRangeAnnotation(color: Colors.green, x2: 12, x1: 12.1);

    final HorizontalRangeAnnotation horizontalRangeAnnotation1 =
        HorizontalRangeAnnotation(color: Colors.green, y2: 12, y1: 12.1);
    final HorizontalRangeAnnotation horizontalRangeAnnotation2 =
        HorizontalRangeAnnotation(color: Colors.green, y2: 12, y1: 12.1);

    final RangeAnnotations rangeAnnotations1 = RangeAnnotations(horizontalRangeAnnotations: [
      horizontalRangeAnnotation1,
      horizontalRangeAnnotation2,
    ], verticalRangeAnnotations: [
      verticalRangeAnnotation1,
      verticalRangeAnnotation2,
    ]);
    final RangeAnnotations rangeAnnotations2 = RangeAnnotations(horizontalRangeAnnotations: [
      horizontalRangeAnnotation1,
      horizontalRangeAnnotation2,
    ], verticalRangeAnnotations: [
      verticalRangeAnnotation1,
      verticalRangeAnnotation2,
    ]);

    final FlLine flLine1 = FlLine(color: Colors.green, strokeWidth: 1, dashArray: [1, 2, 3]);
    final FlLine flLine1Clone = FlLine(color: Colors.green, strokeWidth: 1, dashArray: [1, 2, 3]);

    final Function(double) checkToShowLine = (value) => true;
    final Function(double) getDrawingLine = (value) => FlLine();

    final FlSpot flSpot1 = FlSpot(1, 1);
    final FlSpot flSpot1Clone = flSpot1.copyWith();

    final FlSpot flSpot2 = FlSpot(4, 2);
    final FlSpot flSpot2Clone = flSpot2.copyWith();

    final Function(double value) getTitles = (value) => 'sallam';

    final SideTitles sideTitles1 = SideTitles(
      margin: 1,
      reservedSize: 10,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: getTitles,
      interval: 12,
      rotateAngle: 11,
    );
    final SideTitles sideTitles1Clone = SideTitles(
      margin: 1,
      reservedSize: 10,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: getTitles,
      interval: 12,
      rotateAngle: 11,
    );
    final SideTitles sideTitles2 = SideTitles(
      margin: 1,
      reservedSize: 10,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: null,
      interval: 12,
      rotateAngle: 11,
    );
    final SideTitles sideTitles3 = SideTitles(
      margin: 4,
      reservedSize: 10,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: getTitles,
      interval: 12,
      rotateAngle: 11,
    );
    final SideTitles sideTitles4 = SideTitles(
      margin: 1,
      reservedSize: 11,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: getTitles,
      interval: 12,
      rotateAngle: 11,
    );
    final SideTitles sideTitles5 = SideTitles(
      margin: 1,
      reservedSize: 10,
      textStyle: TextStyle(color: Colors.red),
      showTitles: false,
      getTitles: getTitles,
      interval: 12,
      rotateAngle: 11,
    );
    final SideTitles sideTitles6 = SideTitles(
      margin: 1,
      reservedSize: 10,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: getTitles,
      interval: 12,
      rotateAngle: 13,
    );

    final FlTitlesData flTitlesData1 = FlTitlesData(
      show: true,
      bottomTitles: sideTitles1,
      topTitles: sideTitles2,
      rightTitles: sideTitles3,
      leftTitles: sideTitles4,
    );
    final FlTitlesData flTitlesData1Clone = FlTitlesData(
      show: true,
      bottomTitles: sideTitles1Clone,
      topTitles: sideTitles2,
      rightTitles: sideTitles3,
      leftTitles: sideTitles4,
    );
    final FlTitlesData flTitlesData2 = FlTitlesData(
      show: true,
      bottomTitles: null,
      topTitles: sideTitles2,
      rightTitles: sideTitles3,
      leftTitles: sideTitles4,
    );
    final FlTitlesData flTitlesData3 = FlTitlesData(
      show: true,
      bottomTitles: sideTitles1,
      topTitles: null,
      rightTitles: sideTitles3,
      leftTitles: sideTitles4,
    );
    final FlTitlesData flTitlesData4 = FlTitlesData(
      show: true,
      bottomTitles: sideTitles1,
      topTitles: sideTitles2,
      rightTitles: null,
      leftTitles: sideTitles4,
    );
    final FlTitlesData flTitlesData5 = FlTitlesData(
      show: true,
      bottomTitles: sideTitles1,
      topTitles: sideTitles2,
      rightTitles: sideTitles3,
      leftTitles: null,
    );
    final FlTitlesData flTitlesData6 = FlTitlesData(
      show: false,
      bottomTitles: sideTitles1,
      topTitles: sideTitles2,
      rightTitles: sideTitles3,
      leftTitles: sideTitles4,
    );

    final AxisTitle axisTitle1 = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 12,
      margin: 33,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );
    final AxisTitle axisTitle1Clone = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 12,
      margin: 33,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );

    final AxisTitle axisTitle2 = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 33,
      margin: 33,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );
    final AxisTitle axisTitle3 = AxisTitle(
      textStyle: TextStyle(color: Colors.red),
      reservedSize: 12,
      margin: 33,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );
    final AxisTitle axisTitle4 = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 12,
      margin: 11,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );
    final AxisTitle axisTitle5 = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 12,
      margin: 33,
      showTitle: false,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );
    final AxisTitle axisTitle6 = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 12,
      margin: 33,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.left,
    );
    final AxisTitle axisTitle7 = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 12,
      margin: 33,
      showTitle: true,
      titleText: 'sallamm',
      textAlign: TextAlign.right,
    );
    final AxisTitle axisTitle8 = AxisTitle(
      textStyle: null,
      reservedSize: 12,
      margin: 33,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );

    final FlAxisTitleData flAxisTitleData1 = FlAxisTitleData(
      show: true,
      topTitle: axisTitle1,
      rightTitle: axisTitle2,
      leftTitle: axisTitle3,
      bottomTitle: axisTitle4,
    );
    final FlAxisTitleData flAxisTitleData1Clone = FlAxisTitleData(
      show: true,
      topTitle: axisTitle1Clone,
      rightTitle: axisTitle2,
      leftTitle: axisTitle3,
      bottomTitle: axisTitle4,
    );
    final FlAxisTitleData flAxisTitleData2 = FlAxisTitleData(
      show: true,
      topTitle: null,
      rightTitle: axisTitle2,
      leftTitle: axisTitle3,
      bottomTitle: axisTitle4,
    );
    final FlAxisTitleData flAxisTitleData3 = FlAxisTitleData(
      show: true,
      topTitle: axisTitle1,
      rightTitle: null,
      leftTitle: axisTitle3,
      bottomTitle: axisTitle4,
    );
    final FlAxisTitleData flAxisTitleData4 = FlAxisTitleData(
      show: true,
      topTitle: axisTitle1,
      rightTitle: axisTitle2,
      leftTitle: null,
      bottomTitle: axisTitle4,
    );
    final FlAxisTitleData flAxisTitleData5 = FlAxisTitleData(
      show: true,
      topTitle: axisTitle1,
      rightTitle: axisTitle2,
      leftTitle: axisTitle3,
      bottomTitle: null,
    );
    final FlAxisTitleData flAxisTitleData6 = FlAxisTitleData(
      show: false,
      topTitle: axisTitle1,
      rightTitle: axisTitle2,
      leftTitle: axisTitle3,
      bottomTitle: axisTitle4,
    );
    final FlAxisTitleData flAxisTitleData7 = FlAxisTitleData(
      show: true,
      topTitle: axisTitle1,
      rightTitle: axisTitle2,
      leftTitle: axisTitle4,
      bottomTitle: axisTitle3,
    );
    final FlAxisTitleData flAxisTitleData8 = FlAxisTitleData(
      show: true,
      topTitle: axisTitle4,
      rightTitle: axisTitle2,
      leftTitle: axisTitle3,
      bottomTitle: axisTitle1,
    );

    test('FlAxisTitleData equality test', () {
      expect(flAxisTitleData1 == flAxisTitleData1Clone, true);
      expect(flAxisTitleData1 == flAxisTitleData2, false);
      expect(flAxisTitleData1 == flAxisTitleData3, false);
      expect(flAxisTitleData1 == flAxisTitleData4, false);
      expect(flAxisTitleData1 == flAxisTitleData5, false);
      expect(flAxisTitleData1 == flAxisTitleData6, false);
      expect(flAxisTitleData1 == flAxisTitleData7, false);
      expect(flAxisTitleData1 == flAxisTitleData8, false);
    });

    test('AxisTitle equality test', () {
      expect(axisTitle1 == axisTitle1Clone, true);
      expect(axisTitle1 == axisTitle2, false);
      expect(axisTitle1 == axisTitle3, false);
      expect(axisTitle1 == axisTitle4, false);
      expect(axisTitle1 == axisTitle5, false);
      expect(axisTitle1 == axisTitle6, false);
      expect(axisTitle1 == axisTitle7, false);
      expect(axisTitle1 == axisTitle8, false);
    });

    test('FlTitlesData equality test', () {
      expect(flTitlesData1 == flTitlesData1Clone, true);
      expect(flTitlesData1 == flTitlesData2, false);
      expect(flTitlesData1 == flTitlesData3, false);
      expect(flTitlesData1 == flTitlesData4, false);
      expect(flTitlesData1 == flTitlesData5, false);
      expect(flTitlesData1 == flTitlesData6, false);
    });

    test('SideTitles equality test', () {
      expect(sideTitles1 == sideTitles1Clone, true);
      expect(sideTitles1 == sideTitles2, false);
      expect(sideTitles1 == sideTitles3, false);
      expect(sideTitles1 == sideTitles4, false);
      expect(sideTitles1 == sideTitles5, false);
      expect(sideTitles1 == sideTitles6, false);
    });

    test('FlSpot equality test', () {
      expect(flSpot1 == flSpot1Clone, true);

      expect(flSpot1 == flSpot2, false);

      expect(flSpot2 == flSpot2Clone, true);
    });

    test('FlGridData equality test', () {
      final FlGridData sample1 = FlGridData(
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

      final FlGridData sample2 = FlGridData(
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
      expect(flLine1 == flLine1Clone, true);

      expect(
          flLine1 == FlLine(color: Colors.green, strokeWidth: 1.001, dashArray: [1, 2, 3]), false);

      expect(
          flLine1 ==
              FlLine(color: Colors.green, strokeWidth: 1, dashArray: [
                1,
              ]),
          false);

      expect(flLine1 == FlLine(color: Colors.green, strokeWidth: 1, dashArray: []), false);

      expect(flLine1 == FlLine(color: Colors.green, strokeWidth: 1, dashArray: null), false);

      expect(flLine1 == FlLine(color: Colors.white, strokeWidth: 1, dashArray: [1, 2, 3]), false);

      expect(flLine1 == FlLine(color: Colors.green, strokeWidth: 100, dashArray: [1, 2, 3]), false);
    });

    test('RangeAnnotations equality test', () {
      expect(rangeAnnotations1 == rangeAnnotations2, true);

      expect(
          rangeAnnotations1 ==
              RangeAnnotations(horizontalRangeAnnotations: [
                horizontalRangeAnnotation2,
                horizontalRangeAnnotation1,
              ], verticalRangeAnnotations: [
                verticalRangeAnnotation2,
                verticalRangeAnnotation1,
              ]),
          true);

      expect(
          rangeAnnotations1 ==
              RangeAnnotations(horizontalRangeAnnotations: [
                horizontalRangeAnnotation2,
              ], verticalRangeAnnotations: [
                verticalRangeAnnotation2,
              ]),
          false);

      expect(
          rangeAnnotations1 ==
              RangeAnnotations(horizontalRangeAnnotations: [], verticalRangeAnnotations: [
                verticalRangeAnnotation1,
                verticalRangeAnnotation2,
              ]),
          false);

      expect(
          rangeAnnotations1 ==
              RangeAnnotations(horizontalRangeAnnotations: [
                horizontalRangeAnnotation1,
                horizontalRangeAnnotation2,
              ], verticalRangeAnnotations: [
                verticalRangeAnnotation1,
                VerticalRangeAnnotation(color: Colors.green, x2: 12.01, x1: 12.1),
              ]),
          false);
    });

    test('HorizontalRangeAnnotation equality test', () {
      expect(horizontalRangeAnnotation1 == horizontalRangeAnnotation2, true);

      expect(
          horizontalRangeAnnotation1 ==
              HorizontalRangeAnnotation(color: Colors.green, y2: 12.1, y1: 12.1),
          false);

      expect(
          horizontalRangeAnnotation1 ==
              HorizontalRangeAnnotation(color: Colors.green, y2: 12.0, y1: 12.1),
          true);

      expect(
          horizontalRangeAnnotation1 ==
              HorizontalRangeAnnotation(color: Colors.green, y2: 12.1, y1: 12.0),
          false);

      expect(
          horizontalRangeAnnotation1 ==
              HorizontalRangeAnnotation(color: Colors.green.withOpacity(0.5), y2: 12.0, y1: 12.1),
          false);
    });

    test('VerticalRangeAnnotation equality test', () {
      expect(verticalRangeAnnotation1 == verticalRangeAnnotation2, true);

      expect(
          verticalRangeAnnotation1 ==
              VerticalRangeAnnotation(color: Colors.green, x2: 12.1, x1: 12.1),
          false);

      expect(
          verticalRangeAnnotation1 ==
              VerticalRangeAnnotation(color: Colors.green, x2: 12.0, x1: 12.1),
          true);

      expect(
          verticalRangeAnnotation1 ==
              VerticalRangeAnnotation(color: Colors.green, x2: 12.1, x1: 12.0),
          false);

      expect(
          verticalRangeAnnotation1 ==
              VerticalRangeAnnotation(color: Colors.green.withOpacity(0.5), x2: 12.0, x1: 12.1),
          false);
    });
  });
}
