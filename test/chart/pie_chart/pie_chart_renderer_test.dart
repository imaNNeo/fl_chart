import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/pie_chart/pie_chart_painter.dart';
import 'package:fl_chart/src/chart/pie_chart/pie_chart_renderer.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../data_pool.dart';
import 'pie_chart_renderer_test.mocks.dart';

@GenerateMocks([Canvas, PaintingContext, BuildContext, PieChartPainter])
void main() {
  group('PieChartRenderer', () {
    final PieChartData data = PieChartData();

    final PieChartData targetData = PieChartData(centerSpaceRadius: 12);

    const textScale = 4.0;

    MockBuildContext _mockBuildContext = MockBuildContext();
    RenderPieChart renderBarChart = RenderPieChart(
      _mockBuildContext,
      data,
      targetData,
      textScale,
    );

    MockPieChartPainter _mockPainter = MockPieChartPainter();
    MockPaintingContext _mockPaintingContext = MockPaintingContext();
    MockCanvas _mockCanvas = MockCanvas();
    Size _mockSize = const Size(44, 44);
    when(_mockPaintingContext.canvas)
        .thenAnswer((realInvocation) => _mockCanvas);
    renderBarChart.mockTestSize = _mockSize;
    renderBarChart.painter = _mockPainter;

    test('test 1 correct data set', () {
      expect(renderBarChart.data == data, true);
      expect(renderBarChart.data == targetData, false);
      expect(renderBarChart.targetData == targetData, true);
      expect(renderBarChart.textScale == textScale, true);
      expect(renderBarChart.paintHolder.data == data, true);
      expect(renderBarChart.paintHolder.targetData == targetData, true);
      expect(renderBarChart.paintHolder.textScale == textScale, true);
    });

    test('test 2 check paint function', () {
      renderBarChart.paint(_mockPaintingContext, const Offset(10, 10));
      verify(_mockCanvas.save()).called(1);
      verify(_mockCanvas.translate(10, 10)).called(1);
      final result = verify(_mockPainter.paint(any, captureAny, captureAny));
      expect(result.callCount, 1);

      final canvasWrapper = result.captured[0] as CanvasWrapper;
      expect(canvasWrapper.size, const Size(44, 44));
      expect(canvasWrapper.canvas, _mockCanvas);

      final paintHolder = result.captured[1] as PaintHolder;
      expect(paintHolder.data, data);
      expect(paintHolder.targetData, targetData);
      expect(paintHolder.textScale, textScale);

      verify(_mockCanvas.restore()).called(1);
    });

    test('test 3 check getResponseAtLocation function', () {
      List<Map<String, dynamic>> results = [];
      when(_mockPainter.handleTouch(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        results.add({
          'local_position': inv.positionalArguments[0] as Offset,
          'size': inv.positionalArguments[1] as Size,
          'paint_holder': (inv.positionalArguments[2] as PaintHolder),
        });
        return MockData.pieTouchedSection1;
      });
      final touchResponse =
          renderBarChart.getResponseAtLocation(MockData.offset1);
      expect(touchResponse.touchedSection, MockData.pieTouchedSection1);
      expect(results[0]['local_position'] as Offset, MockData.offset1);
      expect(results[0]['size'] as Size, _mockSize);
      final paintHolder = results[0]['paint_holder'] as PaintHolder;
      expect(paintHolder.data, data);
      expect(paintHolder.targetData, targetData);
      expect(paintHolder.textScale, textScale);
    });

    test('test 4 check setters', () {
      renderBarChart.data = targetData;
      renderBarChart.targetData = data;
      renderBarChart.textScale = 22;

      expect(renderBarChart.data, targetData);
      expect(renderBarChart.targetData, data);
      expect(renderBarChart.textScale, 22);
    });
  });
}
