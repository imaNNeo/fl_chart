import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../data_pool.dart';
import 'radar_chart_painter_test.mocks.dart';

@GenerateMocks([Canvas, CanvasWrapper, BuildContext, Utils])
void main() {
  final utilsMainInstance = Utils();
  group('paint()', () {
    test('test 1', () {
      const viewSize = Size(400, 400);
      final data = RadarChartData(
        dataSets: [
          RadarDataSet(
            dataEntries: const [
              RadarEntry(value: 12),
              RadarEntry(value: 11),
              RadarEntry(value: 10),
            ],
          ),
          RadarDataSet(
            dataEntries: const [
              RadarEntry(value: 2),
              RadarEntry(value: 2),
              RadarEntry(value: 2),
            ],
          ),
          RadarDataSet(
            dataEntries: const [
              RadarEntry(value: 4),
              RadarEntry(value: 4),
              RadarEntry(value: 4),
            ],
          ),
        ],
      );

      final radarPainter = RadarChartPainter();
      final holder = PaintHolder<RadarChartData>(
        data,
        data,
        TextScaler.noScaling,
      );

      final mockUtils = MockUtils();
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
      when(mockUtils.normalizeBorderRadius(any, any))
          .thenAnswer((realInvocation) => BorderRadius.zero);
      when(mockUtils.normalizeBorderSide(any, any)).thenAnswer(
        (realInvocation) => const BorderSide(color: MockData.color0),
      );

      final mockBuildContext = MockBuildContext();
      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      radarPainter.paint(
        mockBuildContext,
        mockCanvasWrapper,
        holder,
      );

      verify(mockCanvasWrapper.drawCircle(any, any, any)).called(12);
      verify(mockCanvasWrapper.drawLine(any, any, any)).called(3);
      Utils.changeInstance(utilsMainInstance);
    });
  });

  group('drawTicks()', () {
    test('test 1', () {
      const viewSize = Size(400, 300);

      final data = RadarChartData(
        dataSets: [
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
            ],
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
            ],
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
            ],
          ),
        ],
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        radarBackgroundColor: MockData.color2,
      );

      final radarChartPainter = RadarChartPainter();
      final holder =
          PaintHolder<RadarChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final mockUtils = MockUtils();
      when(mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(MockData.textStyle1);
      Utils.changeInstance(mockUtils);

      final mockContext = MockBuildContext();

      final drawCircleResults = <Map<String, dynamic>>[];
      when(mockCanvasWrapper.drawCircle(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        drawCircleResults.add({
          'offset': inv.positionalArguments[0] as Offset,
          'radius': inv.positionalArguments[1] as double,
          'paint_color': (inv.positionalArguments[2] as Paint).color,
          'paint_style': (inv.positionalArguments[2] as Paint).style,
          'paint_stroke': (inv.positionalArguments[2] as Paint).strokeWidth,
        });
      });

      radarChartPainter.drawTicks(mockContext, mockCanvasWrapper, holder);

      expect(drawCircleResults.length, 3);

      // Background circle
      expect(drawCircleResults[0]['offset'], const Offset(200, 150));
      expect(drawCircleResults[0]['radius'], 120);
      expect(drawCircleResults[0]['paint_color'], MockData.color2);
      expect(drawCircleResults[0]['paint_style'], PaintingStyle.fill);

      // Border circle
      expect(drawCircleResults[1]['offset'], const Offset(200, 150));
      expect(drawCircleResults[1]['radius'], 120);
      expect(drawCircleResults[1]['paint_color'], MockData.color6);
      expect(drawCircleResults[1]['paint_stroke'], 33);
      expect(drawCircleResults[1]['paint_style'], PaintingStyle.stroke);

      // First Tick
      expect(drawCircleResults[2]['offset'], const Offset(200, 150));
      expect(drawCircleResults[2]['radius'], 60);
      expect(drawCircleResults[2]['paint_color'], MockData.color5);
      expect(drawCircleResults[2]['paint_stroke'], 55);
      expect(drawCircleResults[2]['paint_style'], PaintingStyle.stroke);

      final result = verify(mockCanvasWrapper.drawText(captureAny, captureAny));
      expect(result.callCount, 1);
      final tp = result.captured[0] as TextPainter;
      expect((tp.text as TextSpan?)!.text, '1.0');
      expect((tp.text as TextSpan?)!.style, MockData.textStyle1);
      expect(result.captured[1] as Offset, const Offset(205, 76));
    });

    test('test 2', () {
      const viewSize = Size(400, 300);

      final data = RadarChartData(
        dataSets: [
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
            ],
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
            ],
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
            ],
          ),
        ],
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        radarShape: RadarShape.polygon,
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        radarBackgroundColor: MockData.color2,
      );

      final radarChartPainter = RadarChartPainter();
      final holder =
          PaintHolder<RadarChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final mockUtils = MockUtils();
      when(mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(MockData.textStyle1);
      Utils.changeInstance(mockUtils);

      final mockContext = MockBuildContext();

      final drawPathResult = <Map<String, dynamic>>[];
      when(mockCanvasWrapper.drawPath(captureAny, captureAny))
          .thenAnswer((inv) {
        drawPathResult.add({
          'path': inv.positionalArguments[0] as Path,
          'paint_color': (inv.positionalArguments[1] as Paint).color,
          'paint_stroke': (inv.positionalArguments[1] as Paint).strokeWidth,
          'paint_style': (inv.positionalArguments[1] as Paint).style,
        });
      });

      radarChartPainter.drawTicks(mockContext, mockCanvasWrapper, holder);

      expect(drawPathResult.length, 3);

      // Background circle
      expect(drawPathResult[0]['paint_color'], MockData.color2);
      expect(drawPathResult[0]['paint_stroke'], 0);
      expect(drawPathResult[0]['paint_style'], PaintingStyle.fill);

      // Border circle
      expect(drawPathResult[1]['paint_color'], MockData.color6);
      expect(drawPathResult[1]['paint_stroke'], 33);
      expect(drawPathResult[1]['paint_style'], PaintingStyle.stroke);

      // First Tick
      expect(drawPathResult[2]['paint_color'], MockData.color5);
      expect(drawPathResult[2]['paint_stroke'], 55);
      expect(drawPathResult[2]['paint_style'], PaintingStyle.stroke);

      final result = verify(mockCanvasWrapper.drawText(captureAny, captureAny));
      expect(result.callCount, 1);
      final tp = result.captured[0] as TextPainter;
      expect((tp.text as TextSpan?)!.text, '1.0');
      expect((tp.text as TextSpan?)!.style, MockData.textStyle1);
      expect(result.captured[1] as Offset, const Offset(205, 76));
    });
  });

  group('drawGrids()', () {
    test('test 1', () {
      const viewSize = Size(400, 300);

      final data = RadarChartData(
        dataSets: [
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
            ],
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
            ],
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
            ],
          ),
        ],
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        gridBorderData: const BorderSide(color: MockData.color3, width: 3),
        radarBackgroundColor: MockData.color2,
      );

      final radarChartPainter = RadarChartPainter();
      final holder =
          PaintHolder<RadarChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final mockUtils = MockUtils();
      when(mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(MockData.textStyle1);
      Utils.changeInstance(mockUtils);

      final drawLineResults = <Map<String, dynamic>>[];
      when(mockCanvasWrapper.drawLine(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        drawLineResults.add({
          'offset_from': inv.positionalArguments[0] as Offset,
          'offset_to': inv.positionalArguments[1] as Offset,
          'paint_color': (inv.positionalArguments[2] as Paint).color,
          'paint_style': (inv.positionalArguments[2] as Paint).style,
          'paint_stroke': (inv.positionalArguments[2] as Paint).strokeWidth,
        });
      });

      radarChartPainter.drawGrids(mockCanvasWrapper, holder);
      expect(drawLineResults.length, 3);

      expect(drawLineResults[0]['offset_from'], const Offset(200, 150));
      expect(drawLineResults[0]['offset_to'], const Offset(200, 30));
      expect(drawLineResults[0]['paint_color'], MockData.color3);
      expect(drawLineResults[0]['paint_style'], PaintingStyle.stroke);
      expect(drawLineResults[0]['paint_stroke'], 3);

      expect(drawLineResults[1]['offset_from'], const Offset(200, 150));
      expect(
        drawLineResults[1]['offset_to'],
        const Offset(303.92304845413264, 209.99999999999997),
      );
      expect(drawLineResults[1]['paint_color'], MockData.color3);
      expect(drawLineResults[1]['paint_style'], PaintingStyle.stroke);
      expect(drawLineResults[1]['paint_stroke'], 3);

      expect(drawLineResults[2]['offset_from'], const Offset(200, 150));
      expect(
        drawLineResults[2]['offset_to'],
        const Offset(96.07695154586739, 210.00000000000006),
      );
      expect(drawLineResults[2]['paint_color'], MockData.color3);
      expect(drawLineResults[2]['paint_style'], PaintingStyle.stroke);
      expect(drawLineResults[2]['paint_stroke'], 3);
    });
  });

  group('drawGrids()', () {
    test('test 1', () {
      const viewSize = Size(400, 300);

      final data = RadarChartData(
        dataSets: [
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
            ],
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
            ],
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
            ],
          ),
        ],
        titleTextStyle: MockData.textStyle4,
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        gridBorderData: const BorderSide(color: MockData.color3, width: 3),
        radarBackgroundColor: MockData.color2,
      );

      final radarChartPainter = RadarChartPainter();
      final holder =
          PaintHolder<RadarChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final mockUtils = MockUtils();
      when(mockUtils.getThemeAwareTextStyle(any, any)).thenAnswer(
        (realInvocation) => realInvocation.positionalArguments[1] as TextStyle,
      );
      Utils.changeInstance(mockUtils);

      final mockContext = MockBuildContext();

      radarChartPainter.drawTitles(mockContext, mockCanvasWrapper, holder);

      verifyNever(mockCanvasWrapper.drawText(any, any));
    });

    test('test 2', () {
      const viewSize = Size(400, 300);

      final data = RadarChartData(
        dataSets: [
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
            ],
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
            ],
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
            ],
          ),
        ],
        getTitle: (index, angle) {
          return RadarChartTitle(text: '$index$index', angle: angle);
        },
        titleTextStyle: MockData.textStyle4,
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        gridBorderData: const BorderSide(color: MockData.color3, width: 3),
        radarBackgroundColor: MockData.color2,
      );

      final radarChartPainter = RadarChartPainter();
      final holder =
          PaintHolder<RadarChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final mockUtils = MockUtils();
      when(mockUtils.getThemeAwareTextStyle(any, any)).thenAnswer(
        (realInvocation) => realInvocation.positionalArguments[1] as TextStyle,
      );
      when(mockUtils.degrees(captureAny)).thenAnswer((inv) {
        return utilsMainInstance
            .degrees(inv.positionalArguments.first as double);
      });
      Utils.changeInstance(mockUtils);

      final mockContext = MockBuildContext();

      final results = <Map<String, dynamic>>[];
      when(
        mockCanvasWrapper.drawRotated(
          size: anyNamed('size'),
          rotationOffset: anyNamed('rotationOffset'),
          drawOffset: anyNamed('drawOffset'),
          angle: anyNamed('angle'),
          drawCallback: captureAnyNamed('drawCallback'),
        ),
      ).thenAnswer((inv) {
        (inv.namedArguments[const Symbol('drawCallback')] as void Function())();
      });
      when(mockCanvasWrapper.drawText(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        results.add({
          'tp_text':
              ((inv.positionalArguments[0] as TextPainter).text as TextSpan?)!
                  .text,
          'tp_style':
              ((inv.positionalArguments[0] as TextPainter).text as TextSpan?)!
                  .style,
        });
      });

      radarChartPainter.drawTitles(mockContext, mockCanvasWrapper, holder);
      expect(results.length, 3);

      expect(results[0]['tp_text'] as String, '00');
      expect(results[0]['tp_style'] as TextStyle, MockData.textStyle4);

      expect(results[1]['tp_text'] as String, '11');
      expect(results[1]['tp_style'] as TextStyle, MockData.textStyle4);

      expect(results[2]['tp_text'] as String, '22');
      expect(results[2]['tp_style'] as TextStyle, MockData.textStyle4);
    });
  });

  group('drawDataSets()', () {
    test('test 1', () {
      const viewSize = Size(400, 300);

      final data = RadarChartData(
        dataSets: [
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
            ],
            fillColor: MockData.color1,
            borderColor: MockData.color3,
            borderWidth: 3,
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
            ],
            fillColor: MockData.color2,
            borderColor: MockData.color2,
            borderWidth: 2,
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
            ],
            fillColor: MockData.color3,
            borderColor: MockData.color1,
            borderWidth: 1,
          ),
        ],
        getTitle: (index, angle) {
          return RadarChartTitle(text: '$index$index', angle: angle);
        },
        titleTextStyle: MockData.textStyle4,
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        gridBorderData: const BorderSide(color: MockData.color3, width: 3),
        radarBackgroundColor: MockData.color2,
      );

      final radarChartPainter = RadarChartPainter();
      final holder =
          PaintHolder<RadarChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final mockUtils = MockUtils();
      when(mockUtils.getThemeAwareTextStyle(any, any)).thenAnswer(
        (realInvocation) => realInvocation.positionalArguments[1] as TextStyle,
      );
      Utils.changeInstance(mockUtils);

      final drawCircleResults = <Map<String, dynamic>>[];
      when(mockCanvasWrapper.drawCircle(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        drawCircleResults.add({
          'offset': inv.positionalArguments[0] as Offset,
          'radius': inv.positionalArguments[1] as double,
          'paint': inv.positionalArguments[2] as Paint,
        });
      });

      final drawPathResults = <Map<String, dynamic>>[];
      when(mockCanvasWrapper.drawPath(captureAny, captureAny))
          .thenAnswer((inv) {
        drawPathResults.add({
          'path': inv.positionalArguments[0] as Path,
          'paint_color': (inv.positionalArguments[1] as Paint).color,
          'paint_stroke': (inv.positionalArguments[1] as Paint).strokeWidth,
          'paint_style': (inv.positionalArguments[1] as Paint).style,
        });
      });

      radarChartPainter.drawDataSets(mockCanvasWrapper, holder);
      expect(drawCircleResults.length, 9);

      expect(
        drawCircleResults[0]['offset'] as Offset,
        const Offset(200, 90),
      );
      expect(drawCircleResults[0]['radius'] as double, 5);

      expect(
        drawCircleResults[1]['offset'] as Offset,
        const Offset(277.9422863405995, 195),
      );
      expect(drawCircleResults[1]['radius'] as double, 5);

      expect(
        drawCircleResults[2]['offset'] as Offset,
        const Offset(96.07695154586739, 210.00000000000006),
      );
      expect(drawCircleResults[2]['radius'] as double, 5);

      expect(
        drawCircleResults[3]['offset'] as Offset,
        const Offset(200, 30),
      );
      expect(drawCircleResults[3]['radius'] as double, 5);

      expect(
        drawCircleResults[4]['offset'] as Offset,
        const Offset(251.96152422706632, 180),
      );
      expect(drawCircleResults[4]['radius'] as double, 5);

      expect(
        drawCircleResults[5]['offset'] as Offset,
        const Offset(122.05771365940053, 195.00000000000003),
      );
      expect(drawCircleResults[5]['radius'] as double, 5);

      expect(
        drawCircleResults[6]['offset'] as Offset,
        const Offset(200, 60),
      );
      expect(drawCircleResults[6]['radius'] as double, 5);

      expect(
        drawCircleResults[7]['offset'] as Offset,
        const Offset(303.92304845413264, 209.99999999999997),
      );
      expect(drawCircleResults[7]['radius'] as double, 5);

      expect(
        drawCircleResults[8]['offset'] as Offset,
        const Offset(148.03847577293368, 180.00000000000003),
      );
      expect(drawCircleResults[8]['radius'] as double, 5);

      expect(drawPathResults.length, 6);

      expect(drawPathResults[0]['paint_color'], MockData.color1);
      expect(drawPathResults[0]['paint_style'], PaintingStyle.fill);

      expect(drawPathResults[1]['paint_color'], MockData.color3);
      expect(drawPathResults[1]['paint_stroke'], 3);
      expect(drawPathResults[1]['paint_style'], PaintingStyle.stroke);

      expect(drawPathResults[2]['paint_color'], MockData.color2);
      expect(drawPathResults[2]['paint_style'], PaintingStyle.fill);

      expect(drawPathResults[3]['paint_color'], MockData.color2);
      expect(drawPathResults[3]['paint_stroke'], 2);
      expect(drawPathResults[3]['paint_style'], PaintingStyle.stroke);

      expect(drawPathResults[4]['paint_color'], MockData.color3);
      expect(drawPathResults[4]['paint_style'], PaintingStyle.fill);

      expect(drawPathResults[5]['paint_color'], MockData.color1);
      expect(drawPathResults[5]['paint_stroke'], 1);
      expect(drawPathResults[5]['paint_style'], PaintingStyle.stroke);
    });
  });

  group('drawTitles()', () {
    test('rotated titles', () {
      const viewSize = Size(400, 300);

      final data = RadarChartData(
        dataSets: [
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
            ],
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
            ],
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
            ],
          ),
        ],
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        radarBackgroundColor: MockData.color2,
        getTitle: (index, angle) {
          return RadarChartTitle(text: '$index-$angle', angle: angle);
        },
      );

      final radarChartPainter = RadarChartPainter();
      final holder =
          PaintHolder<RadarChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final mockUtils = MockUtils();
      when(mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(MockData.textStyle1);
      when(mockUtils.degrees(captureAny)).thenAnswer((inv) {
        return utilsMainInstance
            .degrees(inv.positionalArguments.first as double);
      });
      Utils.changeInstance(mockUtils);

      final mockContext = MockBuildContext();

      final drawRotatedResults = <Map<String, dynamic>>[];
      final drawTextResults = <Map<String, dynamic>>[];
      when(
        mockCanvasWrapper.drawRotated(
          size: anyNamed('size'),
          rotationOffset: anyNamed('rotationOffset'),
          drawOffset: anyNamed('drawOffset'),
          angle: captureAnyNamed('angle'),
          drawCallback: captureAnyNamed('drawCallback'),
        ),
      ).thenAnswer((inv) {
        drawRotatedResults.add({
          'angle': inv.namedArguments[const Symbol('angle')],
        });
        (inv.namedArguments[const Symbol('drawCallback')] as void Function())();
      });
      when(mockCanvasWrapper.drawText(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        drawTextResults.add({
          'text':
              (inv.positionalArguments[0] as TextPainter).text?.toPlainText(),
          'angle': inv.positionalArguments[2] as double,
        });
      });

      radarChartPainter.drawTitles(mockContext, mockCanvasWrapper, holder);

      expect(drawRotatedResults.length, 3);
      expect(drawTextResults.length, 3);

      // Titles
      const angle = 360.0 / 3;
      for (var i = 0; i < drawTextResults.length; i++) {
        expect(drawRotatedResults[i]['angle'], closeTo(angle * i, 0.001));
        expect(drawTextResults[i]['text'], startsWith('$i'));
        expect(drawTextResults[i]['angle'], 0);
      }
    });
    test('horizontal titles by default', () {
      const viewSize = Size(400, 300);

      final data = RadarChartData(
        dataSets: [
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
            ],
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
            ],
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
            ],
          ),
        ],
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        radarBackgroundColor: MockData.color2,
        getTitle: (index, angle) {
          return RadarChartTitle(text: '$index-$angle');
        },
      );

      final radarChartPainter = RadarChartPainter();
      final holder =
          PaintHolder<RadarChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final mockUtils = MockUtils();
      when(mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(MockData.textStyle1);
      when(mockUtils.degrees(captureAny)).thenAnswer((inv) {
        return utilsMainInstance
            .degrees(inv.positionalArguments.first as double);
      });
      Utils.changeInstance(mockUtils);

      final mockContext = MockBuildContext();

      final drawRotatedResults = <Map<String, dynamic>>[];
      final drawTextResults = <Map<String, dynamic>>[];
      when(
        mockCanvasWrapper.drawRotated(
          size: anyNamed('size'),
          rotationOffset: anyNamed('rotationOffset'),
          drawOffset: anyNamed('drawOffset'),
          angle: captureAnyNamed('angle'),
          drawCallback: captureAnyNamed('drawCallback'),
        ),
      ).thenAnswer((inv) {
        drawRotatedResults.add({
          'angle': inv.namedArguments[const Symbol('angle')],
        });
        (inv.namedArguments[const Symbol('drawCallback')] as void Function())();
      });
      when(mockCanvasWrapper.drawText(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        drawTextResults.add({
          'text':
              (inv.positionalArguments[0] as TextPainter).text?.toPlainText(),
          'angle': inv.positionalArguments[2] as double,
        });
      });

      radarChartPainter.drawTitles(mockContext, mockCanvasWrapper, holder);

      expect(drawRotatedResults.length, 3);
      expect(drawTextResults.length, 3);

      // Titles
      const angle = 360.0 / 3;
      for (var i = 0; i < drawTextResults.length; i++) {
        expect(drawRotatedResults[i]['angle'], closeTo(angle * i, 0.001));
        expect(drawTextResults[i]['text'], startsWith('$i'));
        expect(drawTextResults[i]['angle'], closeTo(-angle * i, 0.001));
      }
    });
  });

  group('handleTouch()', () {
    test('test 1', () {
      const viewSize = Size(400, 300);
      final data = RadarChartData(
        dataSets: [
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
            ],
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
            ],
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
            ],
          ),
        ],
      );

      final radarChartPainter = RadarChartPainter();
      final holder =
          PaintHolder<RadarChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final mockUtils = MockUtils();
      when(mockUtils.getThemeAwareTextStyle(any, any)).thenAnswer(
        (realInvocation) => realInvocation.positionalArguments[1] as TextStyle,
      );
      Utils.changeInstance(mockUtils);

      final drawCircleResults = <Map<String, dynamic>>[];
      when(mockCanvasWrapper.drawCircle(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        drawCircleResults.add({
          'offset': inv.positionalArguments[0] as Offset,
          'radius': inv.positionalArguments[1] as double,
          'paint': inv.positionalArguments[2] as Paint,
        });
      });

      final drawPathResults = <Map<String, dynamic>>[];
      when(mockCanvasWrapper.drawPath(captureAny, captureAny))
          .thenAnswer((inv) {
        drawPathResults.add({
          'path': inv.positionalArguments[0] as Path,
          'paint_color': (inv.positionalArguments[1] as Paint).color,
          'paint_stroke': (inv.positionalArguments[1] as Paint).strokeWidth,
          'paint_style': (inv.positionalArguments[1] as Paint).style,
        });
      });

      expect(
        radarChartPainter.handleTouch(
          const Offset(287.8, 120.3),
          viewSize,
          holder,
        ),
        null,
      );
      expect(
        radarChartPainter.handleTouch(
          const Offset(145.1, 125.4),
          viewSize,
          holder,
        ),
        null,
      );
      expect(
        radarChartPainter.handleTouch(
          const Offset(175.9, 120.8),
          viewSize,
          holder,
        ),
        null,
      );
      expect(
        radarChartPainter.handleTouch(
          const Offset(201.8, 153.7),
          viewSize,
          holder,
        ),
        null,
      );
      expect(
        radarChartPainter.handleTouch(
          const Offset(259.5, 116.3),
          viewSize,
          holder,
        ),
        null,
      );
      expect(
        radarChartPainter.handleTouch(
          const Offset(266.9, 179.3),
          viewSize,
          holder,
        ),
        null,
      );
      expect(
        radarChartPainter.handleTouch(
          const Offset(145, 193.7),
          viewSize,
          holder,
        ),
        null,
      );

      final result0 = radarChartPainter.handleTouch(
        const Offset(304.9, 212.9),
        viewSize,
        holder,
      );
      expect(result0!.touchedDataSetIndex, 2);
      expect(result0.touchedRadarEntryIndex, 1);

      final result1 = radarChartPainter.handleTouch(
        const Offset(200, 60),
        viewSize,
        holder,
      );
      expect(result1!.touchedDataSetIndex, 2);
      expect(result1.touchedRadarEntryIndex, 0);

      final result2 = radarChartPainter.handleTouch(
        const Offset(148, 180),
        viewSize,
        holder,
      );
      expect(result2!.touchedDataSetIndex, 2);
      expect(result2.touchedRadarEntryIndex, 2);

      final result3 = radarChartPainter.handleTouch(
        const Offset(270.5, 192.3),
        viewSize,
        holder,
      );
      expect(result3!.touchedDataSetIndex, 0);
      expect(result3.touchedRadarEntryIndex, 1);

      final result4 = radarChartPainter.handleTouch(
        const Offset(98.3, 216.8),
        viewSize,
        holder,
      );
      expect(result4!.touchedDataSetIndex, 0);
      expect(result4.touchedRadarEntryIndex, 2);

      final result5 = radarChartPainter.handleTouch(
        const Offset(200, 90),
        viewSize,
        holder,
      );
      expect(result5!.touchedDataSetIndex, 0);
      expect(result5.touchedRadarEntryIndex, 0);

      final result6 = radarChartPainter.handleTouch(
        const Offset(202.6, 33.5),
        viewSize,
        holder,
      );
      expect(result6!.touchedDataSetIndex, 1);
      expect(result6.touchedRadarEntryIndex, 0);

      final result7 = radarChartPainter.handleTouch(
        const Offset(122.1, 195),
        viewSize,
        holder,
      );
      expect(result7!.touchedDataSetIndex, 1);
      expect(result7.touchedRadarEntryIndex, 2);

      final result8 = radarChartPainter.handleTouch(
        const Offset(252, 180),
        viewSize,
        holder,
      );
      expect(result8!.touchedDataSetIndex, 1);
      expect(result8.touchedRadarEntryIndex, 1);
    });
  });

  group('radarCenterY()', () {
    test('test 1', () {
      final painter = RadarChartPainter();
      expect(painter.radarCenterY(const Size(200, 400)), 200);
      expect(painter.radarCenterY(const Size(2314, 400)), 200);
    });
  });

  group('radarCenterX()', () {
    test('test 1', () {
      final painter = RadarChartPainter();
      expect(painter.radarCenterX(const Size(400, 200)), 200);
      expect(painter.radarCenterX(const Size(400, 2314)), 200);
    });
  });

  group('radarRadius()', () {
    test('test 1', () {
      final painter = RadarChartPainter();
      expect(painter.radarRadius(const Size(400, 200)), 80);
      expect(painter.radarRadius(const Size(400, 2314)), 160);
    });
  });

  group('calculateDataSetsPosition()', () {
    test('test 1', () {
      const viewSize = Size(400, 300);

      final data = RadarChartData(
        dataSets: [
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
            ],
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
              const RadarEntry(value: 2),
            ],
          ),
          RadarDataSet(
            dataEntries: [
              const RadarEntry(value: 2),
              const RadarEntry(value: 3),
              const RadarEntry(value: 1),
            ],
          ),
        ],
        titleTextStyle: MockData.textStyle4,
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        gridBorderData: const BorderSide(color: MockData.color3, width: 3),
        radarBackgroundColor: MockData.color2,
      );

      final radarChartPainter = RadarChartPainter();
      final holder =
          PaintHolder<RadarChartData>(data, data, TextScaler.noScaling);

      final result =
          radarChartPainter.calculateDataSetsPosition(viewSize, holder);
      expect(result.length, 3);
      expect(
        result[0].entriesOffset,
        [
          const Offset(200, 90),
          const Offset(277.9422863405995, 195),
          const Offset(96.07695154586739, 210.00000000000006),
        ],
      );
      expect(
        result[1].entriesOffset,
        [
          const Offset(200, 30),
          const Offset(251.96152422706632, 180),
          const Offset(122.05771365940053, 195.00000000000003),
        ],
      );
      expect(
        result[2].entriesOffset,
        [
          const Offset(200, 60),
          const Offset(303.92304845413264, 209.99999999999997),
          const Offset(148.03847577293368, 180.00000000000003),
        ],
      );
    });
  });

  group('getDefaultChartCenterValue()', () {
    final radarChartPainter = RadarChartPainter();

    test('test 1', () {
      expect(radarChartPainter.getDefaultChartCenterValue(), 0);
    });
  });

  group('getChartCenterValue()', () {
    final radarChartPainter = RadarChartPainter();
    final dataSet = RadarDataSet(
      dataEntries: [
        const RadarEntry(value: 15),
        const RadarEntry(value: 20),
        const RadarEntry(value: 20),
      ],
    );
    final dataSetWithSameMaxAndMin = RadarDataSet(
      dataEntries: [
        const RadarEntry(value: 10),
        const RadarEntry(value: 10),
        const RadarEntry(value: 10),
      ],
    );
    final dataWith1Tick = RadarChartData(
      dataSets: [dataSet],
      tickCount: 1,
    );
    final dataWith2Ticks = RadarChartData(
      dataSets: [dataSet],
      tickCount: 2,
    );
    final dataWith3Ticks = RadarChartData(
      dataSets: [dataSet],
      tickCount: 3,
    );
    final dataWithSameMaxAndMin = RadarChartData(
      dataSets: [dataSetWithSameMaxAndMin],
      tickCount: 2,
    );

    test('test 1', () {
      expect(radarChartPainter.getChartCenterValue(dataWith1Tick), 10);
      expect(radarChartPainter.getChartCenterValue(dataWith2Ticks), 12.5);
      expect(
        radarChartPainter.getChartCenterValue(dataWith3Ticks),
        13.333333333333334,
      );
    });

    test('test 2', () {
      expect(radarChartPainter.getChartCenterValue(dataWithSameMaxAndMin), 0);
    });
  });

  group('getScaledPoint()', () {
    final radarChartPainter = RadarChartPainter();
    final data = RadarChartData(
      dataSets: [
        RadarDataSet(
          dataEntries: [
            const RadarEntry(value: 15),
            const RadarEntry(value: 20),
            const RadarEntry(value: 20),
          ],
        ),
      ],
      tickCount: 2,
    );
    final dataWithSameMaxAndMin = RadarChartData(
      dataSets: [
        RadarDataSet(
          dataEntries: [
            const RadarEntry(value: 10),
            const RadarEntry(value: 10),
            const RadarEntry(value: 10),
          ],
        ),
      ],
      tickCount: 2,
    );
    const radius = 200.0;
    const point1 = RadarEntry(value: 0);
    const point2 = RadarEntry(value: 50);
    const point3 = RadarEntry(value: 150);

    test('test 1', () {
      expect(
        radarChartPainter.getScaledPoint(point1, radius, data),
        -333.3333333333333,
      );
      expect(radarChartPainter.getScaledPoint(point2, radius, data), 1000.0);
      expect(
        radarChartPainter.getScaledPoint(point3, radius, data),
        3666.6666666666665,
      );
    });

    test('test 2', () {
      expect(
        radarChartPainter.getScaledPoint(
          point1,
          radius,
          dataWithSameMaxAndMin,
        ),
        0.0,
      );
      expect(
        radarChartPainter.getScaledPoint(
          point2,
          radius,
          dataWithSameMaxAndMin,
        ),
        1000.0,
      );
      expect(
        radarChartPainter.getScaledPoint(
          point3,
          radius,
          dataWithSameMaxAndMin,
        ),
        3000.0,
      );
    });
  });

  group('getFirstTickValue()', () {
    final radarChartPainter = RadarChartPainter();
    final data = RadarChartData(
      dataSets: [
        RadarDataSet(
          dataEntries: [
            const RadarEntry(value: 15),
            const RadarEntry(value: 20),
            const RadarEntry(value: 20),
          ],
        ),
      ],
      tickCount: 2,
    );
    final dataWithSameMaxAndMin = RadarChartData(
      dataSets: [
        RadarDataSet(
          dataEntries: [
            const RadarEntry(value: 10),
            const RadarEntry(value: 10),
            const RadarEntry(value: 10),
          ],
        ),
      ],
      tickCount: 2,
    );

    test('test 1', () {
      expect(radarChartPainter.getFirstTickValue(data), 15);
    });

    test('test 2', () {
      expect(
        radarChartPainter.getFirstTickValue(dataWithSameMaxAndMin),
        3.3333333333333335,
      );
    });
  });

  group('getSpaceBetweenTicks()', () {
    final radarChartPainter = RadarChartPainter();
    final data = RadarChartData(
      dataSets: [
        RadarDataSet(
          dataEntries: [
            const RadarEntry(value: 15),
            const RadarEntry(value: 20),
            const RadarEntry(value: 20),
          ],
        ),
      ],
      tickCount: 2,
    );
    final dataWithSameMaxAndMin = RadarChartData(
      dataSets: [
        RadarDataSet(
          dataEntries: [
            const RadarEntry(value: 10),
            const RadarEntry(value: 10),
            const RadarEntry(value: 10),
          ],
        ),
      ],
      tickCount: 2,
    );

    test('test 1', () {
      expect(radarChartPainter.getSpaceBetweenTicks(data), 2.5);
    });

    test('test 2', () {
      expect(
        radarChartPainter.getSpaceBetweenTicks(dataWithSameMaxAndMin),
        3.3333333333333335,
      );
    });
  });
}
