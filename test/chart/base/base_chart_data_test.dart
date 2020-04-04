
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BaseChartData data equality check',() {

    BaseTouchResponse baseTouchResponse1 = BaseTouchResponse(
      FlPanStart(Offset.zero),
    );
    BaseTouchResponse baseTouchResponse2 = BaseTouchResponse(
      FlPanStart(Offset.zero),
    );

    FlTouchData touchData1 = FlTouchData(
      false,
    );
    FlTouchData touchData2 = FlTouchData(
      false,
    );

    FlBorderData borderData1 = FlBorderData(
      show: true,
      border: Border.all(color: Colors.green),
    );
    FlBorderData borderData2 = FlBorderData(
      show: true,
      border: Border.all(color: Colors.green),
    );

    test('FlBorderData equality test', () {

      expect(borderData1 == borderData2, true);

      expect(borderData1 == FlBorderData(
        show: false,
        border: Border.all(color: Colors.green),
      ), false);

      expect(borderData1 == FlBorderData(
        show: true,
        border: null,
      ), false);

    });

    test('FlTouchData equality test', () {

      expect(touchData1 == touchData2, true);

      expect(baseTouchResponse1 == FlTouchData(
        true,
      ), false);

    });

    test('BaseTouchResponse equality test', () {
      expect(baseTouchResponse1 == baseTouchResponse2, true);

      expect(baseTouchResponse1 == BaseTouchResponse(
        FlPanStart(Offset(0.0, 1.0)),
      ), false);

    });

  });

}