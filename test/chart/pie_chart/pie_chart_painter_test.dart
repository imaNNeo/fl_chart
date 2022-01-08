import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/line.dart';
import 'package:fl_chart/src/chart/pie_chart/pie_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../helper_methods.dart';
import '../data_pool.dart';
import 'pie_chart_painter_test.mocks.dart';

@GenerateMocks([Canvas, CanvasWrapper, BuildContext, Utils])
void main() {
  group('PieChart usable size', () {
    test('test 1', () {
      const viewSize = Size(728, 728);

      final data = PieChartData(sections: [
        PieChartSectionData(),
        PieChartSectionData(),
        PieChartSectionData(),
      ]);
      final barChartPainter = PieChartPainter();
      final holder = PaintHolder<PieChartData>(data, data, 1.0);
      expect(barChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(728, 728));
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

      final PieChartData data = PieChartData(
        centerSpaceColor: MockData.color1,
      );

      final PieChartPainter barChartPainter = PieChartPainter();
      final holder = PaintHolder<PieChartData>(data, data, 1.0);

      final _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      barChartPainter.drawCenterSpace(_mockCanvasWrapper, 10, holder);

      final result = verify(_mockCanvasWrapper.drawCircle(
          const Offset(100, 100), 10, captureAny));
      expect(result.callCount, 1);
      expect((result.captured.first as Paint).color, MockData.color1);
    });
  });

  group('drawSections()', () {
    test('test 1', () {
      const viewSize = Size(200, 200);

      final sections = [
        PieChartSectionData(color: MockData.color2, radius: 30, value: 10)
      ];
      final PieChartData data = PieChartData(
        sections: sections,
      );

      final PieChartPainter barChartPainter = PieChartPainter();
      final holder = PaintHolder<PieChartData>(data, data, 1.0);

      final _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      barChartPainter.drawSections(_mockCanvasWrapper, [360], 10, holder);

      final result = verify(_mockCanvasWrapper.drawCircle(
          const Offset(100, 100), 10 + 15, captureAny));
      expect(result.callCount, 1);
      expect((result.captured.single as Paint).color, MockData.color2);
      expect((result.captured.single as Paint).strokeWidth, 30);
      expect((result.captured.single as Paint).style, PaintingStyle.stroke);
    });

    test('test 2', () {
      const viewSize = Size(200, 200);

      final PieChartData data = PieChartData(
          centerSpaceColor: MockData.color1,
          sectionsSpace: 10,
          sections: [
            PieChartSectionData(color: MockData.color1, value: 1),
            PieChartSectionData(color: MockData.color2, value: 2),
            PieChartSectionData(color: MockData.color3, value: 3),
            PieChartSectionData(color: MockData.color4, value: 4),
          ]);

      final PieChartPainter barChartPainter = PieChartPainter();
      final holder = PaintHolder<PieChartData>(data, data, 1.0);

      final _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      List<Map<String, dynamic>> results = [];
      when(_mockCanvasWrapper.drawPath(captureAny, captureAny))
          .thenAnswer((inv) {
        final paint = inv.positionalArguments[1] as Paint;
        results.add({
          'path': inv.positionalArguments[0] as Path,
          'paint_color': paint.color,
          'paint_style': paint.style,
        });
      });

      barChartPainter.drawSections(
          _mockCanvasWrapper, [36, 72, 108, 144], 10, holder);
      verifyNever(_mockCanvasWrapper.drawCircle(any, any, any));

      expect(results.length, 4);

      final path0 = barChartPainter.generateSectionPath(
          data.sections[0], 10, 0, 36, const Offset(100, 100), 10);
      expect(
          HelperMethods.equalsPaths(results[0]['path'] as Path, path0), true);
      expect((results[0]['paint_color'] as Color), MockData.color1);
      expect((results[0]['paint_style'] as PaintingStyle), PaintingStyle.fill);

      final path1 = barChartPainter.generateSectionPath(
          data.sections[1], 10, 36, 72, const Offset(100, 100), 10);
      expect(
          HelperMethods.equalsPaths(results[1]['path'] as Path, path1), true);
      expect((results[1]['paint_color'] as Color), MockData.color2);
      expect((results[1]['paint_style'] as PaintingStyle), PaintingStyle.fill);

      final path2 = barChartPainter.generateSectionPath(
          data.sections[2], 10, 108, 108, const Offset(100, 100), 10);
      expect(
          HelperMethods.equalsPaths(results[2]['path'] as Path, path2), true);
      expect((results[2]['paint_color'] as Color), MockData.color3);
      expect((results[2]['paint_style'] as PaintingStyle), PaintingStyle.fill);

      final path3 = barChartPainter.generateSectionPath(
          data.sections[3], 10, 216, 144, const Offset(100, 100), 10);
      expect(
          HelperMethods.equalsPaths(results[3]['path'] as Path, path3), true);
      expect((results[3]['paint_color'] as Color), MockData.color4);
      expect((results[3]['paint_style'] as PaintingStyle), PaintingStyle.fill);
    });
  });

  group('generateSectionPath()', () {
    test('test 1', () {
      final PieChartData data = PieChartData(
          centerSpaceColor: MockData.color1,
          sectionsSpace: 10,
          sections: [
            PieChartSectionData(color: MockData.color1, value: 1),
            PieChartSectionData(color: MockData.color2, value: 2),
            PieChartSectionData(color: MockData.color3, value: 3),
            PieChartSectionData(color: MockData.color4, value: 4),
          ]);
      final PieChartPainter barChartPainter = PieChartPainter();

      final path0 = barChartPainter.generateSectionPath(
          data.sections[0], 10, 0, 36, const Offset(100, 100), 10);
      final path0Length = path0
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path0Length, 90.08028411865234);

      final path1 = barChartPainter.generateSectionPath(
          data.sections[1], 10, 36, 72, const Offset(100, 100), 10);
      final path1Length = path1
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path1Length, 136.93048095703125);

      final path2 = barChartPainter.generateSectionPath(
          data.sections[2], 10, 108, 108, const Offset(100, 100), 10);
      final path2Length = path2
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path2Length, 174.60133361816406);

      final path3 = barChartPainter.generateSectionPath(
          data.sections[3], 10, 216, 144, const Offset(100, 100), 10);
      final path3Length = path3
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path3Length, 212.1544189453125);
    });

    test('test 2', () {
      final PieChartData data = PieChartData(
          centerSpaceColor: MockData.color1,
          sectionsSpace: 0,
          sections: [
            PieChartSectionData(color: MockData.color1, value: 1),
            PieChartSectionData(color: MockData.color2, value: 2),
            PieChartSectionData(color: MockData.color3, value: 3),
            PieChartSectionData(color: MockData.color4, value: 4),
          ]);
      final PieChartPainter barChartPainter = PieChartPainter();

      final path0 = barChartPainter.generateSectionPath(
          data.sections[0], 0, 0, 36, const Offset(100, 100), 10);
      final path0Length = path0
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path0Length, 117.56398010253906);

      final path1 = barChartPainter.generateSectionPath(
          data.sections[1], 0, 36, 72, const Offset(100, 100), 10);
      final path1Length = path1
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path1Length, 155.1278076171875);

      final path2 = barChartPainter.generateSectionPath(
          data.sections[2], 0, 108, 108, const Offset(100, 100), 10);
      final path2Length = path2
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path2Length, 192.84017944335938);

      final path3 = barChartPainter.generateSectionPath(
          data.sections[3], 0, 216, 144, const Offset(100, 100), 10);
      final path3Length = path3
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path3Length, 230.37237548828125);
    });

    test('test 3', () {
      final PieChartData data = PieChartData(
          centerSpaceColor: MockData.color1,
          sectionsSpace: 0,
          sections: [
            PieChartSectionData(color: MockData.color1, value: 1),
            PieChartSectionData(color: MockData.color2, value: 2),
            PieChartSectionData(color: MockData.color3, value: 3),
            PieChartSectionData(color: MockData.color4, value: 4),
          ]);
      final PieChartPainter barChartPainter = PieChartPainter();

      final path0 = barChartPainter.generateSectionPath(
          data.sections[0], 0, 0, 36, const Offset(100, 100), 3);
      final path0Length = path0
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path0Length, 108.80243682861328);

      final path1 = barChartPainter.generateSectionPath(
          data.sections[1], 0, 36, 72, const Offset(100, 100), 4);
      final path1Length = path1
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path1Length, 140.05465698242188);

      final path2 = barChartPainter.generateSectionPath(
          data.sections[2], 0, 108, 108, const Offset(100, 100), 5);
      final path2Length = path2
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path2Length, 173.86875915527344);

      final path3 = barChartPainter.generateSectionPath(
          data.sections[3], 0, 216, 144, const Offset(100, 100), 6);
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
      final PieChartPainter barChartPainter = PieChartPainter();
      final path0 = barChartPainter.createRectPathAroundLine(
          Line(const Offset(0, 0), const Offset(10, 0)), 4);
      final path0Length = path0
          .computeMetrics()
          .toList()
          .map((e) => e.length)
          .reduce((a, b) => a + b);
      expect(path0Length, 32.0);

      final path1 = barChartPainter.createRectPathAroundLine(
          Line(const Offset(32, 11), const Offset(12, 5)), 66);
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
      final PieChartData data = PieChartData(
          centerSpaceColor: MockData.color1,
          sectionsSpace: 10,
          sections: [
            PieChartSectionData(color: MockData.color1, value: 1),
            PieChartSectionData(color: MockData.color2, value: 2),
            PieChartSectionData(color: MockData.color3, value: 3),
            PieChartSectionData(color: MockData.color4, value: 4),
          ]);
      final PieChartPainter barChartPainter = PieChartPainter();

      final _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      List<Map<String, dynamic>> results = [];
      when(_mockCanvasWrapper.drawPath(captureAny, captureAny))
          .thenAnswer((inv) {
        final paint = inv.positionalArguments[1] as Paint;
        results.add({
          'path': inv.positionalArguments[0] as Path,
          'paint_color': paint.color,
          'paint_style': paint.style,
        });
      });

      barChartPainter.drawSection(
          data.sections[0], MockData.path1, _mockCanvasWrapper);
      barChartPainter.drawSection(
          data.sections[1], MockData.path2, _mockCanvasWrapper);
      barChartPainter.drawSection(
          data.sections[2], MockData.path3, _mockCanvasWrapper);
      barChartPainter.drawSection(
          data.sections[3], MockData.path4, _mockCanvasWrapper);

      expect(results.length, 4);

      expect((results[0]['path'] as Path), MockData.path1);
      expect((results[0]['paint_color'] as Color), MockData.color1);
      expect((results[0]['paint_style'] as PaintingStyle), PaintingStyle.fill);

      expect((results[1]['path'] as Path), MockData.path2);
      expect((results[1]['paint_color'] as Color), MockData.color2);
      expect((results[1]['paint_style'] as PaintingStyle), PaintingStyle.fill);

      expect((results[2]['path'] as Path), MockData.path3);
      expect((results[2]['paint_color'] as Color), MockData.color3);
      expect((results[2]['paint_style'] as PaintingStyle), PaintingStyle.fill);

      expect((results[3]['path'] as Path), MockData.path4);
      expect((results[3]['paint_color'] as Color), MockData.color4);
      expect((results[3]['paint_style'] as PaintingStyle), PaintingStyle.fill);
    });
  });

  group('drawSectionStroke()', () {
    test('test 1', () {
      const viewSize = Size(200, 200);
      final PieChartData data = PieChartData(
          centerSpaceColor: MockData.color1,
          sectionsSpace: 10,
          sections: [
            PieChartSectionData(color: MockData.color1, value: 1),
            PieChartSectionData(color: MockData.color2, value: 2),
            PieChartSectionData(color: MockData.color3, value: 3),
            PieChartSectionData(color: MockData.color4, value: 4),
          ]);
      final PieChartPainter barChartPainter = PieChartPainter();

      final _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      List<Map<String, dynamic>> results = [];
      when(_mockCanvasWrapper.drawPath(captureAny, captureAny))
          .thenAnswer((inv) {
        final paint = inv.positionalArguments[1] as Paint;
        results.add({
          'path': inv.positionalArguments[0] as Path,
          'paint_color': paint.color,
          'paint_style': paint.style,
        });
      });

      barChartPainter.drawSectionStroke(
          data.sections[0], MockData.path1, _mockCanvasWrapper, viewSize);
      barChartPainter.drawSectionStroke(
          data.sections[1], MockData.path2, _mockCanvasWrapper, viewSize);
      barChartPainter.drawSectionStroke(
          data.sections[2], MockData.path3, _mockCanvasWrapper, viewSize);
      barChartPainter.drawSectionStroke(
          data.sections[3], MockData.path4, _mockCanvasWrapper, viewSize);

      verifyNever(_mockCanvasWrapper.saveLayer(any, any));
      verifyNever(_mockCanvasWrapper.clipPath(any));
      verifyNever(_mockCanvasWrapper.drawPath(any, any));
      verifyNever(_mockCanvasWrapper.restore());
    });

    test('test 2', () {
      const viewSize = Size(200, 200);
      final PieChartData data = PieChartData(
        centerSpaceColor: MockData.color1,
        sectionsSpace: 10,
        sections: [
          PieChartSectionData(
              color: MockData.color1,
              value: 1,
              borderSide: MockData.borderSide1),
          PieChartSectionData(
              color: MockData.color2,
              value: 2,
              borderSide: MockData.borderSide2),
          PieChartSectionData(
              color: MockData.color3,
              value: 3,
              borderSide: MockData.borderSide3),
          PieChartSectionData(
              color: MockData.color4,
              value: 4,
              borderSide: MockData.borderSide4),
        ],
      );
      final PieChartPainter barChartPainter = PieChartPainter();

      final _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      List<Map<String, dynamic>> clipPathResults = [];
      when(_mockCanvasWrapper.clipPath(captureAny)).thenAnswer((inv) {
        clipPathResults.add({
          'path': inv.positionalArguments[0] as Path,
        });
      });

      List<Map<String, dynamic>> drawPathResults = [];
      when(_mockCanvasWrapper.drawPath(captureAny, captureAny))
          .thenAnswer((inv) {
        final paint = inv.positionalArguments[1] as Paint;
        drawPathResults.add({
          'path': inv.positionalArguments[0] as Path,
          'paint_color': paint.color,
          'paint_style': paint.style,
          'paint_stroke_width': paint.strokeWidth,
        });
      });

      barChartPainter.drawSectionStroke(
          data.sections[0], MockData.path1, _mockCanvasWrapper, viewSize);
      barChartPainter.drawSectionStroke(
          data.sections[1], MockData.path2, _mockCanvasWrapper, viewSize);
      barChartPainter.drawSectionStroke(
          data.sections[2], MockData.path3, _mockCanvasWrapper, viewSize);
      barChartPainter.drawSectionStroke(
          data.sections[3], MockData.path4, _mockCanvasWrapper, viewSize);

      verify(_mockCanvasWrapper.saveLayer(
              Rect.fromLTWH(0, 0, viewSize.width, viewSize.height), any))
          .called(4);
      expect(clipPathResults.length, 4);
      expect(clipPathResults[0]['path'], MockData.path1);
      expect(clipPathResults[1]['path'], MockData.path2);
      expect(clipPathResults[2]['path'], MockData.path3);
      expect(clipPathResults[3]['path'], MockData.path4);

      expect(drawPathResults.length, 4);

      expect(drawPathResults[0]['path'], MockData.path1);
      expect(drawPathResults[0]['paint_color'], MockData.color1);
      expect(drawPathResults[0]['paint_style'], PaintingStyle.stroke);
      expect(drawPathResults[0]['paint_stroke_width'],
          MockData.borderSide1.width * 2);

      expect(drawPathResults[1]['path'], MockData.path2);
      expect(drawPathResults[1]['paint_color'], MockData.color2);
      expect(drawPathResults[1]['paint_style'], PaintingStyle.stroke);
      expect(drawPathResults[1]['paint_stroke_width'],
          MockData.borderSide2.width * 2);

      expect(drawPathResults[2]['path'], MockData.path3);
      expect(drawPathResults[2]['paint_color'], MockData.color3);
      expect(drawPathResults[2]['paint_style'], PaintingStyle.stroke);
      expect(drawPathResults[2]['paint_stroke_width'],
          MockData.borderSide3.width * 2);

      expect(drawPathResults[3]['path'], MockData.path4);
      expect(drawPathResults[3]['paint_color'], MockData.color4);
      expect(drawPathResults[3]['paint_style'], PaintingStyle.stroke);
      expect(drawPathResults[3]['paint_stroke_width'],
          MockData.borderSide4.width * 2);

      verify(_mockCanvasWrapper.restore()).called(4);
    });
  });
}
