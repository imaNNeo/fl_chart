import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../data_pool.dart';

void main() {
  group('AxisChartData data equality check', () {
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
      expect(flGridData1 == flGridData1Clone, true);
      expect(flGridData1 == flGridData2, false);
      expect(flGridData1 == flGridData3, false);
      expect(flGridData1 == flGridData4, false);
      expect(flGridData1 == flGridData5, false);
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
      expect(rangeAnnotations1 == rangeAnnotations1Clone, true);

      expect(rangeAnnotations1 == rangeAnnotations2, false);

      expect(
          rangeAnnotations1 ==
              RangeAnnotations(horizontalRangeAnnotations: [
                horizontalRangeAnnotation1Clone,
                horizontalRangeAnnotation1,
              ], verticalRangeAnnotations: [
                verticalRangeAnnotation1Clone,
                verticalRangeAnnotation1,
              ]),
          true);

      expect(
          rangeAnnotations1 ==
              RangeAnnotations(horizontalRangeAnnotations: [
                horizontalRangeAnnotation1Clone,
              ], verticalRangeAnnotations: [
                verticalRangeAnnotation1Clone,
              ]),
          false);

      expect(
          rangeAnnotations1 ==
              RangeAnnotations(horizontalRangeAnnotations: [], verticalRangeAnnotations: [
                verticalRangeAnnotation1,
                verticalRangeAnnotation1Clone,
              ]),
          false);

      expect(
          rangeAnnotations1 ==
              RangeAnnotations(horizontalRangeAnnotations: [
                horizontalRangeAnnotation1,
                horizontalRangeAnnotation1Clone,
              ], verticalRangeAnnotations: [
                verticalRangeAnnotation1,
                VerticalRangeAnnotation(color: Colors.green, x2: 12.01, x1: 12.1),
              ]),
          false);
    });

    test('HorizontalRangeAnnotation equality test', () {
      expect(horizontalRangeAnnotation1 == horizontalRangeAnnotation1Clone, true);

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
      expect(verticalRangeAnnotation1 == verticalRangeAnnotation1Clone, true);

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
