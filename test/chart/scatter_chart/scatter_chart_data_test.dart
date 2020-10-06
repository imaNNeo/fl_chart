import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data_pool.dart';

void main() {
  group('ScatterChart data equality check', () {
    test('ScatterChartData equality test', () {
      expect(scatterChartData1 == scatterChartData1Clone, true);
      expect(scatterChartData1 == scatterChartData1Clone.copyWith(showingTooltipIndicators: []),
          false);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(
                  borderData: FlBorderData(show: true, border: Border.all(color: Colors.green))),
          false);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(
                  borderData: FlBorderData(show: true, border: Border.all(color: Colors.white))),
          true);
      expect(scatterChartData1 == scatterChartData1Clone.copyWith(maxX: 444), false);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(scatterSpots: [
                ScatterSpot(0, 0, show: false, radius: 33, color: Colors.yellow),
                ScatterSpot(2, 2, show: false, radius: 11, color: Colors.purple),
                ScatterSpot(1, 2, show: false, radius: 11, color: Colors.white),
              ]),
          true);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(scatterSpots: [
                ScatterSpot(2, 2, show: false, radius: 11, color: Colors.purple),
                ScatterSpot(0, 0, show: false, radius: 33, color: Colors.yellow),
                ScatterSpot(1, 2, show: false, radius: 11, color: Colors.white),
              ]),
          false);
      expect(
          scatterChartData1 == scatterChartData1Clone.copyWith(clipData: FlClipData.all()), false);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(
                  gridData: FlGridData(
                show: false,
                getDrawingHorizontalLine: gridGetDrawingLine,
                getDrawingVerticalLine: gridGetDrawingLine,
                checkToShowHorizontalLine: gridCheckToShowLine,
                checkToShowVerticalLine: gridCheckToShowLine,
                drawHorizontalLine: true,
                drawVerticalLine: false,
                horizontalInterval: 33,
                verticalInterval: 1,
              )),
          true);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(
                  gridData: FlGridData(
                show: true,
                getDrawingHorizontalLine: gridGetDrawingLine,
                getDrawingVerticalLine: gridGetDrawingLine,
                checkToShowHorizontalLine: gridCheckToShowLine,
                checkToShowVerticalLine: gridCheckToShowLine,
                drawHorizontalLine: true,
                drawVerticalLine: false,
                horizontalInterval: 33,
                verticalInterval: 1,
              )),
          false);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(
                  gridData: FlGridData(
                show: false,
                getDrawingHorizontalLine: (value) =>
                    FlLine(color: Colors.green, strokeWidth: 12, dashArray: [1, 2]),
                getDrawingVerticalLine: (value) =>
                    FlLine(color: Colors.yellow, strokeWidth: 33, dashArray: [0, 1]),
                checkToShowHorizontalLine: (value) => false,
                checkToShowVerticalLine: (value) => true,
                drawHorizontalLine: true,
                drawVerticalLine: false,
                horizontalInterval: 32,
                verticalInterval: 1,
              )),
          false);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(
                  axisTitleData: FlAxisTitleData(
                show: true,
                leftTitle: AxisTitle(
                  showTitle: true,
                  textStyle: const TextStyle(color: Colors.red, fontSize: 33),
                  textAlign: TextAlign.left,
                  reservedSize: 22,
                  margin: 11,
                  titleText: 'title 1',
                ),
                bottomTitle: AxisTitle(
                  showTitle: false,
                  textStyle: const TextStyle(color: Colors.grey, fontSize: 33),
                  textAlign: TextAlign.left,
                  reservedSize: 11,
                  margin: 11,
                  titleText: 'title 2',
                ),
                rightTitle: AxisTitle(
                  showTitle: false,
                  textStyle: const TextStyle(color: Colors.blue, fontSize: 11),
                  textAlign: TextAlign.left,
                  reservedSize: 2,
                  margin: 1324,
                  titleText: 'title 3',
                ),
                topTitle: AxisTitle(
                  showTitle: true,
                  textStyle: const TextStyle(color: Colors.green, fontSize: 33),
                  textAlign: TextAlign.left,
                  reservedSize: 23,
                  margin: 11,
                  titleText: 'title 4',
                ),
              )),
          true);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(
                  axisTitleData: FlAxisTitleData(
                show: true,
                leftTitle: AxisTitle(
                  showTitle: true,
                  textStyle: const TextStyle(color: Colors.red, fontSize: 33),
                  textAlign: TextAlign.left,
                  reservedSize: 21,
                  margin: 11,
                  titleText: 'title 1',
                ),
                bottomTitle: AxisTitle(
                  showTitle: false,
                  textStyle: const TextStyle(color: Colors.grey, fontSize: 33),
                  textAlign: TextAlign.left,
                  reservedSize: 11,
                  margin: 11,
                  titleText: 'title 2',
                ),
                rightTitle: AxisTitle(
                  showTitle: false,
                  textStyle: const TextStyle(color: Colors.blue, fontSize: 11),
                  textAlign: TextAlign.left,
                  reservedSize: 2,
                  margin: 1324,
                  titleText: 'title 3',
                ),
                topTitle: AxisTitle(
                  showTitle: true,
                  textStyle: const TextStyle(color: Colors.green, fontSize: 33),
                  textAlign: TextAlign.left,
                  reservedSize: 23,
                  margin: 11,
                  titleText: 'title 4',
                ),
              )),
          false);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(
                  axisTitleData: FlAxisTitleData(
                show: true,
                leftTitle: AxisTitle(
                  showTitle: true,
                  textStyle: const TextStyle(color: Colors.red, fontSize: 33),
                  textAlign: TextAlign.left,
                  reservedSize: 22,
                  margin: 11,
                  titleText: 'title 1',
                ),
                bottomTitle: AxisTitle(
                  showTitle: false,
                  textStyle: const TextStyle(color: Colors.grey, fontSize: 33),
                  textAlign: TextAlign.left,
                  reservedSize: 11,
                  margin: 11,
                  titleText: 'title 23',
                ),
                rightTitle: AxisTitle(
                  showTitle: false,
                  textStyle: const TextStyle(color: Colors.blue, fontSize: 11),
                  textAlign: TextAlign.left,
                  reservedSize: 2,
                  margin: 1324,
                  titleText: 'title 3',
                ),
                topTitle: AxisTitle(
                  showTitle: true,
                  textStyle: const TextStyle(color: Colors.green, fontSize: 33),
                  textAlign: TextAlign.left,
                  reservedSize: 23,
                  margin: 11,
                  titleText: 'title 4',
                ),
              )),
          false);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(
                  axisTitleData: FlAxisTitleData(
                show: true,
                leftTitle: AxisTitle(
                  showTitle: true,
                  textStyle: const TextStyle(color: Colors.red, fontSize: 33),
                  textAlign: TextAlign.left,
                  reservedSize: 22,
                  margin: 11,
                  titleText: 'title 1',
                ),
                bottomTitle: AxisTitle(
                  showTitle: false,
                  textStyle: const TextStyle(color: Colors.grey, fontSize: 33),
                  textAlign: TextAlign.left,
                  reservedSize: 11,
                  margin: 11,
                  titleText: 'title 2',
                ),
                rightTitle: AxisTitle(
                  showTitle: false,
                  textStyle: const TextStyle(color: Colors.blue, fontSize: 11),
                  textAlign: TextAlign.right,
                  reservedSize: 2,
                  margin: 1324,
                  titleText: 'title 3',
                ),
                topTitle: AxisTitle(
                  showTitle: true,
                  textStyle: const TextStyle(color: Colors.green, fontSize: 33),
                  textAlign: TextAlign.left,
                  reservedSize: 23,
                  margin: 11,
                  titleText: 'title 4',
                ),
              )),
          false);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(
                  axisTitleData: FlAxisTitleData(
                show: true,
                leftTitle: AxisTitle(
                  showTitle: true,
                  textStyle: const TextStyle(color: Colors.red, fontSize: 33),
                  textAlign: TextAlign.left,
                  reservedSize: 22,
                  margin: 11,
                  titleText: 'title 1',
                ),
                bottomTitle: AxisTitle(
                  showTitle: false,
                  textStyle: const TextStyle(color: Colors.grey, fontSize: 33),
                  textAlign: TextAlign.left,
                  reservedSize: 11,
                  margin: 11,
                  titleText: 'title 2',
                ),
                rightTitle: AxisTitle(
                  showTitle: false,
                  textStyle: const TextStyle(color: Colors.blue, fontSize: 11),
                  textAlign: TextAlign.left,
                  reservedSize: 2,
                  margin: 1324,
                  titleText: 'title 3',
                ),
                topTitle: AxisTitle(
                  showTitle: true,
                  textStyle: const TextStyle(color: Colors.green, fontSize: 33.5),
                  textAlign: TextAlign.left,
                  reservedSize: 23,
                  margin: 11,
                  titleText: 'title 4',
                ),
              )),
          false);

      expect(scatterChartData1 == scatterChartData1Clone.copyWith(showingTooltipIndicators: []),
          false);

      expect(
          scatterChartData1 == scatterChartData1Clone.copyWith(showingTooltipIndicators: [2, 1, 0]),
          false);
    });

    test('ScatterSpot equality test', () {
      final ScatterSpot scatterSpot = ScatterSpot(0, 1);
      final ScatterSpot scatterSpotClone = ScatterSpot(0, 1);

      expect(scatterSpot == scatterSpotClone.copyWith(), true);
      expect(scatterSpot == scatterSpotClone.copyWith(y: 3), false);
      expect(scatterSpot == scatterSpotClone.copyWith(x: 3), false);
    });

    test('ScatterTouchData equality test', () {
      final ScatterTouchData sample = ScatterTouchData(
        touchTooltipData: ScatterTouchTooltipData(
          maxContentWidth: 2,
          tooltipBgColor: Colors.red,
          tooltipPadding: const EdgeInsets.all(11),
        ),
        handleBuiltInTouches: false,
        touchCallback: null,
        touchSpotThreshold: 23,
        enabled: false,
      );
      final ScatterTouchData sampleClone = ScatterTouchData(
        touchTooltipData: ScatterTouchTooltipData(
          maxContentWidth: 2,
          tooltipBgColor: Colors.red,
          tooltipPadding: const EdgeInsets.all(11),
        ),
        handleBuiltInTouches: false,
        touchCallback: null,
        touchSpotThreshold: 23,
        enabled: false,
      );
      expect(sample == sampleClone, true);

      expect(
          sample ==
              sampleClone.copyWith(
                touchCallback: (response) {},
              ),
          true);
      expect(
          sample ==
              sampleClone.copyWith(
                enabled: true,
              ),
          false);
      expect(
          sample ==
              sampleClone.copyWith(
                touchSpotThreshold: 22,
              ),
          false);
      expect(
          sample ==
              sampleClone.copyWith(
                handleBuiltInTouches: true,
              ),
          false);
    });

    test('ScatterTouchResponse equality test', () {
      final ScatterTouchResponse sample1 = ScatterTouchResponse(
        FlPanStart(const Offset(0, 0)),
        ScatterSpot(3, 4),
        1,
      );
      final ScatterTouchResponse sample2 = ScatterTouchResponse(
        FlPanStart(const Offset(0, 0)),
        ScatterSpot(3, 4),
        1,
      );
      expect(sample1 == sample2, true);

      ScatterTouchResponse sampleChanged = ScatterTouchResponse(
        FlPanStart(const Offset(0, 3)),
        ScatterSpot(3, 4),
        1,
      );
      expect(sample1 == sampleChanged, false);

      sampleChanged = ScatterTouchResponse(
        FlPanStart(const Offset(0, 0)),
        ScatterSpot(0, 4),
        1,
      );
      expect(sample1 == sampleChanged, false);

      sampleChanged = ScatterTouchResponse(
        FlPanStart(const Offset(0, 0)),
        ScatterSpot(3, 4),
        5,
      );
      expect(sample1 == sampleChanged, false);
    });

    test('ScatterTouchTooltipData equality test', () {
      final ScatterTouchTooltipData sample1 = ScatterTouchTooltipData(
        tooltipRoundedRadius: 23,
        tooltipPadding: const EdgeInsets.all(11),
        tooltipBgColor: Colors.green,
        maxContentWidth: 33,
        fitInsideVertically: true,
        fitInsideHorizontally: false,
        getTooltipItems: scatterChartGetTooltipItems,
      );
      final ScatterTouchTooltipData sample2 = ScatterTouchTooltipData(
        tooltipRoundedRadius: 23,
        tooltipPadding: const EdgeInsets.all(11),
        tooltipBgColor: Colors.green,
        maxContentWidth: 33,
        fitInsideVertically: true,
        fitInsideHorizontally: false,
        getTooltipItems: scatterChartGetTooltipItems,
      );
      expect(sample1 == sample2, true);
    });

    test('ScatterTooltipItem equality test', () {
      final ScatterTooltipItem sample1 = ScatterTooltipItem(
        'aa',
        const TextStyle(color: Colors.red),
        23,
      );
      final ScatterTooltipItem sample2 = ScatterTooltipItem(
        'aa',
        const TextStyle(color: Colors.red),
        23,
      );
      expect(sample1 == sample2, true);

      ScatterTooltipItem changed = ScatterTooltipItem(
        'a3a',
        const TextStyle(color: Colors.red),
        23,
      );
      expect(sample1 == changed, false);

      changed = ScatterTooltipItem(
        'aa',
        const TextStyle(color: Colors.green),
        23,
      );
      expect(sample1 == changed, false);

      changed = ScatterTooltipItem(
        'aa',
        const TextStyle(color: Colors.red),
        0,
      );
      expect(sample1 == changed, false);
    });
  });
}
