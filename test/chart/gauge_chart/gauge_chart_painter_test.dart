import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/gauge_chart/gauge_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../data_pool.dart';
import 'gauge_chart_painter_test.mocks.dart';

@GenerateMocks([Canvas, CanvasWrapper, BuildContext, Utils])
void main() {
  final utilsMainInstance = Utils();
  group('paint()', () {
    test('test 1', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        startAngle: 0,
        endAngle: 90,
        valueColor: const SimpleGaugeColor(color: Colors.red),
        strokeWidth: 2,
        value: 0.5,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.radians(any)).thenAnswer((realInvocation) => 0);
      when(mockUtils.degrees(any)).thenAnswer((realInvocation) => 0);

      final mockBuildContext = MockBuildContext();
      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      gaugePainter.paint(
        mockBuildContext,
        mockCanvasWrapper,
        holder,
      );

      verify(mockCanvasWrapper.drawArc(any, any, any, any, any)).called(1);
      Utils.changeInstance(utilsMainInstance);
    });
  });

  group('drawValue()', () {
    test('only value', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        startAngle: 0,
        endAngle: 90,
        valueColor: const SimpleGaugeColor(color: MockData.color0),
        strokeWidth: 2,
        value: 0.5,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.radians(any)).thenAnswer(
        (realInvocation) => realInvocation.positionalArguments[0] as double,
      );

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      final drawArcResults = <Map<String, dynamic>>[];
      when(
        mockCanvasWrapper.drawArc(
          captureAny,
          captureAny,
          captureAny,
          captureAny,
          captureAny,
        ),
      ).thenAnswer((inv) {
        drawArcResults.add({
          'rect': inv.positionalArguments[0] as Rect,
          'start_angle': inv.positionalArguments[1] as double,
          'sweep_angle': inv.positionalArguments[2] as double,
          'use_center': inv.positionalArguments[3] as bool,
          'paint_color': (inv.positionalArguments[4] as Paint).color,
          'paint_stroke_width':
              (inv.positionalArguments[4] as Paint).strokeWidth,
          'paint_stroke_cap': (inv.positionalArguments[4] as Paint).strokeCap,
        });
      });

      gaugePainter.drawValue(mockCanvasWrapper, holder);

      expect(drawArcResults.length, 1);

      expect(
        drawArcResults[0]['rect'],
        Rect.fromCircle(
          center: const Offset(200, 200),
          radius: 200 - data.strokeWidth / 2,
        ),
      );
      expect(drawArcResults[0]['start_angle'], 0);
      expect(
        drawArcResults[0]['sweep_angle'],
        45,
      ); // (endAngle - startAngle) * value
      expect(drawArcResults[0]['use_center'], false);
      expect(drawArcResults[0]['paint_color'], MockData.color0);
      expect(drawArcResults[0]['paint_stroke_width'], data.strokeWidth);
      expect(drawArcResults[0]['paint_stroke_cap'], data.strokeCap);

      Utils.changeInstance(utilsMainInstance);
    });

    test('with background', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        startAngle: 0,
        endAngle: 90,
        valueColor: const SimpleGaugeColor(color: MockData.color0),
        strokeWidth: 2,
        value: 0.5,
        backgroundColor: MockData.color1,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.radians(any)).thenAnswer(
        (realInvocation) => realInvocation.positionalArguments[0] as double,
      );

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      final drawArcResults = <Map<String, dynamic>>[];
      when(
        mockCanvasWrapper.drawArc(
          captureAny,
          captureAny,
          captureAny,
          captureAny,
          captureAny,
        ),
      ).thenAnswer((inv) {
        drawArcResults.add({
          'rect': inv.positionalArguments[0] as Rect,
          'start_angle': inv.positionalArguments[1] as double,
          'sweep_angle': inv.positionalArguments[2] as double,
          'use_center': inv.positionalArguments[3] as bool,
          'paint_color': (inv.positionalArguments[4] as Paint).color,
          'paint_stroke_width':
              (inv.positionalArguments[4] as Paint).strokeWidth,
          'paint_stroke_cap': (inv.positionalArguments[4] as Paint).strokeCap,
        });
      });

      gaugePainter.drawValue(mockCanvasWrapper, holder);

      expect(drawArcResults.length, 2);

      // background
      expect(
        drawArcResults[1]['rect'],
        Rect.fromCircle(
          center: const Offset(200, 200),
          radius: 200 - data.strokeWidth / 2,
        ),
      );
      expect(drawArcResults[0]['start_angle'], 0);
      expect(
        drawArcResults[0]['sweep_angle'],
        90,
      );
      expect(drawArcResults[0]['use_center'], false);
      expect(drawArcResults[0]['paint_color'], isSameColorAs(MockData.color1));
      expect(drawArcResults[0]['paint_stroke_width'], data.strokeWidth);
      expect(drawArcResults[0]['paint_stroke_cap'], data.strokeCap);

      // value
      expect(
        drawArcResults[1]['rect'],
        Rect.fromCircle(
          center: const Offset(200, 200),
          radius: 200 - data.strokeWidth / 2,
        ),
      );
      expect(drawArcResults[1]['start_angle'], 0);
      expect(
        drawArcResults[1]['sweep_angle'],
        45,
      ); // (endAngle - startAngle) * value
      expect(drawArcResults[1]['use_center'], false);
      expect(drawArcResults[1]['paint_color'], MockData.color0);
      expect(drawArcResults[1]['paint_stroke_width'], data.strokeWidth);
      expect(drawArcResults[1]['paint_stroke_cap'], data.strokeCap);

      Utils.changeInstance(utilsMainInstance);
    });
  });

  group('drawTicks()', () {
    test('ticks without changing color ticks', () {
      const viewSize = Size(400, 400);
      const gaugeTicks = GaugeTicks(
        count: 5,
        color: MockData.color0,
        radius: 4,
        showChangingColorTicks: false,
        position: GaugeTickPosition.center,
        margin: 5,
      );
      final data = GaugeChartData(
        startAngle: 0,
        endAngle: 90,
        valueColor: const SimpleGaugeColor(color: MockData.color0),
        strokeWidth: 2,
        value: 0.5,
        ticks: gaugeTicks,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.radians(any)).thenAnswer(
        (realInvocation) => realInvocation.positionalArguments[0] as double,
      );

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      final drawCircleResults = <Map<String, dynamic>>[];
      when(
        mockCanvasWrapper.drawCircle(captureAny, captureAny, captureAny),
      ).thenAnswer((inv) {
        drawCircleResults.add({
          'offset': inv.positionalArguments[0] as Offset,
          'radius': inv.positionalArguments[1] as double,
          'paint_color': (inv.positionalArguments[2] as Paint).color,
        });
      });

      gaugePainter.drawTicks(mockCanvasWrapper, holder);

      expect(drawCircleResults.length, 5);

      final radius = 200 - data.strokeWidth / 2;
      final angle = Utils().radians(90 / 4);
      for (var i = 0; i < drawCircleResults.length; i++) {
        final tickX = 200 + cos(angle * i) * radius;
        final tickY = 200 + sin(angle * i) * radius;

        expect(drawCircleResults[i]['offset'], Offset(tickX, tickY));
        expect(drawCircleResults[i]['radius'], gaugeTicks.radius);
        expect(drawCircleResults[i]['paint_color'], gaugeTicks.color);
      }

      Utils.changeInstance(utilsMainInstance);
    });

    test('ticks with inner position', () {
      const viewSize = Size(400, 400);
      const gaugeTicks = GaugeTicks(
        count: 5,
        color: MockData.color0,
        radius: 4,
        showChangingColorTicks: false,
        position: GaugeTickPosition.inner,
        margin: 5,
      );
      final data = GaugeChartData(
        startAngle: 0,
        endAngle: 90,
        valueColor: const SimpleGaugeColor(color: MockData.color0),
        strokeWidth: 2,
        value: 0.5,
        ticks: gaugeTicks,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.radians(any)).thenAnswer(
        (realInvocation) => realInvocation.positionalArguments[0] as double,
      );

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      final drawCircleResults = <Map<String, dynamic>>[];
      when(
        mockCanvasWrapper.drawCircle(captureAny, captureAny, captureAny),
      ).thenAnswer((inv) {
        drawCircleResults.add({
          'offset': inv.positionalArguments[0] as Offset,
          'radius': inv.positionalArguments[1] as double,
          'paint_color': (inv.positionalArguments[2] as Paint).color,
        });
      });

      gaugePainter.drawTicks(mockCanvasWrapper, holder);

      expect(drawCircleResults.length, 5);

      // positionRadius = gaugeRadius - strokeWidth - tick.radius - tick.margin
      final positionRadius =
          200 - data.strokeWidth - gaugeTicks.radius - gaugeTicks.margin;
      final angle = Utils().radians(90 / 4);
      for (var i = 0; i < drawCircleResults.length; i++) {
        final tickX = 200 + cos(angle * i) * positionRadius;
        final tickY = 200 + sin(angle * i) * positionRadius;

        expect(drawCircleResults[i]['offset'], Offset(tickX, tickY));
        expect(drawCircleResults[i]['radius'], gaugeTicks.radius);
        expect(drawCircleResults[i]['paint_color'], gaugeTicks.color);
      }

      Utils.changeInstance(utilsMainInstance);
    });

    test('ticks with changing color ticks', () {
      const viewSize = Size(400, 400);
      const gaugeTicks = GaugeTicks(
        count: 5,
        color: MockData.color0,
        radius: 4,
        position: GaugeTickPosition.center,
        margin: 5,
      );
      final gaugeColor = VariableGaugeColor(
        limits: [0.3, 0.5, 0.8],
        colors: [
          MockData.color0,
          MockData.color1,
          MockData.color2,
          MockData.color3,
        ],
      );
      final data = GaugeChartData(
        startAngle: 0,
        endAngle: 270,
        valueColor: gaugeColor,
        strokeWidth: 2,
        value: 0.5,
        ticks: gaugeTicks,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.radians(any)).thenAnswer(
        (realInvocation) => realInvocation.positionalArguments[0] as double,
      );

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      final drawCircleResults = <Map<String, dynamic>>[];
      when(
        mockCanvasWrapper.drawCircle(captureAny, captureAny, captureAny),
      ).thenAnswer((inv) {
        drawCircleResults.add({
          'offset': inv.positionalArguments[0] as Offset,
          'radius': inv.positionalArguments[1] as double,
          'paint_color': (inv.positionalArguments[2] as Paint).color,
        });
      });

      gaugePainter.drawTicks(mockCanvasWrapper, holder);

      expect(drawCircleResults.length, 5 + 3);

      final radius = 200 - data.strokeWidth / 2;
      final angle = Utils().radians(270 / 4);
      for (var i = 0; i < 5; i++) {
        final tickX = 200 + cos(angle * i) * radius;
        final tickY = 200 + sin(angle * i) * radius;

        expect(
          drawCircleResults[i]['offset'],
          Offset(tickX, tickY),
          reason: 'index $i',
        );
        expect(drawCircleResults[i]['radius'], gaugeTicks.radius);
        expect(drawCircleResults[i]['paint_color'], gaugeTicks.color);
      }

      for (var i = 0; i < 3; i++) {
        final angle = 270 * gaugeColor.limits[i];
        final tickX = 200 + cos(angle) * radius;
        final tickY = 200 + sin(angle) * radius;

        expect(
          drawCircleResults[5 + i]['offset'],
          Offset(tickX, tickY),
          reason: 'index $i',
        );
        expect(drawCircleResults[5 + i]['radius'], gaugeTicks.radius);
        expect(
          drawCircleResults[5 + i]['paint_color'],
          isSameColorAs(gaugeColor.colors[i + 1]),
        );
      }

      Utils.changeInstance(utilsMainInstance);
    });
  });

  group('handleTouch()', () {
    test('test 1', () {
      const viewSize = Size(250, 250);
      final data = GaugeChartData(
        value: 0.7,
        valueColor: const SimpleGaugeColor(color: MockData.color0),
        strokeWidth: 30,
        startAngle: 45,
        endAngle: -225,
        strokeCap: StrokeCap.round,
        touchData: GaugeTouchData(
          enabled: true,
          touchCallback: (_, __) {},
        ),
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.radians(captureAny)).thenAnswer(
        (realInvocation) => utilsMainInstance
            .radians(realInvocation.positionalArguments[0] as double),
      );
      when(mockUtils.degrees(captureAny)).thenAnswer(
        (realInvocation) => utilsMainInstance
            .degrees(realInvocation.positionalArguments[0] as double),
      );

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      final drawCircleResults = <Map<String, dynamic>>[];
      when(
        mockCanvasWrapper.drawCircle(captureAny, captureAny, captureAny),
      ).thenAnswer((inv) {
        drawCircleResults.add({
          'offset': inv.positionalArguments[0] as Offset,
          'radius': inv.positionalArguments[1] as double,
          'paint_color': (inv.positionalArguments[2] as Paint).color,
        });
      });

      expect(
        gaugePainter.handleTouch(const Offset(189, 217), viewSize, holder),
        null,
      );
      expect(
        gaugePainter.handleTouch(const Offset(52, 71), viewSize, holder),
        null,
      );
      expect(
        gaugePainter.handleTouch(const Offset(40, 184), viewSize, holder),
        null,
      );
      expect(
        gaugePainter.handleTouch(const Offset(156, 133), viewSize, holder),
        null,
      );
      final expected = GaugeTouchedSpot(
        const FlSpot(196.4392853163202, 41.3553437839966),
        const Offset(196.4, 41.4),
      );

      const offsets = [Offset(195, 209), Offset(33, 61), Offset(170, 26)];
      for (final offset in offsets) {
        final touch = gaugePainter.handleTouch(offset, viewSize, holder);
        expect(touch != null, true);
        expect(touch!.offset.dx, closeTo(expected.offset.dx, 0.1));
        expect(touch.offset.dy, closeTo(expected.offset.dy, 0.1));
        expect(touch.spot.x, closeTo(expected.spot.x, 0.0001));
        expect(touch.spot.y, closeTo(expected.spot.y, 0.0001));
      }

      Utils.changeInstance(utilsMainInstance);
    });
  });
}
