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

    test('HatchPattern equality test', () {
      const pattern1 = HatchPattern(hatchColor: Colors.red);
      const pattern1Clone = HatchPattern(hatchColor: Colors.red);
      const pattern2 = HatchPattern(
        hatchColor: Colors.blue,
        spacing: 8.0,
        angle: -60.0,
      );
      const pattern3 = HatchPattern(
        hatchColor: Colors.red,
        backgroundColor: Colors.white,
      );

      expect(pattern1 == pattern1Clone, true);
      expect(pattern1 == pattern2, false);
      expect(pattern1 == pattern3, false);
      expect(pattern2 == pattern3, false);
    });

    test('HatchPattern default values test', () {
      const pattern = HatchPattern(hatchColor: Colors.red);
      
      expect(pattern.spacing, 6.0);
      expect(pattern.angle, -45.0);
      expect(pattern.strokeWidth, 1.0);
      expect(pattern.hatchColor, Colors.red);
      expect(pattern.backgroundColor, null);
    });

    test('HatchPattern copyWith test', () {
      const original = HatchPattern(
        hatchColor: Colors.red,
        spacing: 8.0,
        angle: -30.0,
        strokeWidth: 2.0,
        backgroundColor: Colors.white,
      );

      final copied = original.copyWith(
        hatchColor: Colors.blue,
        spacing: 4.0,
      );

      expect(copied.hatchColor, Colors.blue);
      expect(copied.spacing, 4.0);
      expect(copied.angle, -30.0); // unchanged
      expect(copied.strokeWidth, 2.0); // unchanged
      expect(copied.backgroundColor, Colors.white); // unchanged
    });

    test('HatchPattern lerp test', () {
      const patternA = HatchPattern(
        hatchColor: Colors.red,
        spacing: 4.0,
        angle: -30.0,
        strokeWidth: 1.0,
      );
      const patternB = HatchPattern(
        hatchColor: Colors.blue,
        spacing: 8.0,
        angle: -60.0,
        strokeWidth: 3.0,
      );

      final lerped = HatchPattern.lerp(patternA, patternB, 0.5);
      
      expect(lerped.spacing, 6.0);
      expect(lerped.angle, -45.0);
      expect(lerped.strokeWidth, 2.0);
      // Color lerping is handled by Flutter's Color.lerp
      expect(lerped.hatchColor, Color.lerp(Colors.red, Colors.blue, 0.5));
    });

    test('BarChartRodStackItem with hatching equality test', () {
      const hatchPattern = HatchPattern(hatchColor: Colors.red);
      
      final stackItem1 = BarChartRodStackItem(
        0,
        5,
        null,
        isHatched: true,
        hatchPattern: hatchPattern,
      );
      
      final stackItem1Clone = BarChartRodStackItem(
        0,
        5,
        null,
        isHatched: true,
        hatchPattern: hatchPattern,
      );
      
      final stackItem2 = BarChartRodStackItem(
        0,
        5,
        Colors.blue,
        isHatched: false,
      );

      expect(stackItem1 == stackItem1Clone, true);
      expect(stackItem1 == stackItem2, false);
    });

    test('BarChartRodStackItem hatching copyWith test', () {
      const hatchPattern1 = HatchPattern(hatchColor: Colors.red);
      const hatchPattern2 = HatchPattern(hatchColor: Colors.blue);
      
      final original = BarChartRodStackItem(
        0,
        5,
        null,
        isHatched: true,
        hatchPattern: hatchPattern1,
      );

      final copied = original.copyWith(
        color: Colors.green,
        isHatched: false,
        hatchPattern: hatchPattern2,
      );

      expect(copied.isHatched, false);
      expect(copied.hatchPattern, hatchPattern2);
      expect(copied.fromY, 0); // unchanged
      expect(copied.toY, 5); // unchanged
    });

    test('BarChartRodStackItem hatching lerp test', () {
      const hatchPattern1 = HatchPattern(
        hatchColor: Colors.red,
        spacing: 4.0,
      );
      const hatchPattern2 = HatchPattern(
        hatchColor: Colors.blue,
        spacing: 8.0,
      );
      
      final stackItemA = BarChartRodStackItem(
        0,
        5,
        null,
        isHatched: true,
        hatchPattern: hatchPattern1,
      );
      
      final stackItemB = BarChartRodStackItem(
        2,
        7,
        null,
        isHatched: true,
        hatchPattern: hatchPattern2,
      );

      final lerped = BarChartRodStackItem.lerp(stackItemA, stackItemB, 0.5);

      expect(lerped.fromY, 1.0);
      expect(lerped.toY, 6.0);
      expect(lerped.isHatched, true);
      expect(lerped.hatchPattern?.spacing, 6.0);
      expect(lerped.hatchPattern?.hatchColor, Color.lerp(Colors.red, Colors.blue, 0.5));
    });

    test('HatchPattern validation test', () {
      // Valid pattern should not throw
      expect(
        () => const HatchPattern(hatchColor: Colors.red, spacing: 1.0),
        returnsNormally,
      );

      // Invalid spacing should throw assertion error
      expect(
        () => HatchPattern(hatchColor: Colors.red, spacing: 0.0),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => HatchPattern(hatchColor: Colors.red, spacing: -1.0),
        throwsA(isA<AssertionError>()),
      );

      // Invalid stroke width should throw assertion error
      expect(
        () => HatchPattern(hatchColor: Colors.red, strokeWidth: -1.0),
        throwsA(isA<AssertionError>()),
      );

      // Zero stroke width should be allowed (invisible lines)
      expect(
        () => const HatchPattern(hatchColor: Colors.red, strokeWidth: 0.0),
        returnsNormally,
      );
    });
  });
}
