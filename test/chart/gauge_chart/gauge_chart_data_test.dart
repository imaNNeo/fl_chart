import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data_pool.dart';

// A dummy BaseChartData subtype used to trigger the negative branch
// in GaugeChartData.lerp when non-gauge BaseChartData instances are provided.
class _DummyData extends BaseChartData {
  _DummyData();

  @override
  BaseChartData lerp(BaseChartData a, BaseChartData b, double t) => this;
}

void main() {
  group('GaugeChart Data equality check', () {
    test('GaugeChartData equality test', () {
      /// object equality test
      expect(gaugeChartData1 == gaugeChartData1Clone, true);

      expect(
        gaugeChartData1 == gaugeChartData1Clone.copyWith(value: 0.5),
        false,
      );

      expect(
        gaugeChartData1 ==
            gaugeChartData1Clone.copyWith(backgroundColor: Colors.black),
        false,
      );

      expect(
        gaugeChartData1 ==
            gaugeChartData1Clone.copyWith(
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.green),
              ),
            ),
        true,
      );

      expect(
        gaugeChartData1 ==
            gaugeChartData1Clone.copyWith(
              ticks: const GaugeTicks(color: Colors.white),
            ),
        false,
      );

      expect(
        gaugeChartData1 ==
            gaugeChartData1Clone.copyWith(
              strokeCap: StrokeCap.square,
            ),
        false,
      );

      expect(
        gaugeChartData1 ==
            gaugeChartData1Clone.copyWith(gaugeTouchData: gaugeTouchData2),
        false,
      );

      expect(
        gaugeChartData1 == gaugeChartData1Clone.copyWith(startAngle: 0),
        false,
      );

      expect(
        gaugeChartData1 == gaugeChartData1Clone.copyWith(endAngle: 0),
        false,
      );

      expect(
        gaugeChartData1 == gaugeChartData1Clone.copyWith(strokeWidth: 7),
        false,
      );

      expect(
        gaugeChartData1 ==
            gaugeChartData1Clone.copyWith(valueColor: gaugeColor2),
        false,
      );
    });

    test('GaugeColor equality test', () {
      expect(gaugeColor1 == const SimpleGaugeColor(color: Colors.black), true);
      expect(gaugeColor1 == const SimpleGaugeColor(color: Colors.red), false);

      expect(
        gaugeColor2 ==
            VariableGaugeColor(
              limits: [0.1, 0.5],
              colors: [Colors.red, Colors.red, Colors.red],
            ),
        true,
      );

      expect(
        gaugeColor2 ==
            VariableGaugeColor(
              limits: [0.2, 0.5],
              colors: [Colors.red, Colors.red, Colors.red],
            ),
        false,
      );

      expect(
        gaugeColor2 ==
            VariableGaugeColor(
              limits: [0.1, 0.5],
              colors: [Colors.blue, Colors.red, Colors.red],
            ),
        false,
      );

      expect(
        gaugeColor2 ==
            VariableGaugeColor(
              limits: [0.1, 0.5, 0.6],
              colors: [Colors.red, Colors.red, Colors.red, Colors.red],
            ),
        false,
      );
    });

    test('GaugeTicks equality test', () {
      expect(
        gaugeTicks1 ==
            const GaugeTicks(
              color: Colors.blue,
              count: 4,
              margin: 7,
              position: GaugeTickPosition.center,
              radius: 4,
              showChangingColorTicks: false,
            ),
        true,
      );

      expect(
        gaugeTicks1 ==
            const GaugeTicks(
              color: Colors.red,
              count: 4,
              margin: 7,
              position: GaugeTickPosition.center,
              radius: 4,
              showChangingColorTicks: false,
            ),
        false,
      );

      expect(
        gaugeTicks1 ==
            const GaugeTicks(
              color: Colors.blue,
              count: 5,
              margin: 7,
              position: GaugeTickPosition.center,
              radius: 4,
              showChangingColorTicks: false,
            ),
        false,
      );

      expect(
        gaugeTicks1 ==
            const GaugeTicks(
              color: Colors.blue,
              count: 4,
              margin: 8,
              position: GaugeTickPosition.center,
              radius: 4,
              showChangingColorTicks: false,
            ),
        false,
      );

      expect(
        gaugeTicks1 ==
            const GaugeTicks(
              color: Colors.blue,
              count: 4,
              margin: 7,
              position: GaugeTickPosition.inner,
              radius: 4,
              showChangingColorTicks: false,
            ),
        false,
      );

      expect(
        gaugeTicks1 ==
            const GaugeTicks(
              color: Colors.blue,
              count: 4,
              margin: 7,
              position: GaugeTickPosition.center,
              radius: 1,
              showChangingColorTicks: false,
            ),
        false,
      );

      expect(
        gaugeTicks1 ==
            const GaugeTicks(
              color: Colors.blue,
              count: 4,
              margin: 7,
              position: GaugeTickPosition.center,
              radius: 4,
            ),
        false,
      );
    });

    test('GaugeTouchData equality test', () {
      expect(gaugeTouchData1 == gaugeTouchData1Clone, true);

      expect(gaugeTouchData1 == gaugeTouchData2, false);

      expect(
        gaugeTouchData1 ==
            GaugeTouchData(
              enabled: true,
              touchCallback: (_, __) {},
            ),
        false,
      );

      expect(
        gaugeTouchData1 ==
            GaugeTouchData(
              enabled: true,
              mouseCursorResolver: (_, __) => MouseCursor.uncontrolled,
            ),
        false,
      );

      expect(
        gaugeTouchData1 ==
            GaugeTouchData(
              enabled: true,
              longPressDuration: Duration.zero,
            ),
        false,
      );

      expect(
        gaugeTouchData1 ==
            GaugeTouchData(
              enabled: true,
              touchCallback: (_, __) {},
              mouseCursorResolver: (_, __) => MouseCursor.uncontrolled,
              longPressDuration: Duration.zero,
            ),
        false,
      );
    });

    test('GaugeTouchedSpot equality test', () {
      expect(gaugeTouchedSpot1 == gaugeTouchedSpotClone1, true);
      expect(gaugeTouchedSpot1 == gaugeTouchedSpot2, false);
      expect(gaugeTouchedSpot1 == gaugeTouchedSpot3, false);
    });

    test('GaugeChartDataTween lerp', () {
      final a = GaugeChartData(
        value: 0.7,
        strokeWidth: 5,
        startAngle: 0,
        endAngle: 270,
        valueColor: const SimpleGaugeColor(color: MockData.color0),
        backgroundColor: MockData.color0,
        strokeCap: StrokeCap.round,
        ticks: const GaugeTicks(
          color: MockData.color0,
          count: 5,
          margin: 7,
          position: GaugeTickPosition.center,
          radius: 7,
          showChangingColorTicks: false,
        ),
        touchData: GaugeTouchData(
          enabled: true,
          touchCallback: (_, __) {},
          longPressDuration: const Duration(seconds: 7),
          mouseCursorResolver: (_, __) => MouseCursor.defer,
        ),
      );

      final b = GaugeChartData(
        value: 0.3,
        strokeWidth: 3,
        startAngle: 20,
        endAngle: 250,
        valueColor: VariableGaugeColor(
          limits: [0.4],
          colors: [MockData.color0, MockData.color2],
        ),
        backgroundColor: MockData.color2,
        strokeCap: StrokeCap.square,
        ticks: const GaugeTicks(
          color: MockData.color2,
          count: 7,
          margin: 9,
          position: GaugeTickPosition.inner,
          radius: 5,
        ),
        touchData: GaugeTouchData(
          enabled: true,
          touchCallback: (_, __) {},
          longPressDuration: const Duration(seconds: 7),
          mouseCursorResolver: (_, __) => MouseCursor.defer,
        ),
      );

      final data = GaugeChartDataTween(begin: a, end: b).lerp(0.5);

      expect(data.value, 0.5);
      expect(data.strokeWidth, 4);
      expect(data.startAngle, 10);
      expect(data.endAngle, 260);
      expect(data.valueColor.getColor(0.5), MockData.color1);
      expect(data.valueColor.getColor(0.5), MockData.color1);
      final colorTicks =
          (data.valueColor as ColoredTicksGenerator).getColoredTicks().toList();
      expect(
        colorTicks,
        [ColoredTick(0.4, MockData.color2.withValues(alpha: 0.5))],
      );
      expect(data.strokeCap, StrokeCap.square);
      expect(data.ticks?.color, MockData.color1);
      expect(data.ticks?.count, 6);
      expect(data.ticks?.margin, 8);
      expect(data.ticks?.position, GaugeTickPosition.inner);
      expect(data.ticks?.radius, 6);
      expect(data.ticks?.showChangingColorTicks, true);
      expect(data.gaugeTouchData, b.gaugeTouchData);
    });

    test('GaugeColor lerp', () {
      final a = VariableGaugeColor(
        limits: [0.2, 0.5, 0.7],
        colors: [
          MockData.color0,
          MockData.color1,
          MockData.color2,
          MockData.color3,
        ],
      );
      final b = VariableGaugeColor(
        limits: [0.3, 0.6, 0.8],
        colors: [
          MockData.color6,
          MockData.color5,
          MockData.color4,
          MockData.color3,
        ],
      );
      final color = GaugeColor.lerp(a, b, 0.2);

      expect(color is ColoredTicksGenerator, true);
      final generator = color as ColoredTicksGenerator;
      final ticks = generator.getColoredTicks().toList();
      expect(ticks, [
        ColoredTick(0.2, MockData.color1.withValues(alpha: 0.8)),
        ColoredTick(0.5, MockData.color2.withValues(alpha: 0.8)),
        ColoredTick(0.7, MockData.color3.withValues(alpha: 0.8)),
        ColoredTick(0.3, MockData.color5.withValues(alpha: 0.2)),
        ColoredTick(0.6, MockData.color4.withValues(alpha: 0.2)),
        ColoredTick(0.8, MockData.color3.withValues(alpha: 0.2)),
      ]);
    });

    test('GaugeChartData.lerp throws on illegal state', () {
      final gauge = GaugeChartData(
        value: 0.5,
        strokeWidth: 4,
        startAngle: 0,
        endAngle: 180,
        valueColor: const SimpleGaugeColor(color: MockData.color0),
      );

      expect(
        () => gauge.lerp(_DummyData(), _DummyData(), 0.3),
        throwsA(isA<Exception>()),
      );
    });

    test('GaugeTouchResponse.copyWith', () {
      final initialSpot =
          GaugeTouchedSpot(const FlSpot(1, 2), const Offset(3, 4));
      final response = GaugeTouchResponse(
        touchLocation: const Offset(10, 20),
        touchedSpot: initialSpot,
      );

      final same = response.copyWith();
      expect(same.touchLocation, response.touchLocation);
      expect(same.touchedSpot, response.touchedSpot);

      final newSpot = GaugeTouchedSpot(const FlSpot(5, 6), const Offset(7, 8));
      final updated = response.copyWith(
        touchLocation: const Offset(30, 40),
        touchedSpot: newSpot,
      );
      expect(updated.touchLocation, const Offset(30, 40));
      expect(updated.touchedSpot, newSpot);
    });
  });
}
