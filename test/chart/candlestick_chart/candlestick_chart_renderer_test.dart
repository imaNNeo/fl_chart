import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/candlestick_chart/candlestick_chart_painter.dart';
import 'package:fl_chart/src/chart/candlestick_chart/candlestick_chart_renderer.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../data_pool.dart';
import 'candlestick_chart_renderer_test.mocks.dart';

@GenerateMocks([Canvas, PaintingContext, BuildContext, CandlestickChartPainter])
void main() {
  group('CandlestickChartRenderer', () {
    final data = CandlestickChartData(
      candlestickSpots: [candlestickSpot1, candlestickSpot2],
    );

    final targetData = CandlestickChartData(
      candlestickSpots: [candlestickSpot3],
    );

    const textScaler = TextScaler.linear(4);

    final mockBuildContext = MockBuildContext();
    final renderCandlestickChart = RenderCandlestickChart(
      mockBuildContext,
      data,
      targetData,
      textScaler,
      null,
      canBeScaled: false,
    );

    final mockPainter = MockCandlestickChartPainter();
    final mockPaintingContext = MockPaintingContext();
    final mockCanvas = MockCanvas();
    const mockSize = Size(44, 44);
    when(mockPaintingContext.canvas).thenAnswer((realInvocation) => mockCanvas);
    renderCandlestickChart
      ..mockTestSize = mockSize
      ..painter = mockPainter;

    test('test 1 correct data set', () {
      expect(renderCandlestickChart.data == data, true);
      expect(renderCandlestickChart.data == targetData, false);
      expect(renderCandlestickChart.targetData == targetData, true);
      expect(renderCandlestickChart.textScaler == textScaler, true);
      expect(renderCandlestickChart.paintHolder.data == data, true);
      expect(renderCandlestickChart.paintHolder.targetData == targetData, true);
      expect(renderCandlestickChart.paintHolder.textScaler == textScaler, true);
    });

    test('test 2 check paint function', () {
      renderCandlestickChart.paint(mockPaintingContext, const Offset(10, 10));
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
        return candlestickTouchedSpot1;
      });

      when(mockPainter.getChartCoordinateFromPixel(any, any, any))
          .thenAnswer((_) => const Offset(10, 10));

      final touchResponse =
          renderCandlestickChart.getResponseAtLocation(MockData.offset1);
      expect(touchResponse.touchedSpot, candlestickTouchedSpot1);
      expect(touchResponse.touchChartCoordinate, const Offset(10, 10));
      expect(results[0]['local_position'] as Offset, MockData.offset1);
      expect(results[0]['size'] as Size, mockSize);
      final paintHolder = results[0]['paint_holder'] as PaintHolder;
      expect(paintHolder.data, data);
      expect(paintHolder.targetData, targetData);
      expect(paintHolder.textScaler, textScaler);
    });

    test('test 4 check setters', () {
      renderCandlestickChart
        ..data = targetData
        ..targetData = data
        ..textScaler = const TextScaler.linear(22);

      expect(renderCandlestickChart.data, targetData);
      expect(renderCandlestickChart.targetData, data);
      expect(renderCandlestickChart.textScaler, const TextScaler.linear(22));
    });

    test('passes chart virtual rect to paint holder', () {
      final rect1 = Offset.zero & const Size(100, 100);
      final renderCandlestickChart = RenderCandlestickChart(
        mockBuildContext,
        data,
        targetData,
        textScaler,
        null,
        canBeScaled: false,
      );

      expect(renderCandlestickChart.chartVirtualRect, isNull);
      expect(renderCandlestickChart.paintHolder.chartVirtualRect, isNull);

      renderCandlestickChart.chartVirtualRect = rect1;

      expect(renderCandlestickChart.chartVirtualRect, rect1);
      expect(renderCandlestickChart.paintHolder.chartVirtualRect, rect1);
    });

    test('uses canBeScaled', () {
      final renderCandlestickChart = RenderCandlestickChart(
        mockBuildContext,
        data,
        targetData,
        textScaler,
        null,
        canBeScaled: false,
      );

      expect(renderCandlestickChart.canBeScaled, false);

      renderCandlestickChart.canBeScaled = true;

      expect(renderCandlestickChart.canBeScaled, true);
    });
  });
}
