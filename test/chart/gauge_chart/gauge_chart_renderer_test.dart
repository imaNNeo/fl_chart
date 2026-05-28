import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/gauge_chart/gauge_chart_painter.dart';
import 'package:fl_chart/src/chart/gauge_chart/gauge_chart_renderer.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../data_pool.dart';
import 'gauge_chart_renderer_test.mocks.dart';

@GenerateMocks([Canvas, PaintingContext, BuildContext, GaugeChartPainter])
void main() {
  group('GaugeChartRenderer', () {
    GaugeChartData createData() {
      return GaugeChartData(
        rings: const [
          GaugeProgressRing(
            value: 0.7,
            color: MockData.color0,
            width: 5,
            backgroundColor: MockData.color6,
            strokeCap: StrokeCap.round,
          ),
        ],
      );
    }

    GaugeChartData createTargetData() {
      return GaugeChartData(
        rings: const [
          GaugeProgressRing(
            value: 0.5,
            color: MockData.color1,
            width: 5,
            backgroundColor: MockData.color5,
            strokeCap: StrokeCap.round,
          ),
        ],
        sweepAngle: 180,
      );
    }

    const textScaler = TextScaler.linear(4);
    final mockBuildContext = MockBuildContext();
    final mockPainter = MockGaugeChartPainter();
    final mockPaintingContext = MockPaintingContext();
    final mockCanvas = MockCanvas();
    const mockSize = Size(44, 44);

    setUp(() {
      reset(mockPainter);
      reset(mockPaintingContext);
      reset(mockCanvas);
      when(mockPaintingContext.canvas)
          .thenAnswer((realInvocation) => mockCanvas);
    });

    test('test 1 correct data', () {
      final data = createData();
      final targetData = createTargetData();
      final renderGaugeChart = RenderGaugeChart(
        mockBuildContext,
        data,
        targetData,
        textScaler,
      )
        ..mockTestSize = mockSize
        ..painter = mockPainter;

      expect(renderGaugeChart.data == data, true);
      expect(renderGaugeChart.data == targetData, false);
      expect(renderGaugeChart.targetData == targetData, true);
      expect(renderGaugeChart.textScaler == textScaler, true);
      expect(renderGaugeChart.paintHolder.data == data, true);
      expect(renderGaugeChart.paintHolder.targetData == targetData, true);
      expect(renderGaugeChart.paintHolder.textScaler == textScaler, true);
    });

    test('test 2 check paint function', () {
      final data = createData();
      final targetData = createTargetData();
      RenderGaugeChart(
        mockBuildContext,
        data,
        targetData,
        textScaler,
      )
        ..mockTestSize = mockSize
        ..painter = mockPainter
        ..paint(mockPaintingContext, const Offset(10, 10));

      verify(mockCanvas.save()).called(1);
      verify(mockCanvas.translate(10, 10)).called(1);
      final result = verify(mockPainter.paint(any, captureAny, captureAny));
      expect(result.callCount, 1);

      final canvasWrapper = result.captured[0] as CanvasWrapper;
      expect(canvasWrapper.size, const Size(44, 44));
      expect(canvasWrapper.canvas, mockCanvas);

      final paintHolder = result.captured[1] as PaintHolder;
      expect(paintHolder.data, data);
      expect(paintHolder.targetData, targetData);
      expect(paintHolder.textScaler, textScaler);

      verify(mockCanvas.restore()).called(1);
    });

    test('test 3 check getResponseAtLocation function', () {
      final data = createData();
      final targetData = createTargetData();
      final renderGaugeChart = RenderGaugeChart(
        mockBuildContext,
        data,
        targetData,
        textScaler,
      )
        ..mockTestSize = mockSize
        ..painter = mockPainter;

      final results = <Map<String, dynamic>>[];
      when(mockPainter.handleTouch(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        results.add({
          'local_position': inv.positionalArguments[0] as Offset,
          'size': inv.positionalArguments[1] as Size,
          'paint_holder': inv.positionalArguments[2] as PaintHolder,
        });
        return gaugeTouchedRing1;
      });
      final touchResponse =
          renderGaugeChart.getResponseAtLocation(MockData.offset1);
      expect(touchResponse.touchedRing, gaugeTouchedRing1);
      expect(results[0]['local_position'] as Offset, MockData.offset1);
      expect(results[0]['size'] as Size, mockSize);
      final paintHolder = results[0]['paint_holder'] as PaintHolder;
      expect(paintHolder.data, data);
      expect(paintHolder.targetData, targetData);
      expect(paintHolder.textScaler, textScaler);
    });

    test('test 4 check setters', () {
      final data = createData();
      final targetData = createTargetData();
      final renderGaugeChart = RenderGaugeChart(
        mockBuildContext,
        data,
        targetData,
        textScaler,
      )
        ..mockTestSize = mockSize
        ..painter = mockPainter
        ..data = targetData
        ..targetData = data
        ..textScaler = const TextScaler.linear(22);

      expect(renderGaugeChart.data, targetData);
      expect(renderGaugeChart.targetData, data);
      expect(renderGaugeChart.textScaler, const TextScaler.linear(22));
    });
  });
}
