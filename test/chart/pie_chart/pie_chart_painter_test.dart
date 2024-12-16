import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/line.dart';
import 'package:fl_chart/src/chart/pie_chart/pie_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../helper_methods.dart';
import '../data_pool.dart';
import 'pie_chart_painter_test.mocks.dart';

@GenerateMocks([Canvas, CanvasWrapper, BuildContext, Utils])
void main() {
  const tolerance = 0.001;
  group('paint()', () {
    test('test 1', () {
      final utilsMainInstance = Utils();
      const viewSize = Size(400, 400);
      final data = PieChartData(
        sections: [
          PieChartSectionData(
            value: 10,
          ),
          PieChartSectionData(
            value: 20,
          ),
          PieChartSectionData(
            value: 30,
          ),
        ],
      );

      final pieChartPainter = PieChartPainter();
      final holder =
          PaintHolder<PieChartData>(data, data, TextScaler.noScaling);

      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getThemeAwareTextStyle(any, any))
          .thenAnswer((realInvocation) => textStyle1);
      when(mockUtils.radians(any)).thenAnswer((realInvocation) => 12);

      final mockBuildContext = MockBuildContext();
      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      pieChartPainter.paint(
        mockBuildContext,
        mockCanvasWrapper,
        holder,
      );

      verify(mockCanvasWrapper.drawPath(any, any)).called(3);
      Utils.changeInstance(utilsMainInstance);
    });
  });

  group('calculateSectionsAngle()', () {
    test('test 1', () {
      final sections = [
        PieChartSectionData(value: 10),
        PieChartSectionData(value: 20),
        PieChartSectionData(value: 30),
        PieChartSectionData(value: 40),
      ];
      expect(
        PieChartPainter().calculateSectionsAngle(sections, 100),
        [36, 72, 108, 144],
      );
    });

    test('test 2', () {
      final sections = [
        PieChartSectionData(value: 10),
        PieChartSectionData(value: 10),
        PieChartSectionData(value: 10),
        PieChartSectionData(value: 10),
      ];
      expect(
        PieChartPainter().calculateSectionsAngle(sections, 40),
        [90, 90, 90, 90],
      );
    });
  });

  group('drawCenterSpace()', () {
    test('test 1', () {
      const viewSize = Size(200, 200);

      final data = PieChartData(
        centerSpaceColor: MockData.color1,
      );

      final barChartPainter = PieChartPainter();
      final holder =
          PaintHolder<PieChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      barChartPainter.drawCenterSpace(mockCanvasWrapper, 10, holder);

      final result = verify(
        mockCanvasWrapper.drawCircle(const Offset(100, 100), 10, captureAny),
      );
      expect(result.callCount, 1);
      expect(
        (result.captured.first as Paint).color,
        isSameColorAs(MockData.color1),
      );
    });
  });

  group('drawTexts()', () {
    test('test 1', () {
      final utilsMainInstance = Utils();
      const viewSize = Size(200, 200);

      final data = PieChartData(
        sections: List.generate(2, (i) {
          return PieChartSectionData(
            value: 10,
            title: '$i%',
          );
        }),
        titleSunbeamLayout: true,
      );

      final pieChartPainter = PieChartPainter();
      final holder =
          PaintHolder<PieChartData>(data, data, TextScaler.noScaling);

      final mockBuildContext = MockBuildContext();
      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final mockUtils = MockUtils();
      Utils.changeInstance(mockUtils);
      when(mockUtils.getThemeAwareTextStyle(any, any))
          .thenAnswer((realInvocation) => textStyle1);
      when(mockUtils.radians(any)).thenAnswer((realInvocation) => 12);

      final centerRadius = pieChartPainter.calculateCenterRadius(
        viewSize,
        holder,
      );

      pieChartPainter.drawTexts(
        mockBuildContext,
        mockCanvasWrapper,
        holder,
        centerRadius,
      );

      final results = verifyInOrder([
        mockCanvasWrapper.drawText(any, any, captureAny),
        mockCanvasWrapper.drawText(any, any, captureAny),
      ]);

      expect(results[0].captured.single, -90);
      expect(results[1].captured.single, 90);

      Utils.changeInstance(utilsMainInstance);
    });
  });

  group('drawSections()', () {
    test('test 1', () {
      const viewSize = Size(200, 200);

      const radius = 30.0;
      const centerSpace = 10.0;
      final sections = [
        PieChartSectionData(
          color: MockData.color2,
          radius: radius,
          value: 10,
          borderSide: const BorderSide(
            color: MockData.color3,
            width: 3,
          ),
        ),
      ];
      final data = PieChartData(
        sections: sections,
      );

      final barChartPainter = PieChartPainter();
      final holder =
          PaintHolder<PieChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      barChartPainter.drawSections(mockCanvasWrapper, [360], 10, holder);

      final rect = Rect.fromCircle(
        center: viewSize.center(Offset.zero),
        radius: radius + centerSpace,
      );
      final results = verifyInOrder([
        mockCanvasWrapper.saveLayer(
          rect,
          any,
        ),
        mockCanvasWrapper.drawCircle(
          const Offset(100, 100),
          10 + 30,
          captureAny,
        ),
        mockCanvasWrapper.drawCircle(
          const Offset(100, 100),
          10,
          captureAny,
        ),
        mockCanvasWrapper.restore(),
      ]);
      final result = results[1];
      expect(result.callCount, 1);
      expect(
        (result.captured.single as Paint).color,
        isSameColorAs(MockData.color2),
      );
      expect((result.captured.single as Paint).style, PaintingStyle.fill);

      final result2 = verify(
        mockCanvasWrapper.drawCircle(
          const Offset(100, 100),
          10 + (3 / 2),
          captureAny,
        ),
      );
      expect(result2.callCount, 1);
      expect(
        (result2.captured.single as Paint).color,
        isSameColorAs(MockData.color3),
      );
      expect((result2.captured.single as Paint).strokeWidth, 3);
      expect((result2.captured.single as Paint).style, PaintingStyle.stroke);
    });

    test('test 2', () {
      const viewSize = Size(200, 200);

      final data = PieChartData(
        centerSpaceColor: MockData.color1,
        sectionsSpace: 10,
        sections: [
          PieChartSectionData(color: MockData.color1, value: 1),
          PieChartSectionData(color: MockData.color2, value: 2),
          PieChartSectionData(color: MockData.color3, value: 3),
          PieChartSectionData(color: MockData.color4, value: 4),
        ],
      );

      final barChartPainter = PieChartPainter();
      final holder =
          PaintHolder<PieChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      final results = <Map<String, dynamic>>[];
      when(mockCanvasWrapper.drawPath(captureAny, captureAny))
          .thenAnswer((inv) {
        final paint = inv.positionalArguments[1] as Paint;
        results.add({
          'path': inv.positionalArguments[0] as Path,
          'paint_color': paint.color,
          'paint_style': paint.style,
        });
      });

      barChartPainter.drawSections(
        mockCanvasWrapper,
        [36, 72, 108, 144],
        10,
        holder,
      );
      verifyNever(mockCanvasWrapper.drawCircle(any, any, any));

      expect(results.length, 4);

      final path0 = barChartPainter.generateSectionPath(
        data.sections[0],
        10,
        0,
        36,
        const Offset(100, 100),
        10,
      );
      expect(
        HelperMethods.equalsPaths(results[0]['path'] as Path, path0),
        true,
      );
      expect(
        results[0]['paint_color'] as Color,
        isSameColorAs(MockData.color1),
      );
      expect(results[0]['paint_style'] as PaintingStyle, PaintingStyle.fill);

      final path1 = barChartPainter.generateSectionPath(
        data.sections[1],
        10,
        36,
        72,
        const Offset(100, 100),
        10,
      );
      expect(
        HelperMethods.equalsPaths(results[1]['path'] as Path, path1),
        true,
      );
      expect(
        results[1]['paint_color'] as Color,
        isSameColorAs(MockData.color2),
      );
      expect(results[1]['paint_style'] as PaintingStyle, PaintingStyle.fill);

      final path2 = barChartPainter.generateSectionPath(
        data.sections[2],
        10,
        108,
        108,
        const Offset(100, 100),
        10,
      );
      expect(
        HelperMethods.equalsPaths(results[2]['path'] as Path, path2),
        true,
      );
      expect(
        results[2]['paint_color'] as Color,
        isSameColorAs(MockData.color3),
      );
      expect(results[2]['paint_style'] as PaintingStyle, PaintingStyle.fill);

      final path3 = barChartPainter.generateSectionPath(
        data.sections[3],
        10,
        216,
        144,
        const Offset(100, 100),
        10,
      );
      expect(
        HelperMethods.equalsPaths(results[3]['path'] as Path, path3),
        true,
      );
      expect(
        results[3]['paint_color'] as Color,
        isSameColorAs(MockData.color4),
      );
      expect(results[3]['paint_style'] as PaintingStyle, PaintingStyle.fill);
    });
  });

  group('generateSectionPath()', () {
    test('test 1', () {
      final data = PieChartData(
        centerSpaceColor: MockData.color1,
        sectionsSpace: 10,
        sections: [
          PieChartSectionData(color: MockData.color1, value: 1),
          PieChartSectionData(color: MockData.color2, value: 2),
          PieChartSectionData(color: MockData.color3, value: 3),
          PieChartSectionData(color: MockData.color4, value: 4),
        ],
      );
      final barChartPainter = PieChartPainter();

      final path0 = barChartPainter.generateSectionPath(
        data.sections[0],
        10,
        0,
        36,
        const Offset(100, 100),
        10,
      );
      final path0Length = path0
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path0Length, 90.08028411865234);

      final path1 = barChartPainter.generateSectionPath(
        data.sections[1],
        10,
        36,
        72,
        const Offset(100, 100),
        10,
      );
      final path1Length = path1
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path1Length, 136.93048095703125);

      final path2 = barChartPainter.generateSectionPath(
        data.sections[2],
        10,
        108,
        108,
        const Offset(100, 100),
        10,
      );
      final path2Length = path2
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path2Length, closeTo(174.6013, tolerance));

      final path3 = barChartPainter.generateSectionPath(
        data.sections[3],
        10,
        216,
        144,
        const Offset(100, 100),
        10,
      );
      final path3Length = path3
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path3Length, 212.1544189453125);
    });

    test('test 2', () {
      final data = PieChartData(
        centerSpaceColor: MockData.color1,
        sectionsSpace: 0,
        sections: [
          PieChartSectionData(color: MockData.color1, value: 1),
          PieChartSectionData(color: MockData.color2, value: 2),
          PieChartSectionData(color: MockData.color3, value: 3),
          PieChartSectionData(color: MockData.color4, value: 4),
        ],
      );
      final barChartPainter = PieChartPainter();

      final path0 = barChartPainter.generateSectionPath(
        data.sections[0],
        0,
        0,
        36,
        const Offset(100, 100),
        10,
      );
      final path0Length = path0
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path0Length, 117.56398010253906);

      final path1 = barChartPainter.generateSectionPath(
        data.sections[1],
        0,
        36,
        72,
        const Offset(100, 100),
        10,
      );
      final path1Length = path1
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path1Length, 155.1278076171875);

      final path2 = barChartPainter.generateSectionPath(
        data.sections[2],
        0,
        108,
        108,
        const Offset(100, 100),
        10,
      );
      final path2Length = path2
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path2Length, closeTo(192.8401, tolerance));

      final path3 = barChartPainter.generateSectionPath(
        data.sections[3],
        0,
        216,
        144,
        const Offset(100, 100),
        10,
      );
      final path3Length = path3
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(nearEqual(path3Length, 230.37237548828125, 0.0001), true);
    });

    test('test 3', () {
      final data = PieChartData(
        centerSpaceColor: MockData.color1,
        sectionsSpace: 0,
        sections: [
          PieChartSectionData(color: MockData.color1, value: 1),
          PieChartSectionData(color: MockData.color2, value: 2),
          PieChartSectionData(color: MockData.color3, value: 3),
          PieChartSectionData(color: MockData.color4, value: 4),
        ],
      );
      final barChartPainter = PieChartPainter();

      final path0 = barChartPainter.generateSectionPath(
        data.sections[0],
        0,
        0,
        36,
        const Offset(100, 100),
        3,
      );
      final path0Length = path0
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path0Length, 108.80243682861328);

      final path1 = barChartPainter.generateSectionPath(
        data.sections[1],
        0,
        36,
        72,
        const Offset(100, 100),
        4,
      );
      final path1Length = path1
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path1Length, 140.05465698242188);

      final path2 = barChartPainter.generateSectionPath(
        data.sections[2],
        0,
        108,
        108,
        const Offset(100, 100),
        5,
      );
      final path2Length = path2
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path2Length, 173.86875915527344);

      final path3 = barChartPainter.generateSectionPath(
        data.sections[3],
        0,
        216,
        144,
        const Offset(100, 100),
        6,
      );
      final path3Length = path3
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path3Length, 210.1807098388672);
    });
  });

  group('createRectPathAroundLine()', () {
    test('test 1', () {
      final barChartPainter = PieChartPainter();
      final path0 = barChartPainter.createRectPathAroundLine(
        const Line(Offset.zero, Offset(10, 0)),
        4,
      );
      final path0Length = path0
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path0Length, 32.0);

      final path1 = barChartPainter.createRectPathAroundLine(
        const Line(Offset(32, 11), Offset(12, 5)),
        66,
      );
      final path1Length = path1
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path1Length, 239.76123046875);
    });
  });

  group('drawSection()', () {
    test('test 1', () {
      const viewSize = Size(200, 200);
      final data = PieChartData(
        centerSpaceColor: MockData.color1,
        sectionsSpace: 10,
        sections: [
          PieChartSectionData(color: MockData.color1, value: 1),
          PieChartSectionData(color: MockData.color2, value: 2),
          PieChartSectionData(color: MockData.color3, value: 3),
          PieChartSectionData(color: MockData.color4, value: 4),
        ],
      );
      final barChartPainter = PieChartPainter();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final results = <Map<String, dynamic>>[];
      when(mockCanvasWrapper.drawPath(captureAny, captureAny))
          .thenAnswer((inv) {
        final paint = inv.positionalArguments[1] as Paint;
        results.add({
          'path': inv.positionalArguments[0] as Path,
          'paint_color': paint.color,
          'paint_style': paint.style,
        });
      });

      barChartPainter
        ..drawSection(
          data.sections[0],
          MockData.path1,
          mockCanvasWrapper,
        )
        ..drawSection(
          data.sections[1],
          MockData.path2,
          mockCanvasWrapper,
        )
        ..drawSection(
          data.sections[2],
          MockData.path3,
          mockCanvasWrapper,
        )
        ..drawSection(
          data.sections[3],
          MockData.path4,
          mockCanvasWrapper,
        );

      expect(results.length, 4);

      expect(results[0]['path'] as Path, MockData.path1);
      expect(
        results[0]['paint_color'] as Color,
        isSameColorAs(MockData.color1),
      );
      expect(results[0]['paint_style'] as PaintingStyle, PaintingStyle.fill);

      expect(results[1]['path'] as Path, MockData.path2);
      expect(
        results[1]['paint_color'] as Color,
        isSameColorAs(MockData.color2),
      );
      expect(results[1]['paint_style'] as PaintingStyle, PaintingStyle.fill);

      expect(results[2]['path'] as Path, MockData.path3);
      expect(
        results[2]['paint_color'] as Color,
        isSameColorAs(MockData.color3),
      );
      expect(results[2]['paint_style'] as PaintingStyle, PaintingStyle.fill);

      expect(results[3]['path'] as Path, MockData.path4);
      expect(
        results[3]['paint_color'] as Color,
        isSameColorAs(MockData.color4),
      );
      expect(results[3]['paint_style'] as PaintingStyle, PaintingStyle.fill);
    });
  });

  group('drawSectionStroke()', () {
    test('test 1', () {
      const viewSize = Size(200, 200);
      final data = PieChartData(
        centerSpaceColor: MockData.color1,
        sectionsSpace: 10,
        sections: [
          PieChartSectionData(color: MockData.color1, value: 1),
          PieChartSectionData(color: MockData.color2, value: 2),
          PieChartSectionData(color: MockData.color3, value: 3),
          PieChartSectionData(color: MockData.color4, value: 4),
        ],
      );
      final barChartPainter = PieChartPainter();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final results = <Map<String, dynamic>>[];
      when(mockCanvasWrapper.drawPath(captureAny, captureAny))
          .thenAnswer((inv) {
        final paint = inv.positionalArguments[1] as Paint;
        results.add({
          'path': inv.positionalArguments[0] as Path,
          'paint_color': paint.color,
          'paint_style': paint.style,
        });
      });

      barChartPainter
        ..drawSectionStroke(
          data.sections[0],
          MockData.path1,
          mockCanvasWrapper,
          viewSize,
        )
        ..drawSectionStroke(
          data.sections[1],
          MockData.path2,
          mockCanvasWrapper,
          viewSize,
        )
        ..drawSectionStroke(
          data.sections[2],
          MockData.path3,
          mockCanvasWrapper,
          viewSize,
        )
        ..drawSectionStroke(
          data.sections[3],
          MockData.path4,
          mockCanvasWrapper,
          viewSize,
        );

      verifyNever(mockCanvasWrapper.saveLayer(any, any));
      verifyNever(mockCanvasWrapper.clipPath(any));
      verifyNever(mockCanvasWrapper.drawPath(any, any));
      verifyNever(mockCanvasWrapper.restore());
    });

    test('test 2', () {
      const viewSize = Size(200, 200);
      final data = PieChartData(
        centerSpaceColor: MockData.color1,
        sectionsSpace: 10,
        sections: [
          PieChartSectionData(
            color: MockData.color1,
            value: 1,
            borderSide: MockData.borderSide1,
          ),
          PieChartSectionData(
            color: MockData.color2,
            value: 2,
            borderSide: MockData.borderSide2,
          ),
          PieChartSectionData(
            color: MockData.color3,
            value: 3,
            borderSide: MockData.borderSide3,
          ),
          PieChartSectionData(
            color: MockData.color4,
            value: 4,
            borderSide: MockData.borderSide4,
          ),
        ],
      );
      final barChartPainter = PieChartPainter();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final clipPathResults = <Map<String, dynamic>>[];
      when(mockCanvasWrapper.clipPath(captureAny)).thenAnswer((inv) {
        clipPathResults.add({
          'path': inv.positionalArguments[0] as Path,
        });
      });

      final drawPathResults = <Map<String, dynamic>>[];
      when(mockCanvasWrapper.drawPath(captureAny, captureAny))
          .thenAnswer((inv) {
        final paint = inv.positionalArguments[1] as Paint;
        drawPathResults.add({
          'path': inv.positionalArguments[0] as Path,
          'paint_color': paint.color,
          'paint_style': paint.style,
          'paint_stroke_width': paint.strokeWidth,
        });
      });

      barChartPainter
        ..drawSectionStroke(
          data.sections[0],
          MockData.path1,
          mockCanvasWrapper,
          viewSize,
        )
        ..drawSectionStroke(
          data.sections[1],
          MockData.path2,
          mockCanvasWrapper,
          viewSize,
        )
        ..drawSectionStroke(
          data.sections[2],
          MockData.path3,
          mockCanvasWrapper,
          viewSize,
        )
        ..drawSectionStroke(
          data.sections[3],
          MockData.path4,
          mockCanvasWrapper,
          viewSize,
        );

      verify(
        mockCanvasWrapper.saveLayer(
          Rect.fromLTWH(0, 0, viewSize.width, viewSize.height),
          any,
        ),
      ).called(4);
      expect(clipPathResults.length, 4);
      expect(clipPathResults[0]['path'], MockData.path1);
      expect(clipPathResults[1]['path'], MockData.path2);
      expect(clipPathResults[2]['path'], MockData.path3);
      expect(clipPathResults[3]['path'], MockData.path4);

      expect(drawPathResults.length, 4);

      expect(drawPathResults[0]['path'], MockData.path1);
      expect(
        drawPathResults[0]['paint_color'],
        isSameColorAs(MockData.color1),
      );
      expect(drawPathResults[0]['paint_style'], PaintingStyle.stroke);
      expect(
        drawPathResults[0]['paint_stroke_width'],
        MockData.borderSide1.width * 2,
      );

      expect(drawPathResults[1]['path'], MockData.path2);
      expect(
        drawPathResults[1]['paint_color'],
        isSameColorAs(MockData.color2),
      );
      expect(drawPathResults[1]['paint_style'], PaintingStyle.stroke);
      expect(
        drawPathResults[1]['paint_stroke_width'],
        MockData.borderSide2.width * 2,
      );

      expect(drawPathResults[2]['path'], MockData.path3);
      expect(
        drawPathResults[2]['paint_color'],
        isSameColorAs(MockData.color3),
      );
      expect(drawPathResults[2]['paint_style'], PaintingStyle.stroke);
      expect(
        drawPathResults[2]['paint_stroke_width'],
        MockData.borderSide3.width * 2,
      );

      expect(drawPathResults[3]['path'], MockData.path4);
      expect(
        drawPathResults[3]['paint_color'],
        isSameColorAs(MockData.color4),
      );
      expect(drawPathResults[3]['paint_style'], PaintingStyle.stroke);
      expect(
        drawPathResults[3]['paint_stroke_width'],
        MockData.borderSide4.width * 2,
      );

      verify(mockCanvasWrapper.restore()).called(4);
    });
  });

  group('calculateCenterRadius()', () {
    test('test 1', () {
      const viewSize = Size(400, 200);
      final sections = [
        PieChartSectionData(
          color: MockData.color1,
          value: 1,
          borderSide: MockData.borderSide1,
          showTitle: true,
          titleStyle: MockData.textStyle1,
          radius: 11,
        ),
        PieChartSectionData(
          color: MockData.color2,
          value: 2,
          borderSide: MockData.borderSide2,
          showTitle: true,
          titleStyle: MockData.textStyle2,
          radius: 22,
          title: '22-22',
        ),
        PieChartSectionData(
          color: MockData.color3,
          value: 3,
          borderSide: MockData.borderSide3,
          showTitle: false,
          titleStyle: MockData.textStyle3,
          radius: 33,
        ),
        PieChartSectionData(
          color: MockData.color4,
          value: 4,
          borderSide: MockData.borderSide4,
          showTitle: true,
          titleStyle: MockData.textStyle4,
          radius: 44,
        ),
      ];
      final barChartPainter = PieChartPainter();

      final data1 = PieChartData(sections: sections, centerSpaceRadius: 15);
      final result1 = barChartPainter.calculateCenterRadius(
        viewSize,
        PaintHolder<PieChartData>(data1, data1, TextScaler.noScaling),
      );
      expect(result1, 15);

      final data2 = PieChartData(sections: sections);
      final result2 = barChartPainter.calculateCenterRadius(
        viewSize,
        PaintHolder<PieChartData>(data2, data2, TextScaler.noScaling),
      );
      expect(result2, 56);
    });
  });

  group('handleTouch()', () {
    test('test 2', () {
      const viewSize = Size(200, 200);
      final data = PieChartData(
        centerSpaceColor: MockData.color1,
        sectionsSpace: 10,
        sections: [
          PieChartSectionData(
            color: MockData.color1,
            value: 1,
            borderSide: MockData.borderSide1,
            radius: 10,
          ),
          PieChartSectionData(
            color: MockData.color2,
            value: 2,
            borderSide: MockData.borderSide2,
            radius: 20,
          ),
          PieChartSectionData(
            color: MockData.color3,
            value: 3,
            borderSide: MockData.borderSide3,
            radius: 30,
          ),
          PieChartSectionData(
            color: MockData.color4,
            value: 4,
            borderSide: MockData.borderSide4,
            radius: 40,
          ),
        ],
      );
      final barChartPainter = PieChartPainter();
      final holder =
          PaintHolder<PieChartData>(data, data, TextScaler.noScaling);

      expect(
        barChartPainter
            .handleTouch(const Offset(191, 110), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(156, 110), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(107, 190), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(90, 156), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(53, 131), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(53, 131), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(43, 94), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(36, 57), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(36, 57), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(65, 4.3), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(7, 108), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );

      expect(
        barChartPainter
            .handleTouch(const Offset(159.76, 135.56), viewSize, holder)
            .touchedSectionIndex,
        0,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(169.35, 108.4), viewSize, holder)
            .touchedSectionIndex,
        0,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(162.32, 109.37), viewSize, holder)
            .touchedSectionIndex,
        0,
      );

      expect(
        barChartPainter
            .handleTouch(const Offset(146.67, 144.94), viewSize, holder)
            .touchedSectionIndex,
        1,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(121.06, 160.38), viewSize, holder)
            .touchedSectionIndex,
        1,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(89.66, 163.60), viewSize, holder)
            .touchedSectionIndex,
        1,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(85.04, 177.85), viewSize, holder)
            .touchedSectionIndex,
        1,
      );

      expect(
        barChartPainter
            .handleTouch(const Offset(75.2, 158.4), viewSize, holder)
            .touchedSectionIndex,
        2,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(66.2, 177), viewSize, holder)
            .touchedSectionIndex,
        2,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(40.3, 124.8), viewSize, holder)
            .touchedSectionIndex,
        2,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(19.1, 131), viewSize, holder)
            .touchedSectionIndex,
        2,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(19.1, 131), viewSize, holder)
            .touchedSectionIndex,
        2,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(17.7, 83.7), viewSize, holder)
            .touchedSectionIndex,
        2,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(27.8, 59.4), viewSize, holder)
            .touchedSectionIndex,
        2,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(44.1, 75.2), viewSize, holder)
            .touchedSectionIndex,
        2,
      );

      expect(
        barChartPainter
            .handleTouch(const Offset(56.1, 55.6), viewSize, holder)
            .touchedSectionIndex,
        3,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(42.1, 46.3), viewSize, holder)
            .touchedSectionIndex,
        3,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(30.9, 38.4), viewSize, holder)
            .touchedSectionIndex,
        3,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(55.3, 17.8), viewSize, holder)
            .touchedSectionIndex,
        3,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(81.2, 39.8), viewSize, holder)
            .touchedSectionIndex,
        3,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(100.5, 4.1), viewSize, holder)
            .touchedSectionIndex,
        3,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(126.7, 40.6), viewSize, holder)
            .touchedSectionIndex,
        3,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(181.8, 51.3), viewSize, holder)
            .touchedSectionIndex,
        3,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(174.5, 40.2), viewSize, holder)
            .touchedSectionIndex,
        3,
      );
      expect(
        barChartPainter
            .handleTouch(const Offset(164.5, 91.4), viewSize, holder)
            .touchedSectionIndex,
        3,
      );
    });
  });

  group('getBadgeOffsets()', () {
    test('test 1', () {
      const viewSize = Size(200, 200);
      final data = PieChartData(
        centerSpaceColor: MockData.color1,
        sectionsSpace: 10,
        sections: [
          PieChartSectionData(
            color: MockData.color1,
            value: 1,
            borderSide: MockData.borderSide1,
          ),
          PieChartSectionData(
            color: MockData.color2,
            value: 2,
            borderSide: MockData.borderSide2,
          ),
          PieChartSectionData(
            color: MockData.color3,
            value: 3,
            borderSide: MockData.borderSide3,
          ),
          PieChartSectionData(
            color: MockData.color4,
            value: 4,
            borderSide: MockData.borderSide4,
          ),
        ],
      );
      final barChartPainter = PieChartPainter();
      final holder = PaintHolder<PieChartData>(
        data,
        data,
        TextScaler.noScaling,
      );

      final result = barChartPainter.getBadgeOffsets(viewSize, holder);
      expect(
        result,
        {
          0: const Offset(176.0845213036123, 124.7213595499958),
          1: const Offset(124.7213595499958, 176.0845213036123),
          2: const Offset(23.915478696387723, 124.7213595499958),
          3: const Offset(124.72135954999578, 23.91547869638771),
        },
      );
    });
  });
}
