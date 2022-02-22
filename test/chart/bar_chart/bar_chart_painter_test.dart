import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../helper_methods.dart';
import '../data_pool.dart';
import 'bar_chart_painter_test.mocks.dart';

@GenerateMocks([Canvas, CanvasWrapper, BuildContext, Utils])
void main() {
  const tolerance = 0.01;

  group('BarChart usable size', () {
    test('test 1', () {
      const viewSize = Size(728, 728);

      final BarChartData data = BarChartData(
          titlesData: FlTitlesData(
        leftTitles: SideTitles(reservedSize: 12, margin: 8, showTitles: true),
        rightTitles: SideTitles(reservedSize: 44, margin: 20, showTitles: true),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(showTitles: false),
      ));

      final BarChartPainter barChartPainter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);
      expect(barChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(644, 728));
    });

    test('test 2', () {
      const viewSize = Size(2020, 2020);

      final BarChartData data = BarChartData(
          titlesData: FlTitlesData(
        leftTitles: SideTitles(reservedSize: 44, margin: 18, showTitles: true),
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(showTitles: false),
      ));

      final BarChartPainter barChartPainter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);
      expect(barChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(1958, 2020));
    });

    test('test 3', () {
      const viewSize = Size(1000, 1000);

      final BarChartData data = BarChartData(
          titlesData: FlTitlesData(
        leftTitles: SideTitles(showTitles: false),
        rightTitles:
            SideTitles(reservedSize: 100, margin: 400, showTitles: true),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(showTitles: false),
      ));

      final BarChartPainter barChartPainter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);
      expect(barChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(500, 1000));
    });

    test('test 4', () {
      const viewSize = Size(800, 1000);

      final BarChartData data = BarChartData(
          titlesData: FlTitlesData(
        leftTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(reservedSize: 10, margin: 0, showTitles: true),
        topTitles: SideTitles(reservedSize: 230, margin: 10, showTitles: true),
        bottomTitles:
            SideTitles(reservedSize: 10, margin: 312, showTitles: true),
      ));

      final BarChartPainter barChartPainter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);
      expect(barChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(790, 438));
    });

    test('test 5', () {
      const viewSize = Size(600, 400);

      final BarChartData data = BarChartData(
          titlesData: FlTitlesData(
        leftTitles: SideTitles(reservedSize: 0, margin: 0, showTitles: true),
        rightTitles:
            SideTitles(reservedSize: 10, margin: 342134123, showTitles: false),
        topTitles: SideTitles(reservedSize: 80, margin: 0, showTitles: true),
        bottomTitles:
            SideTitles(reservedSize: 10, margin: 312, showTitles: false),
      ));

      final BarChartPainter barChartPainter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);
      expect(barChartPainter.getChartUsableDrawSize(viewSize, holder),
          const Size(600, 320));
    });
  });

  group('calculateGroupsX()', () {
    test('test 1', () {
      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(y: 10, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(y: 10, width: 10),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(y: 10, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
      ];

      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
        groupsSpace: 10,
      );

      final BarChartPainter barChartPainter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);

      List<double> callWithAlignment(BarChartAlignment alignment) {
        return barChartPainter.calculateGroupsX(
            viewSize, barGroups, alignment, holder);
      }

      expect(callWithAlignment(BarChartAlignment.center), [50, 92.5, 142.5]);
      expect(callWithAlignment(BarChartAlignment.start), [20, 52.5, 92.5]);
      expect(callWithAlignment(BarChartAlignment.end), [100, 132.5, 172.5]);
      expect(
          callWithAlignment(BarChartAlignment.spaceEvenly), [40, 92.5, 152.5]);
      expect(
        callWithAlignment(BarChartAlignment.spaceAround),
        [
          closeTo(33.33, tolerance),
          92.5,
          closeTo(159.16, tolerance),
        ],
      );
      expect(
          callWithAlignment(BarChartAlignment.spaceBetween), [20, 92.5, 172.5]);
    });
  });

  group('calculateGroupAndBarsPosition()', () {
    test('test 1', () {
      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(y: 10, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(y: 10, width: 10),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
      ];

      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
        groupsSpace: 10,
      );

      final BarChartPainter barChartPainter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);

      final groupsX = barChartPainter.calculateGroupsX(
          viewSize, barGroups, BarChartAlignment.center, holder);
      late Exception exception;
      try {
        barChartPainter.calculateGroupAndBarsPosition(
            viewSize, groupsX + [groupsX.last], barGroups);
      } catch (e) {
        exception = e as Exception;
      }

      expect(true, exception.toString().contains('inconsistent'));
    });

    test('test 2', () {
      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(y: 10, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(y: 10, width: 10),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(y: 10, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
      ];

      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
        groupsSpace: 10,
      );

      final BarChartPainter barChartPainter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);

      List<GroupBarsPosition> callWithAlignment(BarChartAlignment alignment) {
        final groupsX = barChartPainter.calculateGroupsX(
            viewSize, barGroups, alignment, holder);
        return barChartPainter.calculateGroupAndBarsPosition(
            viewSize, groupsX, barGroups);
      }

      final centerResult = callWithAlignment(BarChartAlignment.center);
      expect(centerResult.map((e) => e.groupX).toList(), [50, 92.5, 142.5]);
      expect(centerResult[0].barsX, [35, 50, 65]);
      expect(centerResult[1].barsX, [85, 100]);
      expect(centerResult[2].barsX, [120, 135, 150, 165]);

      final startResult = callWithAlignment(BarChartAlignment.start);
      expect(startResult.map((e) => e.groupX).toList(), [20, 52.5, 92.5]);
      expect(startResult[0].barsX, [5, 20, 35]);
      expect(startResult[1].barsX, [45, 60]);
      expect(startResult[2].barsX, [70, 85, 100, 115]);
    });
  });

  group('drawBars()', () {
    test('test 1', () {
      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                y: 10,
                width: 10,
                colors: [const Color(0x00000000)],
                borderRadius: const BorderRadius.all(Radius.circular(0.1)),
              ),
              BarChartRodData(
                y: 8,
                width: 11,
                colors: [const Color(0x11111111)],
                borderRadius: const BorderRadius.all(Radius.circular(0.2)),
              ),
              BarChartRodData(
                y: 8,
                width: 12,
                colors: [const Color(0x22222222)],
                borderRadius: const BorderRadius.all(Radius.circular(0.3)),
              ),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                  y: 10,
                  width: 10,
                  borderRadius: const BorderRadius.all(Radius.circular(0.4))),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                y: 10,
                width: 10,
                backDrawRodData: BackgroundBarChartRodData(
                  y: 8,
                  show: true,
                ),
              ),
              BarChartRodData(
                y: 8,
                width: 10,
                backDrawRodData: BackgroundBarChartRodData(
                  show: false,
                ),
              ),
              BarChartRodData(
                y: 8,
                width: 10,
                backDrawRodData: BackgroundBarChartRodData(
                  y: -3,
                  show: true,
                ),
              ),
              BarChartRodData(
                y: 8,
                width: 10,
                backDrawRodData: BackgroundBarChartRodData(
                  y: 0,
                ),
              ),
            ],
            barsSpace: 5),
      ];

      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
        groupsSpace: 10,
        barGroups: barGroups,
      );

      final BarChartPainter barChartPainter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);

      final MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final groupsX = barChartPainter.calculateGroupsX(
          viewSize, barGroups, BarChartAlignment.center, holder);
      final barGroupsPosition = barChartPainter.calculateGroupAndBarsPosition(
          viewSize, groupsX, barGroups);

      List<Map<String, dynamic>> results = [];
      when(_mockCanvasWrapper.drawRRect(captureAny, captureAny))
          .thenAnswer((inv) {
        final rrect = inv.positionalArguments[0] as RRect;
        final paint = inv.positionalArguments[1] as Paint;
        results.add({
          'rrect': RRect.fromLTRBAndCorners(
            rrect.left,
            rrect.top,
            rrect.right,
            rrect.bottom,
            topLeft: rrect.tlRadius,
            topRight: rrect.trRadius,
            bottomRight: rrect.brRadius,
            bottomLeft: rrect.blRadius,
          ),
          'paint_color': paint.color,
        });
      });

      barChartPainter.drawBars(_mockCanvasWrapper, barGroupsPosition, holder);
      expect(results.length, 11);

      expect(
          HelperMethods.equalsRRects(
            (results[0]['rrect'] as RRect),
            RRect.fromLTRBR(
              28.5,
              0.0,
              38.5,
              76.9,
              const Radius.circular(0.1),
            ),
          ),
          true);
      expect((results[0]['paint_color'] as Color), const Color(0x00000000));

      expect(
        HelperMethods.equalsRRects(
          (results[1]['rrect'] as RRect),
          RRect.fromLTRBR(
            43.5,
            15.4,
            54.5,
            76.9,
            const Radius.circular(0.2),
          ),
        ),
        true,
      );
      expect((results[1]['paint_color'] as Color), const Color(0x11111111));

      expect(
        HelperMethods.equalsRRects(
          (results[2]['rrect'] as RRect),
          RRect.fromLTRBR(
            59.5,
            15.4,
            71.5,
            76.9,
            const Radius.circular(0.3),
          ),
        ),
        true,
      );
      expect((results[2]['paint_color'] as Color), const Color(0x22222222));

      expect(
        HelperMethods.equalsRRects(
          (results[3]['rrect'] as RRect),
          RRect.fromLTRBR(
            81.5,
            0.0,
            91.5,
            76.9,
            const Radius.circular(0.4),
          ),
        ),
        true,
      );
      expect(
        HelperMethods.equalsRRects(
          (results[4]['rrect'] as RRect),
          RRect.fromLTRBR(
            96.5,
            15.4,
            106.5,
            76.9,
            const Radius.circular(5.0),
          ),
        ),
        true,
      );

      expect(
        HelperMethods.equalsRRects(
          (results[5]['rrect'] as RRect),
          RRect.fromLTRBR(
            116.5,
            15.4,
            126.5,
            76.9,
            const Radius.circular(5.0),
          ),
        ),
        true,
      );

      expect(
        HelperMethods.equalsRRects(
          (results[6]['rrect'] as RRect),
          RRect.fromLTRBR(
            116.5,
            0.0,
            126.5,
            76.9,
            const Radius.circular(5.0),
          ),
        ),
        true,
      );
      expect(
        HelperMethods.equalsRRects(
          (results[7]['rrect'] as RRect),
          RRect.fromLTRBR(
            131.5,
            15.4,
            141.5,
            76.9,
            const Radius.circular(5.0),
          ),
        ),
        true,
      );

      expect(
        HelperMethods.equalsRRects(
          (results[8]['rrect'] as RRect),
          RRect.fromLTRBR(
            146.5,
            76.9,
            156.5,
            100.0,
            const Radius.circular(5.0),
          ),
        ),
        true,
      );

      expect(
        HelperMethods.equalsRRects(
          (results[9]['rrect'] as RRect),
          RRect.fromLTRBR(
            146.5,
            15.4,
            156.5,
            76.9,
            const Radius.circular(5.0),
          ),
        ),
        true,
      );
      expect(
        HelperMethods.equalsRRects(
          (results[10]['rrect'] as RRect),
          RRect.fromLTRBR(
            161.5,
            15.4,
            171.5,
            76.9,
            const Radius.circular(5.0),
          ),
        ),
        true,
      );
    });
  });

  group('drawTitles()', () {
    test('test 1', () {
      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                y: 10,
                width: 10,
                colors: [const Color(0x00000000)],
                borderRadius: const BorderRadius.all(Radius.circular(0.1)),
              ),
              BarChartRodData(
                y: 8,
                width: 11,
                colors: [const Color(0x11111111)],
                borderRadius: const BorderRadius.all(Radius.circular(0.2)),
              ),
              BarChartRodData(
                y: 8,
                width: 12,
                colors: [const Color(0x22222222)],
                borderRadius: const BorderRadius.all(Radius.circular(0.3)),
              ),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                  y: 10,
                  width: 10,
                  borderRadius: const BorderRadius.all(Radius.circular(0.4))),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(y: 10, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
      ];

      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
        groupsSpace: 10,
        barGroups: barGroups,
      );

      final BarChartPainter barChartPainter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);

      final MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      final MockBuildContext _mockBuildContext = MockBuildContext();

      final groupsX = barChartPainter.calculateGroupsX(
          viewSize, barGroups, BarChartAlignment.center, holder);
      final barGroupsPosition = barChartPainter.calculateGroupAndBarsPosition(
          viewSize, groupsX, barGroups);

      barChartPainter.drawTitles(
          _mockBuildContext, _mockCanvasWrapper, barGroupsPosition, holder);
      verifyNever(_mockCanvasWrapper.drawRRect(any, any));
    });

    test('test 2', () {
      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                y: 10,
                width: 10,
                colors: [const Color(0x00000000)],
                borderRadius: const BorderRadius.all(Radius.circular(0.1)),
              ),
              BarChartRodData(
                y: 8,
                width: 11,
                colors: [const Color(0x11111111)],
                borderRadius: const BorderRadius.all(Radius.circular(0.2)),
              ),
              BarChartRodData(
                y: 8,
                width: 12,
                colors: [const Color(0x22222222)],
                borderRadius: const BorderRadius.all(Radius.circular(0.3)),
              ),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                  y: 10,
                  width: 10,
                  borderRadius: const BorderRadius.all(Radius.circular(0.4))),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(y: 10, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
      ];

      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(showTitles: false),
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(showTitles: false),
        ),
        axisTitleData: FlAxisTitleData(show: false),
        groupsSpace: 10,
        barGroups: barGroups,
      );

      final BarChartPainter barChartPainter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);

      final MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final MockBuildContext _mockBuildContext = MockBuildContext();

      final groupsX = barChartPainter.calculateGroupsX(
          viewSize, barGroups, BarChartAlignment.center, holder);
      final barGroupsPosition = barChartPainter.calculateGroupAndBarsPosition(
          viewSize, groupsX, barGroups);

      barChartPainter.drawTitles(
          _mockBuildContext, _mockCanvasWrapper, barGroupsPosition, holder);
      verifyNever(_mockCanvasWrapper.drawRRect(any, any));
    });

    test('test 3', () {
      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(x: 0, barRods: [], barsSpace: 5),
        BarChartGroupData(x: 1, barRods: [], barsSpace: 5),
        BarChartGroupData(x: 2, barRods: [], barsSpace: 5),
      ];

      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(showTitles: true),
          rightTitles: SideTitles(showTitles: true),
          topTitles: SideTitles(showTitles: true),
          bottomTitles: SideTitles(showTitles: true),
        ),
        axisTitleData: FlAxisTitleData(show: false),
        groupsSpace: 10,
        barGroups: barGroups,
      );

      final BarChartPainter barChartPainter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);

      final MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final MockBuildContext _mockBuildContext = MockBuildContext();

      final MockUtils _mockUtils = MockUtils();
      Utils.changeInstance(_mockUtils);
      when(_mockUtils.getThemeAwareTextStyle(any, any))
          .thenAnswer((realInvocation) => MockData.textStyle1);
      when(_mockUtils.getEfficientInterval(any, any))
          .thenAnswer((realInvocation) => 1);
      when(_mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenAnswer((realInvocation) => 0);
      when(_mockUtils.formatNumber(any)).thenAnswer((realInvocation) => '1');
      when(_mockUtils.calculateRotationOffset(any, any))
          .thenAnswer((realInvocation) => Offset.zero);

      final groupsX = barChartPainter.calculateGroupsX(
          viewSize, barGroups, BarChartAlignment.center, holder);
      final barGroupsPosition = barChartPainter.calculateGroupAndBarsPosition(
          viewSize, groupsX, barGroups);

      barChartPainter.drawTitles(
          _mockBuildContext, _mockCanvasWrapper, barGroupsPosition, holder);
      verifyNever(_mockCanvasWrapper.drawRRect(any, any));
      Utils.restoreDefaultInstance();
    });

    test('test 4', () {
      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                y: 10,
                width: 10,
                colors: [const Color(0x00000000)],
                borderRadius: const BorderRadius.all(Radius.circular(0.1)),
              ),
              BarChartRodData(
                y: 8,
                width: 11,
                colors: [const Color(0x11111111)],
                borderRadius: const BorderRadius.all(Radius.circular(0.2)),
              ),
              BarChartRodData(
                y: 8,
                width: 12,
                colors: [const Color(0x22222222)],
                borderRadius: const BorderRadius.all(Radius.circular(0.3)),
              ),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                  y: 10,
                  width: 10,
                  borderRadius: const BorderRadius.all(Radius.circular(0.4))),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(y: 10, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
      ];

      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(showTitles: false),
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(showTitles: true),
        ),
        axisTitleData: FlAxisTitleData(show: false),
        groupsSpace: 10,
        barGroups: barGroups,
      );

      final BarChartPainter barChartPainter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);

      final MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final MockBuildContext _mockBuildContext = MockBuildContext();

      final MockUtils _mockUtils = MockUtils();
      Utils.changeInstance(_mockUtils);
      when(_mockUtils.getThemeAwareTextStyle(any, any)).thenReturn(
        const TextStyle(
          color: Color(0xffd32233),
        ),
      );
      when(_mockUtils.getEfficientInterval(any, any)).thenReturn(11);
      when(_mockUtils.calculateRotationOffset(any, any))
          .thenReturn(Offset.zero);
      when(_mockUtils.formatNumber(captureAny)).thenAnswer((inv) {
        final value = inv.positionalArguments[0] as double;
        return '${value.toInt()}';
      });

      final groupsX = barChartPainter.calculateGroupsX(
          viewSize, barGroups, BarChartAlignment.center, holder);
      final barGroupsPosition = barChartPainter.calculateGroupAndBarsPosition(
          viewSize, groupsX, barGroups);

      List<Map<String, dynamic>> results = [];
      when(_mockCanvasWrapper.drawText(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        final textPainter = inv.positionalArguments[0] as TextPainter;
        final offset = inv.positionalArguments[1] as Offset;
        final rotateAngle = inv.positionalArguments[2] as double;
        results.add({
          'textPainter': textPainter,
          'offset': offset,
          'rotateAngle': rotateAngle,
        });
      });

      barChartPainter.drawTitles(
          _mockBuildContext, _mockCanvasWrapper, barGroupsPosition, holder);
      expect(results.length, 3);

      expect(
        ((results[0]['textPainter'] as TextPainter).text as TextSpan).text,
        '0',
      );
      expect(
        ((results[0]['textPainter'] as TextPainter).text as TextSpan)
            .style
            ?.color,
        const Color(0xffd32233),
      );
      expect(results[0]['offset'] as Offset, const Offset(43, 78));

      expect(
        ((results[1]['textPainter'] as TextPainter).text as TextSpan).text,
        '1',
      );
      expect(
        ((results[1]['textPainter'] as TextPainter).text as TextSpan)
            .style
            ?.color,
        const Color(0xffd32233),
      );
      expect(results[1]['offset'] as Offset, const Offset(87, 78));

      expect(
        ((results[2]['textPainter'] as TextPainter).text as TextSpan).text,
        '2',
      );
      expect(
        ((results[2]['textPainter'] as TextPainter).text as TextSpan)
            .style
            ?.color,
        const Color(0xffd32233),
      );
      expect(results[2]['offset'] as Offset, const Offset(137, 78));
    });

    test('test 5', () {
      final MockUtils _mockUtils = MockUtils();
      when(_mockUtils.getThemeAwareTextStyle(any, any)).thenReturn(
        const TextStyle(
          color: Color(0xffd32233),
        ),
      );
      when(_mockUtils.getEfficientInterval(any, any)).thenReturn(11);
      when(_mockUtils.normalizeBorderRadius(any, any))
          .thenReturn(BorderRadius.zero);
      when(_mockUtils.normalizeBorderSide(any, any))
          .thenReturn(BorderSide.none);
      when(_mockUtils.calculateRotationOffset(any, any))
          .thenReturn(Offset.zero);
      when(_mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenReturn(0.0);
      when(_mockUtils.formatNumber(captureAny)).thenAnswer((inv) {
        final value = inv.positionalArguments[0] as double;
        return '${value.toInt()}';
      });
      Utils.changeInstance(_mockUtils);

      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                y: 10,
                width: 10,
                colors: [const Color(0x00000000)],
                borderRadius: const BorderRadius.all(Radius.circular(0.1)),
              ),
              BarChartRodData(
                y: 8,
                width: 11,
                colors: [const Color(0x11111111)],
                borderRadius: const BorderRadius.all(Radius.circular(0.2)),
              ),
              BarChartRodData(
                y: 8,
                width: 12,
                colors: [const Color(0x22222222)],
                borderRadius: const BorderRadius.all(Radius.circular(0.3)),
              ),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                  y: 10,
                  width: 10,
                  borderRadius: const BorderRadius.all(Radius.circular(0.4))),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(y: 10, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
      ];

      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(showTitles: true, interval: 1.0),
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(showTitles: true),
        ),
        axisTitleData: FlAxisTitleData(show: false),
        groupsSpace: 10,
        barGroups: barGroups,
      );

      final BarChartPainter barChartPainter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);

      final MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final MockBuildContext _mockBuildContext = MockBuildContext();

      final groupsX = barChartPainter.calculateGroupsX(
          viewSize, barGroups, BarChartAlignment.center, holder);
      final barGroupsPosition = barChartPainter.calculateGroupAndBarsPosition(
          viewSize, groupsX, barGroups);

      List<Map<String, dynamic>> results = [];
      when(_mockCanvasWrapper.drawText(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        final textPainter = inv.positionalArguments[0] as TextPainter;
        final offset = inv.positionalArguments[1] as Offset;
        final rotateAngle = inv.positionalArguments[2] as double;
        results.add({
          'textPainter': textPainter,
          'offset': offset,
          'rotateAngle': rotateAngle,
        });
      });

      barChartPainter.drawTitles(
          _mockBuildContext, _mockCanvasWrapper, barGroupsPosition, holder);
      expect(results.length, 14);
    });

    test('test 6', () {
      final MockUtils _mockUtils = MockUtils();
      when(_mockUtils.getThemeAwareTextStyle(any, any)).thenReturn(
        const TextStyle(
          color: Color(0xffd32233),
        ),
      );
      when(_mockUtils.getEfficientInterval(any, any)).thenReturn(11);
      when(_mockUtils.normalizeBorderRadius(any, any))
          .thenReturn(BorderRadius.zero);
      when(_mockUtils.normalizeBorderSide(any, any))
          .thenReturn(BorderSide.none);
      when(_mockUtils.calculateRotationOffset(any, any))
          .thenReturn(Offset.zero);
      when(_mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenReturn(0.0);
      when(_mockUtils.formatNumber(captureAny)).thenAnswer((inv) {
        final value = inv.positionalArguments[0] as double;
        return '${value.toInt()}';
      });
      Utils.changeInstance(_mockUtils);

      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                y: 10,
                width: 10,
                colors: [const Color(0x00000000)],
                borderRadius: const BorderRadius.all(Radius.circular(0.1)),
              ),
              BarChartRodData(
                y: 8,
                width: 11,
                colors: [const Color(0x11111111)],
                borderRadius: const BorderRadius.all(Radius.circular(0.2)),
              ),
              BarChartRodData(
                y: 8,
                width: 12,
                colors: [const Color(0x22222222)],
                borderRadius: const BorderRadius.all(Radius.circular(0.3)),
              ),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                  y: 10,
                  width: 10,
                  borderRadius: const BorderRadius.all(Radius.circular(0.4))),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(y: 10, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
      ];

      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(showTitles: true, interval: 3.0),
          rightTitles: SideTitles(showTitles: true, interval: 3.0),
          topTitles: SideTitles(showTitles: true),
          bottomTitles: SideTitles(showTitles: true),
        ),
        axisTitleData: FlAxisTitleData(show: false),
        groupsSpace: 10,
        barGroups: barGroups,
      );

      final BarChartPainter barChartPainter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);

      final MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final MockBuildContext _mockBuildContext = MockBuildContext();

      final groupsX = barChartPainter.calculateGroupsX(
          viewSize, barGroups, BarChartAlignment.center, holder);
      final barGroupsPosition = barChartPainter.calculateGroupAndBarsPosition(
          viewSize, groupsX, barGroups);

      List<Map<String, dynamic>> results = [];
      when(_mockCanvasWrapper.drawText(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        final textPainter = inv.positionalArguments[0] as TextPainter;
        final offset = inv.positionalArguments[1] as Offset;
        final rotateAngle = inv.positionalArguments[2] as double;
        results.add({
          'textPainter': textPainter,
          'offset': offset,
          'rotateAngle': rotateAngle,
        });
      });

      barChartPainter.drawTitles(
          _mockBuildContext, _mockCanvasWrapper, barGroupsPosition, holder);
      expect(results.length, 16);
    });
  });

  group('drawTouchTooltip()', () {
    test('test 1', () {
      final MockUtils _mockUtils = MockUtils();
      when(_mockUtils.getThemeAwareTextStyle(any, any)).thenReturn(textStyle1);
      when(_mockUtils.getEfficientInterval(any, any)).thenReturn(11);
      when(_mockUtils.normalizeBorderRadius(any, any))
          .thenReturn(BorderRadius.zero);
      when(_mockUtils.normalizeBorderSide(any, any))
          .thenReturn(BorderSide.none);
      when(_mockUtils.calculateRotationOffset(any, any))
          .thenReturn(Offset.zero);
      when(_mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenReturn(0.0);
      when(_mockUtils.formatNumber(captureAny)).thenAnswer((inv) {
        final value = inv.positionalArguments[0] as double;
        return '${value.toInt()}';
      });
      Utils.changeInstance(_mockUtils);

      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                y: 10,
                width: 10,
                colors: [const Color(0x00000000)],
                borderRadius: const BorderRadius.all(Radius.circular(0.1)),
              ),
              BarChartRodData(
                y: 8,
                width: 11,
                colors: [const Color(0x11111111)],
                borderRadius: const BorderRadius.all(Radius.circular(0.2)),
              ),
              BarChartRodData(
                y: 8,
                width: 12,
                colors: [const Color(0x22222222)],
                borderRadius: const BorderRadius.all(Radius.circular(0.3)),
              ),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                  y: 10,
                  width: 10,
                  borderRadius: const BorderRadius.all(Radius.circular(0.4))),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(y: 10, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
      ];

      BarTouchTooltipData tooltipData = BarTouchTooltipData(
          tooltipRoundedRadius: 8,
          tooltipBgColor: const Color(0xf33f33f3),
          maxContentWidth: 80,
          rotateAngle: 12,
          getTooltipItem: (
            group,
            groupIndex,
            rod,
            rodIndex,
          ) {
            return BarTooltipItem('helllo1', textStyle1,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                children: [
                  const TextSpan(text: 'helllo2'),
                  const TextSpan(text: 'helllo3'),
                ]);
          });

      final BarChartData data = BarChartData(
          groupsSpace: 10,
          barGroups: barGroups,
          barTouchData: BarTouchData(
            touchTooltipData: tooltipData,
          ));

      final BarChartPainter barChartPainter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);

      final MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final MockBuildContext _mockBuildContext = MockBuildContext();

      final groupsX = barChartPainter.calculateGroupsX(
          viewSize, barGroups, BarChartAlignment.center, holder);
      final barGroupsPosition = barChartPainter.calculateGroupAndBarsPosition(
          viewSize, groupsX, barGroups);

      final angles = <double>[];
      when(_mockCanvasWrapper.drawRotated(
        size: anyNamed('size'),
        rotationOffset: anyNamed('rotationOffset'),
        drawOffset: anyNamed('drawOffset'),
        angle: anyNamed('angle'),
        drawCallback: anyNamed('drawCallback'),
      )).thenAnswer((inv) {
        final callback = inv.namedArguments[const Symbol('drawCallback')];
        callback();
        angles.add(inv.namedArguments[const Symbol('angle')] as double);
      });

      barChartPainter.drawTouchTooltip(
        _mockBuildContext,
        _mockCanvasWrapper,
        barGroupsPosition,
        tooltipData,
        barGroups[0],
        0,
        barGroups[0].barRods[0],
        0,
        holder,
      );
      final result1 =
          verify(_mockCanvasWrapper.drawRRect(captureAny, captureAny));
      result1.called(1);
      final rrect = result1.captured[0] as RRect;
      expect(rrect.blRadius, const Radius.circular(8.0));
      expect(rrect.width, 112);
      expect(rrect.height, 90);
      expect(rrect.left, -22.5);
      expect(rrect.top, -106);

      final bgTooltipPaint = result1.captured[1] as Paint;
      expect(bgTooltipPaint.color, const Color(0xf33f33f3));
      expect(bgTooltipPaint.style, PaintingStyle.fill);

      expect(angles.length, 1);
      expect(angles[0], 12);

      final result2 =
          verify(_mockCanvasWrapper.drawText(captureAny, captureAny));
      result2.called(1);
      final textPainter = result2.captured[0] as TextPainter;
      expect((textPainter.text as TextSpan).text, 'helllo1');
      expect((textPainter.text as TextSpan).style, textStyle1);
      expect(textPainter.textAlign, TextAlign.right);
      expect(textPainter.textDirection, TextDirection.rtl);
      expect((textPainter.text as TextSpan).children![0],
          const TextSpan(text: 'helllo2'));
      expect((textPainter.text as TextSpan).children![1],
          const TextSpan(text: 'helllo3'));

      final drawOffset = result2.captured[1] as Offset;
      expect(drawOffset, const Offset(-6.5, -98.0));
    });

    test('test 2', () {
      final MockUtils _mockUtils = MockUtils();
      when(_mockUtils.getThemeAwareTextStyle(any, any)).thenReturn(textStyle1);
      when(_mockUtils.getEfficientInterval(any, any)).thenReturn(11);
      when(_mockUtils.normalizeBorderRadius(any, any))
          .thenReturn(BorderRadius.zero);
      when(_mockUtils.normalizeBorderSide(any, any))
          .thenReturn(BorderSide.none);
      when(_mockUtils.calculateRotationOffset(any, any))
          .thenReturn(Offset.zero);
      when(_mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenReturn(0.0);
      when(_mockUtils.formatNumber(captureAny)).thenAnswer((inv) {
        final value = inv.positionalArguments[0] as double;
        return '${value.toInt()}';
      });
      Utils.changeInstance(_mockUtils);

      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                y: 10,
                width: 10,
                colors: [const Color(0x00000000)],
                borderRadius: const BorderRadius.all(Radius.circular(0.1)),
              ),
              BarChartRodData(
                y: 8,
                width: 11,
                colors: [const Color(0x11111111)],
                borderRadius: const BorderRadius.all(Radius.circular(0.2)),
              ),
              BarChartRodData(
                y: 8,
                width: 12,
                colors: [const Color(0x22222222)],
                borderRadius: const BorderRadius.all(Radius.circular(0.3)),
              ),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                  y: 10,
                  width: 10,
                  borderRadius: const BorderRadius.all(Radius.circular(0.4))),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(y: 10, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
      ];

      BarTouchTooltipData tooltipData = BarTouchTooltipData(
          tooltipRoundedRadius: 8,
          tooltipBgColor: const Color(0xf33f33f3),
          maxContentWidth: 80,
          rotateAngle: 12,
          direction: TooltipDirection.bottom,
          getTooltipItem: (
            group,
            groupIndex,
            rod,
            rodIndex,
          ) {
            return BarTooltipItem('helllo1', textStyle1,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                children: [
                  const TextSpan(text: 'helllo2'),
                  const TextSpan(text: 'helllo3'),
                ]);
          });

      final BarChartData data = BarChartData(
          groupsSpace: 10,
          barGroups: barGroups,
          barTouchData: BarTouchData(
            touchTooltipData: tooltipData,
          ));

      final BarChartPainter barChartPainter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);

      final MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final MockBuildContext _mockBuildContext = MockBuildContext();

      final groupsX = barChartPainter.calculateGroupsX(
          viewSize, barGroups, BarChartAlignment.center, holder);
      final barGroupsPosition = barChartPainter.calculateGroupAndBarsPosition(
          viewSize, groupsX, barGroups);

      final angles = <double>[];
      when(_mockCanvasWrapper.drawRotated(
        size: anyNamed('size'),
        rotationOffset: anyNamed('rotationOffset'),
        drawOffset: anyNamed('drawOffset'),
        angle: anyNamed('angle'),
        drawCallback: anyNamed('drawCallback'),
      )).thenAnswer((inv) {
        final callback = inv.namedArguments[const Symbol('drawCallback')];
        callback();
        angles.add(inv.namedArguments[const Symbol('angle')] as double);
      });

      barChartPainter.drawTouchTooltip(
        _mockBuildContext,
        _mockCanvasWrapper,
        barGroupsPosition,
        tooltipData,
        barGroups[0],
        0,
        barGroups[0].barRods[0],
        0,
        holder,
      );
      final result1 =
          verify(_mockCanvasWrapper.drawRRect(captureAny, captureAny));
      result1.called(1);
      final rrect = result1.captured[0] as RRect;
      expect(rrect.blRadius, const Radius.circular(8.0));
      expect(rrect.width, 112);
      expect(rrect.height, 90);
      expect(rrect.left, -22.5);
      expect(rrect.top, 104);

      final bgTooltipPaint = result1.captured[1] as Paint;
      expect(bgTooltipPaint.color, const Color(0xf33f33f3));
      expect(bgTooltipPaint.style, PaintingStyle.fill);

      expect(angles.length, 1);
      expect(angles[0], 12);

      final result2 =
          verify(_mockCanvasWrapper.drawText(captureAny, captureAny));
      result2.called(1);
      final textPainter = result2.captured[0] as TextPainter;
      expect((textPainter.text as TextSpan).text, 'helllo1');
      expect((textPainter.text as TextSpan).style, textStyle1);
      expect(textPainter.textAlign, TextAlign.right);
      expect(textPainter.textDirection, TextDirection.rtl);
      expect((textPainter.text as TextSpan).children![0],
          const TextSpan(text: 'helllo2'));
      expect((textPainter.text as TextSpan).children![1],
          const TextSpan(text: 'helllo3'));

      final drawOffset = result2.captured[1] as Offset;
      expect(drawOffset, const Offset(-6.5, 112.0));
    });

    test('test 3', () {
      final MockUtils _mockUtils = MockUtils();
      when(_mockUtils.getThemeAwareTextStyle(any, any)).thenReturn(textStyle1);
      when(_mockUtils.getEfficientInterval(any, any)).thenReturn(11);
      when(_mockUtils.normalizeBorderRadius(any, any))
          .thenReturn(BorderRadius.zero);
      when(_mockUtils.normalizeBorderSide(any, any))
          .thenReturn(BorderSide.none);
      when(_mockUtils.calculateRotationOffset(any, any))
          .thenReturn(Offset.zero);
      when(_mockUtils.getBestInitialIntervalValue(any, any, any))
          .thenReturn(0.0);
      when(_mockUtils.formatNumber(captureAny)).thenAnswer((inv) {
        final value = inv.positionalArguments[0] as double;
        return '${value.toInt()}';
      });
      Utils.changeInstance(_mockUtils);

      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(x: 0, barRods: [
          BarChartRodData(
            y: 10,
            width: 10,
            colors: [const Color(0x00000000)],
            borderRadius: const BorderRadius.all(Radius.circular(0.1)),
          ),
          BarChartRodData(
            y: -10,
            width: 10,
            colors: [const Color(0x11111111)],
            borderRadius: const BorderRadius.all(Radius.circular(0.2)),
          ),
        ]),
      ];

      BarTouchTooltipData tooltipData = BarTouchTooltipData(
          tooltipRoundedRadius: 8,
          tooltipBgColor: const Color(0xf33f33f3),
          maxContentWidth: 8000,
          rotateAngle: 12,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          direction: TooltipDirection.top,
          getTooltipItem: (
            group,
            groupIndex,
            rod,
            rodIndex,
          ) {
            return BarTooltipItem(
                'helllo1asdfasdfasdfasdfasdfasdfhelllo1asdfasdfasdfasd'
                'fasdfasdfhelllo1asdfasdfasdfasdfasdfasdfhelllo1asdf'
                'asdfasdfasdfasdfasdfhelllo1asdfasdfasdfasdfasdfasdfh'
                'elllo1asdfasdfasdfasdfasdfasdf',
                textStyle1,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                children: List.generate(
                  500,
                  (index) => const TextSpan(text: '\nhelllo3'),
                ));
          });
      final BarChartData data = BarChartData(
        groupsSpace: 10,
        barGroups: barGroups,
        barTouchData: BarTouchData(
          touchTooltipData: tooltipData,
        ),
      );

      final BarChartPainter barChartPainter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);

      final MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final MockBuildContext _mockBuildContext = MockBuildContext();

      final groupsX = barChartPainter.calculateGroupsX(
          viewSize, barGroups, BarChartAlignment.center, holder);
      final barGroupsPosition = barChartPainter.calculateGroupAndBarsPosition(
          viewSize, groupsX, barGroups);

      final angles = <double>[];
      when(_mockCanvasWrapper.drawRotated(
        size: anyNamed('size'),
        rotationOffset: anyNamed('rotationOffset'),
        drawOffset: anyNamed('drawOffset'),
        angle: anyNamed('angle'),
        drawCallback: anyNamed('drawCallback'),
      )).thenAnswer((inv) {
        final callback = inv.namedArguments[const Symbol('drawCallback')];
        callback();
        angles.add(inv.namedArguments[const Symbol('angle')] as double);
      });

      barChartPainter.drawTouchTooltip(
        _mockBuildContext,
        _mockCanvasWrapper,
        barGroupsPosition,
        tooltipData,
        barGroups[0],
        0,
        barGroups[0].barRods[1],
        1,
        holder,
      );
      final result1 =
          verify(_mockCanvasWrapper.drawRRect(captureAny, captureAny));
      result1.called(1);
      final rrect = result1.captured[0] as RRect;
      expect(rrect.blRadius, const Radius.circular(8.0));
      expect(rrect.width, 2636);
      expect(rrect.height, 7034.0);
      expect(rrect.left, -2436);
      expect(rrect.top, -6934.0);

      final bgTooltipPaint = result1.captured[1] as Paint;
      expect(bgTooltipPaint.color, const Color(0xf33f33f3));
      expect(bgTooltipPaint.style, PaintingStyle.fill);

      expect(angles.length, 1);
      expect(angles[0], 12);

      final result2 =
          verify(_mockCanvasWrapper.drawText(captureAny, captureAny));
      result2.called(1);

      final drawOffset = result2.captured[1] as Offset;
      expect(drawOffset, const Offset(-2420, -6926));
    });
  });

  group('drawStackItemBorderStroke()', () {
    test('test 1', () {
      const viewSize = Size(200, 100);

      final rodStackItems = [
        BarChartRodStackItem(
          0,
          3,
          const Color(0x11111110),
          const BorderSide(color: Color(0x11111111), width: 1.0),
        ),
        BarChartRodStackItem(
          3,
          8,
          const Color(0x22222220),
          const BorderSide(color: Color(0x22222221), width: 2.0),
        ),
        BarChartRodStackItem(
          8,
          10,
          const Color(0x33333330),
          const BorderSide(color: Color(0x33333331), width: 3.0),
        ),
      ];

      final barRod = BarChartRodData(
        y: 10,
        width: 10,
        colors: [const Color(0x00000000)],
        borderRadius: const BorderRadius.all(Radius.circular(0.1)),
        rodStackItems: rodStackItems,
      );

      final barGroups = [
        BarChartGroupData(x: 0, barRods: [barRod], barsSpace: 5),
      ];

      final BarChartData data = BarChartData(
          groupsSpace: 10, barGroups: barGroups, barTouchData: BarTouchData());

      final BarChartPainter barChartPainter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);

      final MockCanvasWrapper _mockCanvasWrapper = MockCanvasWrapper();
      when(_mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(_mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final List<Map<String, dynamic>> results = [];
      when(_mockCanvasWrapper.drawRRect(
        captureAny,
        captureAny,
      )).thenAnswer((inv) {
        final rrect = inv.positionalArguments[0] as RRect;
        final paint = inv.positionalArguments[1] as Paint;
        results.add({
          'rrect': rrect,
          'paint.color': paint.color,
          'paint.strokeWidth': paint.strokeWidth,
        });
      });

      barChartPainter.drawStackItemBorderStroke(
        _mockCanvasWrapper,
        rodStackItems[0],
        0,
        3,
        barRod.width,
        RRect.fromLTRBAndCorners(0, 0, 10, 100,
            bottomRight: const Radius.circular(12)),
        viewSize,
        holder,
      );

      barChartPainter.drawStackItemBorderStroke(
        _mockCanvasWrapper,
        rodStackItems[1],
        1,
        3,
        barRod.width,
        RRect.fromLTRBAndCorners(0, 0, 10, 100,
            bottomRight: const Radius.circular(12)),
        viewSize,
        holder,
      );

      barChartPainter.drawStackItemBorderStroke(
        _mockCanvasWrapper,
        rodStackItems[2],
        2,
        3,
        barRod.width,
        RRect.fromLTRBAndCorners(0, 0, 10, 100,
            bottomRight: const Radius.circular(12)),
        viewSize,
        holder,
      );

      expect(results.length, 3);

      expect(
        results[0]['rrect'],
        RRect.fromLTRBAndCorners(
          0.0,
          70.0,
          10.0,
          100.0,
          topLeft: const Radius.circular(0.0),
          topRight: const Radius.circular(0.0),
          bottomRight: const Radius.circular(12.0),
          bottomLeft: const Radius.circular(0.0),
        ),
      );
      expect(results[0]['paint.color'], const Color(0x11111111));
      expect(results[0]['paint.strokeWidth'], 1.0);

      expect(
        results[1]['rrect'],
        RRect.fromLTRBAndCorners(
          0.0,
          20.0,
          10.0,
          70.0,
        ),
      );
      expect(results[1]['paint.color'], const Color(0x22222221));
      expect(results[1]['paint.strokeWidth'], 2.0);

      expect(
        results[2]['rrect'],
        RRect.fromLTRBAndCorners(
          0.0,
          0.0,
          10.0,
          20.0,
        ),
      );
      expect(results[2]['paint.color'], const Color(0x33333331));
      expect(results[2]['paint.strokeWidth'], 3.0);
    });
  });

  group('getExtraNeededHorizontalSpace()', () {
    test('test 1', () {
      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(
          show: false,
        ),
      );

      final BarChartPainter painter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);
      final result = painter.getExtraNeededHorizontalSpace(holder);
      expect(result, 0);
    });

    test('test 2', () {
      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(showTitles: true, reservedSize: 10, margin: 0),
          rightTitles:
              SideTitles(showTitles: false, reservedSize: 10, margin: 0),
        ),
      );

      final BarChartPainter painter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);
      final result = painter.getExtraNeededHorizontalSpace(holder);
      expect(result, 10);
    });

    test('test 3', () {
      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(showTitles: true, reservedSize: 10, margin: 2),
          rightTitles:
              SideTitles(showTitles: true, reservedSize: 10, margin: 2),
        ),
      );
      final BarChartPainter painter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);
      final result = painter.getExtraNeededHorizontalSpace(holder);
      expect(result, 24);
    });
  });

  group('getExtraNeededVerticalSpace()', () {
    test('test 1', () {
      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(show: false),
      );

      final BarChartPainter painter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);
      final result = painter.getExtraNeededVerticalSpace(holder);
      expect(result, 0);
    });

    test('test 2', () {
      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(
          show: true,
          topTitles: SideTitles(showTitles: true, reservedSize: 10, margin: 0),
          bottomTitles:
              SideTitles(showTitles: false, reservedSize: 10, margin: 0),
        ),
      );

      final BarChartPainter painter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);
      final result = painter.getExtraNeededVerticalSpace(holder);
      expect(result, 10);
    });

    test('test 3', () {
      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(
          show: true,
          topTitles: SideTitles(showTitles: true, reservedSize: 10, margin: 2),
          bottomTitles:
              SideTitles(showTitles: true, reservedSize: 10, margin: 2),
        ),
      );

      final BarChartPainter painter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);
      final result = painter.getExtraNeededVerticalSpace(holder);
      expect(result, 24);
    });
  });

  group('getLeftOffsetDrawSize()', () {
    test('test 1', () {
      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(show: false),
      );

      final BarChartPainter painter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);
      final result = painter.getLeftOffsetDrawSize(holder);
      expect(result, 0);
    });

    test('test 2', () {
      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(showTitles: true, reservedSize: 10, margin: 0),
          rightTitles:
              SideTitles(showTitles: false, reservedSize: 10, margin: 0),
        ),
      );

      final BarChartPainter painter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);
      final result = painter.getLeftOffsetDrawSize(holder);
      expect(result, 10);
    });

    test('test 3', () {
      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(showTitles: true, reservedSize: 10, margin: 2),
          rightTitles:
              SideTitles(showTitles: true, reservedSize: 10, margin: 2),
        ),
      );

      final BarChartPainter painter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);
      final result = painter.getLeftOffsetDrawSize(holder);
      expect(result, 12);
    });
  });

  group('getTopOffsetDrawSize()', () {
    test('test 1', () {
      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(show: false),
      );

      final BarChartPainter painter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);
      final result = painter.getTopOffsetDrawSize(holder);
      expect(result, 0);
    });

    test('test 2', () {
      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(
          show: true,
          topTitles: SideTitles(showTitles: true, reservedSize: 10, margin: 0),
          bottomTitles:
              SideTitles(showTitles: false, reservedSize: 10, margin: 0),
        ),
      );

      final BarChartPainter painter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);
      final result = painter.getTopOffsetDrawSize(holder);
      expect(result, 10);
    });

    test('test 3', () {
      final BarChartData data = BarChartData(
        titlesData: FlTitlesData(
          show: true,
          topTitles: SideTitles(showTitles: true, reservedSize: 10, margin: 2),
          bottomTitles:
              SideTitles(showTitles: true, reservedSize: 10, margin: 2),
        ),
      );

      final BarChartPainter painter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);
      final result = painter.getTopOffsetDrawSize(holder);
      expect(result, 12);
    });
  });

  group('handleTouch()', () {
    test('test 1', () {
      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                y: 10,
                width: 10,
                colors: [const Color(0x00000000)],
                borderRadius: const BorderRadius.all(Radius.circular(0.1)),
              ),
              BarChartRodData(
                y: 8,
                width: 11,
                colors: [const Color(0x11111111)],
                borderRadius: const BorderRadius.all(Radius.circular(0.2)),
              ),
              BarChartRodData(
                y: 8,
                width: 12,
                colors: [const Color(0x22222222)],
                borderRadius: const BorderRadius.all(Radius.circular(0.3)),
              ),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                  y: 10,
                  width: 10,
                  borderRadius: const BorderRadius.all(Radius.circular(0.4))),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(y: 10, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
              BarChartRodData(y: 8, width: 10),
            ],
            barsSpace: 5),
      ];

      final BarChartData data = BarChartData(
        barGroups: barGroups,
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
        alignment: BarChartAlignment.center,
        groupsSpace: 10,
        barTouchData: BarTouchData(
          handleBuiltInTouches: true,
          touchExtraThreshold: const EdgeInsets.all(1),
        ),
      );

      final BarChartPainter painter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);

      expect(painter.handleTouch(const Offset(10, 10), viewSize, holder), null);
      expect(
          painter.handleTouch(const Offset(27.49, 10), viewSize, holder), null);

      // Group 0
      // 28.5, 0.0, 38.5, 100.0
      // 43.5, 20.0, 54.5, 100.0
      // 59.5, 20.0, 71.5, 100.0
      final result1 =
          painter.handleTouch(const Offset(27.5, 10), viewSize, holder);
      expect(result1!.touchedBarGroupIndex, 0);
      expect(result1.touchedRodDataIndex, 0);

      final result11 =
          painter.handleTouch(const Offset(39.5, 10), viewSize, holder);
      expect(result11!.touchedBarGroupIndex, 0);
      expect(result11.touchedRodDataIndex, 0);

      expect(
          painter.handleTouch(const Offset(39.51, 10), viewSize, holder), null);

      // Group 1
      // 81.5, 0.0, 91.5, 100.0
      // 96.5, 20.0, 106.5, 100.0
      expect(painter.handleTouch(const Offset(100.0, 18.99), viewSize, holder),
          null);
      final result2 =
          painter.handleTouch(const Offset(100.0, 19), viewSize, holder);
      expect(result2!.touchedBarGroupIndex, 1);
      expect(result2.touchedRodDataIndex, 1);

      // Group 2
      // 116.5, 0.0, 126.5, 100.0
      // 131.5, 20.0, 141.5, 100.0
      // 146.5, 20.0, 156.5, 100.0
      // 161.5, 20.0, 171.5, 100.0
      expect(painter.handleTouch(const Offset(165.0, 101.1), viewSize, holder),
          null);
      final result3 =
          painter.handleTouch(const Offset(165.0, 101), viewSize, holder);
      expect(result3!.touchedBarGroupIndex, 2);
      expect(result3.touchedRodDataIndex, 3);
    });

    test('test 2', () {
      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                  y: 10,
                  width: 10,
                  colors: [const Color(0x00000000)],
                  borderRadius: const BorderRadius.all(Radius.circular(0.1)),
                  rodStackItems: [
                    BarChartRodStackItem(0, 5, const Color(0xFF0F0F0F))
                  ]),
            ],
            barsSpace: 5),
        BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                  y: -10,
                  width: 10,
                  borderRadius: const BorderRadius.all(Radius.circular(0.4))),
            ],
            barsSpace: 5),
      ];

      final BarChartData data = BarChartData(
        barGroups: barGroups,
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
        alignment: BarChartAlignment.center,
        groupsSpace: 10,
        barTouchData: BarTouchData(
          handleBuiltInTouches: true,
          touchExtraThreshold: const EdgeInsets.all(1),
        ),
      );

      final BarChartPainter painter = BarChartPainter();
      final holder = PaintHolder<BarChartData>(data, data, 1.0);

      expect(painter.handleTouch(const Offset(134.0, 48.6), viewSize, holder),
          null);
      expect(painter.handleTouch(const Offset(111.2, 31.1), viewSize, holder),
          null);

      expect(painter.handleTouch(const Offset(103.2, 74.8), viewSize, holder),
          null);
      expect(painter.handleTouch(const Offset(91.3, 55.3), viewSize, holder),
          null);
      expect(painter.handleTouch(const Offset(100.4, 21.2), viewSize, holder),
          null);
      expect(painter.handleTouch(const Offset(80.1, 22.0), viewSize, holder),
          null);

      final result1 =
          painter.handleTouch(const Offset(110.1, 70.2), viewSize, holder);
      expect(result1!.touchedBarGroupIndex, 1);
      expect(result1.touchedRodDataIndex, 0);
      expect(result1.touchedStackItemIndex, -1);

      final result2 =
          painter.handleTouch(const Offset(89.0, 38.5), viewSize, holder);
      expect(result2!.touchedBarGroupIndex, 0);
      expect(result2.touchedRodDataIndex, 0);
      expect(result2.touchedStackItemIndex, 0);

      final result3 =
          painter.handleTouch(const Offset(88.8, 16.5), viewSize, holder);
      expect(result3!.touchedBarGroupIndex, 0);
      expect(result3.touchedRodDataIndex, 0);
      expect(result3.touchedStackItemIndex, -1);
    });
  });
}
