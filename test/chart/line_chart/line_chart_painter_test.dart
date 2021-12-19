import 'dart:math' as math;
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_painter.dart';
import 'package:fl_chart/src/extensions/path_extension.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../data_pool.dart';
import 'line_chart_painter_test.mocks.dart';
import 'dart:ui' as ui show Gradient;

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

      final result =
          verify(_mockCanvasWrapper.drawDashedLine(any, any, captureAny, any));
      result.called(2);

      /// Todo, we can only test last painter due to a bug in mockito.
      /// see more details here: https://github.com/dart-lang/mockito/issues/494
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

      final result =
          verify(_mockCanvasWrapper.drawDashedLine(any, any, captureAny, any));
      result.called(2);

      /// Todo, we can only test last painter due to a bug in mockito.
      /// see more details here: https://github.com/dart-lang/mockito/issues/494
      final Paint paint2 = result.captured[1];
      expect(paint2.color, const Color(0xFF0000FF));
      expect(paint2.strokeWidth, 12);

      verify(_mockCanvasWrapper.drawDot(any, any, any)).called(2);
    });
  });

  group('generateBarPath()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);

      final LineChartBarData lineChartBarData = LineChartBarData(
        show: true,
        spots: const [
          FlSpot(0, 0),
          FlSpot(5, 5),
          FlSpot(10, 0),
        ],
        dotData: FlDotData(show: true),
      );

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        lineBarsData: [lineChartBarData],
        showingTooltipIndicators: [],
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path path = lineChartPainter.generateBarPath(
        viewSize,
        lineChartBarData,
        lineChartBarData.spots,
        holder,
      );

      final iterator = path.computeMetrics().iterator;

      PathMetric? firstMetric, lastMetric;
      while (iterator.moveNext()) {
        firstMetric ??= iterator.current;
        lastMetric = iterator.current;
      }

      final tangent1 = firstMetric!.getTangentForOffset(firstMetric.length / 8);
      final degrees1 = tangent1!.angle * (180 / math.pi);
      expect(degrees1, 45.0);

      final tangent = lastMetric!.getTangentForOffset(
        (lastMetric.length / 8) * 7,
      );
      final degrees = tangent!.angle * (180 / math.pi);
      expect(degrees, -45.0);
    });

    test('test 2', () {
      const viewSize = Size(100, 100);

      final LineChartBarData lineChartBarData = LineChartBarData(
        show: true,
        spots: const [
          FlSpot(0, 0),
          FlSpot(5, 5),
          FlSpot(10, 0),
        ],
        dotData: FlDotData(show: true),
        isStepLineChart: true,
      );

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        lineBarsData: [lineChartBarData],
        showingTooltipIndicators: [],
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path path = lineChartPainter.generateBarPath(
        viewSize,
        lineChartBarData,
        lineChartBarData.spots,
        holder,
      );

      final iterator = path.computeMetrics().iterator;

      PathMetric? firstMetric, lastMetric;
      while (iterator.moveNext()) {
        firstMetric ??= iterator.current;
        lastMetric = iterator.current;
      }

      final tangent1 = firstMetric!.getTangentForOffset(firstMetric.length / 4);
      final degrees1 = tangent1!.angle * (180 / math.pi);
      expect(degrees1, 90.0);

      final tangent2 = lastMetric!.getTangentForOffset(
        (lastMetric.length / 4) * 3,
      );
      final degrees2 = tangent2!.angle * (180 / math.pi);
      expect(degrees2, -90.0);
    });
  });

  group('generateNormalBarPath()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);

      final LineChartBarData lineChartBarData = LineChartBarData(
        show: true,
        spots: const [
          FlSpot(0, 0),
          FlSpot(5, 5),
          FlSpot(10, 0),
        ],
        dotData: FlDotData(show: true),
      );

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        lineBarsData: [lineChartBarData],
        showingTooltipIndicators: [],
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path path = lineChartPainter.generateNormalBarPath(
        viewSize,
        lineChartBarData,
        lineChartBarData.spots,
        holder,
      );

      final iterator = path.computeMetrics().iterator;

      PathMetric? firstMetric, lastMetric;
      while (iterator.moveNext()) {
        firstMetric ??= iterator.current;
        lastMetric = iterator.current;
      }

      final tangent1 = firstMetric!.getTangentForOffset(firstMetric.length / 8);
      final degrees1 = tangent1!.angle * (180 / math.pi);
      expect(degrees1, 45.0);

      final tangent = lastMetric!.getTangentForOffset(
        (lastMetric.length / 8) * 7,
      );
      final degrees = tangent!.angle * (180 / math.pi);
      expect(degrees, -45.0);
    });
  });

  group('generateStepBarPath()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);

      final LineChartBarData lineChartBarData = LineChartBarData(
        show: true,
        spots: const [
          FlSpot(0, 0),
          FlSpot(5, 5),
          FlSpot(10, 0),
        ],
        dotData: FlDotData(show: true),
        isStepLineChart: true,
      );

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        lineBarsData: [lineChartBarData],
        showingTooltipIndicators: [],
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path path = lineChartPainter.generateStepBarPath(
        viewSize,
        lineChartBarData,
        lineChartBarData.spots,
        holder,
      );

      final iterator = path.computeMetrics().iterator;

      PathMetric? firstMetric, lastMetric;
      while (iterator.moveNext()) {
        firstMetric ??= iterator.current;
        lastMetric = iterator.current;
      }

      final tangent1 = firstMetric!.getTangentForOffset(firstMetric.length / 4);
      final degrees1 = tangent1!.angle * (180 / math.pi);
      expect(degrees1, 90.0);

      final tangent2 = lastMetric!.getTangentForOffset(
        (lastMetric.length / 4) * 3,
      );
      final degrees2 = tangent2!.angle * (180 / math.pi);
      expect(degrees2, -90.0);
    });
  });

  group('generateBelowBarPath()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);

      const barSpots = [
        FlSpot(1, 9),
        FlSpot(5, 5),
        FlSpot(8, 9),
      ];

      final LineChartBarData lineChartBarData = LineChartBarData(
        show: true,
        spots: barSpots,
        dotData: FlDotData(show: true),
        isStepLineChart: true,
      );

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        lineBarsData: [lineChartBarData],
        showingTooltipIndicators: [],
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path barPath = Path()
        ..moveTo(10, 10)
        ..lineTo(50, 50)
        ..lineTo(80, 10);

      final Path belowBarPath = lineChartPainter.generateBelowBarPath(
          viewSize, lineChartBarData, barPath, barSpots, holder);

      expect(belowBarPath.getBounds().bottom, 100);
      expect(belowBarPath.getBounds().left, 10);
      expect(belowBarPath.getBounds().right, 80);
      expect(belowBarPath.getBounds().top, 10);
    });
  });

  group('generateAboveBarPath()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);

      const barSpots = [
        FlSpot(1, 9),
        FlSpot(5, 5),
        FlSpot(8, 9),
      ];

      final LineChartBarData lineChartBarData = LineChartBarData(
        show: true,
        spots: barSpots,
        dotData: FlDotData(show: true),
        isStepLineChart: true,
      );

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        lineBarsData: [lineChartBarData],
        showingTooltipIndicators: [],
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path barPath = Path()
        ..moveTo(10, 10)
        ..lineTo(50, 50)
        ..lineTo(80, 10);

      final Path belowBarPath = lineChartPainter.generateAboveBarPath(
          viewSize, lineChartBarData, barPath, barSpots, holder);

      expect(belowBarPath.getBounds().bottom, 50);
      expect(belowBarPath.getBounds().left, 10);
      expect(belowBarPath.getBounds().right, 80);
      expect(belowBarPath.getBounds().top, 0);
    });
  });

  group('drawBelowBar()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);

      const barSpots = [
        FlSpot(1, 9),
        FlSpot(8, 9),
      ];

      final LineChartBarData lineChartBarData = LineChartBarData(
          show: true,
          spots: barSpots,
          dotData: FlDotData(show: true),
          isStepLineChart: true,
          belowBarData: BarAreaData(
              show: true,
              colors: [const Color(0xFFFF0000), const Color(0xFF00FF00)]));

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        lineBarsData: [lineChartBarData],
        showingTooltipIndicators: [],
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path belowBarPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10);

      final Path filletAboveBarPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10)
        ..lineTo(80, 0)
        ..lineTo(10, 0)
        ..lineTo(10, 10);

      lineChartPainter.drawBelowBar(_mockCanvasWrapper, belowBarPath,
          filletAboveBarPath, holder, lineChartBarData);

      final result =
          verify(_mockCanvasWrapper.drawPath(belowBarPath, captureAny));
      result.called(1);

      final paint = result.captured.single as Paint;
      expect(paint.color, const Color(0xFF000000));

      expect(paint.shader is ui.Gradient, true);
    });

    test('test 2', () {
      const viewSize = Size(100, 100);

      const barSpots = [
        FlSpot(1, 9),
        FlSpot(8, 9),
      ];

      final LineChartBarData lineChartBarData = LineChartBarData(
        show: true,
        spots: barSpots,
        dotData: FlDotData(show: true),
        isStepLineChart: true,
        belowBarData: BarAreaData(
          show: true,
          colors: [const Color(0xFFFF0000), const Color(0xFF00FF00)],
          applyCutOffY: true,
          cutOffY: 8,
          spotsLine: BarAreaSpotsLine(
            show: true,
            applyCutOffY: false,
            flLineStyle: FlLine(
              color: const Color(0x00F0F0F0),
              strokeWidth: 18,
            ),
          ),
        ),
      );

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        lineBarsData: [lineChartBarData],
        showingTooltipIndicators: [],
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path belowBarPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10);

      final Path filletAboveBarPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10)
        ..lineTo(80, 0)
        ..lineTo(10, 0)
        ..lineTo(10, 10);

      lineChartPainter.drawBelowBar(_mockCanvasWrapper, belowBarPath,
          filletAboveBarPath, holder, lineChartBarData);

      verify(_mockCanvasWrapper.saveLayer(
              Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), any))
          .called(1);

      final result =
          verify(_mockCanvasWrapper.drawPath(belowBarPath, captureAny));
      result.called(1);
      final paint = result.captured.single as Paint;
      expect(paint.color, const Color(0xFF000000));
      expect(paint.shader is ui.Gradient, true);

      final result2 =
          verify(_mockCanvasWrapper.drawPath(filletAboveBarPath, captureAny));
      result2.called(1);
      final paint2 = result2.captured.single as Paint;
      expect(paint2.color, const Color(0x00000000));
      expect(paint2.blendMode, BlendMode.dstIn);
      expect(paint2.style, PaintingStyle.fill);

      verify(_mockCanvasWrapper.restore()).called(1);

      final result3 =
          verify(_mockCanvasWrapper.drawDashedLine(any, any, captureAny, any));
      result3.called(2);

      /// Todo, we can only test last painter due to a bug in mockito.
      /// see more details here: https://github.com/dart-lang/mockito/issues/494
      for (Paint item in result3.captured) {
        expect(item.color.alpha, 0);
        expect(item.strokeWidth, 18);
      }
    });
  });

  group('drawAboveBar()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);

      const barSpots = [
        FlSpot(1, 9),
        FlSpot(8, 9),
      ];

      final LineChartBarData lineChartBarData = LineChartBarData(
          show: true,
          spots: barSpots,
          dotData: FlDotData(show: true),
          isStepLineChart: true,
          aboveBarData: BarAreaData(
              show: true,
              colors: [const Color(0xFFFF0000), const Color(0xFF00FF00)]));

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        lineBarsData: [lineChartBarData],
        showingTooltipIndicators: [],
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path aboveBarPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10);

      final Path filledBelowBarPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10)
        ..lineTo(80, 0)
        ..lineTo(10, 0)
        ..lineTo(10, 10);

      lineChartPainter.drawAboveBar(_mockCanvasWrapper, aboveBarPath,
          filledBelowBarPath, holder, lineChartBarData);

      final result =
          verify(_mockCanvasWrapper.drawPath(aboveBarPath, captureAny));
      result.called(1);

      final paint = result.captured.single as Paint;
      expect(paint.color, const Color(0xFF000000));

      expect(paint.shader is ui.Gradient, true);
    });

    test('test 2', () {
      const viewSize = Size(100, 100);

      const barSpots = [
        FlSpot(1, 9),
        FlSpot(8, 9),
      ];

      final LineChartBarData lineChartBarData = LineChartBarData(
        show: true,
        spots: barSpots,
        dotData: FlDotData(show: true),
        isStepLineChart: true,
        aboveBarData: BarAreaData(
          show: true,
          colors: [const Color(0xFFFF0000), const Color(0xFF00FF00)],
          applyCutOffY: true,
          cutOffY: 8,
          spotsLine: BarAreaSpotsLine(
            show: true,
            applyCutOffY: false,
            flLineStyle: FlLine(
              color: const Color(0x00F0F0F0),
              strokeWidth: 18,
            ),
          ),
        ),
      );

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        lineBarsData: [lineChartBarData],
        showingTooltipIndicators: [],
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path aboveBarPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10);

      final Path filledBelowBarPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10)
        ..lineTo(80, 0)
        ..lineTo(10, 0)
        ..lineTo(10, 10);

      lineChartPainter.drawAboveBar(_mockCanvasWrapper, aboveBarPath,
          filledBelowBarPath, holder, lineChartBarData);

      verify(_mockCanvasWrapper.saveLayer(
              Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), any))
          .called(1);

      final result =
          verify(_mockCanvasWrapper.drawPath(aboveBarPath, captureAny));
      result.called(1);
      final paint = result.captured.single as Paint;
      expect(paint.color, const Color(0xFF000000));
      expect(paint.shader is ui.Gradient, true);

      final result2 =
          verify(_mockCanvasWrapper.drawPath(filledBelowBarPath, captureAny));
      result2.called(1);
      final paint2 = result2.captured.single as Paint;
      expect(paint2.color, const Color(0x00000000));
      expect(paint2.blendMode, BlendMode.dstIn);
      expect(paint2.style, PaintingStyle.fill);

      verify(_mockCanvasWrapper.restore()).called(1);

      final result3 =
          verify(_mockCanvasWrapper.drawDashedLine(any, any, captureAny, any));
      result3.called(2);

      /// Todo, we can only test last painter due to a bug in mockito.
      /// see more details here: https://github.com/dart-lang/mockito/issues/494
      for (Paint item in result3.captured) {
        expect(item.color.alpha, 0);
        expect(item.strokeWidth, 18);
      }
    });
  });

  group('drawBetweenBar()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);

      const barSpots1 = [
        FlSpot(1, 9),
        FlSpot(8, 9),
      ];

      const barSpots2 = [
        FlSpot(1, 5),
        FlSpot(8, 5),
      ];

      final LineChartBarData lineChartBarData1 = LineChartBarData(
          show: true,
          spots: barSpots1,
          dotData: FlDotData(show: true),
          isStepLineChart: true,
          aboveBarData: BarAreaData(
              show: true,
              colors: [const Color(0xFFFF0000), const Color(0xFF00FF00)]));

      final LineChartBarData lineChartBarData2 = LineChartBarData(
          show: true,
          spots: barSpots2,
          dotData: FlDotData(show: true),
          isStepLineChart: true);

      final betweenBarData1 = BetweenBarsData(
        fromIndex: 0,
        toIndex: 1,
        colors: [
          const Color(0xFFFF0000),
        ],
      );

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        lineBarsData: [lineChartBarData1, lineChartBarData2],
        showingTooltipIndicators: [],
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
        betweenBarsData: [betweenBarData1],
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path aboveBarPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10);

      lineChartPainter.drawBetweenBar(
          _mockCanvasWrapper, aboveBarPath, betweenBarData1, holder);

      verify(_mockCanvasWrapper.saveLayer(
          Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), any));
      final result =
          verify(_mockCanvasWrapper.drawPath(aboveBarPath, captureAny));
      result.called(1);
      final painter = result.captured.single as Paint;
      expect(painter.color, const Color(0xFFFF0000));
      verify(_mockCanvasWrapper.restore());
    });
  });

  group('drawBarShadow()', () {
    test('test 1', () {
      const barSpots1 = [
        FlSpot(1, 9),
        FlSpot(8, 9),
      ];

      final LineChartBarData lineChartBarData1 = LineChartBarData(
        show: true,
        spots: barSpots1,
        dotData: FlDotData(show: true),
        isStepLineChart: true,
        shadow: const Shadow(color: Color(0x0000FF00)),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();

      final Path barPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10);

      lineChartPainter.drawBarShadow(
          _mockCanvasWrapper, barPath, lineChartBarData1);
      verifyNever(_mockCanvasWrapper.drawPath(any, any));
    });

    test('test 2', () {
      const viewSize = Size(100, 100);

      const barSpots1 = [
        FlSpot(1, 9),
        FlSpot(8, 9),
      ];

      final LineChartBarData lineChartBarData1 = LineChartBarData(
        show: true,
        spots: barSpots1,
        dotData: FlDotData(show: true),
        barWidth: 80,
        isStrokeCapRound: true,
        isStepLineChart: true,
        shadow: const Shadow(
          color: Color(0x0100FF00),
          offset: Offset(10, 15),
          blurRadius: 10,
        ),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path barPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10);

      lineChartPainter.drawBarShadow(
          _mockCanvasWrapper, barPath, lineChartBarData1);
      final result =
          verify(_mockCanvasWrapper.drawPath(captureAny, captureAny));
      result.called(1);
      final path = result.captured[0] as Path;
      expect(path.getBounds(), barPath.shift(const Offset(10, 15)).getBounds());

      final paint = result.captured[1] as Paint;
      expect(paint.color, const Color(0x0100FF00));
      expect(paint.shader, null);
      expect(paint.strokeWidth, 80);
      expect(
        paint.maskFilter.toString(),
        MaskFilter.blur(BlurStyle.normal, Utils().convertRadiusToSigma(10))
            .toString(),
      );
      expect(paint.strokeCap, StrokeCap.round);
    });
  });

  group('drawBar()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);

      const barSpots1 = [
        FlSpot(1, 9),
        FlSpot(8, 9),
      ];

      final LineChartBarData lineChartBarData1 = LineChartBarData(
        show: false,
        spots: barSpots1,
        dotData: FlDotData(show: true),
        barWidth: 80,
        isStrokeCapRound: true,
        isStepLineChart: true,
        shadow: const Shadow(
          color: Color(0x0100FF00),
          offset: Offset(10, 15),
          blurRadius: 10,
        ),
      );

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        lineBarsData: [lineChartBarData1],
        showingTooltipIndicators: [],
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path barPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10);

      lineChartPainter.drawBar(
          _mockCanvasWrapper, barPath, lineChartBarData1, holder);
      verifyNever(_mockCanvasWrapper.drawPath(any, any));
    });

    test('test 2', () {
      const viewSize = Size(100, 100);

      const barSpots1 = [
        FlSpot(1, 9),
        FlSpot(8, 9),
      ];

      final LineChartBarData lineChartBarData1 = LineChartBarData(
        show: true,
        spots: barSpots1,
        dotData: FlDotData(show: true),
        barWidth: 80,
        isStrokeCapRound: true,
        isStepLineChart: true,
        colors: [const Color(0xF0F0F0F0)],
        shadow: const Shadow(
          color: Color(0x0100FF00),
          offset: Offset(10, 15),
          blurRadius: 10,
        ),
      );

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        lineBarsData: [lineChartBarData1],
        showingTooltipIndicators: [],
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path barPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10);

      lineChartPainter.drawBar(
          _mockCanvasWrapper, barPath, lineChartBarData1, holder);
      final result =
          verify(_mockCanvasWrapper.drawPath(captureAny, captureAny));
      result.called(1);
      final drewPath = result.captured[0] as Path;
      expect(drewPath, barPath);

      final paint = result.captured[1] as Paint;
      expect(paint.color, const Color(0xF0F0F0F0));
      expect(paint.shader, null);
      expect(paint.maskFilter, null);
      expect(paint.strokeWidth, 80);
    });

    test('test 3', () {
      const viewSize = Size(100, 100);

      const barSpots1 = [
        FlSpot(1, 9),
        FlSpot(8, 9),
      ];

      final LineChartBarData lineChartBarData1 = LineChartBarData(
          show: true,
          spots: barSpots1,
          dotData: FlDotData(show: true),
          barWidth: 80,
          isStrokeCapRound: true,
          isStepLineChart: true,
          colors: [const Color(0xF0F0F0F0), const Color(0x0100FF00)],
          dashArray: [1, 2, 3]);

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        lineBarsData: [lineChartBarData1],
        showingTooltipIndicators: [],
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path barPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10);

      lineChartPainter.drawBar(
          _mockCanvasWrapper, barPath, lineChartBarData1, holder);
      final result =
          verify(_mockCanvasWrapper.drawPath(captureAny, captureAny));
      result.called(1);
      final drewPath = result.captured[0] as Path;
      expect(
        drewPath.computeMetrics().length,
        barPath.toDashedPath([1, 2, 3]).computeMetrics().length,
      );

      final paint = result.captured[1] as Paint;
      expect(paint.shader != null, true);
      expect(paint.maskFilter, null);
      expect(paint.strokeWidth, 80);
    });
  });

  group('drawTitles()', () {
    test('test 1', () {
      final LineChartBarData lineChartBarData1 = LineChartBarData(
        show: false,
        spots: const [
          FlSpot(1, 9),
          FlSpot(8, 9),
        ],
        dotData: FlDotData(show: true),
        barWidth: 80,
        isStrokeCapRound: true,
        isStepLineChart: true,
        shadow: const Shadow(
          color: Color(0x0100FF00),
          offset: Offset(10, 15),
          blurRadius: 10,
        ),
      );

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        lineBarsData: [lineChartBarData1],
        showingTooltipIndicators: [],
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      MockBuildContext _mockBuildContext = MockBuildContext();
      lineChartPainter.drawTitles(
          _mockBuildContext, _mockCanvasWrapper, holder);
      verifyNever(_mockCanvasWrapper.drawText(any, any));
    });

    test('test 2', () {
      const viewSize = Size(100, 100);

      final LineChartBarData lineChartBarData1 = LineChartBarData(
        show: false,
        spots: const [
          FlSpot(1, 9),
          FlSpot(8, 9),
        ],
        dotData: FlDotData(show: true),
        barWidth: 80,
        isStrokeCapRound: true,
        isStepLineChart: true,
        shadow: const Shadow(
          color: Color(0x0100FF00),
          offset: Offset(10, 15),
          blurRadius: 10,
        ),
      );

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 0,
        minX: 1,
        maxX: 1,
        lineBarsData: [lineChartBarData1],
        showingTooltipIndicators: [],
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 84,
            rotateAngle: 33,
            textAlign: TextAlign.right,
            textDirection: TextDirection.ltr,
          ),
          topTitles: SideTitles(showTitles: false),
          rightTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(showTitles: false),
        ),
        axisTitleData: FlAxisTitleData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      MockUtils mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);

      when(mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenAnswer((realInvocation) => 0);
      when(mockUtils.getEfficientInterval(any, any))
          .thenAnswer((realInvocation) => 1);

      MockBuildContext _mockBuildContext = MockBuildContext();

      lineChartPainter.drawTitles(
          _mockBuildContext, _mockCanvasWrapper, holder);

      verifyNever(_mockCanvasWrapper.drawText(any, any, any));
    });

    test('test 3', () {
      const viewSize = Size(100, 100);

      final LineChartBarData lineChartBarData1 = LineChartBarData(
        show: false,
        spots: const [
          FlSpot(1, 9),
          FlSpot(8, 9),
        ],
        dotData: FlDotData(show: true),
        barWidth: 80,
        isStrokeCapRound: true,
        isStepLineChart: true,
        shadow: const Shadow(
          color: Color(0x0100FF00),
          offset: Offset(10, 15),
          blurRadius: 10,
        ),
      );

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        lineBarsData: [lineChartBarData1],
        showingTooltipIndicators: [],
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 84,
            rotateAngle: 33,
            textAlign: TextAlign.right,
            textDirection: TextDirection.ltr,
          ),
          topTitles: SideTitles(showTitles: false),
          rightTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(showTitles: false),
        ),
        axisTitleData: FlAxisTitleData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      MockUtils mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);

      when(mockUtils.getThemeAwareTextStyle(any, any)).thenAnswer(
          (realInvocation) => const TextStyle(color: Color(0xFF00FF00)));

      when(mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenAnswer((realInvocation) => 0);

      when(mockUtils.formatNumber(any)).thenAnswer((realInvocation) {
        final value = realInvocation.positionalArguments[0].toInt();
        if (value == 0) {
          return 'AA-0';
        } else if (value == 1) {
          return 'BB-1';
        }
        return 'SS-${value.toInt()}';
      });

      when(mockUtils.calculateRotationOffset(any, any))
          .thenAnswer((realInvocation) => Offset.zero);

      when(mockUtils.getEfficientInterval(any, any))
          .thenAnswer((realInvocation) => 1);

      MockBuildContext _mockBuildContext = MockBuildContext();

      lineChartPainter.drawTitles(
          _mockBuildContext, _mockCanvasWrapper, holder);

      final result = verify(
          _mockCanvasWrapper.drawText(captureAny, captureAny, captureAny));
      result.called(11);

      final textPainter0 = result.captured[0] as TextPainter;
      final offset0 = result.captured[1] as Offset;
      final rotateAngle0 = result.captured[2] as double;
      expect(textPainter0.width, 84);
      expect((textPainter0.text as TextSpan).text, "AA-0");
      expect(textPainter0.textAlign, TextAlign.right);
      expect(textPainter0.textDirection, TextDirection.ltr);
      expect(offset0.dy, 100 - textPainter0.height / 2);
      expect(rotateAngle0, 33);

      final textPainter1 = result.captured[3] as TextPainter;
      final offset1 = result.captured[4] as Offset;
      final rotateAngle1 = result.captured[5] as double;
      expect(textPainter1.width, 84);
      expect((textPainter1.text as TextSpan).text, "BB-1");
      expect(textPainter1.textAlign, TextAlign.right);
      expect(textPainter1.textDirection, TextDirection.ltr);
      expect(offset1.dy, 90 - textPainter1.height / 2);
      expect(rotateAngle1, 33);

      final textPainter2 = result.captured[6] as TextPainter;
      final offset2 = result.captured[7] as Offset;
      final rotateAngle2 = result.captured[8] as double;
      expect(textPainter2.width, 84);
      expect((textPainter2.text as TextSpan).text, "SS-2");
      expect(textPainter2.textAlign, TextAlign.right);
      expect(textPainter2.textDirection, TextDirection.ltr);
      expect(offset2.dy, 80 - textPainter2.height / 2);
      expect(rotateAngle2, 33);
    });

    test('test 4', () {
      const viewSize = Size(110, 120);

      final LineChartBarData lineChartBarData1 = LineChartBarData(
        show: false,
        spots: const [
          FlSpot(1, 9),
          FlSpot(8, 9),
        ],
        dotData: FlDotData(show: true),
        barWidth: 80,
        isStrokeCapRound: true,
        isStepLineChart: true,
        shadow: const Shadow(
          color: Color(0x0100FF00),
          offset: Offset(10, 15),
          blurRadius: 10,
        ),
      );

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        lineBarsData: [lineChartBarData1],
        showingTooltipIndicators: [],
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(
            showTitles: false,
          ),
          topTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 10,
            rotateAngle: 33,
            textAlign: TextAlign.right,
            textDirection: TextDirection.ltr,
            margin: 0,
          ),
          rightTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 10,
            rotateAngle: 33,
            textAlign: TextAlign.right,
            textDirection: TextDirection.ltr,
            margin: 0,
          ),
          bottomTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 10,
            rotateAngle: 33,
            textAlign: TextAlign.right,
            textDirection: TextDirection.ltr,
            margin: 0,
          ),
        ),
        axisTitleData: FlAxisTitleData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      MockUtils mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);

      when(mockUtils.getThemeAwareTextStyle(any, any)).thenAnswer(
          (realInvocation) => const TextStyle(color: Color(0xFF00FF00)));

      when(mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenAnswer((realInvocation) => 0);

      when(mockUtils.formatNumber(any)).thenAnswer((realInvocation) {
        final value = realInvocation.positionalArguments[0].toInt();
        if (value == 0) {
          return 'AA-0';
        } else if (value == 1) {
          return 'BB-1';
        }
        return 'SS-${value.toInt()}';
      });

      when(mockUtils.calculateRotationOffset(any, any))
          .thenAnswer((realInvocation) => Offset.zero);

      when(mockUtils.getEfficientInterval(any, any))
          .thenAnswer((realInvocation) => 1);

      MockBuildContext _mockBuildContext = MockBuildContext();

      lineChartPainter.drawTitles(
          _mockBuildContext, _mockCanvasWrapper, holder);

      final result = verify(
          _mockCanvasWrapper.drawText(captureAny, captureAny, captureAny));
      result.called(33);

      // Top Titles
      final textPainter0 = result.captured[0] as TextPainter;
      final offset0 = result.captured[1] as Offset;
      final rotateAngle0 = result.captured[2] as double;
      expect((textPainter0.text as TextSpan).text, "AA-0");
      expect(textPainter0.textAlign, TextAlign.right);
      expect(textPainter0.textDirection, TextDirection.ltr);
      expect(offset0.dx, -textPainter0.width / 2);
      expect(rotateAngle0, 33);

      final textPainter1 = result.captured[3] as TextPainter;
      final offset1 = result.captured[4] as Offset;
      final rotateAngle1 = result.captured[5] as double;
      expect((textPainter1.text as TextSpan).text, "BB-1");
      expect(textPainter1.textAlign, TextAlign.right);
      expect(textPainter1.textDirection, TextDirection.ltr);
      expect(offset1.dx, 10 - textPainter1.width / 2);
      expect(rotateAngle1, 33);

      final textPainter2 = result.captured[6] as TextPainter;
      final offset2 = result.captured[7] as Offset;
      final rotateAngle2 = result.captured[8] as double;
      expect((textPainter2.text as TextSpan).text, "SS-2");
      expect(textPainter2.textAlign, TextAlign.right);
      expect(textPainter2.textDirection, TextDirection.ltr);
      expect(offset2.dx, 20 - textPainter2.width / 2);
      expect(rotateAngle2, 33);

      // right titles
      final textPainter3 = result.captured[33] as TextPainter;
      final offset3 = result.captured[34] as Offset;
      final rotateAngle3 = result.captured[35] as double;
      expect(textPainter3.width, 10);
      expect((textPainter3.text as TextSpan).text, "AA-0");
      expect(textPainter3.textAlign, TextAlign.right);
      expect(textPainter3.textDirection, TextDirection.ltr);
      expect(offset3.dy, 100 - textPainter3.height / 2 + 10);
      expect(rotateAngle3, 33);

      final textPainter4 = result.captured[36] as TextPainter;
      final offset4 = result.captured[37] as Offset;
      final rotateAngle4 = result.captured[38] as double;
      expect(textPainter4.width, 10);
      expect((textPainter4.text as TextSpan).text, "BB-1");
      expect(textPainter4.textAlign, TextAlign.right);
      expect(textPainter4.textDirection, TextDirection.ltr);
      expect(offset4.dy, 90 - textPainter4.height / 2 + 10);
      expect(rotateAngle4, 33);

      final textPainter5 = result.captured[39] as TextPainter;
      final offset5 = result.captured[40] as Offset;
      final rotateAngle5 = result.captured[41] as double;
      expect(textPainter5.width, 10);
      expect((textPainter5.text as TextSpan).text, "SS-2");
      expect(textPainter5.textAlign, TextAlign.right);
      expect(textPainter5.textDirection, TextDirection.ltr);
      expect(offset5.dy, 80 - textPainter5.height / 2 + 10);
      expect(rotateAngle5, 33);
    });
  });

  group('drawExtraLines()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);

      final LineChartData data = LineChartData(
          minY: 0,
          maxY: 10,
          minX: 0,
          maxX: 10,
          titlesData: FlTitlesData(show: false),
          axisTitleData: FlAxisTitleData(show: false),
          extraLinesData:
              ExtraLinesData(horizontalLines: [], verticalLines: []));

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      MockBuildContext _mockBuildContext = MockBuildContext();

      lineChartPainter.drawExtraLines(
          _mockBuildContext, _mockCanvasWrapper, holder);

      verifyNever(_mockCanvasWrapper.drawDashedLine(any, any, any, captureAny));
    });

    test('test 2', () {
      const viewSize = Size(100, 100);

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      MockBuildContext _mockBuildContext = MockBuildContext();

      lineChartPainter.drawExtraLines(
          _mockBuildContext, _mockCanvasWrapper, holder);

      verifyNever(_mockCanvasWrapper.drawDashedLine(any, any, any, captureAny));
    });

    test('test 3', () {
      const viewSize = Size(100, 100);

      final LineChartData data = LineChartData(
          minY: 0,
          maxY: 10,
          minX: 0,
          maxX: 10,
          titlesData: FlTitlesData(show: false),
          axisTitleData: FlAxisTitleData(show: false),
          extraLinesData: ExtraLinesData(horizontalLines: [
            HorizontalLine(
                y: 1, color: const Color(0x11111111), strokeWidth: 11),
            HorizontalLine(
                y: 2, color: const Color(0x22222222), strokeWidth: 22),
          ], verticalLines: [
            VerticalLine(x: 4, color: const Color(0x33333333), strokeWidth: 33),
            VerticalLine(x: 5, color: const Color(0x44444444), strokeWidth: 44),
          ]));

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      MockBuildContext _mockBuildContext = MockBuildContext();

      lineChartPainter.drawExtraLines(
          _mockBuildContext, _mockCanvasWrapper, holder);

      final result = verify(_mockCanvasWrapper.drawDashedLine(
          captureAny, captureAny, captureAny, captureAny));
      result.called(4);

      final from0 = result.captured[0] as Offset;
      final to0 = result.captured[1] as Offset;
      expect(from0, const Offset(0, 90));
      expect(to0, const Offset(100, 90));

      final from1 = result.captured[4] as Offset;
      final to1 = result.captured[5] as Offset;
      expect(from1, const Offset(0, 80));
      expect(to1, const Offset(100, 80));

      final from2 = result.captured[8] as Offset;
      final to2 = result.captured[9] as Offset;
      expect(from2, const Offset(40, 0));
      expect(to2, const Offset(40, 100));

      final from3 = result.captured[12] as Offset;
      final to3 = result.captured[13] as Offset;
      final paint3 = result.captured[14] as Paint;

      /// Todo, we can only test last painter due to a bug in mockito.
      /// see more details here: https://github.com/dart-lang/mockito/issues/494
      expect(paint3.color, const Color(0x44444444));
      expect(paint3.strokeWidth, 44);
      expect(from3, const Offset(50, 0));
      expect(to3, const Offset(50, 100));
    });
  });
}
