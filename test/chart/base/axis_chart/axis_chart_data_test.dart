import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../data_pool.dart';
import 'axis_chart_data_test.mocks.dart';

@GenerateMocks([Canvas])
void main() {
  group('AxisChartData data equality check', () {
    test('AxisTitle equality test', () {
      expect(MockData.axisTitles1 == MockData.axisTitles1Clone, true);
      expect(MockData.axisTitles1 == MockData.axisTitles2, false);
      expect(MockData.axisTitles1 == MockData.axisTitles3, false);
      expect(MockData.axisTitles1 == MockData.axisTitles4, false);
      expect(MockData.axisTitles1 == MockData.axisTitles5, false);
    });

    test('FlTitlesData equality test', () {
      expect(MockData.flTitlesData1 == MockData.flTitlesData1Clone, true);
      expect(MockData.flTitlesData1 == MockData.flTitlesData2, false);
      expect(MockData.flTitlesData1 == MockData.flTitlesData3, false);
      expect(MockData.flTitlesData1 == MockData.flTitlesData4, false);
      expect(MockData.flTitlesData1 == MockData.flTitlesData5, false);
      expect(MockData.flTitlesData1 == MockData.flTitlesData6, false);
    });

    test('SideTitles equality test', () {
      expect(MockData.sideTitles1 == MockData.sideTitles1Clone, true);
      expect(MockData.sideTitles1 == MockData.sideTitles2, false);
      expect(MockData.sideTitles1 == MockData.sideTitles3, false);
      expect(MockData.sideTitles1 == MockData.sideTitles4, false);
      expect(MockData.sideTitles1 == MockData.sideTitles5, false);
      expect(MockData.sideTitles1 == MockData.sideTitles6, false);
    });

    test('SideTitleFitInsideData equality test', () {
      expect(
        MockData.sideTitleFitInsideData1 ==
            MockData.sideTitleFitInsideData1Clone,
        true,
      );
      expect(
        MockData.sideTitleFitInsideData1 == MockData.sideTitleFitInsideData2,
        false,
      );
      expect(
        MockData.sideTitleFitInsideData1 == MockData.sideTitleFitInsideData3,
        false,
      );
      expect(
        MockData.sideTitleFitInsideData1 == MockData.sideTitleFitInsideData4,
        false,
      );
      expect(
        MockData.sideTitleFitInsideData1 == MockData.sideTitleFitInsideData5,
        false,
      );
      expect(
        MockData.sideTitleFitInsideData1 == MockData.sideTitleFitInsideData6,
        false,
      );
    });

    test('FlSpot equality test', () {
      expect(flSpot1 == flSpot1Clone, true);

      expect(flSpot1 == flSpot2, false);

      expect(flSpot2 == flSpot2Clone, true);

      expect(nullSpot1 == nullSpot2, true);

      expect(nullSpot2 == nullSpot3, true);

      expect(nullSpot1 == nullSpot3, true);
    });

    test('FlGridData equality test', () {
      expect(flGridData1 == flGridData1Clone, true);
      expect(flGridData1 == flGridData2, false);
      expect(flGridData1 == flGridData3, false);
      expect(flGridData1 == flGridData4, false);
      expect(flGridData1 == flGridData5, false);
    });

    test('FlLine equality test', () {
      expect(flLine1 == flLine1Clone, true);

      expect(
        flLine1 ==
            const FlLine(
              color: Colors.green,
              strokeWidth: 1.001,
              dashArray: [1, 2, 3],
            ),
        false,
      );

      expect(
        flLine1 ==
            const FlLine(
              color: Colors.green,
              strokeWidth: 1,
              dashArray: [
                1,
              ],
            ),
        false,
      );

      expect(
        flLine1 ==
            const FlLine(color: Colors.green, strokeWidth: 1, dashArray: []),
        false,
      );

      expect(
        flLine1 == const FlLine(color: Colors.green, strokeWidth: 1),
        false,
      );

      expect(
        flLine1 ==
            const FlLine(
              color: Colors.white,
              strokeWidth: 1,
              dashArray: [1, 2, 3],
            ),
        false,
      );

      expect(
        flLine1 ==
            const FlLine(
              color: Colors.green,
              strokeWidth: 100,
              dashArray: [1, 2, 3],
            ),
        false,
      );
    });

    test('RangeAnnotations equality test', () {
      expect(rangeAnnotations1 == rangeAnnotations1Clone, true);

      expect(rangeAnnotations1 == rangeAnnotations2, false);

      expect(
        rangeAnnotations1 ==
            RangeAnnotations(
              horizontalRangeAnnotations: [
                horizontalRangeAnnotation1Clone,
                horizontalRangeAnnotation1,
              ],
              verticalRangeAnnotations: [
                verticalRangeAnnotation1Clone,
                verticalRangeAnnotation1,
              ],
            ),
        true,
      );

      expect(
        rangeAnnotations1 ==
            RangeAnnotations(
              horizontalRangeAnnotations: [
                horizontalRangeAnnotation1Clone,
              ],
              verticalRangeAnnotations: [
                verticalRangeAnnotation1Clone,
              ],
            ),
        false,
      );

      expect(
        rangeAnnotations1 ==
            RangeAnnotations(
              horizontalRangeAnnotations: [],
              verticalRangeAnnotations: [
                verticalRangeAnnotation1,
                verticalRangeAnnotation1Clone,
              ],
            ),
        false,
      );

      expect(
        rangeAnnotations1 ==
            RangeAnnotations(
              horizontalRangeAnnotations: [
                horizontalRangeAnnotation1,
                horizontalRangeAnnotation1Clone,
              ],
              verticalRangeAnnotations: [
                verticalRangeAnnotation1,
                VerticalRangeAnnotation(
                  color: Colors.green,
                  x2: 12.01,
                  x1: 12.1,
                ),
              ],
            ),
        false,
      );
    });

    test('HorizontalRangeAnnotation equality test', () {
      expect(
        horizontalRangeAnnotation1 == horizontalRangeAnnotation1Clone,
        true,
      );

      expect(
        horizontalRangeAnnotation1 ==
            HorizontalRangeAnnotation(
              color: Colors.green,
              y2: 12.1,
              y1: 12.1,
            ),
        false,
      );

      expect(
        horizontalRangeAnnotation1 ==
            HorizontalRangeAnnotation(
              color: Colors.green,
              y2: 12,
              y1: 12.1,
            ),
        true,
      );

      expect(
        horizontalRangeAnnotation1 ==
            HorizontalRangeAnnotation(
              color: Colors.green,
              y2: 12.1,
              y1: 12,
            ),
        false,
      );

      expect(
        horizontalRangeAnnotation1 ==
            HorizontalRangeAnnotation(
              color: Colors.green.withValues(alpha: 0.5),
              y2: 12,
              y1: 12.1,
            ),
        false,
      );
    });

    test('VerticalRangeAnnotation equality test', () {
      expect(verticalRangeAnnotation1 == verticalRangeAnnotation1Clone, true);

      expect(
        verticalRangeAnnotation1 ==
            VerticalRangeAnnotation(color: Colors.green, x2: 12.1, x1: 12.1),
        false,
      );

      expect(
        verticalRangeAnnotation1 ==
            VerticalRangeAnnotation(color: Colors.green, x2: 12, x1: 12.1),
        true,
      );

      expect(
        verticalRangeAnnotation1 ==
            VerticalRangeAnnotation(color: Colors.green, x2: 12.1, x1: 12),
        false,
      );

      expect(
        verticalRangeAnnotation1 ==
            VerticalRangeAnnotation(
              color: Colors.green.withValues(alpha: 0.5),
              x2: 12,
              x1: 12.1,
            ),
        false,
      );
    });

    test('FlSpotErrorRangePainter equality', () {
      final FlSpotErrorRangePainter painter1 = FlSimpleErrorPainter();
      final painter2 = FlSimpleErrorPainter();
      final painter3 = FlSimpleErrorPainter(
        lineWidth: 1.1,
      );
      expect(painter1 == painter2, true);
      expect(painter1 != painter3, true);
    });

    test('FlSpotErrorRangePainter render functionality (without texts)', () {
      final painter = FlSimpleErrorPainter(
        lineWidth: 5.3,
        lineColor: Colors.green,
        capLength: 10,
      );
      final mockCanvas = MockCanvas();
      const offsetInCanvas = Offset(24, 34);
      const origin = FlSpot(4, 1);

      painter.draw(
        mockCanvas,
        offsetInCanvas,
        origin,
        const Rect.fromLTWH(0, 4, 0, 6),
        LineChartData(),
      );
      verify(
        mockCanvas.drawLine(
          captureAny,
          captureAny,
          captureAny,
        ),
      ).called(3);

      painter.draw(
        mockCanvas,
        offsetInCanvas,
        origin,
        const Rect.fromLTWH(4, 4, 6, 6),
        LineChartData(),
      );
      final result = verify(
        mockCanvas.drawLine(
          captureAny,
          captureAny,
          any,
        ),
      )..called(6);
      expect(result.captured[0], const Offset(24, 38));
      expect(result.captured[1], const Offset(24, 44));
      expect(result.captured[2], const Offset(19, 38));
      expect(result.captured[3], const Offset(29, 38));
      expect(result.captured[4], const Offset(19, 44));
      expect(result.captured[5], const Offset(29, 44));
      expect(result.captured[6], const Offset(28, 34));
      expect(result.captured[7], const Offset(34, 34));
      expect(result.captured[8], const Offset(28, 29));
      expect(result.captured[9], const Offset(28, 39));

      verifyNever(mockCanvas.drawParagraph(any, any));
    });

    test('FlSpotErrorRangePainter render functionality (with texts)', () {
      final painter = FlSimpleErrorPainter(
        showErrorTexts: true,
        errorTextDirection: TextDirection.rtl,
        errorTextStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
      );
      final mockCanvas = MockCanvas();

      painter.draw(
        mockCanvas,
        const Offset(24, 34),
        const FlSpot(
          4,
          1,
          xError: FlErrorRange.symmetric(1),
          yError: FlErrorRange.symmetric(1),
        ),
        const Rect.fromLTWH(4, 4, 6, 6),
        LineChartData(),
      );
      verify(
        mockCanvas.drawLine(
          captureAny,
          captureAny,
          any,
        ),
      ).called(6);
      verify(
        mockCanvas.drawParagraph(captureAny, captureAny),
      ).called(4);
    });
  });
}
