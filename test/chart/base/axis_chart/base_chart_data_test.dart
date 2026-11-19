import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../data_pool.dart';

void main() {
  group('BaseChartData data equality check', () {
    test('FlBorderData equality test', () {
      expect(borderData1 == borderData1Clone, true);

      expect(
        borderData1 ==
            FlBorderData(
              show: false,
              border: Border.all(color: Colors.green),
            ),
        false,
      );

      expect(
        borderData1 ==
            FlBorderData(
              show: true,
            ),
        false,
      );
    });
  });

  group('FlBorderData dashArray', () {
    test('equality takes dashArray into account', () {
      expect(
        FlBorderData(dashArray: const [4, 2]) ==
            FlBorderData(dashArray: const [4, 2]),
        true,
      );
      expect(
        FlBorderData(dashArray: const [4, 2]) == FlBorderData(),
        false,
      );
    });

    test('copyWith replaces dashArray', () {
      final data = FlBorderData(dashArray: const [4, 2]);

      expect(data.copyWith().dashArray, const [4, 2]);
      expect(data.copyWith(dashArray: const [8, 4]).dashArray, const [8, 4]);
    });

    test('lerp interpolates dashArray', () {
      final a = FlBorderData(dashArray: const [0, 0]);
      final b = FlBorderData(dashArray: const [10, 10]);

      expect(FlBorderData.lerp(a, b, 0.5).dashArray, const [5, 5]);
    });
  });
}
