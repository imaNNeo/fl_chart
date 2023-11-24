import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/extensions/bar_chart_data_extension.dart';
import 'package:fl_chart/src/extensions/path_extension.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../helper_methods.dart';
import '../data_pool.dart';
import 'bar_chart_painter_test.mocks.dart';

@GenerateMocks([Canvas, CanvasWrapper, BuildContext, Utils])
void main() {
  const tolerance = 0.01;
  group('paint()', () {
    test('test 1', () {
      final utilsMainInstance = Utils();
      const viewSize = Size(400, 400);
      final data = BarChartData(
        barGroups: [
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(fromY: 1, toY: 10),
              BarChartRodData(fromY: 2, toY: 10),
            ],
            showingTooltipIndicators: [
              1,
              2,
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(fromY: 3, toY: 10),
              BarChartRodData(fromY: 4, toY: 10),
            ],
          ),
        ],
      );

      final barChartPainter = BarChartPainter();
      final holder =
          PaintHolder<BarChartData>(data, data, TextScaler.noScaling);

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
      barChartPainter.paint(
        mockBuildContext,
        mockCanvasWrapper,
        holder,
      );
      Utils.changeInstance(utilsMainInstance);
    });
  });

  group('calculateGroupsX()', () {
    test('test 1', () {
      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(toY: 10, width: 10),
            BarChartRodData(toY: 8, width: 10),
            BarChartRodData(toY: 8, width: 10),
          ],
          barsSpace: 5,
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(toY: 10, width: 10),
            BarChartRodData(toY: 8, width: 10),
          ],
          barsSpace: 5,
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(toY: 10, width: 10),
            BarChartRodData(toY: 8, width: 10),
            BarChartRodData(toY: 8, width: 10),
            BarChartRodData(toY: 8, width: 10),
          ],
          barsSpace: 5,
        ),
      ];

      final data = BarChartData(
        titlesData: const FlTitlesData(show: false),
        groupsSpace: 10,
        barGroups: barGroups,
      );

      List<double> callWithAlignment(BarChartAlignment alignment) {
        return data
            .copyWith(alignment: alignment)
            .calculateGroupsX(viewSize.width);
      }

      expect(callWithAlignment(BarChartAlignment.center), [50, 92.5, 142.5]);
      expect(callWithAlignment(BarChartAlignment.start), [20, 62.5, 112.5]);
      expect(callWithAlignment(BarChartAlignment.end), [80.0, 122.5, 172.5]);
      expect(
        callWithAlignment(BarChartAlignment.spaceEvenly),
        [40, 92.5, 152.5],
      );
      expect(
        callWithAlignment(BarChartAlignment.spaceAround),
        [
          closeTo(33.33, tolerance),
          92.5,
          closeTo(159.16, tolerance),
        ],
      );
      expect(
        callWithAlignment(BarChartAlignment.spaceBetween),
        [20, 92.5, 172.5],
      );
    });
  });

  group('calculateGroupAndBarsPosition()', () {
    test('test 1', () {
      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(toY: 10, width: 10),
            BarChartRodData(toY: 8, width: 10),
            BarChartRodData(toY: 8, width: 10),
          ],
          barsSpace: 5,
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(toY: 10, width: 10),
            BarChartRodData(toY: 8, width: 10),
          ],
          barsSpace: 5,
        ),
      ];

      final data = BarChartData(
        titlesData: const FlTitlesData(show: false),
        groupsSpace: 10,
        alignment: BarChartAlignment.center,
        barGroups: barGroups,
      );

      final barChartPainter = BarChartPainter();

      final groupsX = data.calculateGroupsX(viewSize.width);
      late Exception exception;
      try {
        barChartPainter.calculateGroupAndBarsPosition(
          viewSize,
          groupsX + [groupsX.last],
          barGroups,
        );
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
            BarChartRodData(toY: 10, width: 10),
            BarChartRodData(toY: 8, width: 10),
            BarChartRodData(toY: 8, width: 10),
          ],
          barsSpace: 5,
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(toY: 10, width: 10),
            BarChartRodData(toY: 8, width: 10),
          ],
          barsSpace: 5,
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(toY: 10, width: 10),
            BarChartRodData(toY: 8, width: 10),
            BarChartRodData(toY: 8, width: 10),
            BarChartRodData(toY: 8, width: 10),
          ],
          barsSpace: 5,
        ),
      ];

      final data = BarChartData(
        titlesData: const FlTitlesData(show: false),
        groupsSpace: 10,
        barGroups: barGroups,
      );

      final barChartPainter = BarChartPainter();

      List<GroupBarsPosition> callWithAlignment(BarChartAlignment alignment) {
        final groupsX = data
            .copyWith(alignment: alignment)
            .calculateGroupsX(viewSize.width);
        return barChartPainter.calculateGroupAndBarsPosition(
          viewSize,
          groupsX,
          barGroups,
        );
      }

      final centerResult = callWithAlignment(BarChartAlignment.center);
      expect(centerResult.map((e) => e.groupX).toList(), [50, 92.5, 142.5]);
      expect(centerResult[0].barsX, [35, 50, 65]);
      expect(centerResult[1].barsX, [85, 100]);
      expect(centerResult[2].barsX, [120, 135, 150, 165]);

      final startResult = callWithAlignment(BarChartAlignment.start);
      expect(startResult.map((e) => e.groupX).toList(), [20.0, 62.5, 112.5]);
      expect(startResult[0].barsX, [5, 20, 35]);
      expect(startResult[1].barsX, [55, 70]);
      expect(startResult[2].barsX, [90, 105, 120, 135]);
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
              toY: 10,
              width: 10,
              color: const Color(0x00000000),
              borderRadius: const BorderRadius.all(Radius.circular(0.1)),
            ),
            BarChartRodData(
              toY: 8,
              width: 11,
              color: const Color(0x11111111),
              borderRadius: const BorderRadius.all(Radius.circular(0.2)),
            ),
            BarChartRodData(
              toY: 8,
              width: 12,
              color: const Color(0x22222222),
              borderRadius: const BorderRadius.all(Radius.circular(0.3)),
            ),
          ],
          barsSpace: 5,
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: 10,
              width: 10,
              borderRadius: const BorderRadius.all(Radius.circular(0.4)),
            ),
            BarChartRodData(toY: 8, width: 10),
          ],
          barsSpace: 5,
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: 10,
              width: 10,
              backDrawRodData: BackgroundBarChartRodData(
                toY: 8,
                show: true,
              ),
            ),
            BarChartRodData(
              toY: 8,
              width: 10,
              backDrawRodData: BackgroundBarChartRodData(
                show: false,
              ),
            ),
            BarChartRodData(
              toY: 8,
              width: 10,
              backDrawRodData: BackgroundBarChartRodData(
                toY: -3,
                show: true,
              ),
            ),
            BarChartRodData(
              toY: 8,
              width: 10,
              backDrawRodData: BackgroundBarChartRodData(
                toY: 0,
              ),
            ),
          ],
          barsSpace: 5,
        ),
      ];

      final data = BarChartData(
        titlesData: const FlTitlesData(show: false),
        groupsSpace: 10,
        barGroups: barGroups,
        alignment: BarChartAlignment.center,
      );

      final barChartPainter = BarChartPainter();
      final holder =
          PaintHolder<BarChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final groupsX = data.calculateGroupsX(viewSize.width);
      final barGroupsPosition = barChartPainter.calculateGroupAndBarsPosition(
        viewSize,
        groupsX,
        barGroups,
      );

      final results = <Map<String, dynamic>>[];
      when(mockCanvasWrapper.drawRRect(captureAny, captureAny))
          .thenAnswer((inv) {
        final rRect = inv.positionalArguments[0] as RRect;
        final paint = inv.positionalArguments[1] as Paint;
        results.add({
          'rRect': RRect.fromLTRBAndCorners(
            rRect.left,
            rRect.top,
            rRect.right,
            rRect.bottom,
            topLeft: rRect.tlRadius,
            topRight: rRect.trRadius,
            bottomRight: rRect.brRadius,
            bottomLeft: rRect.blRadius,
          ),
          'paint_color': paint.color,
        });
      });

      barChartPainter.drawBars(mockCanvasWrapper, barGroupsPosition, holder);
      expect(results.length, 11);

      expect(
        HelperMethods.equalsRRects(
          results[0]['rRect'] as RRect,
          RRect.fromLTRBR(
            28.5,
            0,
            38.5,
            76.923,
            const Radius.circular(0.1),
          ),
        ),
        true,
      );
      expect(results[0]['paint_color'] as Color, const Color(0x00000000));

      expect(
        HelperMethods.equalsRRects(
          results[1]['rRect'] as RRect,
          RRect.fromLTRBR(
            43.5,
            15.384,
            54.5,
            76.923,
            const Radius.circular(0.2),
          ),
        ),
        true,
      );
      expect(results[1]['paint_color'] as Color, const Color(0x11111111));

      expect(
        HelperMethods.equalsRRects(
          results[2]['rRect'] as RRect,
          RRect.fromLTRBR(
            59.5,
            15.384,
            71.5,
            76.923,
            const Radius.circular(0.3),
          ),
        ),
        true,
      );
      expect(results[2]['paint_color'] as Color, const Color(0x22222222));

      expect(
        HelperMethods.equalsRRects(
          results[3]['rRect'] as RRect,
          RRect.fromLTRBR(
            81.5,
            0,
            91.5,
            76.923,
            const Radius.circular(0.4),
          ),
        ),
        true,
      );
      expect(
        HelperMethods.equalsRRects(
          results[4]['rRect'] as RRect,
          RRect.fromLTRBR(
            96.5,
            15.384,
            106.5,
            76.923,
            const Radius.circular(5),
          ),
        ),
        true,
      );

      expect(
        HelperMethods.equalsRRects(
          results[5]['rRect'] as RRect,
          RRect.fromLTRBR(
            116.5,
            15.384,
            126.5,
            76.923,
            const Radius.circular(5),
          ),
        ),
        true,
      );

      expect(
        HelperMethods.equalsRRects(
          results[6]['rRect'] as RRect,
          RRect.fromLTRBR(
            116.5,
            0,
            126.5,
            76.923,
            const Radius.circular(5),
          ),
        ),
        true,
      );
      expect(
        HelperMethods.equalsRRects(
          results[7]['rRect'] as RRect,
          RRect.fromLTRBR(
            131.5,
            15.384,
            141.5,
            76.923,
            const Radius.circular(5),
          ),
        ),
        true,
      );

      expect(
        HelperMethods.equalsRRects(
          results[8]['rRect'] as RRect,
          RRect.fromLTRBR(
            146.5,
            76.923,
            156.5,
            100,
            const Radius.circular(5),
          ),
        ),
        true,
      );

      expect(
        HelperMethods.equalsRRects(
          results[9]['rRect'] as RRect,
          RRect.fromLTRBR(
            146.5,
            15.384,
            156.5,
            76.923,
            const Radius.circular(5),
          ),
        ),
        true,
      );
      expect(
        HelperMethods.equalsRRects(
          results[10]['rRect'] as RRect,
          RRect.fromLTRBR(
            161.5,
            15.384,
            171.5,
            76.923,
            const Radius.circular(5),
          ),
        ),
        true,
      );
    });
    test('test 2', () {
      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
          x: 0,
          groupVertically: true,
          barRods: [
            BarChartRodData(
              fromY: -9,
              toY: -10,
              width: 10,
              color: const Color(0x00000000),
              borderRadius: const BorderRadius.all(Radius.circular(0.1)),
            ),
            BarChartRodData(
              fromY: -11,
              toY: -20,
              width: 11,
              color: const Color(0x11111111),
              borderRadius: const BorderRadius.all(Radius.circular(0.2)),
            ),
            BarChartRodData(
              fromY: -21,
              toY: -30,
              width: 12,
              color: const Color(0x22222222),
              borderRadius: const BorderRadius.all(Radius.circular(0.3)),
            ),
          ],
          barsSpace: 5,
        ),
        BarChartGroupData(
          x: 1,
          groupVertically: true,
          barRods: [
            BarChartRodData(
              fromY: 9,
              toY: 10,
              width: 10,
              color: const Color(0x00000000),
              borderRadius: const BorderRadius.all(Radius.circular(0.1)),
            ),
            BarChartRodData(
              fromY: 11,
              toY: 20,
              width: 11,
              color: const Color(0x11111111),
              borderRadius: const BorderRadius.all(Radius.circular(0.2)),
            ),
            BarChartRodData(
              fromY: 21,
              toY: 30,
              width: 12,
              color: const Color(0x22222222),
              borderRadius: const BorderRadius.all(Radius.circular(0.3)),
            ),
          ],
          barsSpace: 5,
        ),
      ];

      final data = BarChartData(
        titlesData: const FlTitlesData(show: false),
        groupsSpace: 10,
        barGroups: barGroups,
        alignment: BarChartAlignment.center,
      );

      final barChartPainter = BarChartPainter();
      final holder =
          PaintHolder<BarChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final groupsX = data.calculateGroupsX(viewSize.width);
      final barGroupsPosition = barChartPainter.calculateGroupAndBarsPosition(
        viewSize,
        groupsX,
        barGroups,
      );

      final results = <Map<String, dynamic>>[];
      when(mockCanvasWrapper.drawRRect(captureAny, captureAny))
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

      barChartPainter.drawBars(mockCanvasWrapper, barGroupsPosition, holder);
      expect(results.length, 6);

      expect(
        HelperMethods.equalsRRects(
          results[0]['rrect'] as RRect,
          RRect.fromLTRBR(
            84,
            65,
            94,
            66.666,
            const Radius.circular(0.1),
          ),
        ),
        true,
      );
      expect(results[0]['paint_color'] as Color, const Color(0x00000000));

      expect(
        HelperMethods.equalsRRects(
          results[1]['rrect'] as RRect,
          RRect.fromLTRBR(
            83.5,
            68.333,
            94.5,
            83.333,
            const Radius.circular(0.2),
          ),
        ),
        true,
      );
      expect(results[1]['paint_color'] as Color, const Color(0x11111111));

      expect(
        HelperMethods.equalsRRects(
          results[2]['rrect'] as RRect,
          RRect.fromLTRBR(
            83,
            85,
            95,
            100,
            const Radius.circular(0.3),
          ),
        ),
        true,
      );
      expect(results[2]['paint_color'] as Color, const Color(0x22222222));

      expect(
        HelperMethods.equalsRRects(
          results[3]['rrect'] as RRect,
          RRect.fromLTRBR(
            106,
            33.333,
            116,
            35,
            const Radius.circular(0.1),
          ),
        ),
        true,
      );
      expect(
        HelperMethods.equalsRRects(
          results[4]['rrect'] as RRect,
          RRect.fromLTRBR(
            105.5,
            16.666,
            116.5,
            31.666,
            const Radius.circular(0.2),
          ),
        ),
        true,
      );

      expect(
        HelperMethods.equalsRRects(
          results[5]['rrect'] as RRect,
          RRect.fromLTRBR(
            105,
            0,
            117,
            15,
            const Radius.circular(0.3),
          ),
        ),
        true,
      );
    });

    test('test 3', () {
      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              fromY: -10,
              toY: 10,
              color: const Color(0x00000000),
              rodStackItems: [
                BarChartRodStackItem(-5, -10, const Color(0x11111111)),
                BarChartRodStackItem(0, -5, const Color(0x22222222)),
                BarChartRodStackItem(0, 5, const Color(0x33333333)),
                BarChartRodStackItem(5, 10, const Color(0x44444444)),
              ],
            ),
          ],
        ),
      ];

      final data = BarChartData(barGroups: barGroups);

      final barChartPainter = BarChartPainter();
      final holder =
          PaintHolder<BarChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final groupsX = data.calculateGroupsX(viewSize.width);
      final barGroupsPosition = barChartPainter.calculateGroupAndBarsPosition(
        viewSize,
        groupsX,
        barGroups,
      );

      final results = <Map<String, dynamic>>[];
      when(mockCanvasWrapper.drawRRect(captureAny, captureAny))
          .thenAnswer((inv) {
        final paint = inv.positionalArguments[1] as Paint;
        results.add({
          'paint_color': paint.color,
        });
      });

      barChartPainter.drawBars(mockCanvasWrapper, barGroupsPosition, holder);
      expect(results.length, 5);
      expect(results[1]['paint_color'], const Color(0x11111111));
      expect(results[2]['paint_color'], const Color(0x22222222));
      expect(results[3]['paint_color'], const Color(0x33333333));
      expect(results[4]['paint_color'], const Color(0x44444444));
    });

    test('test 4', () {
      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              fromY: 0,
              toY: 5,
              borderRadius: BorderRadius.zero,
              color: Colors.white,
            ),
          ],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              fromY: 0,
              toY: 10,
              borderRadius: BorderRadius.zero,
              color: Colors.white,
            ),
          ],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              fromY: 0,
              toY: 15,
              borderDashArray: [4, 4],
              borderSide: const BorderSide(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.zero,
              color: Colors.transparent,
            ),
          ],
        ),
      ];

      final data = BarChartData(barGroups: barGroups);

      final barChartPainter = BarChartPainter();
      final holder =
          PaintHolder<BarChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final groupsX = data.calculateGroupsX(viewSize.width);
      final barGroupsPosition = barChartPainter.calculateGroupAndBarsPosition(
        viewSize,
        groupsX,
        barGroups,
      );

      final rodDataResults = <Map<String, dynamic>>[];
      final borderResult = <Map<String, dynamic>>[];

      when(mockCanvasWrapper.drawRRect(captureAny, captureAny))
          .thenAnswer((inv) {
        final rrect = inv.positionalArguments[0] as RRect;
        final paint = inv.positionalArguments[1] as Paint;
        rodDataResults.add({
          'rrect': rrect,
          'paint_color': paint.color,
        });
      });

      when(mockCanvasWrapper.drawPath(captureAny, captureAny))
          .thenAnswer((inv) {
        final path = inv.positionalArguments[0] as Path;
        final paint = inv.positionalArguments[1] as Paint;
        borderResult.add({
          'path': path,
          'paint_color': paint.color,
        });
      });

      barChartPainter.drawBars(mockCanvasWrapper, barGroupsPosition, holder);
      expect(rodDataResults.length, 3);
      expect(rodDataResults[0]['paint_color'], Colors.white);
      expect(rodDataResults[1]['paint_color'], Colors.white);
      expect(rodDataResults[2]['paint_color'], Colors.transparent);

      expect(borderResult.length, 1);
      expect(borderResult[0]['paint_color'], Colors.white);
      final rrect = rodDataResults[2]['rrect'] as RRect;
      final path = Path()..addRRect(rrect);
      final expectedPath = path.toDashedPath([4, 4]);
      final currentPath = borderResult[0]['path'] as Path;

      expect(HelperMethods.equalsPaths(expectedPath, currentPath), true);
    });

    test('test 5', () {
      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              fromY: 0,
              toY: 5,
              borderRadius: BorderRadius.zero,
              color: Colors.white,
            ),
          ],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              fromY: 0,
              toY: 10,
              borderRadius: BorderRadius.zero,
              color: Colors.white,
            ),
          ],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              fromY: 0,
              toY: 15,
              borderSide: const BorderSide(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.zero,
              color: Colors.transparent,
            ),
          ],
        ),
      ];

      final data = BarChartData(barGroups: barGroups);

      final barChartPainter = BarChartPainter();
      final holder =
          PaintHolder<BarChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final groupsX = data.calculateGroupsX(viewSize.width);
      final barGroupsPosition = barChartPainter.calculateGroupAndBarsPosition(
        viewSize,
        groupsX,
        barGroups,
      );

      final rodDataResults = <Map<String, dynamic>>[];
      final borderResult = <Map<String, dynamic>>[];

      when(mockCanvasWrapper.drawRRect(captureAny, captureAny))
          .thenAnswer((inv) {
        final rrect = inv.positionalArguments[0] as RRect;
        final paint = inv.positionalArguments[1] as Paint;
        rodDataResults.add({
          'rrect': rrect,
          'paint_color': paint.color,
        });
      });

      when(mockCanvasWrapper.drawPath(captureAny, captureAny))
          .thenAnswer((inv) {
        final path = inv.positionalArguments[0] as Path;
        final paint = inv.positionalArguments[1] as Paint;
        borderResult.add({
          'path': path,
          'paint_color': paint.color,
        });
      });

      barChartPainter.drawBars(mockCanvasWrapper, barGroupsPosition, holder);
      expect(rodDataResults.length, 3);
      expect(rodDataResults[0]['paint_color'], Colors.white);
      expect(rodDataResults[1]['paint_color'], Colors.white);
      expect(rodDataResults[2]['paint_color'], Colors.transparent);

      expect(borderResult.length, 1);
      expect(borderResult[0]['paint_color'], Colors.white);
      final rrect = rodDataResults[2]['rrect'] as RRect;
      final path = Path()..addRRect(rrect);
      final expectedPath = path.toDashedPath(null);
      final currentPath = borderResult[0]['path'] as Path;

      expect(HelperMethods.equalsPaths(expectedPath, currentPath), true);
    });
  });

  group('drawTouchTooltip()', () {
    test('test 1', () {
      final mockUtils = MockUtils();
      when(mockUtils.getThemeAwareTextStyle(any, any)).thenReturn(textStyle1);
      when(mockUtils.getEfficientInterval(any, any)).thenReturn(11);
      when(mockUtils.normalizeBorderRadius(any, any))
          .thenReturn(BorderRadius.zero);
      when(mockUtils.normalizeBorderSide(any, any)).thenReturn(BorderSide.none);
      when(mockUtils.calculateRotationOffset(any, any)).thenReturn(Offset.zero);
      when(mockUtils.getBestInitialIntervalValue(any, any, any)).thenReturn(0);
      when(mockUtils.formatNumber(any, any, captureAny)).thenAnswer((inv) {
        final value = inv.positionalArguments[0] as double;
        return '${value.toInt()}';
      });
      Utils.changeInstance(mockUtils);

      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: 10,
              width: 10,
              color: const Color(0x00000000),
              borderRadius: const BorderRadius.all(Radius.circular(0.1)),
            ),
            BarChartRodData(
              toY: 8,
              width: 11,
              color: const Color(0x11111111),
              borderRadius: const BorderRadius.all(Radius.circular(0.2)),
            ),
            BarChartRodData(
              toY: 8,
              width: 12,
              color: const Color(0x22222222),
              borderRadius: const BorderRadius.all(Radius.circular(0.3)),
            ),
          ],
          barsSpace: 5,
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: 10,
              width: 10,
              borderRadius: const BorderRadius.all(Radius.circular(0.4)),
            ),
            BarChartRodData(toY: 8, width: 10),
          ],
          barsSpace: 5,
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(toY: 10, width: 10),
            BarChartRodData(toY: 8, width: 10),
            BarChartRodData(toY: 8, width: 10),
            BarChartRodData(toY: 8, width: 10),
          ],
          barsSpace: 5,
        ),
      ];

      final tooltipData = BarTouchTooltipData(
        tooltipRoundedRadius: 8,
        tooltipBgColor: const Color(0xf33f33f3),
        maxContentWidth: 80,
        rotateAngle: 12,
        tooltipBorder: const BorderSide(color: Color(0xf33f33f3), width: 2),
        getTooltipItem: (
          group,
          groupIndex,
          rod,
          rodIndex,
        ) {
          return BarTooltipItem(
            'helllo1',
            textStyle1,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            children: [
              const TextSpan(text: 'helllo2'),
              const TextSpan(text: 'helllo3'),
            ],
          );
        },
      );

      final data = BarChartData(
        groupsSpace: 10,
        barGroups: barGroups,
        barTouchData: BarTouchData(
          touchTooltipData: tooltipData,
        ),
        alignment: BarChartAlignment.center,
      );

      final barChartPainter = BarChartPainter();
      final holder =
          PaintHolder<BarChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final mockBuildContext = MockBuildContext();

      final groupsX = data.calculateGroupsX(viewSize.width);
      final barGroupsPosition = barChartPainter.calculateGroupAndBarsPosition(
        viewSize,
        groupsX,
        barGroups,
      );

      final angles = <double>[];
      when(
        mockCanvasWrapper.drawRotated(
          size: anyNamed('size'),
          rotationOffset: anyNamed('rotationOffset'),
          drawOffset: anyNamed('drawOffset'),
          angle: anyNamed('angle'),
          drawCallback: anyNamed('drawCallback'),
        ),
      ).thenAnswer((inv) {
        final callback =
            inv.namedArguments[const Symbol('drawCallback')] as DrawCallback;
        callback();
        angles.add(inv.namedArguments[const Symbol('angle')] as double);
      });

      barChartPainter.drawTouchTooltip(
        mockBuildContext,
        mockCanvasWrapper,
        barGroupsPosition,
        tooltipData,
        barGroups[0],
        0,
        barGroups[0].barRods[0],
        0,
        holder,
      );
      final result1 =
          verify(mockCanvasWrapper.drawRRect(captureAny, captureAny))
            ..called(2);
      final rrect = result1.captured[0] as RRect;
      expect(rrect.blRadius, const Radius.circular(8));
      expect(rrect.width, 112);
      expect(rrect.height, 90);
      expect(rrect.left, -22.5);
      expect(rrect.top, -106);

      final bgTooltipPaint = result1.captured[1] as Paint;
      expect(bgTooltipPaint.color, const Color(0xf33f33f3));
      expect(bgTooltipPaint.style, PaintingStyle.fill);

      final rRectBorder = result1.captured[2] as RRect;
      final paintBorder = result1.captured[3] as Paint;

      expect(rRectBorder.blRadius, const Radius.circular(8));
      expect(rRectBorder.width, 112);
      expect(rRectBorder.height, 90);
      expect(rRectBorder.left, -22.5);
      expect(rRectBorder.top, -106);
      expect(paintBorder.color, const Color(0xf33f33f3));
      expect(paintBorder.strokeWidth, 2);
      expect(paintBorder.style, PaintingStyle.stroke);

      expect(angles.length, 1);
      expect(angles[0], 12);

      final result2 = verify(mockCanvasWrapper.drawText(captureAny, captureAny))
        ..called(1);
      final textPainter = result2.captured[0] as TextPainter;
      expect((textPainter.text as TextSpan?)!.text, 'helllo1');
      expect((textPainter.text as TextSpan?)!.style, textStyle1);
      expect(textPainter.textAlign, TextAlign.right);
      expect(textPainter.textDirection, TextDirection.rtl);
      expect(
        (textPainter.text as TextSpan?)!.children![0],
        const TextSpan(text: 'helllo2'),
      );
      expect(
        (textPainter.text as TextSpan?)!.children![1],
        const TextSpan(text: 'helllo3'),
      );

      final drawOffset = result2.captured[1] as Offset;
      expect(drawOffset, const Offset(-6.5, -98));
    });

    test('test 2', () {
      final mockUtils = MockUtils();
      when(mockUtils.getThemeAwareTextStyle(any, any)).thenReturn(textStyle1);
      when(mockUtils.getEfficientInterval(any, any)).thenReturn(11);
      when(mockUtils.normalizeBorderRadius(any, any))
          .thenReturn(BorderRadius.zero);
      when(mockUtils.normalizeBorderSide(any, any)).thenReturn(BorderSide.none);
      when(mockUtils.calculateRotationOffset(any, any)).thenReturn(Offset.zero);
      when(mockUtils.getBestInitialIntervalValue(any, any, any)).thenReturn(0);
      when(mockUtils.formatNumber(any, any, captureAny)).thenAnswer((inv) {
        final value = inv.positionalArguments[0] as double;
        return '${value.toInt()}';
      });
      Utils.changeInstance(mockUtils);

      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: 10,
              width: 10,
              color: const Color(0x00000000),
              borderRadius: const BorderRadius.all(Radius.circular(0.1)),
            ),
            BarChartRodData(
              toY: 8,
              width: 11,
              color: const Color(0x11111111),
              borderRadius: const BorderRadius.all(Radius.circular(0.2)),
            ),
            BarChartRodData(
              toY: 8,
              width: 12,
              color: const Color(0x22222222),
              borderRadius: const BorderRadius.all(Radius.circular(0.3)),
            ),
          ],
          barsSpace: 5,
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: 10,
              width: 10,
              borderRadius: const BorderRadius.all(Radius.circular(0.4)),
            ),
            BarChartRodData(toY: 8, width: 10),
          ],
          barsSpace: 5,
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(toY: 10, width: 10),
            BarChartRodData(toY: 8, width: 10),
            BarChartRodData(toY: 8, width: 10),
            BarChartRodData(toY: 8, width: 10),
          ],
          barsSpace: 5,
        ),
      ];

      final tooltipData = BarTouchTooltipData(
        tooltipRoundedRadius: 8,
        tooltipBgColor: const Color(0xf33f33f3),
        maxContentWidth: 80,
        rotateAngle: 12,
        direction: TooltipDirection.bottom,
        tooltipBorder: const BorderSide(color: Color(0xf33f33f3), width: 2),
        tooltipHorizontalAlignment: FLHorizontalAlignment.left,
        tooltipHorizontalOffset: -1.5,
        getTooltipItem: (
          group,
          groupIndex,
          rod,
          rodIndex,
        ) {
          return BarTooltipItem(
            'helllo1',
            textStyle1,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            children: [
              const TextSpan(text: 'helllo2'),
              const TextSpan(text: 'helllo3'),
            ],
          );
        },
      );

      final data = BarChartData(
        groupsSpace: 10,
        barGroups: barGroups,
        barTouchData: BarTouchData(
          touchTooltipData: tooltipData,
        ),
        alignment: BarChartAlignment.center,
      );

      final barChartPainter = BarChartPainter();
      final holder =
          PaintHolder<BarChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final mockBuildContext = MockBuildContext();

      final groupsX = data.calculateGroupsX(viewSize.width);
      final barGroupsPosition = barChartPainter.calculateGroupAndBarsPosition(
        viewSize,
        groupsX,
        barGroups,
      );

      final angles = <double>[];
      when(
        mockCanvasWrapper.drawRotated(
          size: anyNamed('size'),
          rotationOffset: anyNamed('rotationOffset'),
          drawOffset: anyNamed('drawOffset'),
          angle: anyNamed('angle'),
          drawCallback: anyNamed('drawCallback'),
        ),
      ).thenAnswer((inv) {
        final callback =
            inv.namedArguments[const Symbol('drawCallback')] as DrawCallback;
        callback();
        angles.add(inv.namedArguments[const Symbol('angle')] as double);
      });

      barChartPainter.drawTouchTooltip(
        mockBuildContext,
        mockCanvasWrapper,
        barGroupsPosition,
        tooltipData,
        barGroups[0],
        0,
        barGroups[0].barRods[0],
        0,
        holder,
      );
      final result1 =
          verify(mockCanvasWrapper.drawRRect(captureAny, captureAny))
            ..called(2);
      final rrect = result1.captured[0] as RRect;
      expect(rrect.blRadius, const Radius.circular(8));
      expect(rrect.width, 112);
      expect(rrect.height, 90);
      expect(rrect.left, -80);
      expect(rrect.top, 116);

      final bgTooltipPaint = result1.captured[1] as Paint;
      expect(bgTooltipPaint.color, const Color(0xf33f33f3));
      expect(bgTooltipPaint.style, PaintingStyle.fill);

      final rRectBorder = result1.captured[2] as RRect;
      final paintBorder = result1.captured[3] as Paint;

      expect(rRectBorder.blRadius, const Radius.circular(8));
      expect(rRectBorder.width, 112);
      expect(rRectBorder.height, 90);
      expect(rRectBorder.left, -80);
      expect(rRectBorder.top, 116);
      expect(paintBorder.color, const Color(0xf33f33f3));
      expect(paintBorder.strokeWidth, 2);
      expect(paintBorder.style, PaintingStyle.stroke);

      expect(angles.length, 1);
      expect(angles[0], 12);

      final result2 = verify(mockCanvasWrapper.drawText(captureAny, captureAny))
        ..called(1);
      final textPainter = result2.captured[0] as TextPainter;
      expect((textPainter.text as TextSpan?)!.text, 'helllo1');
      expect((textPainter.text as TextSpan?)!.style, textStyle1);
      expect(textPainter.textAlign, TextAlign.right);
      expect(textPainter.textDirection, TextDirection.rtl);
      expect(
        (textPainter.text as TextSpan?)!.children![0],
        const TextSpan(text: 'helllo2'),
      );
      expect(
        (textPainter.text as TextSpan?)!.children![1],
        const TextSpan(text: 'helllo3'),
      );

      final drawOffset = result2.captured[1] as Offset;
      expect(drawOffset, const Offset(-64, 124));
    });

    test('test 3', () {
      final mockUtils = MockUtils();
      when(mockUtils.getThemeAwareTextStyle(any, any)).thenReturn(textStyle1);
      when(mockUtils.getEfficientInterval(any, any)).thenReturn(11);
      when(mockUtils.normalizeBorderRadius(any, any))
          .thenReturn(BorderRadius.zero);
      when(mockUtils.normalizeBorderSide(any, any)).thenReturn(BorderSide.none);
      when(mockUtils.calculateRotationOffset(any, any)).thenReturn(Offset.zero);
      when(mockUtils.getBestInitialIntervalValue(any, any, any)).thenReturn(0);
      when(mockUtils.formatNumber(any, any, captureAny)).thenAnswer((inv) {
        final value = inv.positionalArguments[0] as double;
        return '${value.toInt()}';
      });
      Utils.changeInstance(mockUtils);

      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: 10,
              width: 10,
              color: const Color(0x00000000),
              borderRadius: const BorderRadius.all(Radius.circular(0.1)),
            ),
            BarChartRodData(
              toY: -10,
              width: 10,
              color: const Color(0x11111111),
              borderRadius: const BorderRadius.all(Radius.circular(0.2)),
            ),
          ],
        ),
      ];

      final tooltipData = BarTouchTooltipData(
        tooltipRoundedRadius: 8,
        tooltipBgColor: const Color(0xf33f33f3),
        maxContentWidth: 8000,
        rotateAngle: 12,
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        direction: TooltipDirection.top,
        tooltipHorizontalAlignment: FLHorizontalAlignment.right,
        tooltipBorder: const BorderSide(color: Color(0xf33f33f3), width: 2),
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
            ),
          );
        },
      );
      final data = BarChartData(
        groupsSpace: 10,
        barGroups: barGroups,
        barTouchData: BarTouchData(
          touchTooltipData: tooltipData,
        ),
        alignment: BarChartAlignment.center,
      );

      final barChartPainter = BarChartPainter();
      final holder =
          PaintHolder<BarChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final mockBuildContext = MockBuildContext();

      final groupsX = data.calculateGroupsX(viewSize.width);
      final barGroupsPosition = barChartPainter.calculateGroupAndBarsPosition(
        viewSize,
        groupsX,
        barGroups,
      );

      final angles = <double>[];
      when(
        mockCanvasWrapper.drawRotated(
          size: anyNamed('size'),
          rotationOffset: anyNamed('rotationOffset'),
          drawOffset: anyNamed('drawOffset'),
          angle: anyNamed('angle'),
          drawCallback: anyNamed('drawCallback'),
        ),
      ).thenAnswer((inv) {
        final callback =
            inv.namedArguments[const Symbol('drawCallback')] as DrawCallback;
        callback();
        angles.add(inv.namedArguments[const Symbol('angle')] as double);
      });

      barChartPainter.drawTouchTooltip(
        mockBuildContext,
        mockCanvasWrapper,
        barGroupsPosition,
        tooltipData,
        barGroups[0],
        0,
        barGroups[0].barRods[1],
        1,
        holder,
      );
      final result1 =
          verify(mockCanvasWrapper.drawRRect(captureAny, captureAny))
            ..called(2);
      final rrect = result1.captured[0] as RRect;
      expect(rrect.blRadius, const Radius.circular(8));
      expect(rrect.width, 2636);
      expect(rrect.height, 7034.0);
      expect(rrect.left, -2436);
      expect(rrect.top, -6934.0);

      final bgTooltipPaint = result1.captured[1] as Paint;
      expect(bgTooltipPaint.color, const Color(0xf33f33f3));
      expect(bgTooltipPaint.style, PaintingStyle.fill);

      final rRectBorder = result1.captured[2] as RRect;
      final paintBorder = result1.captured[3] as Paint;

      expect(rRectBorder.blRadius, const Radius.circular(8));
      expect(rRectBorder.width, 2636);
      expect(rRectBorder.height, 7034.0);
      expect(rRectBorder.left, -2436);
      expect(rRectBorder.top, -6934.0);
      expect(paintBorder.color, const Color(0xf33f33f3));
      expect(paintBorder.strokeWidth, 2);
      expect(paintBorder.style, PaintingStyle.stroke);

      expect(angles.length, 1);
      expect(angles[0], 12);

      final result2 = verify(mockCanvasWrapper.drawText(captureAny, captureAny))
        ..called(1);

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
          const BorderSide(color: Color(0x11111111)),
        ),
        BarChartRodStackItem(
          3,
          8,
          const Color(0x22222220),
          const BorderSide(color: Color(0x22222221), width: 2),
        ),
        BarChartRodStackItem(
          8,
          10,
          const Color(0x33333330),
          const BorderSide(color: Color(0x33333331), width: 3),
        ),
      ];

      final barRod = BarChartRodData(
        toY: 10,
        width: 10,
        color: const Color(0x00000000),
        borderRadius: const BorderRadius.all(Radius.circular(0.1)),
        rodStackItems: rodStackItems,
      );

      final barGroups = [
        BarChartGroupData(x: 0, barRods: [barRod], barsSpace: 5),
      ];

      final data = BarChartData(
        groupsSpace: 10,
        barGroups: barGroups,
        barTouchData: BarTouchData(),
      );

      final barChartPainter = BarChartPainter();
      final holder =
          PaintHolder<BarChartData>(data, data, TextScaler.noScaling);

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final results = <Map<String, dynamic>>[];
      when(
        mockCanvasWrapper.drawRRect(
          captureAny,
          captureAny,
        ),
      ).thenAnswer((inv) {
        final rrect = inv.positionalArguments[0] as RRect;
        final paint = inv.positionalArguments[1] as Paint;
        results.add({
          'rRect': rrect,
          'paint.color': paint.color,
          'paint.strokeWidth': paint.strokeWidth,
        });
      });

      barChartPainter
        ..drawStackItemBorderStroke(
          mockCanvasWrapper,
          rodStackItems[0],
          0,
          3,
          barRod.width,
          RRect.fromLTRBAndCorners(
            0,
            0,
            10,
            100,
            bottomRight: const Radius.circular(12),
          ),
          viewSize,
          holder,
        )
        ..drawStackItemBorderStroke(
          mockCanvasWrapper,
          rodStackItems[1],
          1,
          3,
          barRod.width,
          RRect.fromLTRBAndCorners(
            0,
            0,
            10,
            100,
            bottomRight: const Radius.circular(12),
          ),
          viewSize,
          holder,
        )
        ..drawStackItemBorderStroke(
          mockCanvasWrapper,
          rodStackItems[2],
          2,
          3,
          barRod.width,
          RRect.fromLTRBAndCorners(
            0,
            0,
            10,
            100,
            bottomRight: const Radius.circular(12),
          ),
          viewSize,
          holder,
        );

      expect(results.length, 3);

      expect(
        results[0]['rRect'],
        RRect.fromLTRBAndCorners(
          0,
          70,
          10,
          100,
          bottomRight: const Radius.circular(12),
        ),
      );
      expect(results[0]['paint.color'], const Color(0x11111111));
      expect(results[0]['paint.strokeWidth'], 1.0);

      expect(
        results[1]['rRect'],
        RRect.fromLTRBAndCorners(
          0,
          20,
          10,
          70,
        ),
      );
      expect(results[1]['paint.color'], const Color(0x22222221));
      expect(results[1]['paint.strokeWidth'], 2.0);

      expect(
        results[2]['rRect'],
        RRect.fromLTRBAndCorners(
          0,
          0,
          10,
          20,
        ),
      );
      expect(results[2]['paint.color'], const Color(0x33333331));
      expect(results[2]['paint.strokeWidth'], 3.0);
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
              toY: 10,
              width: 10,
              color: const Color(0x00000000),
              borderRadius: const BorderRadius.all(Radius.circular(0.1)),
            ),
            BarChartRodData(
              toY: 8,
              width: 11,
              color: const Color(0x11111111),
              borderRadius: const BorderRadius.all(Radius.circular(0.2)),
            ),
            BarChartRodData(
              toY: 8,
              width: 12,
              color: const Color(0x22222222),
              borderRadius: const BorderRadius.all(Radius.circular(0.3)),
            ),
          ],
          barsSpace: 5,
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: 10,
              width: 10,
              borderRadius: const BorderRadius.all(Radius.circular(0.4)),
            ),
            BarChartRodData(toY: 8, width: 10),
          ],
          barsSpace: 5,
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(toY: 10, width: 10),
            BarChartRodData(toY: 8, width: 10),
            BarChartRodData(toY: 8, width: 10),
            BarChartRodData(toY: 8, width: 10),
          ],
          barsSpace: 5,
        ),
      ];

      final data = BarChartData(
        barGroups: barGroups,
        titlesData: const FlTitlesData(show: false),
        alignment: BarChartAlignment.center,
        groupsSpace: 10,
        barTouchData: BarTouchData(
          handleBuiltInTouches: true,
          touchExtraThreshold: const EdgeInsets.all(1),
        ),
      );

      final painter = BarChartPainter();
      final holder =
          PaintHolder<BarChartData>(data, data, TextScaler.noScaling);

      expect(painter.handleTouch(const Offset(10, 10), viewSize, holder), null);
      expect(
        painter.handleTouch(const Offset(27.49, 10), viewSize, holder),
        null,
      );

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
        painter.handleTouch(const Offset(39.51, 10), viewSize, holder),
        null,
      );

      // Group 1
      // 81.5, 0.0, 91.5, 100.0
      // 96.5, 20.0, 106.5, 100.0
      expect(
        painter.handleTouch(const Offset(100, 18.99), viewSize, holder),
        null,
      );
      final result2 =
          painter.handleTouch(const Offset(100, 19), viewSize, holder);
      expect(result2!.touchedBarGroupIndex, 1);
      expect(result2.touchedRodDataIndex, 1);

      // Group 2
      // 116.5, 0.0, 126.5, 100.0
      // 131.5, 20.0, 141.5, 100.0
      // 146.5, 20.0, 156.5, 100.0
      // 161.5, 20.0, 171.5, 100.0
      expect(
        painter.handleTouch(const Offset(165, 101.1), viewSize, holder),
        null,
      );
      final result3 =
          painter.handleTouch(const Offset(165, 101), viewSize, holder);
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
              toY: 10,
              width: 10,
              color: const Color(0x00000000),
              borderRadius: const BorderRadius.all(Radius.circular(0.1)),
              rodStackItems: [
                BarChartRodStackItem(0, 5, const Color(0xFF0F0F0F)),
              ],
            ),
          ],
          barsSpace: 5,
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: -10,
              width: 10,
              borderRadius: const BorderRadius.all(Radius.circular(0.4)),
            ),
          ],
          barsSpace: 5,
        ),
      ];

      final data = BarChartData(
        barGroups: barGroups,
        titlesData: const FlTitlesData(show: false),
        alignment: BarChartAlignment.center,
        groupsSpace: 10,
        barTouchData: BarTouchData(
          handleBuiltInTouches: true,
          touchExtraThreshold: const EdgeInsets.all(1),
        ),
      );

      final painter = BarChartPainter();
      final holder =
          PaintHolder<BarChartData>(data, data, TextScaler.noScaling);

      expect(
        painter.handleTouch(const Offset(134, 48.6), viewSize, holder),
        null,
      );
      expect(
        painter.handleTouch(const Offset(111.2, 31.1), viewSize, holder),
        null,
      );

      expect(
        painter.handleTouch(const Offset(103.2, 74.8), viewSize, holder),
        null,
      );
      expect(
        painter.handleTouch(const Offset(100.4, 21.2), viewSize, holder),
        null,
      );
      expect(
        painter.handleTouch(const Offset(80.1, 22), viewSize, holder),
        null,
      );

      final result1 =
          painter.handleTouch(const Offset(89, 38.5), viewSize, holder);
      expect(result1!.touchedBarGroupIndex, 0);
      expect(result1.touchedRodDataIndex, 0);
      expect(result1.touchedStackItemIndex, 0);

      final result2 =
          painter.handleTouch(const Offset(88.8, 16.5), viewSize, holder);
      expect(result2!.touchedBarGroupIndex, 0);
      expect(result2.touchedRodDataIndex, 0);
      expect(result2.touchedStackItemIndex, -1);
    });

    test('test 3', () {
      const viewSize = Size(200, 100);

      final barGroups = [
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: 5,
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                fromY: -5,
                toY: 5,
              ),
            ),
          ],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: -6,
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                fromY: 5,
                toY: -6,
              ),
            ),
          ],
        ),
      ];

      final data = BarChartData(
        barGroups: barGroups,
        titlesData: const FlTitlesData(show: false),
        alignment: BarChartAlignment.start,
        groupsSpace: 10,
        minY: -10,
        maxY: 15,
        barTouchData: BarTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          allowTouchBarBackDraw: true,
          touchExtraThreshold: const EdgeInsets.all(1),
        ),
      );

      final painter = BarChartPainter();
      final holder =
          PaintHolder<BarChartData>(data, data, TextScaler.noScaling);

      final result1 =
          painter.handleTouch(const Offset(4, 60), viewSize, holder);
      expect(result1!.touchedBarGroupIndex, 0);
      expect(result1.touchedRodDataIndex, 0);

      // tap below the positive bar
      final result11 =
          painter.handleTouch(const Offset(4, 61.1), viewSize, holder);
      expect(result11!.touchedBarGroupIndex, 0);
      expect(result11.touchedRodDataIndex, 0);

      final result2 =
          painter.handleTouch(const Offset(22, 60), viewSize, holder);
      expect(result2!.touchedBarGroupIndex, 1);
      expect(result2.touchedRodDataIndex, 0);

      final result22 =
          painter.handleTouch(const Offset(22, 58.9), viewSize, holder);
      expect(result22!.touchedBarGroupIndex, 1);
      expect(result22.touchedRodDataIndex, 0);
    });
  });

  group('drawExtraLines()', () {
    test(
        'should not draw lines when constructor is called with empty ExtraLinesData object',
        () {
      const viewSize = Size(400, 400);
      final data = BarChartData(
        barGroups: [
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(fromY: 1, toY: 10),
              BarChartRodData(fromY: 2, toY: 10),
            ],
            showingTooltipIndicators: [
              1,
              2,
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(fromY: 3, toY: 10),
              BarChartRodData(fromY: 4, toY: 10),
            ],
          ),
        ],
        extraLinesData: const ExtraLinesData(),
      );

      final barChartPainter = BarChartPainter();
      final holder =
          PaintHolder<BarChartData>(data, data, TextScaler.noScaling);
      final mockBuildContext = MockBuildContext();
      final mockCanvasWrapper = MockCanvasWrapper();

      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      barChartPainter.drawExtraLines(
        mockBuildContext,
        mockCanvasWrapper,
        holder,
      );

      verifyNever(
        mockCanvasWrapper.drawDashedLine(
          any,
          any,
          any,
          any,
        ),
      );
    });

    test('should not draw lines when constructor is not passed extraLinesData',
        () {
      const viewSize = Size(400, 400);
      final data = BarChartData(
        barGroups: [
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(fromY: 1, toY: 10),
              BarChartRodData(fromY: 2, toY: 10),
            ],
            showingTooltipIndicators: [
              1,
              2,
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(fromY: 3, toY: 10),
              BarChartRodData(fromY: 4, toY: 10),
            ],
          ),
        ],
      );

      final barChartPainter = BarChartPainter();
      final holder =
          PaintHolder<BarChartData>(data, data, TextScaler.noScaling);
      final mockBuildContext = MockBuildContext();
      final mockCanvasWrapper = MockCanvasWrapper();

      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      barChartPainter.drawExtraLines(
        mockBuildContext,
        mockCanvasWrapper,
        holder,
      );

      verifyNever(
        mockCanvasWrapper.drawDashedLine(
          any,
          any,
          any,
          any,
        ),
      );
    });

    test('bar chart should not paint vertical lines', () {
      final utilsMainInstance = Utils();
      const viewSize = Size(400, 400);
      final data = BarChartData(
        barGroups: [
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(fromY: 1, toY: 10),
              BarChartRodData(fromY: 2, toY: 10),
            ],
            showingTooltipIndicators: [
              1,
              2,
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(fromY: 3, toY: 10),
              BarChartRodData(fromY: 4, toY: 10),
            ],
          ),
        ],
        extraLinesData: ExtraLinesData(
          verticalLines: [verticalLine1],
        ),
      );

      final barChartPainter = BarChartPainter();
      final holder =
          PaintHolder<BarChartData>(data, data, TextScaler.noScaling);

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

      barChartPainter.paint(
        mockBuildContext,
        mockCanvasWrapper,
        holder,
      );

      verifyNever(
        mockCanvasWrapper.drawDashedLine(
          any,
          any,
          argThat(
            const TypeMatcher<Paint>().having(
              (p0) => p0.color.value,
              'colors match',
              equals(Colors.red),
            ),
          ),
          holder.data.extraLinesData.verticalLines[0].dashArray,
        ),
      );

      Utils.changeInstance(utilsMainInstance);
    });

    test(
        'should not paint horizontal line if Y value is greater or less than Y axis',
        () {
      final utilsMainInstance = Utils();
      const viewSize = Size(400, 400);

      final horizontalLine1 = HorizontalLine(
        y: 10.1,
        color: Colors.red,
        dashArray: [0, 1],
      );

      final horizontalLine2 = HorizontalLine(
        y: -10.1,
        color: Colors.red,
        dashArray: [0, 1],
      );

      final data = BarChartData(
        minY: -10,
        maxY: 10,
        barGroups: [
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(fromY: 1, toY: 10),
              BarChartRodData(fromY: 2, toY: 10),
            ],
            showingTooltipIndicators: [
              1,
              2,
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(fromY: 3, toY: 10),
              BarChartRodData(fromY: 4, toY: 10),
            ],
          ),
        ],
        extraLinesData: ExtraLinesData(
          horizontalLines: [horizontalLine1, horizontalLine2],
        ),
      );

      final barChartPainter = BarChartPainter();
      final holder =
          PaintHolder<BarChartData>(data, data, TextScaler.noScaling);

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

      barChartPainter.paint(
        mockBuildContext,
        mockCanvasWrapper,
        holder,
      );

      verifyNever(
        mockCanvasWrapper.drawDashedLine(
          any,
          any,
          argThat(
            const TypeMatcher<Paint>().having(
              (p0) => p0.color.value,
              'colors match',
              equals(Colors.red.value),
            ),
          ),
          holder.data.extraLinesData.horizontalLines[0].dashArray,
        ),
      );

      Utils.changeInstance(utilsMainInstance);
    });

    test('should paint horizontal lines', () {
      final horizontalLine = HorizontalLine(
        y: 2.5,
        strokeWidth: 90,
        color: Colors.cyanAccent,
        dashArray: [100, 20],
      );
      final horizontalLine1 = HorizontalLine(
        y: 0.2,
        strokeWidth: 100,
        color: Colors.cyanAccent,
        dashArray: [100, 20],
      );
      final utilsMainInstance = Utils();
      const viewSize = Size(400, 400);
      final data = BarChartData(
        barGroups: [
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(fromY: 1, toY: 10),
              BarChartRodData(fromY: 2, toY: 10),
            ],
            showingTooltipIndicators: [
              1,
              2,
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(fromY: 3, toY: 10),
              BarChartRodData(fromY: 4, toY: 10),
            ],
          ),
        ],
        extraLinesData: ExtraLinesData(
          horizontalLines: [horizontalLine, horizontalLine1],
        ),
      );

      final barChartPainter = BarChartPainter();
      final holder =
          PaintHolder<BarChartData>(data, data, TextScaler.noScaling);

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

      final results = <Map<String, dynamic>>[];

      when(
        mockCanvasWrapper.drawDashedLine(
          any,
          any,
          captureThat(
            const TypeMatcher<Paint>().having(
              (p0) => p0.color.value,
              'colors match',
              equals(Colors.cyanAccent.value),
            ),
          ),
          [100, 20],
        ),
      ).thenAnswer((inv) {
        results.add({
          'from': inv.positionalArguments[0] as Offset,
          'to': inv.positionalArguments[1] as Offset,
          'paint_color': (inv.positionalArguments[2] as Paint).color.value,
          'paint_stroke_width':
              (inv.positionalArguments[2] as Paint).strokeWidth,
        });
      });

      barChartPainter.paint(
        mockBuildContext,
        mockCanvasWrapper,
        holder,
      );

      expect(results.length, 1);

      expect(results[0]['paint_color'], Colors.cyanAccent.value);
      expect(results[0]['paint_stroke_width'], 90);

      Utils.changeInstance(utilsMainInstance);
    });

    test('should draw extra horizontal lines under chart', () {
      const viewSize = Size(100, 100);
      final data = BarChartData(
        minY: -10,
        maxY: 10,
        barGroups: [
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(fromY: 1, toY: 10),
              BarChartRodData(fromY: 2, toY: 10),
            ],
          ),
        ],
        titlesData: const FlTitlesData(show: false),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: -9.9,
              color: Colors.cyanAccent,
              dashArray: [12, 22],
            ),
            HorizontalLine(
              y: -.5,
              color: Colors.cyanAccent,
              dashArray: [12, 22],
            ),
          ],
          extraLinesOnTop: false,
        ),
      );

      final barChartPainter = BarChartPainter();
      final holder =
          PaintHolder<BarChartData>(data, data, TextScaler.noScaling);
      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((realInvocation) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final mockBuildContext = MockBuildContext();

      barChartPainter.paint(
        mockBuildContext,
        mockCanvasWrapper,
        holder,
      );

      verify(
        mockCanvasWrapper.drawDashedLine(
          any,
          any,
          argThat(
            const TypeMatcher<Paint>().having(
              (p0) => p0.color.value,
              'colors match',
              equals(Colors.cyanAccent.value),
            ),
          ),
          holder.data.extraLinesData.horizontalLines[0].dashArray,
        ),
      ).called(2);
    });
  });
}
