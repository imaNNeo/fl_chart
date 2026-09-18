import 'dart:ui' as ui show Image;

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

  group('FlDotImagePainter', () {
    // A single handle is reused everywhere, because [ui.Image] compares by
    // identity and createTestImage() hands out a fresh clone on every call.
    late final ui.Image image;

    setUpAll(() async {
      image = await createTestImage(width: 20, height: 10);
    });

    test('equality', () {
      final painter1 = FlDotImagePainter(image: image);
      final painter2 = FlDotImagePainter(image: image);
      final painter3 = FlDotImagePainter(image: image, size: 12);
      final painter4 = FlDotImagePainter(image: image, mainColor: Colors.red);

      expect(painter1 == painter2, true);
      expect(painter1 == painter3, false);
      expect(painter1 == painter4, false);
    });

    test('equality with a different image', () async {
      final otherImage = await createTestImage(
        width: 20,
        height: 10,
        cache: false,
      );

      expect(
        FlDotImagePainter(image: image) == FlDotImagePainter(image: otherImage),
        false,
      );
    });

    test('getSize and mainColor', () {
      const spot = FlSpot(1, 1);

      expect(FlDotImagePainter(image: image).getSize(spot), const Size(24, 24));
      expect(
        FlDotImagePainter(image: image, size: 12).getSize(spot),
        const Size(12, 12),
      );
      expect(FlDotImagePainter(image: image).mainColor, Colors.green);
      expect(
        FlDotImagePainter(image: image, mainColor: Colors.red).mainColor,
        Colors.red,
      );
    });

    test('lerp between two image painters', () async {
      final otherImage = await createTestImage(width: 4, height: 4);
      final painter1 = FlDotImagePainter(
        image: image,
        size: 10,
        mainColor: Colors.black,
      );
      final painter2 = FlDotImagePainter(
        image: otherImage,
        size: 20,
        mainColor: Colors.white,
      );

      final lerped =
          painter1.lerp(painter1, painter2, 0.5) as FlDotImagePainter;
      expect(lerped.size, 15);
      expect(lerped.mainColor, Color.lerp(Colors.black, Colors.white, 0.5));
      // The image can't be interpolated, so it snaps to the target one.
      expect(lerped.image, same(otherImage));
    });

    test('lerp falls back to b when the types differ', () {
      final painter = FlDotImagePainter(image: image);
      final circlePainter = FlDotCirclePainter();

      expect(painter.lerp(painter, circlePainter, 0.5), same(circlePainter));
      expect(painter.lerp(circlePainter, painter, 0.5), same(painter));
    });

    test('hitTest behaves like a square of getSize', () {
      final painter = FlDotImagePainter(image: image, size: 20);
      const spot = FlSpot(1, 1);
      const center = Offset(50, 50);

      expect(painter.hitTest(spot, const Offset(59, 59), center, 0), true);
      expect(painter.hitTest(spot, const Offset(61, 61), center, 0), false);
      expect(painter.hitTest(spot, const Offset(61, 61), center, 5), true);
    });

    test('draw fits the image inside the dot square, keeping its ratio', () {
      final painter = FlDotImagePainter(image: image);
      final mockCanvas = MockCanvas();

      painter.draw(mockCanvas, const FlSpot(1, 1), const Offset(50, 60));

      final result = verify(
        mockCanvas.drawImageRect(
          captureAny,
          captureAny,
          captureAny,
          captureAny,
        ),
      )..called(1);
      expect(result.captured[0], same(image));
      // The whole 20x10 image is drawn...
      expect(result.captured[1], const Rect.fromLTWH(0, 0, 20, 10));
      // ...scaled down to 24x12 and centered on the spot, so it fits inside
      // the 24x24 square without being stretched.
      expect(result.captured[2], const Rect.fromLTRB(38, 54, 62, 66));
      expect(
        (result.captured[3] as Paint).filterQuality,
        FilterQuality.high,
      );
    });

    test('draw fills the dot square when the image is a square', () async {
      final squareImage = await createTestImage(width: 10, height: 10);
      final painter = FlDotImagePainter(image: squareImage, size: 20);
      final mockCanvas = MockCanvas();

      painter.draw(mockCanvas, const FlSpot(1, 1), const Offset(50, 60));

      final result = verify(
        mockCanvas.drawImageRect(
          captureAny,
          captureAny,
          captureAny,
          captureAny,
        ),
      )..called(1);
      expect(result.captured[1], const Rect.fromLTWH(0, 0, 10, 10));
      expect(result.captured[2], const Rect.fromLTRB(40, 50, 60, 70));
    });
  });
}
