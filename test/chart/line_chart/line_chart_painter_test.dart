import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../data_pool.dart';
import 'line_chart_painter_test.mocks.dart';

@GenerateMocks([Canvas, CanvasWrapper, BuildContext, Utils, LineChartPainter])
void main() {
  group('LineChart usable size', () {
    test('test 1', () {
      const viewSize = Size(728, 728);

      final LineChartData data = LineChartData(
          titlesData: FlTitlesData(
        leftTitles: SideTitles(reservedSize: 12, margin: 8, showTitles: true),
        rightTitles: SideTitles(reservedSize: 44, margin: 20, showTitles: true),
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
        leftTitles: SideTitles(reservedSize: 44, margin: 18, showTitles: true),
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
        rightTitles: SideTitles(reservedSize: 10, margin: 0, showTitles: true),
        topTitles: SideTitles(reservedSize: 230, margin: 10, showTitles: true),
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
        leftTitles: SideTitles(reservedSize: 0, margin: 0, showTitles: true),
        rightTitles:
            SideTitles(reservedSize: 10, margin: 342134123, showTitles: false),
        topTitles: SideTitles(reservedSize: 80, margin: 0, showTitles: true),
        bottomTitles:
            SideTitles(reservedSize: 10, margin: 312, showTitles: false),
      ));

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      expect(lineChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(600, 320));
    });
  });

  group('clipToBorder()', () {
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
          rightTitles:
              SideTitles(showTitles: true, reservedSize: 30, margin: 0),
          bottomTitles:
              SideTitles(showTitles: true, reservedSize: 40, margin: 0),
        ),
        axisTitleData: FlAxisTitleData(show: false),
        borderData: FlBorderData(show: true, border: Border.all(width: 8)),
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
          rightTitles:
              SideTitles(showTitles: true, reservedSize: 30, margin: 0),
          bottomTitles:
              SideTitles(showTitles: true, reservedSize: 30, margin: 10),
        ),
        axisTitleData: FlAxisTitleData(show: false),
        borderData: FlBorderData(show: true, border: Border.all(width: 8)),
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

  group('drawBarLine()', () {
    test('test 1', () {
      const viewSize = Size(400, 400);

      final LineChartBarData barData = LineChartBarData(
        show: true,
        spots: const [
          flSpot1,
          flSpot2,
          FlSpot(20, 11),
          FlSpot(11, 11),
        ],
      );

      final LineChartData data = LineChartData(lineBarsData: [barData]);

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawBarLine(
        _mockCanvasWrapper,
        barData,
        holder,
      );

      verify(_mockCanvasWrapper.drawPath(any, any)).called(1);
    });

    test('test 2', () {
      const viewSize = Size(400, 400);

      final LineChartBarData barData = LineChartBarData(
        show: true,
        spots: const [
          flSpot1,
          flSpot2,
          FlSpot.nullSpot,
          FlSpot(20, 11),
          FlSpot(11, 11),
        ],
      );

      final LineChartData data = LineChartData(lineBarsData: [barData]);

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawBarLine(
        _mockCanvasWrapper,
        barData,
        holder,
      );

      verify(_mockCanvasWrapper.drawPath(any, any)).called(2);
    });

    test('test 3', () {
      const viewSize = Size(400, 400);

      final LineChartBarData barData = LineChartBarData(
        show: true,
        spots: const [
          flSpot1,
          flSpot2,
          FlSpot(20, 11),
          FlSpot(11, 11),
        ],
      );

      final LineChartData data = LineChartData(
        lineBarsData: [barData],
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawBarLine(
        _mockCanvasWrapper,
        barData,
        holder,
      );

      final verificationResult =
          verify(_mockCanvasWrapper.drawPath(any, captureAny));
      final paint = verificationResult.captured.single as Paint;
      verificationResult.called(1);
      expect(paint.color.value, barData.colors.first.value);
    });
  });

  group('drawBetweenBarsArea()', () {
    test('test 1', () {
      const viewSize = Size(400, 400);

      final LineChartBarData barData = LineChartBarData(
        show: true,
        spots: const [
          flSpot1,
          flSpot2,
          FlSpot(20, 11),
          FlSpot(11, 11),
        ],
      );

      final LineChartBarData barData2 = LineChartBarData(
        show: true,
        spots: const [
          flSpot2,
          flSpot1,
          FlSpot(20, 11),
          FlSpot(11, 11),
        ],
      );

      final betweenBarData = BetweenBarsData(
        fromIndex: 0,
        toIndex: 1,
        colors: [const Color(0xFFFF0000)],
      );

      final LineChartData data = LineChartData(
        lineBarsData: [
          barData,
          barData2,
        ],
        betweenBarsData: [
          betweenBarData,
        ],
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawBetweenBarsArea(
        _mockCanvasWrapper,
        data,
        betweenBarData,
        holder,
      );

      final verifyResult = verifyInOrder([
        _mockCanvasWrapper.saveLayer(const Rect.fromLTWH(0, 0, 400, 400), any),
        _mockCanvasWrapper.drawPath(any, captureAny),
        _mockCanvasWrapper.restore(),
      ]);

      final Paint paint = verifyResult[1].captured.first;
      expect(paint.shader, null);
      expect(paint.color, const Color(0xFFFF0000));
    });
  });

  group('drawDots()', () {
    test('test 1', () {
      const viewSize = Size(400, 400);

      final LineChartBarData barData = LineChartBarData(
        show: true,
        spots: const [],
        dotData: FlDotData(show: true),
      );

      final LineChartData data = LineChartData(
        lineBarsData: [
          barData,
        ],
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawDots(
        _mockCanvasWrapper,
        barData,
        holder,
      );

      verifyNever(_mockCanvasWrapper.drawDot(any, any, any));
    });

    test('test 2', () {
      const viewSize = Size(400, 400);

      final LineChartBarData barData = LineChartBarData(
        show: true,
        spots: const [FlSpot(1, 1)],
        dotData: FlDotData(show: false),
      );

      final LineChartData data = LineChartData(
        lineBarsData: [
          barData,
        ],
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawDots(
        _mockCanvasWrapper,
        barData,
        holder,
      );

      verifyNever(_mockCanvasWrapper.drawDot(any, any, any));
    });

    test('test 3', () {
      const viewSize = Size(400, 400);

      final LineChartBarData barData = LineChartBarData(
        show: true,
        spots: const [
          FlSpot(1, 1),
          FlSpot(2, 2),
          FlSpot(3, 3),
          FlSpot(4, 4),
          FlSpot.nullSpot,
          FlSpot(5, 5),
        ],
        dotData: FlDotData(show: true),
      );

      final LineChartData data = LineChartData(
        lineBarsData: [
          barData,
        ],
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawDots(
        _mockCanvasWrapper,
        barData,
        holder,
      );

      verify(_mockCanvasWrapper.drawDot(any, any, any)).called(5);
    });

    test('test 4', () {
      const viewSize = Size(100, 100);

      final LineChartBarData barData = LineChartBarData(
        show: true,
        spots: const [
          FlSpot(1, 1),
          FlSpot(2, 2),
          FlSpot(3, 3),
          FlSpot(4, 4),
          FlSpot.nullSpot,
          FlSpot(5, 5),
        ],
        dotData: FlDotData(show: true),
      );

      final LineChartData data = LineChartData(
        minX: 0,
        maxX: 10,
        minY: 0,
        maxY: 10,
        lineBarsData: [
          barData,
        ],
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawDots(
        _mockCanvasWrapper,
        barData,
        holder,
      );

      verifyInOrder([
        _mockCanvasWrapper.drawDot(
          any,
          const FlSpot(1, 1),
          const Offset(10, 90),
        ),
        _mockCanvasWrapper.drawDot(
          any,
          const FlSpot(2, 2),
          const Offset(20, 80),
        ),
        _mockCanvasWrapper.drawDot(
          any,
          const FlSpot(3, 3),
          const Offset(30, 70),
        ),
        _mockCanvasWrapper.drawDot(
          any,
          const FlSpot(4, 4),
          const Offset(40, 60),
        ),
        _mockCanvasWrapper.drawDot(
          any,
          const FlSpot(5, 5),
          const Offset(50, 50),
        ),
      ]);
    });
  });

  group('drawTouchedSpotsIndicator()', () {
    test('test 1', () {
      const viewSize = Size(400, 400);

      final LineChartBarData lineChartBarData = LineChartBarData(
        show: true,
        spots: const [],
        dotData: FlDotData(show: true),
      );

      final LineChartData data = LineChartData(
        lineBarsData: [lineChartBarData],
        showingTooltipIndicators: [],
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawTouchedSpotsIndicator(
        _mockCanvasWrapper,
        lineChartBarData,
        holder,
      );

      verifyNever(_mockCanvasWrapper.drawPath(any, any));
    });

    test('test 2', () {
      const viewSize = Size(400, 400);

      const spot1 = FlSpot(1, 1);
      const spot2 = FlSpot(2, 2);
      const spot3 = FlSpot(3, 3);
      final LineChartBarData lineChartBarData = LineChartBarData(
          show: true,
          spots: const [spot1, spot2, spot3],
          dotData: FlDotData(show: true),
          showingIndicators: [0, 1]);

      final LineChartData data = LineChartData(
        lineBarsData: [lineChartBarData],
        lineTouchData: LineTouchData(
          enabled: true,
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes.asMap().entries.map((e) {
              final index = e.key;
              final color = index == 0
                  ? const Color(0xFF00FF00)
                  : const Color(0xFF0000FF);
              final strokeWidth = index == 0 ? 8.0 : 12.0;
              return TouchedSpotIndicatorData(
                FlLine(color: color, strokeWidth: strokeWidth),
                FlDotData(show: false),
              );
            }).toList();
          },
        ),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawTouchedSpotsIndicator(
        _mockCanvasWrapper,
        lineChartBarData,
        holder,
      );

      final result = verify(_mockCanvasWrapper.drawPath(any, captureAny));
      result.called(2);

      final Paint paint2 = result.captured[1];
      expect(paint2.color, const Color(0xFF0000FF));
      expect(paint2.strokeWidth, 12);
    });

    test('test 3', () {
      const viewSize = Size(400, 400);

      const spot1 = FlSpot(1, 1);
      const spot2 = FlSpot(2, 2);
      const spot3 = FlSpot(3, 3);
      final LineChartBarData lineChartBarData = LineChartBarData(
          show: true,
          spots: const [spot1, spot2, spot3],
          showingIndicators: [0, 1]);

      final LineChartData data = LineChartData(
        lineBarsData: [lineChartBarData],
        lineTouchData: LineTouchData(
          enabled: true,
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes.asMap().entries.map((e) {
              final index = e.key;
              final color = index == 0
                  ? const Color(0xFF00FF00)
                  : const Color(0xFF0000FF);
              final strokeWidth = index == 0 ? 8.0 : 12.0;
              return TouchedSpotIndicatorData(
                FlLine(color: color, strokeWidth: strokeWidth),
                FlDotData(show: true),
              );
            }).toList();
          },
        ),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawTouchedSpotsIndicator(
        _mockCanvasWrapper,
        lineChartBarData,
        holder,
      );

      final result = verify(_mockCanvasWrapper.drawPath(any, captureAny));
      result.called(2);

      final Paint paint2 = result.captured[1];
      expect(paint2.color, const Color(0xFF0000FF));
      expect(paint2.strokeWidth, 12);

      verify(_mockCanvasWrapper.drawDot(any, any, any)).called(2);
    });
  });
}
