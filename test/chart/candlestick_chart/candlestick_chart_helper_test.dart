import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/candlestick_chart/candlestick_chart_helper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data_pool.dart';

void main() {
  group('Check CandlestickChartHelper.calculateMaxAxisValues', () {
    test('Test validity 1', () {
      final candlestickSpots = [
        candlestickSpot1,
        candlestickSpot2,
        candlestickSpot3,
        candlestickSpot4,
      ];
      final (minX, maxX, minY, maxY) =
          CandlestickChartHelper.calculateMaxAxisValues(candlestickSpots);
      expect(minX, 0);
      expect(maxX, 30);
      expect(minY, 0);
      expect(maxY, 130);
    });

    test('Test validity 2', () {
      final scatterSpots = [
        CandlestickSpot(
          x: 0,
          open: 100,
          close: 200,
          high: 400,
          low: 4,
        ),
        CandlestickSpot(
          x: 1,
          open: 500,
          close: 200,
          high: 800,
          low: 40,
        ),
      ];
      final (minX, maxX, minY, maxY) =
          CandlestickChartHelper.calculateMaxAxisValues(scatterSpots);
      expect(minX, 0);
      expect(maxX, 1);
      expect(minY, 4);
      expect(maxY, 800);
    });

    test('Test validity 3', () {
      final candlestickSpots = <CandlestickSpot>[];
      final (minX, maxX, minY, maxY) =
          CandlestickChartHelper.calculateMaxAxisValues(candlestickSpots);
      expect(minX, 0);
      expect(maxX, 0);
      expect(minY, 0);
      expect(maxY, 0);
    });

    test('Test validity 4', () {
      final candlestickSpots = [
        candlestickSpot1,
        candlestickSpot2,
        candlestickSpot3,
        candlestickSpot4,
        candlestickSpot5,
      ];
      final (minX, maxX, minY, maxY) =
          CandlestickChartHelper.calculateMaxAxisValues(candlestickSpots);
      expect(minX, -50);
      expect(maxX, 30);
      expect(minY, -30);
      expect(maxY, 130);
    });

    test('Test equality', () {
      final candlestickSpots = [
        candlestickSpot1,
        candlestickSpot2,
        candlestickSpot3,
      ];
      final candlestickSpotsClone = [
        candlestickSpot1Clone,
        candlestickSpot2Clone,
        candlestickSpot3,
      ];
      final result1 =
          CandlestickChartHelper.calculateMaxAxisValues(candlestickSpots);
      final result2 =
          CandlestickChartHelper.calculateMaxAxisValues(candlestickSpotsClone);
      expect(result1, result2);
    });
  });
}
