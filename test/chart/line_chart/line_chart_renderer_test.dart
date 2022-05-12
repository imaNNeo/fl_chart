import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_painter.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_renderer.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../data_pool.dart';
import 'line_chart_renderer_test.mocks.dart';

@GenerateMocks([Canvas, PaintingContext, BuildContext, LineChartPainter])
void main() {
  group('LineChartRenderer', () {
    final LineChartData data = LineChartData(
        titlesData: FlTitlesData(
      leftTitles: AxisTitles(
          sideTitles: SideTitles(reservedSize: 20, showTitles: true)),
      rightTitles: AxisTitles(
          sideTitles: SideTitles(reservedSize: 464, showTitles: true)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    ));

    final LineChartData targetData = LineChartData(
        titlesData: FlTitlesData(
      leftTitles:
          AxisTitles(sideTitles: SideTitles(reservedSize: 8, showTitles: true)),
      rightTitles: AxisTitles(
          sideTitles: SideTitles(reservedSize: 20, showTitles: true)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    ));

    const textScale = 4.0;

    MockBuildContext mockBuildContext = MockBuildContext();
    RenderLineChart renderLineChart = RenderLineChart(
      mockBuildContext,
      data,
      targetData,
      textScale,
    );

    MockLineChartPainter mockPainter = MockLineChartPainter();
    MockPaintingContext mockPaintingContext = MockPaintingContext();
    MockCanvas mockCanvas = MockCanvas();
    Size mockSize = const Size(44, 44);
    when(mockPaintingContext.canvas).thenAnswer((realInvocation) => mockCanvas);
    renderLineChart.mockTestSize = mockSize;
    renderLineChart.painter = mockPainter;

    test('test 1 correct data set', () {
      expect(renderLineChart.data == data, true);
      expect(renderLineChart.data == targetData, false);
      expect(renderLineChart.targetData == targetData, true);
      expect(renderLineChart.textScale == textScale, true);
      expect(renderLineChart.paintHolder.data == data, true);
      expect(renderLineChart.paintHolder.targetData == targetData, true);
      expect(renderLineChart.paintHolder.textScale == textScale, true);
    });

    test('test 2 check paint function', () {
      renderLineChart.paint(mockPaintingContext, const Offset(10, 10));
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
      expect(paintHolder.textScale, textScale);

      verify(mockCanvas.restore()).called(1);
    });

    test('test 3 check getResponseAtLocation function', () {
      List<Map<String, dynamic>> results = [];
      when(mockPainter.handleTouch(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        results.add({
          'local_position': inv.positionalArguments[0] as Offset,
          'size': inv.positionalArguments[1] as Size,
          'paint_holder': (inv.positionalArguments[2] as PaintHolder),
        });
        return MockData.lineTouchResponse1.lineBarSpots;
      });
      final touchResponse =
          renderLineChart.getResponseAtLocation(MockData.offset1);
      expect(
        touchResponse.lineBarSpots,
        MockData.lineTouchResponse1.lineBarSpots,
      );
      expect(results[0]['local_position'] as Offset, MockData.offset1);
      expect(results[0]['size'] as Size, mockSize);
      final paintHolder = results[0]['paint_holder'] as PaintHolder;
      expect(paintHolder.data, data);
      expect(paintHolder.targetData, targetData);
      expect(paintHolder.textScale, textScale);
    });

    test('test 4 check setters', () {
      renderLineChart.data = targetData;
      renderLineChart.targetData = data;
      renderLineChart.textScale = 22;

      expect(renderLineChart.data, targetData);
      expect(renderLineChart.targetData, data);
      expect(renderLineChart.textScale, 22);
    });
  });
}
