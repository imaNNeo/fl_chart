import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_painter.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_renderer.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../data_pool.dart';
import 'radar_chart_renderer_test.mocks.dart';

@GenerateMocks([Canvas, PaintingContext, BuildContext, RadarChartPainter])
void main() {
  group('RadarChartRenderer', () {
    final data = RadarChartData(
      dataSets: [MockData.radarDataSet1],
      tickCount: 1,
    );

    final targetData = RadarChartData(
      dataSets: [MockData.radarDataSet2],
      tickCount: 1,
    );

    const textScaler = TextScaler.linear(4);

    final mockBuildContext = MockBuildContext();
    final renderRadarChart = RenderRadarChart(
      mockBuildContext,
      data,
      targetData,
      textScaler,
    );

    final mockPainter = MockRadarChartPainter();
    final mockPaintingContext = MockPaintingContext();
    final mockCanvas = MockCanvas();
    const mockSize = Size(44, 44);
    when(mockPaintingContext.canvas).thenAnswer((realInvocation) => mockCanvas);
    renderRadarChart
      ..mockTestSize = mockSize
      ..painter = mockPainter;

    test('test 1 correct data set', () {
      expect(renderRadarChart.data == data, true);
      expect(renderRadarChart.data == targetData, false);
      expect(renderRadarChart.targetData == targetData, true);
      expect(renderRadarChart.textScaler == textScaler, true);
      expect(renderRadarChart.paintHolder.data == data, true);
      expect(renderRadarChart.paintHolder.targetData == targetData, true);
      expect(renderRadarChart.paintHolder.textScaler == textScaler, true);
    });

    test('test 2 check paint function', () {
      renderRadarChart.paint(mockPaintingContext, const Offset(10, 10));
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
        return MockData.radarTouchedSpot;
      });
      final touchResponse =
          renderRadarChart.getResponseAtLocation(MockData.offset1);
      expect(touchResponse.touchedSpot, MockData.radarTouchedSpot);
      expect(results[0]['local_position'] as Offset, MockData.offset1);
      expect(results[0]['size'] as Size, mockSize);
      final paintHolder = results[0]['paint_holder'] as PaintHolder;
      expect(paintHolder.data, data);
      expect(paintHolder.targetData, targetData);
      expect(paintHolder.textScaler, textScaler);
    });

    test('test 4 check setters', () {
      renderRadarChart
        ..data = targetData
        ..targetData = data
        ..textScaler = const TextScaler.linear(22);

      expect(renderRadarChart.data, targetData);
      expect(renderRadarChart.targetData, data);
      expect(renderRadarChart.textScaler, const TextScaler.linear(22));
    });
  });
}
