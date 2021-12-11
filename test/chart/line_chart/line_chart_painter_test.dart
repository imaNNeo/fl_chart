import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'line_chart_painter_test.mocks.dart';

@GenerateMocks([Canvas, CanvasWrapper, BuildContext, Utils])
void main() {
  group('LineChart usable size', () {
    test('test 1', () {
      const viewSize = Size(728, 728);

      final LineChartData data = LineChartData(
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
                reservedSize: 12, margin: 8, showTitles: true),
            rightTitles: SideTitles(
                reservedSize: 44, margin: 20, showTitles: true),
            topTitles: SideTitles(showTitles: false),
            bottomTitles: SideTitles(showTitles: false),
          ));

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      expect(lineChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(644, 728));
    });

    test('test 2', () {
      const viewSize = Size(2020, 2020);

      final LineChartData data = LineChartData(
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
                reservedSize: 44, margin: 18, showTitles: true),
            rightTitles: SideTitles(showTitles: false),
            topTitles: SideTitles(showTitles: false),
            bottomTitles: SideTitles(showTitles: false),
          ));

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      expect(lineChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(1958, 2020));
    });

    test('test 3', () {
      const viewSize = Size(1000, 1000);

      final LineChartData data = LineChartData(
          titlesData: FlTitlesData(
            leftTitles: SideTitles(showTitles: false),
            rightTitles:
            SideTitles(reservedSize: 100, margin: 400, showTitles: true),
            topTitles: SideTitles(showTitles: false),
            bottomTitles: SideTitles(showTitles: false),
          ));

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      expect(lineChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(500, 1000));
    });

    test('test 4', () {
      const viewSize = Size(800, 1000);

      final LineChartData data = LineChartData(
          titlesData: FlTitlesData(
            leftTitles: SideTitles(showTitles: false),
            rightTitles: SideTitles(
                reservedSize: 10, margin: 0, showTitles: true),
            topTitles: SideTitles(
                reservedSize: 230, margin: 10, showTitles: true),
            bottomTitles:
            SideTitles(reservedSize: 10, margin: 312, showTitles: true),
          ));

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      expect(lineChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(790, 438));
    });

    test('test 5', () {
      const viewSize = Size(600, 400);

      final LineChartData data = LineChartData(
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
                reservedSize: 0, margin: 0, showTitles: true),
            rightTitles:
            SideTitles(reservedSize: 10, margin: 342134123, showTitles: false),
            topTitles: SideTitles(
                reservedSize: 80, margin: 0, showTitles: true),
            bottomTitles:
            SideTitles(reservedSize: 10, margin: 312, showTitles: false),
          ));

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      expect(lineChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(600, 320));
    });
  });

  group('drawAxisTitles()', () {
    test('test 1', () {
      const viewSize = Size(400, 400);

      final LineChartData data = LineChartData(
        clipData: FlClipData(
          top: false,
          bottom: false,
          left: false,
          right: false,
        ),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      lineChartPainter.clipToBorder(
        _mockCanvasWrapper,
        holder,
      );

      final verifyResult = verify(_mockCanvasWrapper.clipRect(captureAny));
      final Rect rect = verifyResult.captured.single;
      verifyResult.called(1);
      expect(rect.left, 0);
      expect(rect.top, 0);
      expect(rect.width, 400);
      expect(rect.height, 400);
    });

    test('test 2', () {
      const viewSize = Size(400, 400);

      final LineChartData data = LineChartData(
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(showTitles: true, reservedSize: 10, margin: 0),
          topTitles: SideTitles(showTitles: true, reservedSize: 20, margin: 0),
          rightTitles: SideTitles(showTitles: true, reservedSize: 30, margin: 0),
          bottomTitles: SideTitles(showTitles: true, reservedSize: 40, margin: 0),
        ),
        axisTitleData: FlAxisTitleData(show: false),
        borderData: FlBorderData(
          show: true,
          border: Border.all(width: 8)
        ),
        clipData: FlClipData(
          top: false,
          bottom: false,
          left: true,
          right: true,
        ),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      lineChartPainter.clipToBorder(
        _mockCanvasWrapper,
        holder,
      );

      final verifyResult = verify(_mockCanvasWrapper.clipRect(captureAny));
      final Rect rect = verifyResult.captured.single;
      verifyResult.called(1);
      expect(rect.left, 6);
      expect(rect.top, 0);
      expect(rect.right, 374);
      expect(rect.bottom, 400);
    });

    test('test 3', () {
      const viewSize = Size(400, 400);

      final LineChartData data = LineChartData(
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(showTitles: true, reservedSize: 10, margin: 0),
          topTitles: SideTitles(showTitles: true, reservedSize: 20, margin: 20),
          rightTitles: SideTitles(showTitles: true, reservedSize: 30, margin: 0),
          bottomTitles: SideTitles(showTitles: true, reservedSize: 30, margin: 10),
        ),
        axisTitleData: FlAxisTitleData(show: false),
        borderData: FlBorderData(
            show: true,
            border: Border.all(width: 8)
        ),
        clipData: FlClipData(
          top: true,
          bottom: true,
          left: true,
          right: true,
        ),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      lineChartPainter.clipToBorder(
        _mockCanvasWrapper,
        holder,
      );

      final verifyResult = verify(_mockCanvasWrapper.clipRect(captureAny));
      final Rect rect = verifyResult.captured.single;
      verifyResult.called(1);
      expect(rect.left, 6);
      expect(rect.top, 36);
      expect(rect.right, 374);
      expect(rect.bottom, 364);
    });

  });
}
