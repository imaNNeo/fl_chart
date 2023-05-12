import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/extensions/side_titles_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test totalReservedWidth', () {
    expect(
      const AxisTitles(
        axisNameSize: 12,
        sideTitles: SideTitles(
          showTitles: true,
          reservedWidth: 20,
        ),
      ).totalReservedWidth,
      20,
    );

    expect(
      const AxisTitles(
        axisNameWidget: Text('asdf'),
        axisNameSize: 12,
        sideTitles: SideTitles(
          reservedWidth: 20,
        ),
      ).totalReservedWidth,
      12,
    );

    expect(
      const AxisTitles(
        axisNameWidget: Text('asdf'),
        axisNameSize: 12,
        sideTitles: SideTitles(
          showTitles: true,
          reservedWidth: 20,
        ),
      ).totalReservedWidth,
      32,
    );
  });
  test('test totalReservedHeight', () {
    expect(
      const AxisTitles(
        axisNameSize: 12,
        sideTitles: SideTitles(
          showTitles: true,
          reservedHeight: 20,
        ),
      ).totalReservedHeight,
      20,
    );

    expect(
      const AxisTitles(
        axisNameWidget: Text('asdf'),
        axisNameSize: 12,
        sideTitles: SideTitles(
          reservedHeight: 20,
        ),
      ).totalReservedHeight,
      12,
    );

    expect(
      const AxisTitles(
        axisNameWidget: Text('asdf'),
        axisNameSize: 12,
        sideTitles: SideTitles(
          showTitles: true,
          reservedHeight: 20,
        ),
      ).totalReservedHeight,
      32,
    );
  });
}
