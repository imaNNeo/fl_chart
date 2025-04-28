import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/candlestick_chart/candlestick_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../helper_methods.dart';
import '../data_pool.dart';
import 'candlestick_chart_painter_test.mocks.dart';

@GenerateMocks([Canvas, CanvasWrapper, BuildContext, Utils])
void main() {
  group('paint()', () {
    test('test 1 - simple paint call', () {
      final utilsMainInstance = Utils();
      const viewSize = Size(400, 400);
      final data = CandlestickChartData(
        candlestickSpots: [
          candlestickSpot1,
          candlestickSpot2,
          candlestickSpot3,
        ],
        clipData: const FlClipData.all(),
      );

      final candlestickPainter = CandlestickChartPainter();
      final holder = PaintHolder<CandlestickChartData>(
        data,
        data,
        TextScaler.noScaling,
      );

      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getEfficientInterval(any, any))
          .thenAnswer((realInvocation) => 1.0);
      when(mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenAnswer((realInvocation) => 1.0);
      final mockBuildContext = MockBuildContext();
      final mockCanvas = MockCanvas();
      final canvasWrapper = CanvasWrapper(mockCanvas, viewSize);
      candlestickPainter.paint(
        mockBuildContext,
        canvasWrapper,
        holder,
      );

      verify(mockCanvas.clipRect(any)).called(1);
      verify(mockCanvas.drawLine(any, any, any)).called(6);
      Utils.changeInstance(utilsMainInstance);
    });
  });

  group('drawAxisSpotIndicator()', () {
    test('test 1 - draw both lines', () {
      final utilsMainInstance = Utils();
      const viewSize = Size(400, 400);
      final data = CandlestickChartData(
        minX: 0,
        maxX: 100,
        minY: 0,
        maxY: 100,
        gridData: const FlGridData(show: false),
        touchedPointIndicator: AxisSpotIndicator(
          x: 50,
          y: 50,
          painter: AxisLinesIndicatorPainter(
            verticalLineProvider: (x) => VerticalLine(
              x: x,
              color: MockData.color2,
              strokeWidth: 8,
            ),
            horizontalLineProvider: (y) => HorizontalLine(
              y: y,
              color: MockData.color1,
              strokeWidth: 4,
              dashArray: [0, 1, 0],
            ),
          ),
        ),
      );

      final candlestickPainter = CandlestickChartPainter();
      final holder = PaintHolder<CandlestickChartData>(
        data,
        data,
        TextScaler.noScaling,
      );

      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getEfficientInterval(any, any))
          .thenAnswer((realInvocation) => 1.0);
      when(mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenAnswer((realInvocation) => 1.0);
      final mockBuildContext = MockBuildContext();
      final mockCanvas = MockCanvas();
      final canvasWrapper = CanvasWrapper(mockCanvas, viewSize);
      final drawCalls = <(Path, Color, double)>[];
      when(mockCanvas.drawPath(any, any)).thenAnswer((invocation) {
        drawCalls.add(
          (
            invocation.positionalArguments[0] as Path,
            (invocation.positionalArguments[1] as Paint).color,
            (invocation.positionalArguments[1] as Paint).strokeWidth,
          ),
        );
      });

      candlestickPainter.paint(
        mockBuildContext,
        canvasWrapper,
        holder,
      );

      expect(drawCalls.length, 2);

      // Horizontal line
      expect(drawCalls[0].$1.getBounds().left, 0);
      expect(drawCalls[0].$1.getBounds().right, 400);
      expect(drawCalls[0].$1.getBounds().top, 200);
      expect(drawCalls[0].$1.getBounds().bottom, 200);
      expect(drawCalls[0].$2.toARGB32(), MockData.color1.toARGB32());
      expect(drawCalls[0].$3, 4);

      /// Vertical line
      expect(drawCalls[1].$1.getBounds().left, 200);
      expect(drawCalls[1].$1.getBounds().right, 200);
      expect(drawCalls[1].$1.getBounds().top, 0);
      expect(drawCalls[1].$1.getBounds().bottom, 400);
      expect(drawCalls[1].$2.toARGB32(), MockData.color2.toARGB32());
      expect(drawCalls[1].$3, 8);

      Utils.changeInstance(utilsMainInstance);
    });

    test('test 1 - draw only horizontal line', () {
      final utilsMainInstance = Utils();
      const viewSize = Size(400, 400);
      final data = CandlestickChartData(
        minX: 0,
        maxX: 100,
        minY: 0,
        maxY: 100,
        gridData: const FlGridData(show: false),
        touchedPointIndicator: AxisSpotIndicator(
          y: 50,
          painter: AxisLinesIndicatorPainter(
            verticalLineProvider: null,
            horizontalLineProvider: (y) => HorizontalLine(
              y: y,
              color: MockData.color1,
              strokeWidth: 4,
            ),
          ),
        ),
      );

      final candlestickPainter = CandlestickChartPainter();
      final holder = PaintHolder<CandlestickChartData>(
        data,
        data,
        TextScaler.noScaling,
      );

      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getEfficientInterval(any, any))
          .thenAnswer((realInvocation) => 1.0);
      when(mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenAnswer((realInvocation) => 1.0);
      final mockBuildContext = MockBuildContext();
      final mockCanvas = MockCanvas();
      final canvasWrapper = CanvasWrapper(mockCanvas, viewSize);
      final drawCalls = <(Path, Color, double)>[];
      when(mockCanvas.drawPath(any, any)).thenAnswer((invocation) {
        drawCalls.add(
          (
            invocation.positionalArguments[0] as Path,
            (invocation.positionalArguments[1] as Paint).color,
            (invocation.positionalArguments[1] as Paint).strokeWidth,
          ),
        );
      });

      candlestickPainter.paint(
        mockBuildContext,
        canvasWrapper,
        holder,
      );

      expect(drawCalls.length, 1);

      // Horizontal line
      expect(drawCalls[0].$1.getBounds().left, 0);
      expect(drawCalls[0].$1.getBounds().right, 400);
      expect(drawCalls[0].$1.getBounds().top, 200);
      expect(drawCalls[0].$1.getBounds().bottom, 200);
      expect(drawCalls[0].$2.toARGB32(), MockData.color1.toARGB32());
      expect(drawCalls[0].$3, 4);

      Utils.changeInstance(utilsMainInstance);
    });

    test('test 1 - draw no line', () {
      final utilsMainInstance = Utils();
      const viewSize = Size(400, 400);
      final data = CandlestickChartData(
        minX: 0,
        maxX: 100,
        minY: 0,
        maxY: 100,
      );

      final candlestickPainter = CandlestickChartPainter();
      final holder = PaintHolder<CandlestickChartData>(
        data,
        data,
        TextScaler.noScaling,
      );

      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getEfficientInterval(any, any))
          .thenAnswer((realInvocation) => 1.0);
      when(mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenAnswer((realInvocation) => 1.0);
      final mockBuildContext = MockBuildContext();
      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      final drawCalls = <(Offset, Offset, Color, double)>[];
      when(mockCanvasWrapper.drawLine(any, any, any)).thenAnswer((invocation) {
        drawCalls.add(
          (
            invocation.positionalArguments[0] as Offset,
            invocation.positionalArguments[1] as Offset,
            (invocation.positionalArguments[2] as Paint).color,
            (invocation.positionalArguments[2] as Paint).strokeWidth,
          ),
        );
      });

      candlestickPainter.paint(
        mockBuildContext,
        mockCanvasWrapper,
        holder,
      );

      expect(drawCalls.length, 0);

      Utils.changeInstance(utilsMainInstance);
    });
  });

  group('drawCandlesticks()', () {
    test('test 1 - check drawing candlesticks', () {
      final utilsMainInstance = Utils();
      const viewSize = Size(400, 400);
      final data = CandlestickChartData(
        candlestickSpots: [
          candlestickSpot1,
          candlestickSpot2,
          candlestickSpot3,
        ],
        candlestickPainter: DefaultCandlestickPainter(
          candlestickStyleProvider: (CandlestickSpot spot, int index) {
            final generalColor =
                spot.isUp ? const Color(0xFF4CAF50) : const Color(0xFFEF5350);
            return CandlestickStyle(
              lineColor: generalColor,
              lineWidth: (1 + index).toDouble(),
              bodyStrokeColor: generalColor,
              bodyStrokeWidth: (1 + index).toDouble(),
              bodyFillColor: generalColor,
              bodyWidth: (4 + index).toDouble(),
              bodyRadius: index.toDouble(),
            );
          },
        ),
      );

      final candlestickPainter = CandlestickChartPainter();
      final holder = PaintHolder<CandlestickChartData>(
        data,
        data,
        TextScaler.noScaling,
      );

      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getEfficientInterval(any, any))
          .thenAnswer((realInvocation) => 1.0);
      when(mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenAnswer((realInvocation) => 1.0);
      final mockBuildContext = MockBuildContext();
      final mockCanvas = MockCanvas();
      final canvasWrapper = CanvasWrapper(mockCanvas, viewSize);
      final lineDrawCalls = <(Offset, Offset, Color, double)>[];
      when(mockCanvas.drawLine(any, any, any)).thenAnswer((invocation) {
        lineDrawCalls.add(
          (
            invocation.positionalArguments[0] as Offset,
            invocation.positionalArguments[1] as Offset,
            (invocation.positionalArguments[2] as Paint).color,
            (invocation.positionalArguments[2] as Paint).strokeWidth,
          ),
        );
      });

      final rrectDrawCalls = <(RRect, Color, double)>[];
      when(mockCanvas.drawRRect(any, any)).thenAnswer((invocation) {
        rrectDrawCalls.add(
          (
            invocation.positionalArguments[0] as RRect,
            (invocation.positionalArguments[1] as Paint).color,
            (invocation.positionalArguments[1] as Paint).strokeWidth,
          ),
        );
      });

      candlestickPainter.paint(
        mockBuildContext,
        canvasWrapper,
        holder,
      );

      expect(lineDrawCalls.length, 6);
      expect(rrectDrawCalls.length, 6);

      final expectedLines = [
        (const Offset(0, 400), const Offset(0, 366.7)),
        (const Offset(0, 66.7), const Offset(0, 333.3)),
        (const Offset(200, 366.7), const Offset(200, 333.3)),
        (const Offset(200, 33.3), const Offset(200, 300)),
        (const Offset(400, 333.3), const Offset(400, 300)),
        (const Offset(400, 0), const Offset(400, 266.7)),
      ];

      final expectedLineColors = [
        const Color(0xFF4CAF50),
        const Color(0xFF4CAF50),
        const Color(0xFFEF5350),
        const Color(0xFFEF5350),
        const Color(0xFF4CAF50),
        const Color(0xFF4CAF50),
      ];

      final expectedLineWidths = [
        1.0,
        1.0,
        2.0,
        2.0,
        3.0,
        3.0,
      ];

      final expectedRRectCalls = <({
        double width,
        double height,
        double radius,
        Color color,
        double strokeWidth,
      })>[
        (
          width: 4,
          height: 33.3,
          radius: 0,
          color: const Color(0xFF4CAF50),
          strokeWidth: 1,
        ),
        (
          width: 4,
          height: 33.3,
          radius: 0,
          color: const Color(0xFF4CAF50),
          strokeWidth: 1,
        ),
        (
          width: 5,
          height: 33.3,
          radius: 1,
          color: const Color(0xFFEF5350),
          strokeWidth: 2,
        ),
        (
          width: 5,
          height: 33.3,
          radius: 1,
          color: const Color(0xFFEF5350),
          strokeWidth: 2,
        ),
        (
          width: 6,
          height: 33.3,
          radius: 2,
          color: const Color(0xFF4CAF50),
          strokeWidth: 3,
        ),
        (
          width: 7,
          height: 33.3,
          radius: 2,
          color: const Color(0xFF4CAF50),
          strokeWidth: 3,
        ),
      ];

      for (var i = 0; i < lineDrawCalls.length; i += 2) {
        // bottom line
        expect(
          HelperMethods.equalsOffsets(lineDrawCalls[i].$1, expectedLines[i].$1),
          true,
        );
        expect(
          HelperMethods.equalsOffsets(lineDrawCalls[i].$2, expectedLines[i].$2),
          true,
        );
        expect(
          lineDrawCalls[i].$3.toARGB32(),
          expectedLineColors[i].toARGB32(),
        );
        expect(lineDrawCalls[i].$4, expectedLineWidths[i]);

        // top line
        expect(
          HelperMethods.equalsOffsets(
            lineDrawCalls[i + 1].$1,
            expectedLines[i + 1].$1,
          ),
          true,
        );
        expect(
          HelperMethods.equalsOffsets(
            lineDrawCalls[i + 1].$2,
            expectedLines[i + 1].$2,
          ),
          true,
        );
        expect(
          lineDrawCalls[i + 1].$3.toARGB32(),
          expectedLineColors[i + 1].toARGB32(),
        );
        expect(lineDrawCalls[i + 1].$4, expectedLineWidths[i + 1]);

        // body
        expect(
          rrectDrawCalls[i].$1.blRadiusX,
          closeTo(expectedRRectCalls[i].radius, 0.1),
        );
        expect(
          rrectDrawCalls[i].$1.width,
          closeTo(expectedRRectCalls[i].width, 0.1),
        );
        expect(
          rrectDrawCalls[i].$1.height,
          closeTo(expectedRRectCalls[i].height, 0.1),
        );
        expect(
          rrectDrawCalls[i].$2.toARGB32(),
          expectedRRectCalls[i].color.toARGB32(),
        );

        // body stroke
        expect(rrectDrawCalls[i + 1].$3, expectedRRectCalls[i + 1].strokeWidth);
        expect(
          rrectDrawCalls[i + 1].$1.blRadiusY,
          expectedRRectCalls[i].radius,
        );
      }

      Utils.changeInstance(utilsMainInstance);
    });
  });

  group('drawTouchTooltips()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);

      final data = CandlestickChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        candlestickSpots: [
          candlestickSpot1,
          candlestickSpot2,
          candlestickSpot3,
          candlestickSpot4,
        ],
        showingTooltipIndicators: [0, 3],
        titlesData: const FlTitlesData(show: false),
      );

      final candlestickChartPainter = CandlestickChartPainter();
      final holder = PaintHolder<CandlestickChartData>(
        data,
        data,
        TextScaler.noScaling,
      );
      final mockCanvasWrapper = MockCanvasWrapper();
      final mockBuildContext = MockBuildContext();
      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(const TextStyle(color: Color(0x00ffffff)));
      when(mockUtils.calculateRotationOffset(any, any)).thenReturn(Offset.zero);
      when(mockCanvasWrapper.size).thenReturn(viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      candlestickChartPainter.drawTouchTooltips(
        mockBuildContext,
        mockCanvasWrapper,
        holder,
      );

      verify(
        mockCanvasWrapper.drawRotated(
          size: anyNamed('size'),
          rotationOffset: anyNamed('rotationOffset'),
          drawOffset: anyNamed('drawOffset'),
          angle: anyNamed('angle'),
          drawCallback: anyNamed('drawCallback'),
        ),
      ).called(2);
    });
  });

  group('drawTouchTooltip()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);

      final data = CandlestickChartData(
        minY: 0,
        maxY: 1000,
        minX: 0,
        maxX: 1000,
        candlestickSpots: [
          candlestickSpot1,
          candlestickSpot2,
          candlestickSpot3,
          candlestickSpot4,
        ],
        showingTooltipIndicators: [0, 2, 3],
        titlesData: const FlTitlesData(show: false),
        candlestickTouchData: CandlestickTouchData(
          touchTooltipData: CandlestickTouchTooltipData(
            rotateAngle: 18,
            getTooltipColor: (touchedSpot) => const Color(0xFF00FF00),
            tooltipBorderRadius: const BorderRadius.only(
              topLeft: Radius.circular(85),
              topRight: Radius.circular(8),
            ),
            tooltipPadding: const EdgeInsets.all(12),
            getTooltipItems: (_, __, ___) {
              return CandlestickTooltipItem(
                'faketext',
                textStyle: textStyle1,
                textAlign: TextAlign.left,
                textDirection: TextDirection.rtl,
                children: [
                  textSpan2,
                  textSpan1,
                ],
              );
            },
          ),
        ),
      );

      final candlestickChartPainter = CandlestickChartPainter();
      final holder = PaintHolder<CandlestickChartData>(
        data,
        data,
        TextScaler.noScaling,
      );
      final mockCanvasWrapper = MockCanvasWrapper();
      final mockBuildContext = MockBuildContext();
      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getThemeAwareTextStyle(any, any)).thenReturn(textStyle2);
      when(mockUtils.calculateRotationOffset(any, any)).thenReturn(Offset.zero);
      when(mockCanvasWrapper.size).thenReturn(viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      candlestickChartPainter.drawTouchTooltip(
        mockBuildContext,
        mockCanvasWrapper,
        data.candlestickTouchData.touchTooltipData,
        candlestickSpot1,
        0,
        holder,
      );

      final verificationResult = verify(
        mockCanvasWrapper.drawRotated(
          size: anyNamed('size'),
          drawOffset: anyNamed('drawOffset'),
          angle: 18,
          drawCallback: captureAnyNamed('drawCallback'),
        ),
      );

      final passedDrawCallback =
          verificationResult.captured.first as DrawCallback;
      passedDrawCallback();

      verificationResult.called(1);

      final captured2 = verifyInOrder([
        mockCanvasWrapper.drawRRect(captureAny, captureAny),
        mockCanvasWrapper.drawText(captureAny, any),
      ]).captured;

      final rRect = captured2[0][0] as RRect;
      final bgPaint = captured2[0][1] as Paint;
      final textPainter = captured2[1][0] as TextPainter;

      expect(rRect.blRadiusX, 0);
      expect(rRect.blRadiusY, 0);
      expect(rRect.tlRadiusY, 85);
      expect(rRect.trRadiusX, 8);

      expect(bgPaint.color, const Color(0xFF00FF00));
      expect(
        textPainter.text,
        const TextSpan(
          style: textStyle2,
          text: 'faketext',
          children: [
            textSpan2,
            textSpan1,
          ],
        ),
      );
    });

    test('test 2', () {
      const viewSize = Size(100, 100);

      final data = CandlestickChartData(
        minY: 0,
        maxY: 1000,
        minX: 0,
        maxX: 1000,
        candlestickSpots: [
          candlestickSpot1,
          candlestickSpot2,
          candlestickSpot3,
          candlestickSpot4,
        ],
        showingTooltipIndicators: [0, 2, 3],
        titlesData: const FlTitlesData(show: false),
        candlestickTouchData: CandlestickTouchData(
          touchTooltipData: CandlestickTouchTooltipData(
            rotateAngle: 18,
            getTooltipColor: (touchedSpot) => const Color(0xFFFFFF00),
            tooltipBorderRadius: BorderRadius.circular(22),
            fitInsideHorizontally: false,
            fitInsideVertically: true,
            tooltipPadding: const EdgeInsets.all(12),
            tooltipHorizontalAlignment: FLHorizontalAlignment.left,
            getTooltipItems: (_, __, ___) => CandlestickTooltipItem(
              'faketext',
              textStyle: textStyle2,
              textAlign: TextAlign.right,
              textDirection: TextDirection.ltr,
              children: [
                textSpan1,
                textSpan2,
              ],
            ),
          ),
        ),
      );

      final candlestickChartPainter = CandlestickChartPainter();
      final holder = PaintHolder<CandlestickChartData>(
        data,
        data,
        TextScaler.noScaling,
      );
      final mockCanvasWrapper = MockCanvasWrapper();
      final mockBuildContext = MockBuildContext();
      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getThemeAwareTextStyle(any, any)).thenReturn(textStyle1);
      when(mockUtils.calculateRotationOffset(any, any)).thenReturn(Offset.zero);
      when(mockCanvasWrapper.size).thenReturn(viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      candlestickChartPainter.drawTouchTooltip(
        mockBuildContext,
        mockCanvasWrapper,
        data.candlestickTouchData.touchTooltipData,
        candlestickSpot1,
        0,
        holder,
      );

      final verificationResult = verify(
        mockCanvasWrapper.drawRotated(
          size: anyNamed('size'),
          drawOffset: anyNamed('drawOffset'),
          angle: 18,
          drawCallback: captureAnyNamed('drawCallback'),
        ),
      );

      final passedDrawCallback =
          verificationResult.captured.first as DrawCallback;
      passedDrawCallback();

      verificationResult.called(1);

      final captured2 = verifyInOrder([
        mockCanvasWrapper.drawRRect(captureAny, captureAny),
        mockCanvasWrapper.drawText(captureAny, any),
      ]).captured;

      final rRect = captured2[0][0] as RRect;
      final bgPaint = captured2[0][1] as Paint;
      final textPainter = captured2[1][0] as TextPainter;

      expect(rRect.blRadiusX, 22);
      expect(rRect.tlRadiusY, 22);

      expect(rRect.left, -144);

      expect(bgPaint.color, const Color(0xFFFFFF00));
      expect(
        textPainter.text,
        const TextSpan(
          style: textStyle1,
          text: 'faketext',
          children: [
            textSpan1,
            textSpan2,
          ],
        ),
      );
    });

    test('test 3', () {
      const viewSize = Size(100, 100);

      final data = CandlestickChartData(
        minY: 0,
        maxY: 1000,
        minX: 0,
        maxX: 1000,
        candlestickSpots: [
          candlestickSpot1,
          candlestickSpot2,
          candlestickSpot3,
          candlestickSpot4,
        ],
        showingTooltipIndicators: [0, 2, 3],
        titlesData: const FlTitlesData(show: false),
        candlestickTouchData: CandlestickTouchData(
          touchTooltipData: CandlestickTouchTooltipData(
            rotateAngle: 18,
            getTooltipColor: (touchedSpot) => const Color(0xFFFFFF00),
            tooltipBorderRadius: BorderRadius.circular(22),
            fitInsideHorizontally: false,
            fitInsideVertically: true,
            tooltipPadding: const EdgeInsets.all(12),
            tooltipHorizontalAlignment: FLHorizontalAlignment.right,
            getTooltipItems: (_, __, ___) => CandlestickTooltipItem(
              'faketext',
              textStyle: textStyle2,
              textAlign: TextAlign.right,
              textDirection: TextDirection.ltr,
              children: [
                textSpan1,
                textSpan2,
              ],
            ),
          ),
        ),
      );

      final candlestickChartPainter = CandlestickChartPainter();
      final holder = PaintHolder<CandlestickChartData>(
        data,
        data,
        TextScaler.noScaling,
      );
      final mockCanvasWrapper = MockCanvasWrapper();
      final mockBuildContext = MockBuildContext();
      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getThemeAwareTextStyle(any, any)).thenReturn(textStyle1);
      when(mockUtils.calculateRotationOffset(any, any)).thenReturn(Offset.zero);
      when(mockCanvasWrapper.size).thenReturn(viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      candlestickChartPainter.drawTouchTooltip(
        mockBuildContext,
        mockCanvasWrapper,
        data.candlestickTouchData.touchTooltipData,
        candlestickSpot1,
        0,
        holder,
      );

      final verificationResult = verify(
        mockCanvasWrapper.drawRotated(
          size: anyNamed('size'),
          drawOffset: anyNamed('drawOffset'),
          angle: 18,
          drawCallback: captureAnyNamed('drawCallback'),
        ),
      );

      final passedDrawCallback =
          verificationResult.captured.first as DrawCallback;
      passedDrawCallback();

      verificationResult.called(1);

      final captured2 = verifyInOrder([
        mockCanvasWrapper.drawRRect(captureAny, captureAny),
        mockCanvasWrapper.drawText(captureAny, any),
      ]).captured;

      final rRect = captured2[0][0] as RRect;
      final bgPaint = captured2[0][1] as Paint;
      final textPainter = captured2[1][0] as TextPainter;

      expect(rRect.blRadiusX, 22);
      expect(rRect.tlRadiusY, 22);

      expect(rRect.left, 0);

      expect(bgPaint.color, const Color(0xFFFFFF00));
      expect(
        textPainter.text,
        const TextSpan(
          style: textStyle1,
          text: 'faketext',
          children: [
            textSpan1,
            textSpan2,
          ],
        ),
      );
    });

    test('test 4', () {
      const viewSize = Size(100, 100);

      final data = CandlestickChartData(
        candlestickSpots: [
          candlestickSpot1,
          candlestickSpot2,
          candlestickSpot3,
          candlestickSpot4,
        ],
        showingTooltipIndicators: [0, 1, 2, 3],
        titlesData: const FlTitlesData(show: false),
        candlestickTouchData: CandlestickTouchData(
          touchTooltipData: CandlestickTouchTooltipData(
            rotateAngle: 18,
            getTooltipColor: (touchedSpot) => const Color(0xFFFFFF00),
            tooltipBorderRadius: BorderRadius.circular(22),
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            tooltipPadding: const EdgeInsets.all(12),
            tooltipHorizontalAlignment: FLHorizontalAlignment.right,
            tooltipBorder: const BorderSide(
              color: Color(0xFF00FF00),
              width: 2,
            ),
            getTooltipItems: (_, __, ___) => CandlestickTooltipItem(
              'faketext',
              textStyle: textStyle2,
              textAlign: TextAlign.right,
              textDirection: TextDirection.ltr,
              children: [
                textSpan1,
                textSpan2,
              ],
            ),
          ),
        ),
      );

      final candlestickChartPainter = CandlestickChartPainter();
      final holder = PaintHolder<CandlestickChartData>(
        data,
        data,
        TextScaler.noScaling,
      );
      final mockCanvasWrapper = MockCanvasWrapper();
      final mockBuildContext = MockBuildContext();
      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getThemeAwareTextStyle(any, any)).thenReturn(textStyle1);
      when(mockUtils.calculateRotationOffset(any, any)).thenReturn(Offset.zero);
      when(mockCanvasWrapper.size).thenReturn(viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      candlestickChartPainter.drawTouchTooltip(
        mockBuildContext,
        mockCanvasWrapper,
        data.candlestickTouchData.touchTooltipData,
        candlestickSpot1,
        0,
        holder,
      );

      final verificationResult = verify(
        mockCanvasWrapper.drawRotated(
          size: anyNamed('size'),
          drawOffset: anyNamed('drawOffset'),
          angle: 18,
          drawCallback: captureAnyNamed('drawCallback'),
        ),
      );

      final passedDrawCallback =
          verificationResult.captured.first as DrawCallback;
      passedDrawCallback();

      verificationResult.called(1);

      final captured2 = verifyInOrder([
        mockCanvasWrapper.drawRRect(captureAny, captureAny),
        mockCanvasWrapper.drawText(captureAny, any),
      ]).captured;

      final rRect = captured2[0][0] as RRect;
      final bgPaint = captured2[0][1] as Paint;
      final textPainter = captured2[1][0] as TextPainter;

      expect(rRect.blRadiusX, 22);
      expect(rRect.tlRadiusY, 22);

      expect(rRect.left, -44);

      expect(bgPaint.color, const Color(0xFFFFFF00));
      expect(
        textPainter.text,
        const TextSpan(
          style: textStyle1,
          text: 'faketext',
          children: [
            textSpan1,
            textSpan2,
          ],
        ),
      );
    });
  });

  group('handleTouch()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);
      final spots = [
        candlestickSpot1,
        candlestickSpot2,
        candlestickSpot3,
        candlestickSpot4,
      ];

      final data = CandlestickChartData(
        minY: 0,
        maxY: 150,
        minX: 0,
        maxX: 30,
        titlesData: const FlTitlesData(show: false),
        candlestickSpots: spots,
        candlestickTouchData: CandlestickTouchData(
          touchSpotThreshold: 5,
        ),
      );

      final candlestickChartPainter = CandlestickChartPainter();
      final holder = PaintHolder<CandlestickChartData>(
        data,
        data,
        TextScaler.noScaling,
      );
      expect(
        candlestickChartPainter
            .handleTouch(
              const Offset(0, 1),
              viewSize,
              holder,
            )!
            .spot,
        spots[0],
      );

      expect(
        candlestickChartPainter
            .handleTouch(
              const Offset(0, 100),
              viewSize,
              holder,
            )!
            .spot,
        spots[0],
      );

      expect(
        candlestickChartPainter
            .handleTouch(
              const Offset(5, 100),
              viewSize,
              holder,
            )!
            .spot,
        spots[0],
      );

      expect(
        candlestickChartPainter.handleTouch(
          const Offset(6, 100),
          viewSize,
          holder,
        ),
        null,
      );

      expect(
        candlestickChartPainter
            .handleTouch(
              const Offset((1 / 3) * 100, 100),
              viewSize,
              holder,
            )!
            .spot,
        spots[1],
      );

      expect(
        candlestickChartPainter
            .handleTouch(
              const Offset((1 / 3) * 100, 0),
              viewSize,
              holder,
            )!
            .spot,
        spots[1],
      );

      expect(
        candlestickChartPainter
            .handleTouch(
              const Offset((2 / 3) * 100, 0),
              viewSize,
              holder,
            )!
            .spot,
        spots[2],
      );

      expect(
        candlestickChartPainter.handleTouch(
          const Offset(((2 / 3) * 100) + 6, 0),
          viewSize,
          holder,
        ),
        null,
      );
    });
  });
}
