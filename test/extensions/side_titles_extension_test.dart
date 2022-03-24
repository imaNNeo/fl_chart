import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/extensions/side_titles_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test totalReservedSize', () {
    expect(
      AxisTitles(
        axisNameWidget: null,
        axisNameSize: 12,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 20,
        ),
      ).totalReservedSize,
      20,
    );

    expect(
      AxisTitles(
        axisNameWidget: const Text('asdf'),
        axisNameSize: 12,
        sideTitles: SideTitles(
          showTitles: false,
          reservedSize: 20,
        ),
      ).totalReservedSize,
      12,
    );

    expect(
      AxisTitles(
        axisNameWidget: const Text('asdf'),
        axisNameSize: 12,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 20,
        ),
      ).totalReservedSize,
      32,
    );
  });
}
