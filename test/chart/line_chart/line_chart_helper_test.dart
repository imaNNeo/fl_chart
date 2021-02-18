import '../data_pool.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_helper.dart';


void main() {
  group('Check caching of LineChartHelper.calculateMaxAxisValues', () {

    test('Test read from cache', () {
      final lineBars = [lineChartBarData1, lineChartBarData2]
      final lineBarsClone = [lineChartBarData1Clone, lineChartBarData2]
      final result1 = LineChartHelper.calculateMaxAxisValues(lineBars)
      final result2 = LineChartHelper.calculateMaxAxisValues(lineBarsClone)
      expect(result1.readFromCache == false)
      expect(result2.readFromCache == true)
    })

    test('Test validity 1', () {
      final lineBars = [lineChartBarData1, lineChartBarData2]
      final result = LineChartHelper.calculateMaxAxisValues(lineBars)
      expect(result.minX == 1);
      expect(result.maxX == 4);
      expect(result.minY == 1);
      expect(result.maxY == 2);
    })

    test('Test validity 2', () {
      final lineBars = [
        lineChartBarData1.copyWith(
            spots: [
              FlSpot(3, 4),
              FlSpot(-3, 50),
              FlSpot(14, -10),
            ]
        )
      ]
      final result = LineChartHelper.calculateMaxAxisValues(lineBars)
      expect(result.minX == -3);
      expect(result.maxX == 14);
      expect(result.minY == -10);
      expect(result.maxY == 50);
    })

    test('Test equality', () {
      final lineBars = [lineChartBarData1, lineChartBarData2]
      final lineBarsClone = [lineChartBarData1Clone, lineChartBarData2]
      final result1 = LineChartHelper.calculateMaxAxisValues(lineBars)
      final result2 = LineChartHelper.calculateMaxAxisValues(lineBarsClone)
      expect(result1 == result2)
    });
  })
}