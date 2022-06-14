import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data_pool.dart';

void main() {
  group('ScatterChart data equality check', () {
    test('ScatterChartData equality test', () {
      expect(scatterChartData1 == scatterChartData1Clone, true);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(showingTooltipIndicators: []),
          false);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(
                  borderData: FlBorderData(
                      show: true, border: Border.all(color: Colors.green))),
          false);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(
                  borderData: FlBorderData(
                      show: true, border: Border.all(color: Colors.white))),
          true);
      expect(scatterChartData1 == scatterChartData1Clone.copyWith(maxX: 444),
          false);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(scatterSpots: [
                ScatterSpot(0, 0,
                    show: false, radius: 33, color: Colors.yellow),
                ScatterSpot(2, 2,
                    show: false, radius: 11, color: Colors.purple),
                ScatterSpot(1, 2, show: false, radius: 11, color: Colors.white),
              ]),
          true);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(scatterSpots: [
                ScatterSpot(2, 2,
                    show: false, radius: 11, color: Colors.purple),
                ScatterSpot(0, 0,
                    show: false, radius: 33, color: Colors.yellow),
                ScatterSpot(1, 2, show: false, radius: 11, color: Colors.white),
              ]),
          false);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(clipData: FlClipData.all()),
          false);
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
                getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.green, strokeWidth: 12, dashArray: [1, 2]),
                getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.yellow, strokeWidth: 33, dashArray: [0, 1]),
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
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    axisNameSize: 33,
                    axisNameWidget: MockData.widget1,
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    axisNameSize: 1326,
                    axisNameWidget: MockData.widget3,
                    sideTitles: SideTitles(reservedSize: 500, showTitles: true),
                  ),
                  topTitles: AxisTitles(
                    axisNameSize: 34,
                    axisNameWidget: MockData.widget4,
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameSize: 22,
                    axisNameWidget: MockData.widget2,
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
              ),
          true);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    axisNameSize: 332,
                    axisNameWidget: const Text('title 1'),
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    axisNameSize: 1326,
                    axisNameWidget: const Text('title 3'),
                    sideTitles: SideTitles(reservedSize: 500, showTitles: true),
                  ),
                  topTitles: AxisTitles(
                    axisNameSize: 34,
                    axisNameWidget: const Text('title 4'),
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameSize: 22,
                    axisNameWidget: const Text('title 2'),
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
              ),
          false);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    axisNameSize: 33,
                    axisNameWidget: const Text('title 1'),
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    axisNameSize: 1326,
                    axisNameWidget: const Text('title 3'),
                    sideTitles: SideTitles(reservedSize: 500, showTitles: true),
                  ),
                  topTitles: AxisTitles(
                    axisNameSize: 34,
                    axisNameWidget: const Text('title 4'),
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameSize: 22,
                    axisNameWidget: const Text('title 2'),
                    sideTitles: SideTitles(showTitles: true),
                  ),
                ),
              ),
          false);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    axisNameSize: 33,
                    axisNameWidget: const Text('title 1'),
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    axisNameSize: 1326,
                    axisNameWidget: const Text('title 1'),
                    sideTitles: SideTitles(reservedSize: 500, showTitles: true),
                  ),
                  topTitles: AxisTitles(
                    axisNameSize: 34,
                    axisNameWidget: const Text('title 4'),
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameSize: 22,
                    axisNameWidget: const Text('title 2'),
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
              ),
          false);
      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    axisNameSize: 33,
                    axisNameWidget: const Text('title 1'),
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    axisNameSize: 13262,
                    axisNameWidget: const Text('title 3'),
                    sideTitles: SideTitles(reservedSize: 500, showTitles: true),
                  ),
                  topTitles: AxisTitles(
                    axisNameSize: 34,
                    axisNameWidget: const Text('title 4'),
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameSize: 22,
                    axisNameWidget: const Text('title 2'),
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
              ),
          false);

      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(showingTooltipIndicators: []),
          false);

      expect(
          scatterChartData1 ==
              scatterChartData1Clone
                  .copyWith(showingTooltipIndicators: [2, 1, 0]),
          false);

      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(
                  scatterLabelSettings: ScatterLabelSettings(
                showLabel: true,
                getLabelTextStyleFunction: (int index, ScatterSpot spot) =>
                    const TextStyle(color: Colors.green),
              )),
          false);

      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(
                  scatterLabelSettings: ScatterLabelSettings(
                showLabel: false,
                getLabelTextStyleFunction: (int index, ScatterSpot spot) =>
                    const TextStyle(color: Colors.red),
                getLabelFunction: (int index, ScatterSpot spot) =>
                    'Label - $index',
              )),
          false);

      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(
                  scatterLabelSettings: ScatterLabelSettings(
                showLabel: true,
                getLabelTextStyleFunction: (int index, ScatterSpot spot) =>
                    const TextStyle(color: Colors.red),
                getLabelFunction: (int index, ScatterSpot spot) =>
                    'Different Label - $index',
              )),
          false);

      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(
                  scatterLabelSettings: ScatterLabelSettings(
                showLabel: true,
                getLabelFunction: getLabel,
                getLabelTextStyleFunction: getLabelTextStyle,
              )),
          true);

      expect(
          scatterChartData1 ==
              scatterChartData1Clone.copyWith(
                  scatterLabelSettings: ScatterLabelSettings(
                showLabel: true,
                getLabelFunction: getLabel,
                getLabelTextStyleFunction: getLabelTextStyle,
                textDirection: TextDirection.rtl,
              )),
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
                touchCallback: (event, response) {},
              ),
          false);
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

    test('ScatterTouchTooltipData equality test', () {
      expect(scatterTouchTooltipData1 == scatterTouchTooltipData1Clone, true);
      expect(scatterTouchTooltipData1 == scatterTouchTooltipData2, false);
      expect(scatterTouchTooltipData1 == scatterTouchTooltipData3, false);
    });

    test('ScatterTooltipItem equality test', () {
      final ScatterTooltipItem sample1 = ScatterTooltipItem(
        'aa',
        textStyle: const TextStyle(color: Colors.red),
        bottomMargin: 23,
      );
      final ScatterTooltipItem sample2 = ScatterTooltipItem(
        'aa',
        textStyle: const TextStyle(color: Colors.red),
        bottomMargin: 23,
      );
      expect(sample1 == sample2, true);

      ScatterTooltipItem changed = ScatterTooltipItem(
        'a3a',
        textStyle: const TextStyle(color: Colors.red),
        bottomMargin: 23,
      );
      expect(sample1 == changed, false);

      changed = ScatterTooltipItem(
        'aa',
        textStyle: const TextStyle(color: Colors.green),
        bottomMargin: 23,
      );
      expect(sample1 == changed, false);

      changed = ScatterTooltipItem(
        'aa',
        textStyle: const TextStyle(color: Colors.red),
        bottomMargin: 0,
      );
      expect(sample1 == changed, false);
    });

    test('ScatterLabelSettings equality test', () {
      final ScatterLabelSettings sample1 = ScatterLabelSettings(
        showLabel: true,
        getLabelTextStyleFunction: getLabelTextStyle,
        getLabelFunction: getLabel,
      );
      final ScatterLabelSettings sample2 = ScatterLabelSettings(
        showLabel: true,
        getLabelTextStyleFunction: getLabelTextStyle,
        getLabelFunction: getLabel,
      );
      expect(sample1 == sample2, true);

      ScatterLabelSettings changed = ScatterLabelSettings(
        showLabel: false,
        getLabelTextStyleFunction: getLabelTextStyle,
        getLabelFunction: getLabel,
      );
      expect(sample1 == changed, false);

      expect(sample1 == changed.copyWith(showLabel: true), true);

      changed = ScatterLabelSettings(
        showLabel: true,
        getLabelTextStyleFunction: getLabelTextStyle,
        getLabelFunction: (int index, ScatterSpot spot) => 'Label',
      );
      expect(sample1 == changed, false);

      changed = ScatterLabelSettings(
        showLabel: true,
        getLabelTextStyleFunction: getLabelTextStyle,
        getLabelFunction: getLabel,
        textDirection: TextDirection.rtl,
      );
      expect(sample1 == changed, false);
    });
  });
}
