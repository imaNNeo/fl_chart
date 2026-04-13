import 'dart:math' as math;

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

      final pieChartPainter = PieChartPainter();
      final holder =
          PaintHolder<PieChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      pieChartPainter.drawCenterSpace(mockCanvasWrapper, 10, holder);

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

      final pieChartPainter = PieChartPainter();
      final holder =
          PaintHolder<PieChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      pieChartPainter.drawSections(mockCanvasWrapper, [360], 10, holder);

      final result = verify(mockCanvasWrapper.drawPath(captureAny, captureAny));
      expect(result.callCount, 1);
      final path = result.captured[0] as Path;
      final paint = result.captured[1] as Paint;

      final expectedPath = pieChartPainter.generateSegmentPath(
        viewSize.center(Offset.zero),
        centerSpace,
        radius,
        0,
        360,
      );
      expect(HelperMethods.equalsPaths(path, expectedPath), true);
      expect(
        paint.color,
        isSameColorAs(MockData.color2),
      );

      expect(paint.style, PaintingStyle.fill);

      // Outer border
      final result2 = verify(
        mockCanvasWrapper.drawCircle(
          const Offset(100, 100),
          centerSpace + radius - (3 / 2),
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

      // Inner border
      final result3 = verify(
        mockCanvasWrapper.drawCircle(
          const Offset(100, 100),
          centerSpace + (3 / 2),
          captureAny,
        ),
      );
      expect(result3.callCount, 1);
      expect(
        (result3.captured.single as Paint).color,
        isSameColorAs(MockData.color3),
      );
      expect((result3.captured.single as Paint).strokeWidth, 3);
      expect((result3.captured.single as Paint).style, PaintingStyle.stroke);
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

      final pieChartPainter = PieChartPainter();
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

      pieChartPainter.drawSections(
        mockCanvasWrapper,
        [36, 72, 108, 144],
        10,
        holder,
      );
      verifyNever(mockCanvasWrapper.drawCircle(any, any, any));

      expect(results.length, 4);

      final path0 = pieChartPainter.generateSectionPath(
        data.sections[0],
        data.sectionsSpace,
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

      final path1 = pieChartPainter.generateSectionPath(
        data.sections[1],
        data.sectionsSpace,
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

      final path2 = pieChartPainter.generateSectionPath(
        data.sections[2],
        data.sectionsSpace,
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

      final path3 = pieChartPainter.generateSectionPath(
        data.sections[3],
        data.sectionsSpace,
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
      final pieChartPainter = PieChartPainter();

      final path0 = pieChartPainter.generateSectionPath(
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

      final path1 = pieChartPainter.generateSectionPath(
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

      final path2 = pieChartPainter.generateSectionPath(
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

      final path3 = pieChartPainter.generateSectionPath(
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
      final pieChartPainter = PieChartPainter();

      final path0 = pieChartPainter.generateSectionPath(
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

      final path1 = pieChartPainter.generateSectionPath(
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

      final path2 = pieChartPainter.generateSectionPath(
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

      final path3 = pieChartPainter.generateSectionPath(
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
      final pieChartPainter = PieChartPainter();

      final path0 = pieChartPainter.generateSectionPath(
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

      final path1 = pieChartPainter.generateSectionPath(
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

      final path2 = pieChartPainter.generateSectionPath(
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

      final path3 = pieChartPainter.generateSectionPath(
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

    test('test 4 with cornerRadius matches rounded path when no space', () {
      const center = Offset(100, 100);
      const centerRadius = 10.0;
      const tempAngle = 36.0;
      const sectionDegree = 144.0;

      final section = PieChartSectionData(
        color: MockData.color1,
        value: 1,
        radius: 40,
        cornerRadius: 10,
      );

      final pieChartPainter = PieChartPainter();

      final generatedPath = pieChartPainter.generateSectionPath(
        section,
        0,
        tempAngle,
        sectionDegree,
        center,
        centerRadius,
      );

      final startRadians = Utils().radians(tempAngle);
      final sweepRadians = Utils().radians(sectionDegree);
      final expectedRoundedPath = pieChartPainter.generateRoundedSectionPath(
        section,
        startRadians,
        sweepRadians,
        center,
        centerRadius,
        Rect.fromCircle(center: center, radius: centerRadius + section.radius),
        Rect.fromCircle(center: center, radius: centerRadius),
      );

      expect(
        HelperMethods.equalsPaths(generatedPath, expectedRoundedPath),
        true,
      );
    });

    test('test 5 with cornerRadius and sectionSpace trims rounded path', () {
      const center = Offset(100, 100);
      const centerRadius = 10.0;
      const tempAngle = 36.0;
      const sectionDegree = 144.0;

      final section = PieChartSectionData(
        color: MockData.color1,
        value: 1,
        radius: 40,
        cornerRadius: 10,
      );

      final pieChartPainter = PieChartPainter();

      final pathWithoutSpace = pieChartPainter.generateSectionPath(
        section,
        0,
        tempAngle,
        sectionDegree,
        center,
        centerRadius,
      );

      final pathWithSpace = pieChartPainter.generateSectionPath(
        section,
        10,
        tempAngle,
        sectionDegree,
        center,
        centerRadius,
      );

      expect(HelperMethods.equalsPaths(pathWithSpace, pathWithoutSpace), false);

      final withSpaceMetrics = pathWithSpace.computeMetrics().toList();
      expect(withSpaceMetrics.isNotEmpty, true);
    });
  });

  group('generateRoundedSectionPath()', () {
    test('test 1 uses standard path when cornerRadius <= 1', () {
      const center = Offset(100, 100);
      const centerRadius = 10.0;
      const startRadians = 0.4;
      const sweepRadians = 1.3;

      final section = PieChartSectionData(
        value: 10,
        radius: 40,
        cornerRadius: 1,
      );

      final pieChartPainter = PieChartPainter();

      final sectionRadiusRect = Rect.fromCircle(
        center: center,
        radius: centerRadius + section.radius,
      );
      final centerRadiusRect = Rect.fromCircle(
        center: center,
        radius: centerRadius,
      );

      final result = pieChartPainter.generateRoundedSectionPath(
        section,
        startRadians,
        sweepRadians,
        center,
        centerRadius,
        sectionRadiusRect,
        centerRadiusRect,
      );

      const endRadians = startRadians + sweepRadians;
      final innerStart = center +
          Offset(math.cos(startRadians), math.sin(startRadians)) * centerRadius;
      final outerStart = center +
          Offset(math.cos(startRadians), math.sin(startRadians)) *
              (centerRadius + section.radius);
      final innerEnd = center +
          Offset(math.cos(endRadians), math.sin(endRadians)) * centerRadius;

      final expected = Path()
        ..moveTo(innerStart.dx, innerStart.dy)
        ..lineTo(outerStart.dx, outerStart.dy)
        ..arcTo(sectionRadiusRect, startRadians, sweepRadians, false)
        ..lineTo(innerEnd.dx, innerEnd.dy)
        ..arcTo(centerRadiusRect, endRadians, -sweepRadians, false)
        ..close();

      expect(HelperMethods.equalsPaths(result, expected), true);
    });

    test('test 2 uses inner fallback lines when clampedInnerRadius <= 1', () {
      const center = Offset(100, 100);
      const centerRadius = 0.2;
      const startRadians = 0.0;
      const sweepRadians = 1.0;

      final section = PieChartSectionData(
        value: 10,
        radius: 40,
        cornerRadius: 10,
      );

      final pieChartPainter = PieChartPainter();

      final result = pieChartPainter.generateRoundedSectionPath(
        section,
        startRadians,
        sweepRadians,
        center,
        centerRadius,
        Rect.fromCircle(center: center, radius: centerRadius + section.radius),
        Rect.fromCircle(center: center, radius: centerRadius),
      );

      final metrics = result.computeMetrics().toList();
      expect(metrics.isNotEmpty, true);
      expect(metrics.map((e) => e.length).reduce((a, b) => a + b) > 0, true);
    });

    test('test 3 supports centerRadius == 0 with fallback line branches', () {
      const center = Offset(100, 100);
      const centerRadius = 0.0;
      const startRadians = 0.3;
      const sweepRadians = 1.2;

      final section = PieChartSectionData(
        value: 10,
        radius: 1,
        cornerRadius: 10,
      );

      final pieChartPainter = PieChartPainter();

      final result = pieChartPainter.generateRoundedSectionPath(
        section,
        startRadians,
        sweepRadians,
        center,
        centerRadius,
        Rect.fromCircle(center: center, radius: centerRadius + section.radius),
        Rect.fromCircle(center: center, radius: centerRadius),
      );

      final metrics = result.computeMetrics().toList();
      expect(metrics.isNotEmpty, true);
      expect(result.getBounds().contains(center), true);
    });
  });

  group('createRectPathAroundLine()', () {
    test('test 1', () {
      final pieChartPainter = PieChartPainter();
      final path0 = pieChartPainter.createRectPathAroundLine(
        const Line(Offset.zero, Offset(10, 0)),
        4,
      );
      final path0Length = path0
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path0Length, 32.0);

      final path1 = pieChartPainter.createRectPathAroundLine(
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
      final pieChartPainter = PieChartPainter();

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

      pieChartPainter
        ..drawSegment(
          PieChartStackSegmentData(
            toRadius: data.sections[0].radius,
            color: data.sections[0].color,
          ),
          MockData.path1,
          mockCanvasWrapper,
        )
        ..drawSegment(
          PieChartStackSegmentData(
            toRadius: data.sections[1].radius,
            color: data.sections[1].color,
          ),
          MockData.path2,
          mockCanvasWrapper,
        )
        ..drawSegment(
          PieChartStackSegmentData(
            toRadius: data.sections[2].radius,
            color: data.sections[2].color,
          ),
          MockData.path3,
          mockCanvasWrapper,
        )
        ..drawSegment(
          PieChartStackSegmentData(
            toRadius: data.sections[3].radius,
            color: data.sections[3].color,
          ),
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
      final pieChartPainter = PieChartPainter();

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

      pieChartPainter
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
      final pieChartPainter = PieChartPainter();

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

      pieChartPainter
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
      final pieChartPainter = PieChartPainter();

      final data1 = PieChartData(sections: sections, centerSpaceRadius: 15);
      final result1 = pieChartPainter.calculateCenterRadius(
        viewSize,
        PaintHolder<PieChartData>(data1, data1, TextScaler.noScaling),
      );
      expect(result1, 15);

      final data2 = PieChartData(sections: sections);
      final result2 = pieChartPainter.calculateCenterRadius(
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
      final pieChartPainter = PieChartPainter();
      final holder =
          PaintHolder<PieChartData>(data, data, TextScaler.noScaling);

      expect(
        pieChartPainter
            .handleTouch(const Offset(191, 110), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(156, 110), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(107, 190), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(90, 156), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(53, 131), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(53, 131), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(43, 94), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(36, 57), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(36, 57), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(65, 4.3), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(7, 108), viewSize, holder)
            .touchedSectionIndex,
        -1,
      );

      expect(
        pieChartPainter
            .handleTouch(const Offset(159.76, 135.56), viewSize, holder)
            .touchedSectionIndex,
        0,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(169.35, 108.4), viewSize, holder)
            .touchedSectionIndex,
        0,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(162.32, 109.37), viewSize, holder)
            .touchedSectionIndex,
        0,
      );

      expect(
        pieChartPainter
            .handleTouch(const Offset(146.67, 144.94), viewSize, holder)
            .touchedSectionIndex,
        1,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(121.06, 160.38), viewSize, holder)
            .touchedSectionIndex,
        1,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(89.66, 163.60), viewSize, holder)
            .touchedSectionIndex,
        1,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(85.04, 177.85), viewSize, holder)
            .touchedSectionIndex,
        1,
      );

      expect(
        pieChartPainter
            .handleTouch(const Offset(75.2, 158.4), viewSize, holder)
            .touchedSectionIndex,
        2,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(66.2, 177), viewSize, holder)
            .touchedSectionIndex,
        2,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(40.3, 124.8), viewSize, holder)
            .touchedSectionIndex,
        2,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(19.1, 131), viewSize, holder)
            .touchedSectionIndex,
        2,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(19.1, 131), viewSize, holder)
            .touchedSectionIndex,
        2,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(17.7, 83.7), viewSize, holder)
            .touchedSectionIndex,
        2,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(27.8, 59.4), viewSize, holder)
            .touchedSectionIndex,
        2,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(44.1, 75.2), viewSize, holder)
            .touchedSectionIndex,
        2,
      );

      expect(
        pieChartPainter
            .handleTouch(const Offset(56.1, 55.6), viewSize, holder)
            .touchedSectionIndex,
        3,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(42.1, 46.3), viewSize, holder)
            .touchedSectionIndex,
        3,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(30.9, 38.4), viewSize, holder)
            .touchedSectionIndex,
        3,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(55.3, 17.8), viewSize, holder)
            .touchedSectionIndex,
        3,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(81.2, 39.8), viewSize, holder)
            .touchedSectionIndex,
        3,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(100.5, 4.1), viewSize, holder)
            .touchedSectionIndex,
        3,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(126.7, 40.6), viewSize, holder)
            .touchedSectionIndex,
        3,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(181.8, 51.3), viewSize, holder)
            .touchedSectionIndex,
        3,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(174.5, 40.2), viewSize, holder)
            .touchedSectionIndex,
        3,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(164.5, 91.4), viewSize, holder)
            .touchedSectionIndex,
        3,
      );
    });

    test('test 3 with cornerRadius sections', () {
      const viewSize = Size(200, 200);
      final data = PieChartData(
        sectionsSpace: 10,
        sections: [
          PieChartSectionData(value: 1, radius: 10, cornerRadius: 5),
          PieChartSectionData(value: 2, radius: 20, cornerRadius: 8),
          PieChartSectionData(value: 3, radius: 30, cornerRadius: 10),
          PieChartSectionData(value: 4, radius: 40, cornerRadius: 12),
        ],
      );
      final pieChartPainter = PieChartPainter();
      final holder =
          PaintHolder<PieChartData>(data, data, TextScaler.noScaling);

      expect(
        pieChartPainter
            .handleTouch(const Offset(159.76, 135.56), viewSize, holder)
            .touchedSectionIndex,
        0,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(121.06, 160.38), viewSize, holder)
            .touchedSectionIndex,
        1,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(40.3, 124.8), viewSize, holder)
            .touchedSectionIndex,
        2,
      );
      expect(
        pieChartPainter
            .handleTouch(const Offset(126.7, 40.6), viewSize, holder)
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
      final pieChartPainter = PieChartPainter();
      final holder = PaintHolder<PieChartData>(
        data,
        data,
        TextScaler.noScaling,
      );

      final result = pieChartPainter.getBadgeOffsets(viewSize, holder);
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

  group('drawSegments()', () {
    test('draws main section with no stacked segments', () {
      const viewSize = Size(200, 200);
      const center = Offset(100, 100);
      const startRadius = 10.0;
      const sweepAngle = 90.0;
      const startAngle = 0.0;

      final section = PieChartSectionData(
        color: MockData.color1,
        radius: 40,
      );

      final painter = PieChartPainter();
      final mainPath = painter.generateSegmentPath(
        center,
        startRadius,
        section.radius,
        startAngle,
        sweepAngle,
      );

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      painter.drawSegments(
        mockCanvasWrapper,
        section,
        mainPath,
        sweepAngle,
        startRadius,
        startAngle,
        center,
      );

      // Only the main section should be drawn — no segments
      final result = verify(mockCanvasWrapper.drawPath(captureAny, captureAny));
      expect(result.callCount, 1);
      expect(
        (result.captured[1] as Paint).color,
        isSameColorAs(MockData.color1),
      );
      expect((result.captured[1] as Paint).style, PaintingStyle.fill);
    });

    test('draws main section plus one stacked segment', () {
      const viewSize = Size(200, 200);
      const center = Offset(100, 100);
      const startRadius = 10.0;
      const sweepAngle = 90.0;
      const startAngle = 0.0;

      final section = PieChartSectionData(
        color: MockData.color1,
        radius: 40,
        segments: [
          PieChartStackSegmentData(
            fromRadius: 10,
            toRadius: 30,
            color: MockData.color2,
          ),
        ],
      );

      final painter = PieChartPainter();
      final mainPath = painter.generateSegmentPath(
        center,
        startRadius,
        section.radius,
        startAngle,
        sweepAngle,
      );

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final drawnColors = <Color>[];
      when(mockCanvasWrapper.drawPath(captureAny, captureAny))
          .thenAnswer((inv) {
        drawnColors.add((inv.positionalArguments[1] as Paint).color);
      });

      painter.drawSegments(
        mockCanvasWrapper,
        section,
        mainPath,
        sweepAngle,
        startRadius,
        startAngle,
        center,
      );

      // main + one segment = 2 drawPath calls
      expect(drawnColors.length, 2);
      expect(drawnColors[0], isSameColorAs(MockData.color1));
      expect(drawnColors[1], isSameColorAs(MockData.color2));
    });

    test('skips segment when clamped segRadius <= 0', () {
      const viewSize = Size(200, 200);
      const center = Offset(100, 100);
      const startRadius = 10.0;
      const sweepAngle = 90.0;
      const startAngle = 0.0;

      final section = PieChartSectionData(
        color: MockData.color1,
        radius: 40,
        segments: [
          // entirely outside [0, radius]: fromRadius > toRadius after clamping
          PieChartStackSegmentData(
            fromRadius: 50,
            toRadius: 50,
            color: MockData.color3,
          ),
          // negative range: toRadius < fromRadius after clamping
          PieChartStackSegmentData(
            fromRadius: 30,
            toRadius: 20,
            color: MockData.color4,
          ),
        ],
      );

      final painter = PieChartPainter();
      final mainPath = painter.generateSegmentPath(
        center,
        startRadius,
        section.radius,
        startAngle,
        sweepAngle,
      );

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      painter.drawSegments(
        mockCanvasWrapper,
        section,
        mainPath,
        sweepAngle,
        startRadius,
        startAngle,
        center,
      );

      // Only the main section — both segments are skipped
      verify(mockCanvasWrapper.drawPath(any, any)).called(1);
    });

    test('draws full-circle (360°) section with a segment', () {
      const viewSize = Size(200, 200);
      const center = Offset(100, 100);
      const startRadius = 10.0;
      const sweepAngle = 360.0;
      const startAngle = 0.0;

      final section = PieChartSectionData(
        color: MockData.color1,
        radius: 40,
        segments: [
          PieChartStackSegmentData(
            fromRadius: 0,
            toRadius: 20,
            color: MockData.color2,
          ),
        ],
      );

      final painter = PieChartPainter();
      final mainPath = painter.generateSegmentPath(
        center,
        startRadius,
        section.radius,
        startAngle,
        sweepAngle,
      );

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      painter.drawSegments(
        mockCanvasWrapper,
        section,
        mainPath,
        sweepAngle,
        startRadius,
        startAngle,
        center,
      );

      // main + one segment = 2 drawPath calls
      verify(mockCanvasWrapper.drawPath(any, any)).called(2);
    });
  });
}
