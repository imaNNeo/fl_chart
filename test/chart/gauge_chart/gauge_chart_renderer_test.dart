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
    final data = GaugeChartData(
      startAngle: 0,
      endAngle: 270,
      strokeWidth: 5,
      value: 0.7,
      valueColor: const SimpleGaugeColor(color: MockData.color0),
      backgroundColor: MockData.color6,
      strokeCap: StrokeCap.round,
      ticks: const GaugeTicks(
        color: MockData.color0,
        margin: 5,
        showChangingColorTicks: false,
        radius: 4,
        count: 5,
        position: GaugeTickPosition.inner,
      ),
    );

    final targetData = GaugeChartData(
      startAngle: 0,
      endAngle: 180,
      strokeWidth: 5,
      value: 0.5,
      valueColor: const SimpleGaugeColor(color: MockData.color1),
      backgroundColor: MockData.color5,
      strokeCap: StrokeCap.round,
      ticks: const GaugeTicks(
        color: MockData.color1,
        margin: 10,
        radius: 20,
        count: 30,
        position: GaugeTickPosition.center,
      ),
    );

    const textScaler = TextScaler.linear(4);

    final mockBuildContext = MockBuildContext();
    final renderGaugeChart = RenderGaugeChart(
      mockBuildContext,
      data,
      targetData,
      textScaler,
    );

    final mockPainter = MockGaugeChartPainter();
    final mockPaintingContext = MockPaintingContext();
    final mockCanvas = MockCanvas();
    const mockSize = Size(44, 44);
    when(mockPaintingContext.canvas).thenAnswer((realInvocation) => mockCanvas);
    renderGaugeChart
      ..mockTestSize = mockSize
      ..painter = mockPainter;

    test('test 1 correct data', () {
      expect(renderGaugeChart.data == data, true);
      expect(renderGaugeChart.data == targetData, false);
      expect(renderGaugeChart.targetData == targetData, true);
      expect(renderGaugeChart.textScaler == textScaler, true);
      expect(renderGaugeChart.paintHolder.data == data, true);
      expect(renderGaugeChart.paintHolder.targetData == targetData, true);
      expect(renderGaugeChart.paintHolder.textScaler == textScaler, true);
    });

    test('test 2 check paint function', () {
      renderGaugeChart.paint(mockPaintingContext, const Offset(10, 10));
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
      final results = <Map<String, dynamic>>[];
      when(mockPainter.handleTouch(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        results.add({
          'local_position': inv.positionalArguments[0] as Offset,
          'size': inv.positionalArguments[1] as Size,
          'paint_holder': inv.positionalArguments[2] as PaintHolder,
        });
        return gaugeTouchedSpot1;
      });
      final touchResponse =
          renderGaugeChart.getResponseAtLocation(MockData.offset1);
      expect(touchResponse.touchedSpot, gaugeTouchedSpot1);
      expect(results[0]['local_position'] as Offset, MockData.offset1);
      expect(results[0]['size'] as Size, mockSize);
      final paintHolder = results[0]['paint_holder'] as PaintHolder;
      expect(paintHolder.data, data);
      expect(paintHolder.targetData, targetData);
      expect(paintHolder.textScaler, textScaler);
    });

    test('test 4 check setters', () {
      renderGaugeChart
        ..data = targetData
        ..targetData = data
        ..textScaler = const TextScaler.linear(22);

      expect(renderGaugeChart.data, targetData);
      expect(renderGaugeChart.targetData, data);
      expect(renderGaugeChart.textScaler, const TextScaler.linear(22));
    });
  });
}
