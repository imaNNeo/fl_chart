import '../data_pool.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_extensions.dart';

void main() {
  group('test BackgroundBarChartRodData.getSafeColorStops()', () {
    test('test 1', () {
      final backgroundBarChartRodData = BackgroundBarChartRodData(
        colors: [MockData.color1, MockData.color2],
        colorStops: [0.2, 0.5],
      );

      expect(backgroundBarChartRodData.getSafeColorStops(), [0.2, 0.5]);
    });

    test('test 2', () {
      final backgroundBarChartRodData = BackgroundBarChartRodData(
        colors: [MockData.color1, MockData.color2],
        colorStops: [0.2],
      );

      expect(backgroundBarChartRodData.getSafeColorStops(), [0.0, 1.0]);
    });

    test('test 3', () {
      final backgroundBarChartRodData = BackgroundBarChartRodData(
        colors: [MockData.color1, MockData.color2, MockData.color3],
        colorStops: [0.2],
      );

      expect(backgroundBarChartRodData.getSafeColorStops(), [0.0, 0.5, 1.0]);
    });

    test('test 4', () {
      final backgroundBarChartRodData = BackgroundBarChartRodData(
        colors: [],
        colorStops: [0.2],
      );

      var threwException = false;
      try {
        backgroundBarChartRodData.getSafeColorStops();
      } on ArgumentError {
        threwException = true;
      }
      expect(threwException, true);
    });
  });

  group('test BarChartRodData.getSafeColorStops()', () {
    test('test 1', () {
      final barChartRodData = BarChartRodData(
        y: 10,
        colors: [MockData.color1, MockData.color2],
        gradientColorStops: [0.2, 0.5],
      );

      expect(barChartRodData.getSafeColorStops(), [0.2, 0.5]);
    });

    test('test 2', () {
      final barChartRodData = BarChartRodData(
        y: 10,
        colors: [MockData.color1, MockData.color2],
        gradientColorStops: [0.2],
      );

      expect(barChartRodData.getSafeColorStops(), [0.0, 1.0]);
    });

    test('test 3', () {
      final barChartRodData = BarChartRodData(
        y: 10,
        colors: [MockData.color1, MockData.color2, MockData.color3],
        gradientColorStops: [0.2],
      );

      expect(barChartRodData.getSafeColorStops(), [0.0, 0.5, 1.0]);
    });

    test('test 4', () {
      final barChartRodData = BarChartRodData(
        y: 10,
        colors: [],
        gradientColorStops: [0.2],
      );

      var threwException = false;
      try {
        barChartRodData.getSafeColorStops();
      } on ArgumentError {
        threwException = true;
      }
      expect(threwException, true);
    });
  });
}
