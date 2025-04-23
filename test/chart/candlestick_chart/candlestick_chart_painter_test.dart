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
      candlestickPainter.paint(
        mockBuildContext,
        mockCanvasWrapper,
        holder,
      );

      verify(mockCanvasWrapper.drawLine(any, any, any)).called(6);
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
        touchedPointIndicator: AxisSpotIndicator(
          x: 50,
          y: 50,
          painter: AxisLinesIndicatorPainter(
            horizontalLine: const FlLine(
              color: MockData.color1,
              strokeWidth: 4,
            ),
            verticalLine: const FlLine(
              color: MockData.color2,
              strokeWidth: 8,
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

      expect(drawCalls.length, 2);

      // Horizontal line
      expect(drawCalls[0].$1, const Offset(0, 200));
      expect(drawCalls[0].$2, const Offset(400, 200));
      expect(drawCalls[0].$3.toARGB32(), MockData.color1.toARGB32());
      expect(drawCalls[0].$4, 4);

      /// Vertical line
      expect(drawCalls[1].$1, const Offset(200, 0));
      expect(drawCalls[1].$2, const Offset(200, 400));
      expect(drawCalls[1].$3.toARGB32(), MockData.color2.toARGB32());
      expect(drawCalls[1].$4, 8);

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
        touchedPointIndicator: AxisSpotIndicator(
          x: 50,
          y: 50,
          painter: AxisLinesIndicatorPainter(
            horizontalLine: const FlLine(
              color: MockData.color1,
              strokeWidth: 4,
            ),
            verticalLine: null,
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

      expect(drawCalls.length, 1);

      // Horizontal line
      expect(drawCalls[0].$1, const Offset(0, 200));
      expect(drawCalls[0].$2, const Offset(400, 200));
      expect(drawCalls[0].$3.toARGB32(), MockData.color1.toARGB32());
      expect(drawCalls[0].$4, 4);

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
      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      final lineDrawCalls = <(Offset, Offset, Color, double)>[];
      when(mockCanvasWrapper.drawLine(any, any, any)).thenAnswer((invocation) {
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
      when(mockCanvasWrapper.drawRRect(any, any)).thenAnswer((invocation) {
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
        mockCanvasWrapper,
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

}
