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

}
