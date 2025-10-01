import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_painter.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_renderer.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../data_pool.dart';
import 'scatter_chart_renderer_test.mocks.dart';

@GenerateMocks([Canvas, PaintingContext, BuildContext, ScatterChartPainter])
void main() {
  group('ScatterChartRenderer', () {
    final data = ScatterChartData(
      scatterSpots: [MockData.scatterSpot1, MockData.scatterSpot2],
    );

    final targetData = ScatterChartData(
      scatterSpots: [MockData.scatterSpot3],
      scatterTouchData: ScatterTouchData(enabled: false),
    );

    const textScaler = TextScaler.linear(4);

    final mockBuildContext = MockBuildContext();
    final renderScatterChart = RenderScatterChart(
      mockBuildContext,
      data,
      targetData,
      textScaler,
      null,
      canBeScaled: false,
    );

    final mockPainter = MockScatterChartPainter();
    final mockPaintingContext = MockPaintingContext();
    final mockCanvas = MockCanvas();
    const mockSize = Size(44, 44);
    when(mockPaintingContext.canvas).thenAnswer((realInvocation) => mockCanvas);
    renderScatterChart
      ..mockTestSize = mockSize
      ..painter = mockPainter;

    test('test 1 correct data set', () {
      expect(renderScatterChart.data == data, true);
      expect(renderScatterChart.data == targetData, false);
      expect(renderScatterChart.targetData == targetData, true);
      expect(renderScatterChart.textScaler == textScaler, true);
      expect(renderScatterChart.paintHolder.data == data, true);
      expect(renderScatterChart.paintHolder.targetData == targetData, true);
      expect(renderScatterChart.paintHolder.textScaler == textScaler, true);
      expect(renderScatterChart.hitTestSelf(Offset.zero), false);
    });

    test('test 2 check paint function', () {
      renderScatterChart.paint(mockPaintingContext, const Offset(10, 10));
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
        return MockData.scatterTouchedSpot;
      });
      when(mockPainter.getChartCoordinateFromPixel(any, any, any))
          .thenAnswer((_) => const Offset(10, 10));
      final touchResponse =
          renderScatterChart.getResponseAtLocation(MockData.offset1);
      expect(touchResponse.touchedSpot, MockData.scatterTouchedSpot);
      expect(touchResponse.touchChartCoordinate, const Offset(10, 10));
      expect(results[0]['local_position'] as Offset, MockData.offset1);
      expect(results[0]['size'] as Size, mockSize);
      final paintHolder = results[0]['paint_holder'] as PaintHolder;
      expect(paintHolder.data, data);
      expect(paintHolder.targetData, targetData);
      expect(paintHolder.textScaler, textScaler);
    });

    test('test 4 check setters', () {
      renderScatterChart
        ..data = targetData
        ..targetData = data
        ..textScaler = const TextScaler.linear(22);

      expect(renderScatterChart.data, targetData);
      expect(renderScatterChart.targetData, data);
      expect(renderScatterChart.textScaler, const TextScaler.linear(22));
    });

    test('passes chart virtual rect to paint holder', () {
      final rect1 = Offset.zero & const Size(100, 100);
      final renderScatterChart = RenderScatterChart(
        mockBuildContext,
        data,
        targetData,
        textScaler,
        null,
        canBeScaled: false,
      );

      expect(renderScatterChart.chartVirtualRect, isNull);
      expect(renderScatterChart.paintHolder.chartVirtualRect, isNull);

      renderScatterChart.chartVirtualRect = rect1;

      expect(renderScatterChart.chartVirtualRect, rect1);
      expect(renderScatterChart.paintHolder.chartVirtualRect, rect1);
    });

    test('uses canBeScaled', () {
      final renderScatterChart = RenderScatterChart(
        mockBuildContext,
        data,
        targetData,
        textScaler,
        null,
        canBeScaled: false,
      );

      expect(renderScatterChart.canBeScaled, false);

      renderScatterChart.canBeScaled = true;

      expect(renderScatterChart.canBeScaled, true);
    });
  });
}
