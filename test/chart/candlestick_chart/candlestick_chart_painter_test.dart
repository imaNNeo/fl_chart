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
}
