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

  group('PieChartStackSegmentData', () {
    test('equality', () {
      final a = PieChartStackSegmentData(
        fromRadius: 10,
        toRadius: 30,
        color: Colors.red,
      );
      final b = PieChartStackSegmentData(
        fromRadius: 10,
        toRadius: 30,
        color: Colors.red,
      );
      expect(a == b, true);

      expect(
        a ==
            PieChartStackSegmentData(
              fromRadius: 20,
              toRadius: 30,
              color: Colors.red,
            ),
        false,
      );
      expect(
        a ==
            PieChartStackSegmentData(
              fromRadius: 10,
              toRadius: 40,
              color: Colors.red,
            ),
        false,
      );
      expect(
        a ==
            PieChartStackSegmentData(
              fromRadius: 10,
              toRadius: 30,
              color: Colors.blue,
            ),
        false,
      );
    });

    test('copyWith', () {
      final original = PieChartStackSegmentData(
        fromRadius: 10,
        toRadius: 40,
        color: Colors.red,
      );

      expect(original.copyWith() == original, true);

      expect(
        original.copyWith(fromRadius: 5) ==
            PieChartStackSegmentData(
              fromRadius: 5,
              toRadius: 40,
              color: Colors.red,
            ),
        true,
      );

      expect(
        original.copyWith(toRadius: 50) ==
            PieChartStackSegmentData(
              fromRadius: 10,
              toRadius: 50,
              color: Colors.red,
            ),
        true,
      );

      expect(
        original.copyWith(color: Colors.green) ==
            PieChartStackSegmentData(
              fromRadius: 10,
              toRadius: 40,
              color: Colors.green,
            ),
        true,
      );
    });

    test('lerp', () {
      final a = PieChartStackSegmentData(
        fromRadius: 0,
        toRadius: 20,
        color: const Color(0xFF000000),
      );
      final b = PieChartStackSegmentData(
        fromRadius: 40,
        toRadius: 80,
        color: const Color(0xFFFFFFFF),
      );

      final atZero = PieChartStackSegmentData.lerp(a, b, 0);
      expect(atZero.fromRadius, 0);
      expect(atZero.toRadius, 20);

      final atOne = PieChartStackSegmentData.lerp(a, b, 1);
      expect(atOne.fromRadius, 40);
      expect(atOne.toRadius, 80);

      final mid = PieChartStackSegmentData.lerp(a, b, 0.5);
      expect(mid.fromRadius, 20);
      expect(mid.toRadius, 50);
    });
  });
}
