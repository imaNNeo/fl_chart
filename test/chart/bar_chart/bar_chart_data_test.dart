import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data_pool.dart';

void main() {
  group('BarChart data equality check', () {
    test('BarChartGroupData equality test', () {
      expect(barChartGroupData1 == barChartGroupData1Clone, true);
      expect(barChartGroupData1 == barChartGroupData2, false);
      expect(barChartGroupData1 == barChartGroupData3, false);
      expect(barChartGroupData1 == barChartGroupData4, false);
      expect(barChartGroupData1 == barChartGroupData5, false);
      expect(barChartGroupData1 == barChartGroupData6, false);
      expect(barChartGroupData1 == barChartGroupData7, false);
      expect(barChartGroupData1 == barChartGroupData8, false);
      expect(barChartGroupData1 == barChartGroupData9, false);
    });

    test('BarChartRodData equality test', () {
      expect(barChartRodData1 == barChartRodData1Clone, true);
      expect(barChartRodData1 == barChartRodData2, false);
      expect(barChartRodData1 == barChartRodData3, false);
      expect(barChartRodData1 == barChartRodData4, false);
      expect(barChartRodData1 == barChartRodData5, false);
      expect(barChartRodData1 == barChartRodData6, false);
      expect(barChartRodData1 == barChartRodData7, false);
      expect(barChartRodData1 == barChartRodData8, false);
    });

    test('BarChartRodData copyWith borderDashArray', () {
      final base = BarChartRodData(toY: 10, borderDashArray: [4, 4]);

      final unchanged = base.copyWith(toY: 20);
      expect(unchanged.borderDashArray, [4, 4]);

      final changed = base.copyWith(borderDashArray: [2, 8]);
      expect(changed.borderDashArray, [2, 8]);

      final noArray = BarChartRodData(toY: 10);
      final withArray = noArray.copyWith(borderDashArray: [6, 2]);
      expect(withArray.borderDashArray, [6, 2]);
    });

    test('BarChartRodStackItem equality test', () {
      expect(barChartRodStackItem1 == barChartRodStackItem1Clone, true);
      expect(
        barChartRodStackItem1 == barChartRodStackItem1Clone.copyWith(fromY: 2),
        false,
      );
      expect(
        barChartRodStackItem1 == barChartRodStackItem1Clone.copyWith(toY: 2),
        true,
      );
      expect(
        barChartRodStackItem1 == barChartRodStackItem1Clone.copyWith(toY: 3),
        false,
      );
      expect(
        barChartRodStackItem1 ==
            barChartRodStackItem1Clone.copyWith(color: Colors.red),
        false,
      );
      expect(
        barChartRodStackItem1 ==
            barChartRodStackItem1Clone.copyWith(color: Colors.green),
        true,
      );
      expect(barChartRodStackItem1 == barChartRodStackItem2, false);
      expect(barChartRodStackItem1 == barChartRodStackItem3, false);
      expect(barChartRodStackItem2 == barChartRodStackItem4, false);
    });

    test('BackgroundBarChartRodData equality test', () {
      expect(
        backgroundBarChartRodData1 == backgroundBarChartRodData1Clone,
        true,
      );
      expect(backgroundBarChartRodData1 == backgroundBarChartRodData2, false);
      expect(backgroundBarChartRodData2 == backgroundBarChartRodData3, false);

      final changed = BackgroundBarChartRodData(
        toY: 21,
        color: Colors.blue,
        show: false,
      );

      expect(backgroundBarChartRodData1 == changed, false);

      final changed2 = BackgroundBarChartRodData(
        toY: 22,
        color: Colors.blue,
        show: true,
      );

      expect(backgroundBarChartRodData1 == changed2, false);
    });

    test('BarTouchData equality test', () {
      expect(barTouchData1 == barTouchData1Clone, true);
      expect(barTouchData1 == barTouchData2, false);
      expect(barTouchData1 == barTouchData3, false);
      expect(barTouchData1 == barTouchData4, false);
      expect(barTouchData1 == barTouchData5, false);
      expect(barTouchData1 == barTouchData6, false);
      expect(barTouchData1 == barTouchData7, false);
      expect(barTouchData1 == barTouchData8, false);
      expect(barTouchData1 == barTouchData9, false);
      expect(barTouchData1 == barTouchData10, false);
    });

    test('BarTouchTooltipData equality test', () {
      expect(barTouchTooltipData1 == barTouchTooltipData1Clone, true);
      expect(barTouchTooltipData1 == barTouchTooltipData2, false);
      expect(barTouchTooltipData1 == barTouchTooltipData3, false);
      expect(barTouchTooltipData1 == barTouchTooltipData4, false);
      expect(barTouchTooltipData1 == barTouchTooltipData5, false);
      expect(barTouchTooltipData1 == barTouchTooltipData6, false);
      expect(barTouchTooltipData1 == barTouchTooltipData7, false);
      expect(barTouchTooltipData1 == barTouchTooltipData8, false);
      expect(barTouchTooltipData1 == barTouchTooltipData9, false);
      expect(barTouchTooltipData1 == barTouchTooltipData10, false);
      expect(barTouchTooltipData1 == barTouchTooltipData11, false);
    });

    test('BarTouchTooltipData direction in props', () {
      const base = BarTouchTooltipData(direction: TooltipDirection.auto);
      const different = BarTouchTooltipData(direction: TooltipDirection.bottom);
      expect(base == different, false);
    });

    test('BarTouchTooltipData copyWith', () {
      const base = BarTouchTooltipData(
        tooltipMargin: 8,
        direction: TooltipDirection.top,
      );

      final unchanged = base.copyWith(maxContentWidth: 200);
      expect(unchanged.tooltipMargin, 8);
      expect(unchanged.direction, TooltipDirection.top);

      final changed = base.copyWith(
        tooltipMargin: 24,
        direction: TooltipDirection.bottom,
      );
      expect(changed.tooltipMargin, 24);
      expect(changed.direction, TooltipDirection.bottom);
    });

    test('BarTooltipItem equality test', () {
      expect(barTooltipItem1 == barTooltipItem1Clone, true);
      expect(barTooltipItem1 == barTooltipItem2, false);
      expect(barTooltipItem1 == barTooltipItem3, false);
      expect(barTooltipItem1 == barTooltipItem4, false);
      expect(barTooltipItem1 == barTooltipItem5, false);
    });

    test('BarTouchedSpot equality test', () {
      expect(barTouchedSpot1 == barTouchedSpot1Clone, true);
      expect(barTouchedSpot1 == barTouchedSpot2, false);
      expect(barTouchedSpot1 == barTouchedSpot3, false);
      expect(barTouchedSpot1 == barTouchedSpot4, false);
      expect(barTouchedSpot1 == barTouchedSpot5, false);
      expect(barTouchedSpot1 == barTouchedSpot6, false);
      expect(barTouchedSpot1 == barTouchedSpot7, false);
    });

    test('BarChartData equality test', () {
      expect(barChartData1 == barChartData1Clone, true);
      expect(barChartData1 == barChartData2, false);
      expect(barChartData1 == barChartData3, false);
      expect(barChartData1 == barChartData4, false);
      expect(barChartData1 == barChartData5, false);
      expect(barChartData1 == barChartData6, false);
      expect(barChartData1 == barChartData7, false);
      expect(barChartData1 == barChartData8, false);
      expect(barChartData1 == barChartData9, false);
      expect(barChartData1 == barChartData10, false);
      expect(barChartData1 == barChartData11, false);
      expect(barChartData1 == barChartData12, false);
      expect(barChartData1 == barChartData13, false);
      expect(barChartData1 == barChartData14, false);
      expect(barChartData1 == barChartData15, false);
    });
  });
}
