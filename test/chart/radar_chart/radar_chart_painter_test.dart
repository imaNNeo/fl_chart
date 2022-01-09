import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../data_pool.dart';
import 'radar_chart_painter_test.mocks.dart';

@GenerateMocks([Canvas, CanvasWrapper, BuildContext, Utils])
void main() {
  group('RadarChart usable size', () {
    test('test 1', () {
      const viewSize = Size(728, 728);

      final RadarChartData data = RadarChartData(dataSets: [
        RadarDataSet(),
      ]);

      final RadarChartPainter radarChartPainter = RadarChartPainter();
      final holder = PaintHolder<RadarChartData>(data, data, 1.0);
      expect(radarChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(728, 728));
    });
  });

  group('drawTicks()', () {
    test('test 1', () {
      const viewSize = Size(400, 300);

      final RadarChartData data = RadarChartData(
        dataSets: [
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
          ]),
        ],
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        radarBackgroundColor: MockData.color2,
      );

      final RadarChartPainter radarChartPainter = RadarChartPainter();
      final holder = PaintHolder<RadarChartData>(data, data, 1.0);

      final _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final _mockUtils = MockUtils();
      when(_mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(MockData.textStyle1);
      Utils.changeInstance(_mockUtils);

      MockBuildContext _mockContext = MockBuildContext();

      List<Map<String, dynamic>> drawCircleResults = [];
      when(_mockCanvasWrapper.drawCircle(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        drawCircleResults.add({
          'offset': inv.positionalArguments[0] as Offset,
          'radius': inv.positionalArguments[1] as double,
          'paint_color': (inv.positionalArguments[2] as Paint).color,
          'paint_style': (inv.positionalArguments[2] as Paint).style,
          'paint_stroke': (inv.positionalArguments[2] as Paint).strokeWidth,
        });
      });

      radarChartPainter.drawTicks(_mockContext, _mockCanvasWrapper, holder);

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

      final result =
          verify(_mockCanvasWrapper.drawText(captureAny, captureAny));
      expect(result.callCount, 1);
      final tp = result.captured[0] as TextPainter;
      expect((tp.text as TextSpan).text, '1.0');
      expect((tp.text as TextSpan).style, MockData.textStyle1);
      expect(result.captured[1] as Offset, const Offset(205, 76));
    });
  });

  group('drawGrids()', () {
    test('test 1', () {
      const viewSize = Size(400, 300);

      final RadarChartData data = RadarChartData(
        dataSets: [
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
          ]),
        ],
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        gridBorderData: const BorderSide(color: MockData.color3, width: 3),
        radarBackgroundColor: MockData.color2,
      );

      final RadarChartPainter radarChartPainter = RadarChartPainter();
      final holder = PaintHolder<RadarChartData>(data, data, 1.0);

      final _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final _mockUtils = MockUtils();
      when(_mockUtils.getThemeAwareTextStyle(any, any))
          .thenReturn(MockData.textStyle1);
      Utils.changeInstance(_mockUtils);

      List<Map<String, dynamic>> drawLineResults = [];
      when(_mockCanvasWrapper.drawLine(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        drawLineResults.add({
          'offset_from': inv.positionalArguments[0] as Offset,
          'offset_to': inv.positionalArguments[1] as Offset,
          'paint_color': (inv.positionalArguments[2] as Paint).color,
          'paint_style': (inv.positionalArguments[2] as Paint).style,
          'paint_stroke': (inv.positionalArguments[2] as Paint).strokeWidth,
        });
      });

      radarChartPainter.drawGrids(_mockCanvasWrapper, holder);
      expect(drawLineResults.length, 3);

      expect(drawLineResults[0]['offset_from'], const Offset(200, 150));
      expect(drawLineResults[0]['offset_to'], const Offset(200, 30));
      expect(drawLineResults[0]['paint_color'], MockData.color3);
      expect(drawLineResults[0]['paint_style'], PaintingStyle.stroke);
      expect(drawLineResults[0]['paint_stroke'], 3);

      expect(drawLineResults[1]['offset_from'], const Offset(200, 150));
      expect(drawLineResults[1]['offset_to'],
          const Offset(303.92304845413264, 209.99999999999997));
      expect(drawLineResults[1]['paint_color'], MockData.color3);
      expect(drawLineResults[1]['paint_style'], PaintingStyle.stroke);
      expect(drawLineResults[1]['paint_stroke'], 3);

      expect(drawLineResults[2]['offset_from'], const Offset(200, 150));
      expect(drawLineResults[2]['offset_to'],
          const Offset(96.07695154586739, 210.00000000000006));
      expect(drawLineResults[2]['paint_color'], MockData.color3);
      expect(drawLineResults[2]['paint_style'], PaintingStyle.stroke);
      expect(drawLineResults[2]['paint_stroke'], 3);
    });
  });

  group('drawGrids()', () {
    test('test 1', () {
      const viewSize = Size(400, 300);

      final RadarChartData data = RadarChartData(
        dataSets: [
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
          ]),
        ],
        getTitle: null,
        titleTextStyle: MockData.textStyle4,
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        gridBorderData: const BorderSide(color: MockData.color3, width: 3),
        radarBackgroundColor: MockData.color2,
      );

      final RadarChartPainter radarChartPainter = RadarChartPainter();
      final holder = PaintHolder<RadarChartData>(data, data, 1.0);

      final _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final _mockUtils = MockUtils();
      when(_mockUtils.getThemeAwareTextStyle(any, any)).thenAnswer(
          (realInvocation) =>
              realInvocation.positionalArguments[1] as TextStyle);
      Utils.changeInstance(_mockUtils);

      final _mockContext = MockBuildContext();

      radarChartPainter.drawTitles(_mockContext, _mockCanvasWrapper, holder);

      verifyNever(_mockCanvasWrapper.drawText(any, any));
    });

    test('test 2', () {
      const viewSize = Size(400, 300);

      final RadarChartData data = RadarChartData(
        dataSets: [
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
            const RadarEntry(value: 2),
          ]),
          RadarDataSet(dataEntries: [
            const RadarEntry(value: 2),
            const RadarEntry(value: 3),
            const RadarEntry(value: 1),
          ]),
        ],
        getTitle: (index) {
          return '$index$index';
        },
        titleTextStyle: MockData.textStyle4,
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        gridBorderData: const BorderSide(color: MockData.color3, width: 3),
        radarBackgroundColor: MockData.color2,
      );

      final RadarChartPainter radarChartPainter = RadarChartPainter();
      final holder = PaintHolder<RadarChartData>(data, data, 1.0);

      final _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final _mockUtils = MockUtils();
      when(_mockUtils.getThemeAwareTextStyle(any, any)).thenAnswer(
          (realInvocation) =>
              realInvocation.positionalArguments[1] as TextStyle);
      Utils.changeInstance(_mockUtils);

      final _mockContext = MockBuildContext();

      List<Map<String, dynamic>> results = [];
      when(_mockCanvasWrapper.drawText(captureAny, captureAny))
          .thenAnswer((inv) {
        results.add({
          'tp_text':
              ((inv.positionalArguments[0] as TextPainter).text as TextSpan)
                  .text,
          'tp_style':
              ((inv.positionalArguments[0] as TextPainter).text as TextSpan)
                  .style,
        });
      });

      radarChartPainter.drawTitles(_mockContext, _mockCanvasWrapper, holder);
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

      final RadarChartData data = RadarChartData(
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
        getTitle: (index) {
          return '$index$index';
        },
        titleTextStyle: MockData.textStyle4,
        radarBorderData: const BorderSide(color: MockData.color6, width: 33),
        tickBorderData: const BorderSide(color: MockData.color5, width: 55),
        gridBorderData: const BorderSide(color: MockData.color3, width: 3),
        radarBackgroundColor: MockData.color2,
      );

      final RadarChartPainter radarChartPainter = RadarChartPainter();
      final holder = PaintHolder<RadarChartData>(data, data, 1.0);

      final _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final _mockUtils = MockUtils();
      when(_mockUtils.getThemeAwareTextStyle(any, any)).thenAnswer(
          (realInvocation) =>
              realInvocation.positionalArguments[1] as TextStyle);
      Utils.changeInstance(_mockUtils);

      List<Map<String, dynamic>> drawCircleResults = [];
      when(_mockCanvasWrapper.drawCircle(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        drawCircleResults.add({
          'offset': inv.positionalArguments[0] as Offset,
          'radius': inv.positionalArguments[1] as double,
          'paint': inv.positionalArguments[2] as Paint,
        });
      });

      List<Map<String, dynamic>> drawPathResults = [];
      when(_mockCanvasWrapper.drawPath(captureAny, captureAny))
          .thenAnswer((inv) {
        drawPathResults.add({
          'path': inv.positionalArguments[0] as Path,
          'paint_color': (inv.positionalArguments[1] as Paint).color,
          'paint_stroke': (inv.positionalArguments[1] as Paint).strokeWidth,
          'paint_style': (inv.positionalArguments[1] as Paint).style,
        });
      });

      radarChartPainter.drawDataSets(_mockCanvasWrapper, holder);
      expect(drawCircleResults.length, 9);

      expect(
          drawCircleResults[0]['offset'] as Offset, const Offset(200.0, 110.0));
      expect(drawCircleResults[0]['radius'] as double, 5);

      expect(drawCircleResults[1]['offset'] as Offset,
          const Offset(269.2820323027551, 190.0));
      expect(drawCircleResults[1]['radius'] as double, 5);

      expect(drawCircleResults[2]['offset'] as Offset,
          const Offset(96.07695154586739, 210.00000000000006));
      expect(drawCircleResults[2]['radius'] as double, 5);

      expect(
          drawCircleResults[3]['offset'] as Offset, const Offset(200.0, 30.0));
      expect(drawCircleResults[3]['radius'] as double, 5);

      expect(drawCircleResults[4]['offset'] as Offset,
          const Offset(234.64101615137756, 170.0));
      expect(drawCircleResults[4]['radius'] as double, 5);

      expect(drawCircleResults[5]['offset'] as Offset,
          const Offset(130.71796769724492, 190.00000000000003));
      expect(drawCircleResults[5]['radius'] as double, 5);

      expect(
          drawCircleResults[6]['offset'] as Offset, const Offset(200.0, 70.0));
      expect(drawCircleResults[6]['radius'] as double, 5);

      expect(drawCircleResults[7]['offset'] as Offset,
          const Offset(303.92304845413264, 209.99999999999997));
      expect(drawCircleResults[7]['radius'] as double, 5);

      expect(drawCircleResults[8]['offset'] as Offset,
          const Offset(165.35898384862247, 170.0));
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
}
