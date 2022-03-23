import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../data_pool.dart';

void main() {
  group('AxisChartData data equality check', () {
    test('AxisTitle equality test', () {
      expect(MockData.axisTitles1 == MockData.axisTitles1Clone, true);
      expect(MockData.axisTitles1 == MockData.axisTitles2, false);
      expect(MockData.axisTitles1 == MockData.axisTitles3, false);
      expect(MockData.axisTitles1 == MockData.axisTitles4, false);
      expect(MockData.axisTitles1 == MockData.axisTitles5, false);
    });

    test('FlTitlesData equality test', () {
      expect(MockData.flTitlesData1 == MockData.flTitlesData1Clone, true);
      expect(MockData.flTitlesData1 == MockData.flTitlesData2, false);
      expect(MockData.flTitlesData1 == MockData.flTitlesData3, false);
      expect(MockData.flTitlesData1 == MockData.flTitlesData4, false);
      expect(MockData.flTitlesData1 == MockData.flTitlesData5, false);
      expect(MockData.flTitlesData1 == MockData.flTitlesData6, false);
    });

    test('SideTitles equality test', () {
      expect(MockData.sideTitles1 == MockData.sideTitles1Clone, true);
      expect(MockData.sideTitles1 == MockData.sideTitles2, false);
      expect(MockData.sideTitles1 == MockData.sideTitles3, false);
      expect(MockData.sideTitles1 == MockData.sideTitles4, false);
      expect(MockData.sideTitles1 == MockData.sideTitles5, false);
      expect(MockData.sideTitles1 == MockData.sideTitles6, false);
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
          flLine1 ==
              FlLine(
                  color: Colors.green,
                  strokeWidth: 1.001,
                  dashArray: [1, 2, 3]),
          false);

      expect(
          flLine1 ==
              FlLine(color: Colors.green, strokeWidth: 1, dashArray: [
                1,
              ]),
          false);

      expect(
          flLine1 == FlLine(color: Colors.green, strokeWidth: 1, dashArray: []),
          false);

      expect(
          flLine1 ==
              FlLine(color: Colors.green, strokeWidth: 1, dashArray: null),
          false);

      expect(
          flLine1 ==
              FlLine(color: Colors.white, strokeWidth: 1, dashArray: [1, 2, 3]),
          false);

      expect(
          flLine1 ==
              FlLine(
                  color: Colors.green, strokeWidth: 100, dashArray: [1, 2, 3]),
          false);
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
              RangeAnnotations(
                  horizontalRangeAnnotations: [],
                  verticalRangeAnnotations: [
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
                VerticalRangeAnnotation(
                    color: Colors.green, x2: 12.01, x1: 12.1),
              ]),
          false);
    });

    test('HorizontalRangeAnnotation equality test', () {
      expect(
          horizontalRangeAnnotation1 == horizontalRangeAnnotation1Clone, true);

      expect(
          horizontalRangeAnnotation1 ==
              HorizontalRangeAnnotation(
                  color: Colors.green, y2: 12.1, y1: 12.1),
          false);

      expect(
          horizontalRangeAnnotation1 ==
              HorizontalRangeAnnotation(
                  color: Colors.green, y2: 12.0, y1: 12.1),
          true);

      expect(
          horizontalRangeAnnotation1 ==
              HorizontalRangeAnnotation(
                  color: Colors.green, y2: 12.1, y1: 12.0),
          false);

      expect(
          horizontalRangeAnnotation1 ==
              HorizontalRangeAnnotation(
                  color: Colors.green.withOpacity(0.5), y2: 12.0, y1: 12.1),
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
              VerticalRangeAnnotation(
                  color: Colors.green.withOpacity(0.5), x2: 12.0, x1: 12.1),
          false);
    });
  });
}
