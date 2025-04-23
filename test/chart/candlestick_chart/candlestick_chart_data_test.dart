import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data_pool.dart';

void main() {
  group('Candlestick data equality check', () {
    test('CandlestickChartData equality test', () {
      expect(candleStickChartData1 == candleStickChartData1Clone, true);
      expect(
        candleStickChartData1 ==
            candleStickChartData1Clone.copyWith(showingTooltipIndicators: []),
        false,
      );
      expect(
        candleStickChartData1 ==
            candleStickChartData1Clone.copyWith(
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.red),
              ),
            ),
        false,
      );
      expect(
        candleStickChartData1 ==
            candleStickChartData1Clone.copyWith(
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.green),
              ),
            ),
        true,
      );
      expect(
        candleStickChartData1 == candleStickChartData1Clone.copyWith(maxX: 444),
        false,
      );
      expect(
        candleStickChartData1 ==
            candleStickChartData1Clone.copyWith(
              candlestickSpots: [
                CandlestickSpot(
                  x: 0,
                  open: 10,
                  high: 100,
                  low: 0,
                  close: 20,
                ),
                CandlestickSpot(
                  x: 10,
                  open: 30,
                  high: 110,
                  low: 10,
                  close: 20,
                ),
                CandlestickSpot(
                  x: 20,
                  open: 30,
                  high: 120,
                  low: 20,
                  close: 40,
                ),
                CandlestickSpot(
                  x: 30,
                  open: 40,
                  high: 130,
                  low: 30,
                  close: 50,
                ),
              ],
            ),
        true,
      );
      expect(
        candleStickChartData1 ==
            candleStickChartData1Clone.copyWith(
              candlestickSpots: [
                CandlestickSpot(x: 5, open: 10, high: 100, low: 0, close: 20),
                CandlestickSpot(x: 10, open: 20, high: 110, low: 10, close: 30),
                CandlestickSpot(x: 20, open: 30, high: 120, low: 20, close: 40),
                CandlestickSpot(x: 30, open: 40, high: 130, low: 30, close: 50),
              ],
            ),
        false,
      );
      expect(
        candleStickChartData1 ==
            candleStickChartData1Clone.copyWith(
              clipData: const FlClipData.all(),
            ),
        false,
      );
      expect(
        candleStickChartData1 ==
            candleStickChartData1Clone.copyWith(
              gridData: const FlGridData(
                verticalInterval: 12,
                horizontalInterval: 22,
                drawVerticalLine: false,
                checkToShowVerticalLine: checkToShowLine,
                getDrawingHorizontalLine: getDrawingLine,
              ),
            ),
        true,
      );
      expect(
        candleStickChartData1 ==
            candleStickChartData1Clone.copyWith(
              gridData: const FlGridData(
                getDrawingHorizontalLine: gridGetDrawingLine,
                getDrawingVerticalLine: gridGetDrawingLine,
                checkToShowHorizontalLine: gridCheckToShowLine,
                checkToShowVerticalLine: gridCheckToShowLine,
                drawVerticalLine: false,
                horizontalInterval: 33,
                verticalInterval: 1,
              ),
            ),
        false,
      );
      expect(
        candleStickChartData1 ==
            candleStickChartData1Clone.copyWith(
              gridData: FlGridData(
                show: false,
                getDrawingHorizontalLine: (value) => const FlLine(
                  color: Colors.green,
                  strokeWidth: 12,
                  dashArray: [1, 2],
                ),
                getDrawingVerticalLine: (value) => const FlLine(
                  color: Colors.yellow,
                  strokeWidth: 33,
                  dashArray: [0, 1],
                ),
                checkToShowHorizontalLine: (value) => false,
                checkToShowVerticalLine: (value) => true,
                drawVerticalLine: false,
                horizontalInterval: 32,
                verticalInterval: 1,
              ),
            ),
        false,
      );
      expect(
        candleStickChartData1 ==
            candleStickChartData1Clone.copyWith(
              titlesData: MockData.flTitlesData1,
            ),
        true,
      );
      expect(
        candleStickChartData1 ==
            candleStickChartData1Clone.copyWith(
              titlesData: const FlTitlesData(
                leftTitles: AxisTitles(
                  axisNameSize: 332,
                  axisNameWidget: Text('title 1'),
                ),
                rightTitles: AxisTitles(
                  axisNameSize: 1326,
                  axisNameWidget: Text('title 3'),
                  sideTitles: SideTitles(reservedSize: 500, showTitles: true),
                ),
                topTitles: AxisTitles(
                  axisNameSize: 34,
                  axisNameWidget: Text('title 4'),
                ),
                bottomTitles: AxisTitles(
                  axisNameSize: 22,
                  axisNameWidget: Text('title 2'),
                ),
              ),
            ),
        false,
      );
      expect(
        candleStickChartData1 ==
            candleStickChartData1Clone.copyWith(
              titlesData: const FlTitlesData(
                leftTitles: AxisTitles(
                  axisNameSize: 33,
                  axisNameWidget: Text('title 1'),
                ),
                rightTitles: AxisTitles(
                  axisNameSize: 1326,
                  axisNameWidget: Text('title 3'),
                  sideTitles: SideTitles(reservedSize: 500, showTitles: true),
                ),
                topTitles: AxisTitles(
                  axisNameSize: 34,
                  axisNameWidget: Text('title 4'),
                ),
                bottomTitles: AxisTitles(
                  axisNameSize: 22,
                  axisNameWidget: Text('title 2'),
                  sideTitles: SideTitles(showTitles: true),
                ),
              ),
            ),
        false,
      );
      expect(
        candleStickChartData1 ==
            candleStickChartData1Clone.copyWith(
              titlesData: const FlTitlesData(
                leftTitles: AxisTitles(
                  axisNameSize: 33,
                  axisNameWidget: Text('title 1'),
                ),
                rightTitles: AxisTitles(
                  axisNameSize: 1326,
                  axisNameWidget: Text('title 1'),
                  sideTitles: SideTitles(reservedSize: 500, showTitles: true),
                ),
                topTitles: AxisTitles(
                  axisNameSize: 34,
                  axisNameWidget: Text('title 4'),
                ),
                bottomTitles: AxisTitles(
                  axisNameSize: 22,
                  axisNameWidget: Text('title 2'),
                ),
              ),
            ),
        false,
      );
      expect(
        candleStickChartData1 ==
            candleStickChartData1Clone.copyWith(
              titlesData: const FlTitlesData(
                leftTitles: AxisTitles(
                  axisNameSize: 33,
                  axisNameWidget: Text('title 1'),
                ),
                rightTitles: AxisTitles(
                  axisNameSize: 13262,
                  axisNameWidget: Text('title 3'),
                  sideTitles: SideTitles(reservedSize: 500, showTitles: true),
                ),
                topTitles: AxisTitles(
                  axisNameSize: 34,
                  axisNameWidget: Text('title 4'),
                ),
                bottomTitles: AxisTitles(
                  axisNameSize: 22,
                  axisNameWidget: Text('title 2'),
                ),
              ),
            ),
        false,
      );

      expect(
        candleStickChartData1 ==
            candleStickChartData1Clone.copyWith(showingTooltipIndicators: []),
        false,
      );

      expect(
        candleStickChartData1 ==
            candleStickChartData1Clone
                .copyWith(showingTooltipIndicators: [2, 1, 0]),
        false,
      );

      expect(
        candleStickChartData1 ==
            candleStickChartData1Clone.copyWith(
              candlestickPainter: DefaultCandlestickPainter(),
            ),
        false,
      );
    });

    test('CandlestickSpot equality test', () {
      expect(candlestickSpot1 == candlestickSpot1Clone, true);
      expect(candlestickSpot1 == candlestickSpot2, false);
      expect(candlestickSpot2 == candlestickSpot2.copyWith(), true);
      expect(candlestickSpot2 == candlestickSpot3, false);
      expect(candlestickSpot3 == candlestickSpot4, false);
      expect(
        candlestickSpot3 ==
            candlestickSpot3.copyWith(
              show: false,
            ),
        false,
      );
      expect(
        candlestickSpot3 ==
            candlestickSpot3.copyWith(
              show: true,
            ),
        true,
      );
    });

    test('CandlestickTouchData equality test', () {
      final sample = CandlestickTouchData(
        touchTooltipData: CandlestickTouchTooltipData(
          maxContentWidth: 2,
          getTooltipColor: candlestickChartGetTooltipRedColor,
          tooltipPadding: const EdgeInsets.all(11),
        ),
        handleBuiltInTouches: false,
        touchSpotThreshold: 23,
        enabled: false,
      );
      final sampleClone = CandlestickTouchData(
        touchTooltipData: CandlestickTouchTooltipData(
          maxContentWidth: 2,
          getTooltipColor: candlestickChartGetTooltipRedColor,
          tooltipPadding: const EdgeInsets.all(11),
        ),
        handleBuiltInTouches: false,
        touchSpotThreshold: 23,
        enabled: false,
      );
      expect(sample == sampleClone, true);

      expect(
        sample ==
            sampleClone.copyWith(
              touchCallback: (event, response) {},
            ),
        false,
      );
      expect(
        sample ==
            sampleClone.copyWith(
              enabled: true,
            ),
        false,
      );
      expect(
        sample ==
            sampleClone.copyWith(
              touchSpotThreshold: 22,
            ),
        false,
      );
      expect(
        sample ==
            sampleClone.copyWith(
              handleBuiltInTouches: true,
            ),
        false,
      );
      expect(
        sample ==
            sampleClone.copyWith(
              longPressDuration: Duration.zero,
            ),
        false,
      );
    });

    test('CandlestickTouchTooltipData equality test', () {
      expect(
        candlestickTouchTooltipData1 == candlestickTouchTooltipData1Clone,
        true,
      );
      expect(
        candlestickTouchTooltipData1 == candlestickTouchTooltipData2,
        false,
      );
      expect(
        candlestickTouchTooltipData1 == candlestickTouchTooltipData3,
        false,
      );
    });

    test('CandlestickTooltipItem equality test', () {
      final sample1 = CandlestickTooltipItem(
        'aa',
        textStyle: const TextStyle(color: Colors.red),
        bottomMargin: 23,
      );
      final sample2 = CandlestickTooltipItem(
        'aa',
        textStyle: const TextStyle(color: Colors.red),
        bottomMargin: 23,
      );
      expect(sample1 == sample2, true);

      var changed = CandlestickTooltipItem(
        'a3a',
        textStyle: const TextStyle(color: Colors.red),
        bottomMargin: 23,
      );
      expect(sample1 == changed, false);

      changed = CandlestickTooltipItem(
        'aa',
        textStyle: const TextStyle(color: Colors.green),
        bottomMargin: 23,
      );
      expect(sample1 == changed, false);

      changed = CandlestickTooltipItem(
        'aa',
        textStyle: const TextStyle(color: Colors.red),
        bottomMargin: 0,
      );
      expect(sample1 == changed, false);
    });
  });
}
