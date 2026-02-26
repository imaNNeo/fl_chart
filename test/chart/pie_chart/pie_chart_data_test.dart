import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data_pool.dart';

void main() {
  group('PieChart data equality check', () {
    test('PieChartData equality test', () {
      expect(pieChartData1 == pieChartData1Clone, true);

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              borderData: FlBorderData(
                show: false,
                border: Border.all(),
              ),
            ),
        true,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              borderData: FlBorderData(
                show: true,
                border: Border.all(),
              ),
            ),
        false,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              startDegreeOffset: 33,
            ),
        false,
      );

      expect(
        pieChartData1 ==
            PieChartData(
              borderData: FlBorderData(
                show: false,
                border: Border.all(),
              ),
              startDegreeOffset: 0,
              centerSpaceColor: Colors.white,
              centerSpaceRadius: 12,
              pieTouchData: PieTouchData(
                enabled: false,
              ),
              sectionsSpace: 44,
            ),
        false,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              sections: [],
            ),
        false,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              sections: [
                PieChartSectionData(value: 12, color: Colors.red),
                PieChartSectionData(value: 22, color: Colors.green),
              ],
            ),
        true,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              sections: [
                PieChartSectionData(value: 12, color: Colors.red),
                PieChartSectionData(
                  value: 22,
                  color: Colors.green.withValues(alpha: 0.99),
                ),
              ],
            ),
        false,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              sections: [
                PieChartSectionData(value: 22, color: Colors.green),
                PieChartSectionData(value: 12, color: Colors.red),
              ],
            ),
        false,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              centerSpaceColor: Colors.cyan,
            ),
        false,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              centerSpaceRadius: 44,
            ),
        false,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              pieTouchData: PieTouchData(),
            ),
        false,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              sectionsSpace: 44.000001,
            ),
        false,
      );

      expect(
        pieChartData1 ==
            pieChartData1Clone.copyWith(
              titleSunbeamLayout: true,
            ),
        false,
      );
    });

    test('PieTouchData equality test', () {
      final sample1 = PieTouchData(
        touchCallback: (event, response) {},
        enabled: true,
      );
      final sample2 = PieTouchData(
        enabled: true,
      );

      expect(sample1 == sample2, false);

      final disabled = PieTouchData(
        enabled: false,
      );
      expect(sample1 == disabled, false);

      final zeroLongPressDuration = PieTouchData(
        enabled: true,
        longPressDuration: Duration.zero,
      );
      expect(sample1 == zeroLongPressDuration, false);
    });
  });

  group('PieChartSectionBorder', () {
    test('default constructor creates border with all sides none', () {
      const border = PieChartSectionBorder();
      expect(border.outer, BorderSide.none);
      expect(border.inner, BorderSide.none);
      expect(border.left, BorderSide.none);
      expect(border.right, BorderSide.none);
      expect(border.hasVisibleBorder, false);
    });

    test('.all constructor creates border with same side on all', () {
      const side = BorderSide(color: Colors.red, width: 2);
      const border = PieChartSectionBorder.all(side);
      expect(border.outer, side);
      expect(border.inner, side);
      expect(border.left, side);
      expect(border.right, side);
      expect(border.hasVisibleBorder, true);
    });

    test('.arcsOnly constructor creates border with only arcs', () {
      const side = BorderSide(color: Colors.blue, width: 3);
      const border = PieChartSectionBorder.arcsOnly(side);
      expect(border.outer, side);
      expect(border.inner, side);
      expect(border.left, BorderSide.none);
      expect(border.right, BorderSide.none);
      expect(border.hasVisibleBorder, true);
    });

    test('.outerOnly constructor creates border with only outer arc', () {
      const side = BorderSide(color: Colors.green, width: 1);
      const border = PieChartSectionBorder.outerOnly(side);
      expect(border.outer, side);
      expect(border.inner, BorderSide.none);
      expect(border.left, BorderSide.none);
      expect(border.right, BorderSide.none);
      expect(border.hasVisibleBorder, true);
    });

    test('hasVisibleBorder returns false for zero width', () {
      const border = PieChartSectionBorder(
        outer: BorderSide(color: Colors.red, width: 0),
      );
      expect(border.hasVisibleBorder, false);
    });

    test('hasVisibleBorder returns false for transparent color', () {
      const border = PieChartSectionBorder(
        outer: BorderSide(color: Colors.transparent, width: 2),
      );
      expect(border.hasVisibleBorder, false);
    });

    test('copyWith creates new instance with replaced values', () {
      const original = PieChartSectionBorder(
        outer: BorderSide(color: Colors.red, width: 1),
        inner: BorderSide(color: Colors.blue, width: 2),
      );
      final copied = original.copyWith(
        outer: const BorderSide(color: Colors.green, width: 3),
      );
      expect(copied.outer, const BorderSide(color: Colors.green, width: 3));
      expect(copied.inner, const BorderSide(color: Colors.blue, width: 2));
      expect(copied.left, BorderSide.none);
      expect(copied.right, BorderSide.none);
    });

    test('lerp interpolates between two borders', () {
      const a = PieChartSectionBorder(
        outer: BorderSide(color: Colors.red, width: 0),
      );
      const b = PieChartSectionBorder(
        outer: BorderSide(color: Colors.red, width: 10),
      );
      final result = PieChartSectionBorder.lerp(a, b, 0.5);
      expect(result.outer.width, 5);
    });

    test('equality check works correctly', () {
      const border1 = PieChartSectionBorder(
        outer: BorderSide(color: Colors.red, width: 2),
      );
      const border2 = PieChartSectionBorder(
        outer: BorderSide(color: Colors.red, width: 2),
      );
      const border3 = PieChartSectionBorder(
        outer: BorderSide(color: Colors.blue, width: 2),
      );
      expect(border1 == border2, true);
      expect(border1 == border3, false);
    });
  });

  group('PieChartSectionData with border', () {
    test('section with border has correct equality', () {
      final section1 = PieChartSectionData(
        value: 10,
        border: const PieChartSectionBorder.all(
          BorderSide(color: Colors.red, width: 2),
        ),
      );
      final section2 = PieChartSectionData(
        value: 10,
        border: const PieChartSectionBorder.all(
          BorderSide(color: Colors.red, width: 2),
        ),
      );
      final section3 = PieChartSectionData(
        value: 10,
        border: const PieChartSectionBorder.all(
          BorderSide(color: Colors.blue, width: 2),
        ),
      );
      expect(section1 == section2, true);
      expect(section1 == section3, false);
    });

    test('copyWith border works correctly', () {
      final section = PieChartSectionData(
        value: 10,
        border: const PieChartSectionBorder.all(
          BorderSide(color: Colors.red, width: 2),
        ),
      );
      final copied = section.copyWith(
        border: const PieChartSectionBorder.outerOnly(
          BorderSide(color: Colors.blue, width: 3),
        ),
      );
      expect(copied.border.outer.color, Colors.blue);
      expect(copied.border.outer.width, 3);
      expect(copied.border.inner, BorderSide.none);
    });

    test('lerp interpolates border correctly', () {
      final a = PieChartSectionData(
        value: 10,
        border: const PieChartSectionBorder(
          outer: BorderSide(color: Colors.red, width: 0),
        ),
      );
      final b = PieChartSectionData(
        value: 10,
        border: const PieChartSectionBorder(
          outer: BorderSide(color: Colors.red, width: 10),
        ),
      );
      final result = PieChartSectionData.lerp(a, b, 0.5);
      expect(result.border.outer.width, 5);
    });
  });
}
