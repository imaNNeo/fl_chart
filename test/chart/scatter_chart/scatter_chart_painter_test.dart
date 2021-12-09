import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../data_pool.dart';
import 'scatter_chart_painter_test.mocks.dart';

@GenerateMocks([Canvas, CanvasWrapper, BuildContext, Utils])
void main() {
  group('ScatterChart usable size', () {
    test('test 1', () {
      const viewSize = Size(728, 728);

      final ScatterChartData data = ScatterChartData(
          titlesData: FlTitlesData(
        leftTitles: SideTitles(reservedSize: 12, margin: 8, showTitles: true),
        rightTitles: SideTitles(reservedSize: 44, margin: 20, showTitles: true),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(showTitles: false),
      ));

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      expect(scatterChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(644, 728));
    });

    test('test 2', () {
      const viewSize = Size(2020, 2020);

      final ScatterChartData data = ScatterChartData(
          titlesData: FlTitlesData(
        leftTitles: SideTitles(reservedSize: 44, margin: 18, showTitles: true),
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(showTitles: false),
      ));

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      expect(scatterChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(1958, 2020));
    });

    test('test 3', () {
      const viewSize = Size(1000, 1000);

      final ScatterChartData data = ScatterChartData(
          titlesData: FlTitlesData(
        leftTitles: SideTitles(showTitles: false),
        rightTitles:
            SideTitles(reservedSize: 100, margin: 400, showTitles: true),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(showTitles: false),
      ));

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      expect(scatterChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(500, 1000));
    });

    test('test 4', () {
      const viewSize = Size(800, 1000);

      final ScatterChartData data = ScatterChartData(
          titlesData: FlTitlesData(
        leftTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(reservedSize: 10, margin: 0, showTitles: true),
        topTitles: SideTitles(reservedSize: 230, margin: 10, showTitles: true),
        bottomTitles:
            SideTitles(reservedSize: 10, margin: 312, showTitles: true),
      ));

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      expect(scatterChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(790, 438));
    });

    test('test 5', () {
      const viewSize = Size(600, 400);

      final ScatterChartData data = ScatterChartData(
          titlesData: FlTitlesData(
        leftTitles: SideTitles(reservedSize: 0, margin: 0, showTitles: true),
        rightTitles:
            SideTitles(reservedSize: 10, margin: 342134123, showTitles: false),
        topTitles: SideTitles(reservedSize: 80, margin: 0, showTitles: true),
        bottomTitles:
            SideTitles(reservedSize: 10, margin: 312, showTitles: false),
      ));

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      expect(scatterChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(600, 320));
    });
  });

  group('drawAxisTitles()', () {
    test('test 1', () {
      const viewSize = Size(728, 728);

      final ScatterChartData data =
          ScatterChartData(axisTitleData: flAxisTitleData1);

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      MockBuildContext _mockBuildContext = MockBuildContext();
      MockUtils _mockUtils = MockUtils();
      when(_mockCanvasWrapper.getsize())
          .thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      Utils.changeInstance(_mockUtils);
      when(_mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(const TextStyle(color: Color(0x00ffffff)));
      scatterChartPainter.drawAxisTitles(
        _mockBuildContext,
        _mockCanvasWrapper,
        holder,
      );
      verify(_mockCanvasWrapper.drawText(any, any)).called(4);
    });

    test('test 2', () {
      const viewSize = Size(728, 728);

      final ScatterChartData data = ScatterChartData(
          axisTitleData: flAxisTitleData1.copyWith(
              leftTitle: AxisTitle(showTitle: false)));

      final ScatterChartPainter scatterChartPainter = ScatterChartPainter();
      final holder = PaintHolder<ScatterChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      MockBuildContext _mockBuildContext = MockBuildContext();
      when(_mockCanvasWrapper.getsize())
          .thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      when(_mockBuildContext
              .dependOnInheritedWidgetOfExactType<DefaultTextStyle>())
          .thenAnswer((realInvocation) => defaultTextStyle1);
      when(_mockBuildContext.dependOnInheritedWidgetOfExactType<MediaQuery>())
          .thenAnswer((realInvocation) => null);

      scatterChartPainter.drawAxisTitles(
        _mockBuildContext,
        _mockCanvasWrapper,
        holder,
      );
      verify(_mockCanvasWrapper.drawText(any, any)).called(3);
    });
  });
}
