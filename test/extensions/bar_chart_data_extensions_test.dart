import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/extensions/bar_chart_data_extension.dart';
import 'package:flutter_test/flutter_test.dart';
import '../chart/data_pool.dart';

void main() {
  test('test drawRRect', () {
    expect(
      MockData.barChartData1
          .copyWith(alignment: BarChartAlignment.start)
          .calculateGroupsX(100),
      [9.0, 27.0, 45.0],
    );

    expect(
      MockData.barChartData1
          .copyWith(alignment: BarChartAlignment.end)
          .calculateGroupsX(100),
      [55.0, 73.0, 91.0],
    );

    expect(
      MockData.barChartData1
          .copyWith(alignment: BarChartAlignment.center)
          .calculateGroupsX(100),
      [16.0, 50.0, 84.0],
    );

    expect(
      MockData.barChartData1
          .copyWith(alignment: BarChartAlignment.spaceBetween)
          .calculateGroupsX(100),
      [9.0, 50.0, 91.0],
    );

    expect(
      MockData.barChartData1
          .copyWith(alignment: BarChartAlignment.spaceAround)
          .calculateGroupsX(100),
      [16.666666666666668, 50.0, 83.33333333333334],
    );
  });
}
