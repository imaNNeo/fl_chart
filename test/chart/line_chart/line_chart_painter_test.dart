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
  group('paint()', () {
    test('test 1', () {
      const viewSize = Size(400, 400);

      final bar1 = LineChartBarData(spots: const [
        FlSpot(0, 4),
        FlSpot(1, 3),
        FlSpot(2, 2),
        FlSpot(3, 1),
        FlSpot(4, 0),
      ], showingIndicators: [
        0,
        2,
        3,
      ]);
      final bar2 = LineChartBarData(
        spots: const [
          FlSpot(0, 5),
          FlSpot(1, 3),
          FlSpot(2, 2),
          FlSpot(3, 5),
          FlSpot(4, 0),
        ],
      );
      final LineChartData data = LineChartData(
        lineBarsData: [
          bar1,
          bar2,
        ],
        clipData: FlClipData.all(),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(y: 1),
          ],
          verticalLines: [
            VerticalLine(x: 4),
          ],
        ),
        betweenBarsData: [
          BetweenBarsData(fromIndex: 0, toIndex: 1),
        ],
        showingTooltipIndicators: [
          ShowingTooltipIndicators([
            LineBarSpot(bar1, 0, bar1.spots.first),
            LineBarSpot(bar2, 1, bar2.spots.first),
          ])
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          getTouchedSpotIndicator:
              (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.asMap().entries.map((entry) {
              final i = entry.key;
              if (i == 0) {
                return null;
              }
              return TouchedSpotIndicatorData(
                FlLine(color: MockData.color0),
                FlDotData(show: true),
              );
            }).toList();
          },
        ),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);

      MockUtils mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getThemeAwareTextStyle(any, any))
          .thenAnswer((realInvocation) => textStyle1);
      when(mockUtils.calculateRotationOffset(any, any))
          .thenAnswer((realInvocation) => Offset.zero);
      when(mockUtils.convertRadiusToSigma(any))
          .thenAnswer((realInvocation) => 4.0);
      when(mockUtils.getEfficientInterval(any, any))
          .thenAnswer((realInvocation) => 1.0);
      when(mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenAnswer((realInvocation) => 1.0);

      final mockBuildContext = MockBuildContext();
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      lineChartPainter.paint(
        mockBuildContext,
        mockCanvasWrapper,
        holder,
      );

      verify(mockCanvasWrapper.clipRect(any)).called(1);
      verify(mockCanvasWrapper.drawDot(any, any, any)).called(12);
      verify(mockCanvasWrapper.drawPath(any, any)).called(3);
    });
    test('test 2', () {
      const viewSize = Size(400, 400);

      final bar1 = LineChartBarData(
        spots: const [
          FlSpot(0, 4),
          FlSpot(1, 3),
          FlSpot(2, 2),
          FlSpot(3, 1),
          FlSpot(4, 0),
        ],
      );
      final bar2 = LineChartBarData(
        spots: const [
          FlSpot(0, 2),
          FlSpot(1, 5),
          FlSpot(2, 1),
          FlSpot(3, 2),
          FlSpot(4, 3),
        ],
      );
      final LineChartData data = LineChartData(
        lineBarsData: [
          bar1,
          bar2,
        ],
        clipData: FlClipData.all(),
        lineTouchData: LineTouchData(
          enabled: true,
          getTouchedSpotIndicator:
              (LineChartBarData barData, List<int> spotIndexes) {
            return List.generate(
              spotIndexes.length + 1,
              (index) {
                return TouchedSpotIndicatorData(
                  FlLine(color: MockData.color0),
                  FlDotData(show: true),
                );
              },
            ).toList();
          },
        ),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(y: 1),
          ],
          verticalLines: [
            VerticalLine(x: 4),
          ],
          extraLinesOnTop: false,
        ),
        showingTooltipIndicators: [
          ShowingTooltipIndicators([
            LineBarSpot(bar1, 0, bar1.spots[0]),
            LineBarSpot(bar1, 0, bar1.spots[2]),
            LineBarSpot(bar2, 1, bar1.spots[2]),
            LineBarSpot(bar2, 1, bar1.spots[3]),
            LineBarSpot(bar2, 1, bar1.spots[4]),
          ])
        ],
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);

      MockUtils mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getThemeAwareTextStyle(any, any))
          .thenAnswer((realInvocation) => textStyle1);
      when(mockUtils.calculateRotationOffset(any, any))
          .thenAnswer((realInvocation) => Offset.zero);
      when(mockUtils.convertRadiusToSigma(any))
          .thenAnswer((realInvocation) => 4.0);
      when(mockUtils.getEfficientInterval(any, any))
          .thenAnswer((realInvocation) => 1.0);
      when(mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenAnswer((realInvocation) => 1.0);

      final mockBuildContext = MockBuildContext();
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      Exception? exception;
      try {
        lineChartPainter.paint(
          mockBuildContext,
          mockCanvasWrapper,
          holder,
        );
      } on Exception catch (e) {
        exception = e;
      }
      expect(exception != null, true);
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
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      lineChartPainter.clipToBorder(
        mockCanvasWrapper,
        holder,
      );

      final verifyResult = verify(mockCanvasWrapper.clipRect(captureAny));
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
          leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 10)),
          topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 20)),
          rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
        ),
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
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      lineChartPainter.clipToBorder(
        mockCanvasWrapper,
        holder,
      );

      final verifyResult = verify(mockCanvasWrapper.clipRect(captureAny));
      final Rect rect = verifyResult.captured.single;
      verifyResult.called(1);
      expect(rect.left, 4);
      expect(rect.top, 0);
      expect(rect.right, 396);
      expect(rect.bottom, 400);
    });

    test('test 3', () {
      const viewSize = Size(400, 400);

      final LineChartData data = LineChartData(
        titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 10)),
          topTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
          )),
          rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
        ),
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
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      lineChartPainter.clipToBorder(
        mockCanvasWrapper,
        holder,
      );

      final verifyResult = verify(mockCanvasWrapper.clipRect(captureAny));
      final Rect rect = verifyResult.captured.single;
      verifyResult.called(1);
      expect(rect.left, 4);
      expect(rect.top, 4);
      expect(rect.right, 396);
      expect(rect.bottom, 396);
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
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawBarLine(
        mockCanvasWrapper,
        barData,
        holder,
      );

      verify(mockCanvasWrapper.drawPath(any, any)).called(1);
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
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawBarLine(
        mockCanvasWrapper,
        barData,
        holder,
      );

      verify(mockCanvasWrapper.drawPath(any, any)).called(2);
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
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawBarLine(
        mockCanvasWrapper,
        barData,
        holder,
      );

      final verificationResult =
          verify(mockCanvasWrapper.drawPath(any, captureAny));
      final paint = verificationResult.captured.single as Paint;
      verificationResult.called(1);
      expect(paint.color.value,
          barData.gradient?.colors.first.value ?? barData.color?.value);
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
        color: const Color(0xFFFF0000),
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
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawBetweenBarsArea(
        mockCanvasWrapper,
        data,
        betweenBarData,
        holder,
      );

      final verifyResult = verifyInOrder([
        mockCanvasWrapper.saveLayer(const Rect.fromLTWH(0, 0, 400, 400), any),
        mockCanvasWrapper.drawPath(any, captureAny),
        mockCanvasWrapper.restore(),
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
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawDots(
        mockCanvasWrapper,
        barData,
        holder,
      );

      verifyNever(mockCanvasWrapper.drawDot(any, any, any));
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
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawDots(
        mockCanvasWrapper,
        barData,
        holder,
      );

      verifyNever(mockCanvasWrapper.drawDot(any, any, any));
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
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawDots(
        mockCanvasWrapper,
        barData,
        holder,
      );

      verify(mockCanvasWrapper.drawDot(any, any, any)).called(5);
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
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawDots(
        mockCanvasWrapper,
        barData,
        holder,
      );

      verifyInOrder([
        mockCanvasWrapper.drawDot(
          any,
          const FlSpot(1, 1),
          const Offset(10, 90),
        ),
        mockCanvasWrapper.drawDot(
          any,
          const FlSpot(2, 2),
          const Offset(20, 80),
        ),
        mockCanvasWrapper.drawDot(
          any,
          const FlSpot(3, 3),
          const Offset(30, 70),
        ),
        mockCanvasWrapper.drawDot(
          any,
          const FlSpot(4, 4),
          const Offset(40, 60),
        ),
        mockCanvasWrapper.drawDot(
          any,
          const FlSpot(5, 5),
          const Offset(50, 50),
        ),
      ]);
    });
  });

  group('drawTouchedSpotsIndicator()', () {
    List<LineIndexDrawingInfo> getDrawingInfo(LineChartData data) {
      List<LineIndexDrawingInfo> lineIndexDrawingInfo = [];

      /// draw each line independently on the chart
      for (var i = 0; i < data.lineBarsData.length; i++) {
        final barData = data.lineBarsData[i];

        if (!barData.show) {
          continue;
        }

        final indicatorsData = data.lineTouchData
            .getTouchedSpotIndicator(barData, barData.showingIndicators);

        if (indicatorsData.length != barData.showingIndicators.length) {
          throw Exception(
              'indicatorsData and touchedSpotOffsets size should be same');
        }

        for (var j = 0; j < barData.showingIndicators.length; j++) {
          final indicatorData = indicatorsData[j];
          final index = barData.showingIndicators[j];
          final spot = barData.spots[index];

          if (indicatorData == null) {
            continue;
          }
          lineIndexDrawingInfo.add(
            LineIndexDrawingInfo(barData, i, spot, index, indicatorData),
          );
        }
      }
      return lineIndexDrawingInfo;
    }

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
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawTouchedSpotsIndicator(
        mockCanvasWrapper,
        getDrawingInfo(data),
        holder,
      );

      verifyNever(mockCanvasWrapper.drawPath(any, any));
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
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      List<Map<String, dynamic>> results = [];
      when(mockCanvasWrapper.drawDashedLine(
              captureAny, captureAny, captureAny, any))
          .thenAnswer((inv) {
        results.add({
          'from': inv.positionalArguments[0] as Offset,
          'to': inv.positionalArguments[1] as Offset,
          'paint_color': (inv.positionalArguments[2] as Paint).color,
          'paint_stroke_width':
              (inv.positionalArguments[2] as Paint).strokeWidth,
        });
      });

      lineChartPainter.drawTouchedSpotsIndicator(
        mockCanvasWrapper,
        getDrawingInfo(data),
        holder,
      );

      expect(results.length, 2);

      expect(results[0]['paint_color'], const Color(0xFF0000FF));
      expect(results[0]['paint_stroke_width'], 12);

      expect(results[1]['paint_color'], const Color(0xFF00FF00));
      expect(results[1]['paint_stroke_width'], 8.0);
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
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      List<Map<String, dynamic>> results = [];
      when(mockCanvasWrapper.drawDashedLine(
              captureAny, captureAny, captureAny, any))
          .thenAnswer((inv) {
        results.add({
          'from': inv.positionalArguments[0] as Offset,
          'to': inv.positionalArguments[1] as Offset,
          'paint_color': (inv.positionalArguments[2] as Paint).color,
          'paint_stroke_width':
              (inv.positionalArguments[2] as Paint).strokeWidth,
        });
      });

      lineChartPainter.drawTouchedSpotsIndicator(
        mockCanvasWrapper,
        getDrawingInfo(data),
        holder,
      );

      expect(results.length, 2);

      expect(results[0]['paint_color'], const Color(0xFF0000FF));
      expect(results[0]['paint_stroke_width'], 12);

      expect(results[1]['paint_color'], const Color(0xFF00FF00));
      expect(results[1]['paint_stroke_width'], 8.0);

      verify(mockCanvasWrapper.drawDot(any, any, any)).called(2);
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
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

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
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

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
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

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
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

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
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

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

    test('test 2', () {
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
          belowBarData: BarAreaData(
            cutOffY: 4,
            applyCutOffY: true,
          ));

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        lineBarsData: [lineChartBarData],
        showingTooltipIndicators: [],
        titlesData: FlTitlesData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path barPath = Path()
        ..moveTo(10, 10)
        ..lineTo(50, 50)
        ..lineTo(80, 10);

      final Path belowBarPath = lineChartPainter.generateBelowBarPath(
          viewSize, lineChartBarData, barPath, barSpots, holder);

      expect(belowBarPath.getBounds().bottom, 60);
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
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

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
          gradient: const LinearGradient(
            colors: [Color(0xFFFF0000), Color(0xFF00FF00)],
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
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path belowBarPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10);

      final Path filletAboveBarPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10)
        ..lineTo(80, 0)
        ..lineTo(10, 0)
        ..lineTo(10, 10);

      lineChartPainter.drawBelowBar(mockCanvasWrapper, belowBarPath,
          filletAboveBarPath, holder, lineChartBarData);

      final result =
          verify(mockCanvasWrapper.drawPath(belowBarPath, captureAny));
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
          gradient: const LinearGradient(
            colors: [Color(0xFFFF0000), Color(0xFF00FF00)],
          ),
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
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path belowBarPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10);

      final Path filletAboveBarPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10)
        ..lineTo(80, 0)
        ..lineTo(10, 0)
        ..lineTo(10, 10);

      List<Map<String, dynamic>> results = [];
      when(mockCanvasWrapper.drawDashedLine(
              captureAny, captureAny, captureAny, any))
          .thenAnswer((inv) {
        results.add({
          'from': inv.positionalArguments[0] as Offset,
          'to': inv.positionalArguments[1] as Offset,
          'paint_color': (inv.positionalArguments[2] as Paint).color,
          'paint_stroke_width':
              (inv.positionalArguments[2] as Paint).strokeWidth,
        });
      });

      lineChartPainter.drawBelowBar(mockCanvasWrapper, belowBarPath,
          filletAboveBarPath, holder, lineChartBarData);

      verify(mockCanvasWrapper.saveLayer(
              Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), any))
          .called(1);

      final result =
          verify(mockCanvasWrapper.drawPath(belowBarPath, captureAny));
      result.called(1);
      final paint = result.captured.single as Paint;
      expect(paint.color, const Color(0xFF000000));
      expect(paint.shader is ui.Gradient, true);

      final result2 =
          verify(mockCanvasWrapper.drawPath(filletAboveBarPath, captureAny));
      result2.called(1);
      final paint2 = result2.captured.single as Paint;
      expect(paint2.color, const Color(0x00000000));
      expect(paint2.blendMode, BlendMode.dstIn);
      expect(paint2.style, PaintingStyle.fill);

      verify(mockCanvasWrapper.restore()).called(1);

      expect(results.length, 2);

      for (Map<String, dynamic> item in results) {
        expect((item['paint_color'] as Color).alpha, 0);
        expect(item['paint_stroke_width'], 18);
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
          gradient: const LinearGradient(
            colors: [Color(0xFFFF0000), Color(0xFF00FF00)],
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
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path aboveBarPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10);

      final Path filledBelowBarPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10)
        ..lineTo(80, 0)
        ..lineTo(10, 0)
        ..lineTo(10, 10);

      lineChartPainter.drawAboveBar(mockCanvasWrapper, aboveBarPath,
          filledBelowBarPath, holder, lineChartBarData);

      final result =
          verify(mockCanvasWrapper.drawPath(aboveBarPath, captureAny));
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
          gradient: const LinearGradient(
            colors: [Color(0xFFFF0000), Color(0xFF00FF00)],
          ),
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
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path aboveBarPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10);

      final Path filledBelowBarPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10)
        ..lineTo(80, 0)
        ..lineTo(10, 0)
        ..lineTo(10, 10);

      List<Map<String, dynamic>> results = [];
      when(mockCanvasWrapper.drawDashedLine(
              captureAny, captureAny, captureAny, any))
          .thenAnswer((inv) {
        results.add({
          'from': inv.positionalArguments[0] as Offset,
          'to': inv.positionalArguments[1] as Offset,
          'paint_color': (inv.positionalArguments[2] as Paint).color,
          'paint_stroke_width':
              (inv.positionalArguments[2] as Paint).strokeWidth,
        });
      });

      lineChartPainter.drawAboveBar(mockCanvasWrapper, aboveBarPath,
          filledBelowBarPath, holder, lineChartBarData);

      verify(mockCanvasWrapper.saveLayer(
              Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), any))
          .called(1);

      final result =
          verify(mockCanvasWrapper.drawPath(aboveBarPath, captureAny));
      result.called(1);
      final paint = result.captured.single as Paint;
      expect(paint.color, const Color(0xFF000000));
      expect(paint.shader is ui.Gradient, true);

      final result2 =
          verify(mockCanvasWrapper.drawPath(filledBelowBarPath, captureAny));
      result2.called(1);
      final paint2 = result2.captured.single as Paint;
      expect(paint2.color, const Color(0x00000000));
      expect(paint2.blendMode, BlendMode.dstIn);
      expect(paint2.style, PaintingStyle.fill);

      verify(mockCanvasWrapper.restore()).called(1);

      expect(results.length, 2);

      for (Map<String, dynamic> item in results) {
        expect((item['paint_color'] as Color).alpha, 0);
        expect(item['paint_stroke_width'], 18);
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
          gradient: const LinearGradient(
            colors: [Color(0xFFFF0000), Color(0xFF00FF00)],
          ),
        ),
      );

      final LineChartBarData lineChartBarData2 = LineChartBarData(
          show: true,
          spots: barSpots2,
          dotData: FlDotData(show: true),
          isStepLineChart: true);

      final betweenBarData1 = BetweenBarsData(
        fromIndex: 0,
        toIndex: 1,
        color: const Color(0xFFFF0000),
      );

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        lineBarsData: [lineChartBarData1, lineChartBarData2],
        showingTooltipIndicators: [],
        titlesData: FlTitlesData(show: false),
        betweenBarsData: [betweenBarData1],
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path aboveBarPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10);

      lineChartPainter.drawBetweenBar(
        mockCanvasWrapper,
        aboveBarPath,
        betweenBarData1,
        MockData.rect1,
        holder,
      );

      verify(mockCanvasWrapper.saveLayer(
          Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), any));
      final result =
          verify(mockCanvasWrapper.drawPath(aboveBarPath, captureAny));
      result.called(1);
      final painter = result.captured.single as Paint;
      expect(painter.color, const Color(0xFFFF0000));
      verify(mockCanvasWrapper.restore());
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
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();

      final Path barPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10);

      lineChartPainter.drawBarShadow(
          mockCanvasWrapper, barPath, lineChartBarData1);
      verifyNever(mockCanvasWrapper.drawPath(any, any));
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
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path barPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10);

      lineChartPainter.drawBarShadow(
          mockCanvasWrapper, barPath, lineChartBarData1);
      final result = verify(mockCanvasWrapper.drawPath(captureAny, captureAny));
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
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path barPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10);

      lineChartPainter.drawBar(
          mockCanvasWrapper, barPath, lineChartBarData1, holder);
      verifyNever(mockCanvasWrapper.drawPath(any, any));
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
        color: const Color(0xF0F0F0F0),
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
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path barPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10);

      lineChartPainter.drawBar(
          mockCanvasWrapper, barPath, lineChartBarData1, holder);
      final result = verify(mockCanvasWrapper.drawPath(captureAny, captureAny));
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
        gradient: const LinearGradient(
          colors: [Color(0xF0F0F0F0), Color(0x0100FF00)],
        ),
        dashArray: [1, 2, 3],
      );

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        lineBarsData: [lineChartBarData1],
        showingTooltipIndicators: [],
        titlesData: FlTitlesData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final Path barPath = Path()
        ..moveTo(10, 10)
        ..lineTo(80, 10);

      lineChartPainter.drawBar(
          mockCanvasWrapper, barPath, lineChartBarData1, holder);
      final result = verify(mockCanvasWrapper.drawPath(captureAny, captureAny));
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

  group('drawExtraLines()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);

      final LineChartData data = LineChartData(
          minY: 0,
          maxY: 10,
          minX: 0,
          maxX: 10,
          titlesData: FlTitlesData(show: false),
          extraLinesData:
              ExtraLinesData(horizontalLines: [], verticalLines: []));

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      MockBuildContext mockBuildContext = MockBuildContext();

      lineChartPainter.drawExtraLines(
          mockBuildContext, mockCanvasWrapper, holder);

      verifyNever(mockCanvasWrapper.drawDashedLine(any, any, any, captureAny));
    });

    test('test 2', () {
      const viewSize = Size(100, 100);

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        titlesData: FlTitlesData(show: false),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      MockBuildContext mockBuildContext = MockBuildContext();

      lineChartPainter.drawExtraLines(
          mockBuildContext, mockCanvasWrapper, holder);

      verifyNever(mockCanvasWrapper.drawDashedLine(any, any, any, captureAny));
    });

    test('test 3', () {
      const viewSize = Size(100, 100);

      final LineChartData data = LineChartData(
          minY: 0,
          maxY: 10,
          minX: 0,
          maxX: 10,
          titlesData: FlTitlesData(show: false),
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
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      MockBuildContext mockBuildContext = MockBuildContext();

      List<Map<String, dynamic>> results = [];
      when(mockCanvasWrapper.drawDashedLine(
              captureAny, captureAny, captureAny, any))
          .thenAnswer((inv) {
        results.add({
          'from': inv.positionalArguments[0] as Offset,
          'to': inv.positionalArguments[1] as Offset,
          'paint_color': (inv.positionalArguments[2] as Paint).color,
          'paint_stroke_width':
              (inv.positionalArguments[2] as Paint).strokeWidth,
        });
      });

      lineChartPainter.drawExtraLines(
          mockBuildContext, mockCanvasWrapper, holder);

      expect(results.length, 4);

      expect(results[0]['paint_color'], const Color(0x11111111));
      expect(results[0]['paint_stroke_width'], 11);
      expect(results[0]['from'], const Offset(0, 90));
      expect(results[0]['to'], const Offset(100, 90));

      expect(results[1]['paint_color'], const Color(0x22222222));
      expect(results[1]['paint_stroke_width'], 22);
      expect(results[1]['from'], const Offset(0, 80));
      expect(results[1]['to'], const Offset(100, 80));

      expect(results[2]['paint_color'], const Color(0x33333333));
      expect(results[2]['paint_stroke_width'], 33);
      expect(results[2]['from'], const Offset(40, 0));
      expect(results[2]['to'], const Offset(40, 100));

      expect(results[3]['paint_color'], const Color(0x44444444));
      expect(results[3]['paint_stroke_width'], 44);
      expect(results[3]['from'], const Offset(50, 0));
      expect(results[3]['to'], const Offset(50, 100));
    });
  });

  group('drawTouchTooltip()', () {
    test('test 1', () {
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

      final LineTouchTooltipData tooltipData = LineTouchTooltipData(
        tooltipBgColor: const Color(0x11111111),
        tooltipRoundedRadius: 12,
        rotateAngle: 43,
        maxContentWidth: 100,
        tooltipMargin: 12,
        tooltipPadding: const EdgeInsets.all(12),
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        showOnTopOfTheChartBoxArea: false,
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots
              .map((e) => LineTooltipItem(e.barIndex.toString(), textStyle1))
              .toList();
        },
        tooltipBorder: const BorderSide(color: Color(0x11111111), width: 2),
      );
      final LineChartData data = LineChartData(
          minY: 0,
          maxY: 10,
          minX: 0,
          maxX: 10,
          titlesData: FlTitlesData(show: false),
          extraLinesData: ExtraLinesData(
            horizontalLines: [],
            verticalLines: [],
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: tooltipData,
          ));

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      MockBuildContext mockBuildContext = MockBuildContext();
      MockUtils mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getThemeAwareTextStyle(any, any))
          .thenAnswer((realInvocation) => textStyle1);
      when(mockUtils.calculateRotationOffset(any, any))
          .thenAnswer((realInvocation) => Offset.zero);
      when(mockCanvasWrapper.drawRotated(
        size: anyNamed('size'),
        rotationOffset: anyNamed('rotationOffset'),
        drawOffset: anyNamed('drawOffset'),
        angle: anyNamed('angle'),
        drawCallback: anyNamed('drawCallback'),
      )).thenAnswer((realInvocation) {
        final callback =
            realInvocation.namedArguments[const Symbol('drawCallback')];
        callback();
      });
      lineChartPainter.drawTouchTooltip(
        mockBuildContext,
        mockCanvasWrapper,
        tooltipData,
        barData.spots.first,
        ShowingTooltipIndicators([
          LineBarSpot(
            barData,
            0,
            barData.spots.first,
          ),
        ]),
        holder,
      );

      final result1 =
          verify(mockCanvasWrapper.drawRRect(captureAny, captureAny));
      result1.called(2);
      final rRect = result1.captured[0] as RRect;
      final paint = result1.captured[1] as Paint;
      expect(rRect,
          RRect.fromLTRBR(0.0, 40.0, 38.0, 78.0, const Radius.circular(12)));
      expect(paint.color, const Color(0x11111111));
      final rRectBorder = result1.captured[2] as RRect;
      final paintBorder = result1.captured[3] as Paint;
      expect(rRectBorder,
          RRect.fromLTRBR(0.0, 40.0, 38.0, 78.0, const Radius.circular(12)));
      expect(paintBorder.color, const Color(0x11111111));
      expect(paintBorder.strokeWidth, 2);

      final result2 =
          verify(mockCanvasWrapper.drawText(captureAny, captureAny));
      result2.called(1);
      final textPainter = result2.captured[0] as TextPainter;
      final drawOffset = result2.captured[1] as Offset;
      expect((textPainter.text as TextSpan).text, "0");
      expect((textPainter.text as TextSpan).style, textStyle1);
      expect(drawOffset, const Offset(12.0, 52.0));
    });
  });

  group('getBarLineXLength()', () {
    test('test 1', () {
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
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      final result = lineChartPainter.getBarLineXLength(
        barData,
        viewSize,
        holder,
      );
      expect(result, 40);
    });
  });

  group('handleTouch()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);

      final LineChartBarData lineChartBarData1 = LineChartBarData(
        show: false,
        spots: const [
          FlSpot(1, 1),
          FlSpot(4, 1),
          FlSpot(6, 1),
          FlSpot(8, 1),
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

      final LineChartBarData lineChartBarData2 = LineChartBarData(
        show: false,
        spots: const [
          FlSpot(1.1, 2),
          FlSpot(2, 2),
          FlSpot(3.5, 2),
          FlSpot(4.3, 2),
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
          lineBarsData: [lineChartBarData1, lineChartBarData2],
          showingTooltipIndicators: [],
          titlesData: FlTitlesData(show: false),
          lineTouchData: LineTouchData(
            touchSpotThreshold: 0.5,
          ));

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      final touchResponse =
          lineChartPainter.handleTouch(const Offset(35, 0), viewSize, holder);
      expect(touchResponse, null);
    });

    test('test 2', () {
      const viewSize = Size(100, 100);

      final LineChartBarData lineChartBarData1 = LineChartBarData(
        show: true,
        spots: const [
          FlSpot(1, 1),
          FlSpot(4, 1),
          FlSpot(6, 1),
          FlSpot(8, 1),
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

      final LineChartBarData lineChartBarData2 = LineChartBarData(
        show: true,
        spots: const [
          FlSpot(1.1, 2),
          FlSpot(2, 2),
          FlSpot(3.5, 2),
          FlSpot(4.3, 2),
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
          lineBarsData: [lineChartBarData1, lineChartBarData2],
          showingTooltipIndicators: [],
          titlesData: FlTitlesData(show: false),
          lineTouchData: LineTouchData(
            touchSpotThreshold: 5,
          ));

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      expect(
          lineChartPainter
              .handleTouch(const Offset(30, 0), viewSize, holder)!
              .length,
          1);
      expect(
          lineChartPainter.handleTouch(
              const Offset(29.99, 0), viewSize, holder),
          null);
      expect(
          lineChartPainter
              .handleTouch(const Offset(10.0, 0), viewSize, holder)!
              .length,
          2);
    });

    test('test 3', () {
      const viewSize = Size(100, 100);

      final LineChartBarData lineChartBarData1 = LineChartBarData(
        show: true,
        spots: const [
          FlSpot(1, 1),
          FlSpot(2, 1),
          FlSpot(3, 1),
          FlSpot(8, 1),
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

      final LineChartBarData lineChartBarData2 = LineChartBarData(
        show: true,
        spots: const [
          FlSpot(1.3, 1),
          FlSpot(2, 1),
          FlSpot(3, 1),
          FlSpot(4, 1),
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
          lineBarsData: [lineChartBarData1, lineChartBarData2],
          showingTooltipIndicators: [],
          titlesData: FlTitlesData(show: false),
          lineTouchData: LineTouchData(
            touchSpotThreshold: 5,
          ));

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);

      final result1 =
          lineChartPainter.handleTouch(const Offset(11, 0), viewSize, holder)!;
      expect(result1[0].barIndex, 0);
      expect(result1[1].barIndex, 1);

      final result2 =
          lineChartPainter.handleTouch(const Offset(12, 0), viewSize, holder)!;
      expect(result2[0].barIndex, 1);
      expect(result2[1].barIndex, 0);
    });
  });

  group('getNearestTouchedSpot()', () {
    test('test 1', () {
      const viewSize = Size(100, 100);

      final LineChartBarData lineChartBarData1 = LineChartBarData(
        show: false,
        spots: const [
          FlSpot(1, 1),
          FlSpot(4, 1),
          FlSpot(6, 1),
          FlSpot(8, 1),
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

      final LineChartBarData lineChartBarData2 = LineChartBarData(
        show: false,
        spots: const [
          FlSpot(1.1, 2),
          FlSpot(2, 2),
          FlSpot(3.5, 2),
          FlSpot(4.3, 2),
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
          lineBarsData: [lineChartBarData1, lineChartBarData2],
          showingTooltipIndicators: [],
          titlesData: FlTitlesData(show: false),
          lineTouchData: LineTouchData(
            touchSpotThreshold: 0.5,
          ));

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      final touchResponse = lineChartPainter.getNearestTouchedSpot(
          viewSize, const Offset(35, 0), data.lineBarsData[0], 0, holder);
      expect(touchResponse, null);

      final touchResponse2 = lineChartPainter.getNearestTouchedSpot(
          viewSize, const Offset(35, 0), data.lineBarsData[0], 0, holder);
      expect(touchResponse2, null);
    });

    test('test 2', () {
      const viewSize = Size(100, 100);

      final LineChartBarData lineChartBarData1 = LineChartBarData(
        show: true,
        spots: const [
          FlSpot(1, 1),
          FlSpot(4, 1),
          FlSpot(6, 1),
          FlSpot(8, 1),
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

      final LineChartBarData lineChartBarData2 = LineChartBarData(
        show: true,
        spots: const [
          FlSpot(1.1, 2),
          FlSpot(2, 2),
          FlSpot(3.5, 2),
          FlSpot(4.3, 2),
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
          lineBarsData: [lineChartBarData1, lineChartBarData2],
          showingTooltipIndicators: [],
          titlesData: FlTitlesData(show: false),
          lineTouchData: LineTouchData(
            touchSpotThreshold: 5,
          ));

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      expect(
          lineChartPainter.getNearestTouchedSpot(
              viewSize, const Offset(30, 0), data.lineBarsData[0], 0, holder),
          null);
      final result1 = lineChartPainter.getNearestTouchedSpot(
          viewSize, const Offset(30, 0), data.lineBarsData[1], 1, holder);
      expect(result1!.barIndex, 1);
      expect(result1.spotIndex, 2);

      expect(
          lineChartPainter.getNearestTouchedSpot(viewSize,
              const Offset(29.99, 0), data.lineBarsData[0], 0, holder),
          null);
      expect(
          lineChartPainter.getNearestTouchedSpot(viewSize,
              const Offset(29.99, 0), data.lineBarsData[1], 1, holder),
          null);

      final result2 = lineChartPainter.getNearestTouchedSpot(
          viewSize, const Offset(10.0, 0), data.lineBarsData[0], 0, holder);
      expect(result2!.barIndex, 0);
      expect(result2.spotIndex, 0);

      final result3 = lineChartPainter.getNearestTouchedSpot(
          viewSize, const Offset(10.0, 0), data.lineBarsData[1], 1, holder);
      expect(result3!.barIndex, 1);
      expect(result3.spotIndex, 0);
    });

    test('test 3', () {
      const viewSize = Size(100, 100);

      final LineChartBarData lineChartBarData1 = LineChartBarData(
        show: true,
        spots: const [
          FlSpot(1, 1),
          FlSpot(4, 1),
          FlSpot(6, 4),
          FlSpot(8, 1),
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

      final LineChartBarData lineChartBarData2 = LineChartBarData(
        show: true,
        spots: const [
          FlSpot(1.1, 4),
          FlSpot(2, 4),
          FlSpot(3.5, 1),
          FlSpot(4.3, 4),
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
          lineBarsData: [lineChartBarData1, lineChartBarData2],
          showingTooltipIndicators: [],
          titlesData: FlTitlesData(show: false),
          lineTouchData: LineTouchData(
            distanceCalculator: (Offset a, Offset b) {
              final dx = a.dx - b.dx;
              final dy = a.dy - b.dy;
              return math.sqrt(dx * dx + dy * dy);
            },
            touchSpotThreshold: 5,
          ));

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      expect(
          lineChartPainter.getNearestTouchedSpot(
              viewSize, const Offset(30, 0), data.lineBarsData[0], 0, holder),
          null);
      final result1 = lineChartPainter.getNearestTouchedSpot(
          viewSize, const Offset(60, 65), data.lineBarsData[0], 0, holder);
      expect(result1!.barIndex, 0);
      expect(result1.spotIndex, 2);

      expect(
          lineChartPainter.getNearestTouchedSpot(viewSize,
              const Offset(60, 65.01), data.lineBarsData[0], 0, holder),
          null);
      expect(
          lineChartPainter.getNearestTouchedSpot(viewSize,
              const Offset(29.99, 0), data.lineBarsData[1], 1, holder),
          null);

      final result2 = lineChartPainter.getNearestTouchedSpot(
          viewSize, const Offset(63.5, 63.5), data.lineBarsData[0], 0, holder);
      expect(result2!.barIndex, 0);
      expect(result2.spotIndex, 2);
    });
  });

  group('drawGrid()', () {
    test('test 1 - none', () {
      const viewSize = Size(20, 100);

      final LineChartData data = LineChartData(
          minY: 0,
          maxY: 10,
          minX: 0,
          maxX: 10,
          titlesData: FlTitlesData(show: false),
          gridData: FlGridData(
            show: false,
            drawVerticalLine: true,
            drawHorizontalLine: true,
            horizontalInterval: 2,
          ));

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      MockUtils mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenAnswer((realInvocation) => 0);

      lineChartPainter.drawGrid(mockCanvasWrapper, holder);
      verifyNever(mockCanvasWrapper.drawDashedLine(any, any, any, any));
    });

    test('test 2 - horizontal', () {
      const viewSize = Size(20, 100);

      final LineChartData data = LineChartData(
          minY: 0,
          maxY: 10,
          minX: 0,
          maxX: 10,
          titlesData: FlTitlesData(show: false),
          gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              drawHorizontalLine: true,
              horizontalInterval: 2,
              checkToShowHorizontalLine: (value) => value != 2 && value != 8,
              getDrawingHorizontalLine: (value) {
                if (value == 4) {
                  return FlLine(
                    color: MockData.color1,
                    strokeWidth: 11,
                    dashArray: [1, 1],
                  );
                } else if (value == 6) {
                  return FlLine(
                    color: MockData.color2,
                    strokeWidth: 22,
                    dashArray: [2, 2],
                  );
                } else {
                  throw StateError("We shouldn't draw these lines");
                }
              }));

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      MockUtils mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenAnswer((realInvocation) => 0);

      List<Map<String, dynamic>> results = [];
      when(mockCanvasWrapper.drawDashedLine(
              captureAny, captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        results.add({
          'from': inv.positionalArguments[0] as Offset,
          'to': inv.positionalArguments[1] as Offset,
          'paint_color': (inv.positionalArguments[2] as Paint).color,
          'paint_stroke_width':
              (inv.positionalArguments[2] as Paint).strokeWidth,
          'dash_array': inv.positionalArguments[3] as List<int>,
        });
      });

      lineChartPainter.drawGrid(mockCanvasWrapper, holder);
      expect(results.length, 2);

      expect(results[0]['from'], const Offset(0, 60));
      expect(results[0]['to'], const Offset(20, 60));
      expect(results[0]['paint_color'], MockData.color1);
      expect(results[0]['paint_stroke_width'], 11);
      expect(results[0]['dash_array'], [1, 1]);

      expect(results[1]['from'], const Offset(0, 40));
      expect(results[1]['to'], const Offset(20, 40));
      expect(results[1]['paint_color'], MockData.color2);
      expect(results[1]['paint_stroke_width'], 22);
      expect(results[1]['dash_array'], [2, 2]);
    });

    test('test 3 - vertical', () {
      const viewSize = Size(100, 20);

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        titlesData: FlTitlesData(show: false),
        gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            drawHorizontalLine: false,
            verticalInterval: 2,
            checkToShowVerticalLine: (value) => value != 2 && value != 8,
            getDrawingVerticalLine: (value) {
              if (value == 4) {
                return FlLine(
                  color: MockData.color1,
                  strokeWidth: 11,
                  dashArray: [1, 1],
                );
              } else if (value == 6) {
                return FlLine(
                  color: MockData.color2,
                  strokeWidth: 22,
                  dashArray: [2, 2],
                );
              } else {
                throw StateError("We shouldn't draw these lines");
              }
            }),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      MockUtils mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenAnswer((realInvocation) => 0);

      List<Map<String, dynamic>> results = [];
      when(mockCanvasWrapper.drawDashedLine(
              captureAny, captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        results.add({
          'from': inv.positionalArguments[0] as Offset,
          'to': inv.positionalArguments[1] as Offset,
          'paint_color': (inv.positionalArguments[2] as Paint).color,
          'paint_stroke_width':
              (inv.positionalArguments[2] as Paint).strokeWidth,
          'dash_array': inv.positionalArguments[3] as List<int>,
        });
      });

      lineChartPainter.drawGrid(mockCanvasWrapper, holder);
      expect(results.length, 2);

      expect(results[0]['from'], const Offset(40, 0));
      expect(results[0]['to'], const Offset(40, 20));
      expect(results[0]['paint_color'], MockData.color1);
      expect(results[0]['paint_stroke_width'], 11);
      expect(results[0]['dash_array'], [1, 1]);

      expect(results[1]['from'], const Offset(60, 0));
      expect(results[1]['to'], const Offset(60, 20));
      expect(results[1]['paint_color'], MockData.color2);
      expect(results[1]['paint_stroke_width'], 22);
      expect(results[1]['dash_array'], [2, 2]);
    });

    test('test 4 - both', () {
      const viewSize = Size(100, 20);

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
        ),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      MockUtils mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getEfficientInterval(any, any))
          .thenAnswer((realInvocation) => 3);
      when(mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenAnswer((realInvocation) => 0);

      lineChartPainter.drawGrid(mockCanvasWrapper, holder);
      verify(mockCanvasWrapper.drawDashedLine(any, any, any, any)).called(6);
    });
  });

  group('drawBackground()', () {
    test('test 1', () {
      const viewSize = Size(20, 100);

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        titlesData: FlTitlesData(show: false),
        backgroundColor: MockData.color1.withOpacity(0),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawBackground(mockCanvasWrapper, holder);
      verifyNever(mockCanvasWrapper.drawRect(any, any));
    });

    test('test 2', () {
      const viewSize = Size(20, 100);

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        titlesData: FlTitlesData(show: false),
        backgroundColor: MockData.color1,
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawBackground(mockCanvasWrapper, holder);
      final result = verify(
        mockCanvasWrapper.drawRect(
          const Rect.fromLTRB(0, 0, 20, 100),
          captureAny,
        ),
      );
      expect(result.callCount, 1);
      expect((result.captured.single as Paint).color, MockData.color1);
    });
  });

  group('drawRangeAnnotation()', () {
    test('test 1 - none', () {
      const viewSize = Size(20, 100);

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        titlesData: FlTitlesData(show: false),
        rangeAnnotations: RangeAnnotations(),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      lineChartPainter.drawRangeAnnotation(mockCanvasWrapper, holder);
      verifyNever(mockCanvasWrapper.drawRect(any, any));
    });

    test('test 2 - horizontal', () {
      const viewSize = Size(20, 100);

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        titlesData: FlTitlesData(show: false),
        rangeAnnotations: RangeAnnotations(
          horizontalRangeAnnotations: [
            HorizontalRangeAnnotation(y1: 4, y2: 10, color: MockData.color1),
            HorizontalRangeAnnotation(y1: 12, y2: 14, color: MockData.color2),
          ],
        ),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      List<Map<String, dynamic>> results = [];
      when(mockCanvasWrapper.drawRect(captureAny, captureAny))
          .thenAnswer((inv) {
        results.add({
          'rect': inv.positionalArguments[0] as Rect,
          'paint_color': (inv.positionalArguments[1] as Paint).color,
        });
      });

      lineChartPainter.drawRangeAnnotation(mockCanvasWrapper, holder);
      expect(results.length, 2);

      expect(results[0]['rect'], const Rect.fromLTRB(0.0, 0.0, 20.0, 60.0));
      expect(results[0]['paint_color'], MockData.color1);

      expect(results[1]['rect'], const Rect.fromLTRB(0.0, -40.0, 20.0, -20.0));
      expect(results[1]['paint_color'], MockData.color2);
    });

    test('test 3 - vertical', () {
      const viewSize = Size(20, 100);

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        titlesData: FlTitlesData(show: false),
        rangeAnnotations: RangeAnnotations(
          verticalRangeAnnotations: [
            VerticalRangeAnnotation(x1: 1, x2: 2, color: MockData.color1),
            VerticalRangeAnnotation(x1: 4, x2: 5, color: MockData.color2),
          ],
        ),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      List<Map<String, dynamic>> results = [];
      when(mockCanvasWrapper.drawRect(captureAny, captureAny))
          .thenAnswer((inv) {
        results.add({
          'rect': inv.positionalArguments[0] as Rect,
          'paint_color': (inv.positionalArguments[1] as Paint).color,
        });
      });

      lineChartPainter.drawRangeAnnotation(mockCanvasWrapper, holder);
      expect(results.length, 2);

      expect(results[0]['rect'], const Rect.fromLTRB(2.0, 0.0, 4.0, 100.0));
      expect(results[0]['paint_color'], MockData.color1);

      expect(results[1]['rect'], const Rect.fromLTRB(8.0, 0.0, 10.0, 100.0));
      expect(results[1]['paint_color'], MockData.color2);
    });

    test('test 4 - both', () {
      const viewSize = Size(20, 100);

      final LineChartData data = LineChartData(
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 10,
        titlesData: FlTitlesData(show: false),
        rangeAnnotations: RangeAnnotations(
          horizontalRangeAnnotations: [
            HorizontalRangeAnnotation(y1: 4, y2: 10, color: MockData.color1),
            HorizontalRangeAnnotation(y1: 12, y2: 14, color: MockData.color2),
          ],
          verticalRangeAnnotations: [
            VerticalRangeAnnotation(x1: 1, x2: 2, color: MockData.color1),
            VerticalRangeAnnotation(x1: 4, x2: 5, color: MockData.color2),
          ],
        ),
      );

      final LineChartPainter lineChartPainter = LineChartPainter();
      final holder = PaintHolder<LineChartData>(data, data, 1.0);
      MockCanvasWrapper mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      lineChartPainter.drawRangeAnnotation(mockCanvasWrapper, holder);

      verify(mockCanvasWrapper.drawRect(captureAny, captureAny)).called(4);
    });
  });
}
