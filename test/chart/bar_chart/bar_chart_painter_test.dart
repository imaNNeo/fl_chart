import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../data_pool.dart';

class MockCanvasWrapper extends Mock implements CanvasWrapper {}

void main() {
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

      final BarChartPainter barChartPainter = BarChartPainter(
        data,
        data,
        (s) {},
      );
      expect(barChartPainter.getChartUsableDrawSize(viewSize), const Size(644, 728));
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

      final BarChartPainter barChartPainter = BarChartPainter(
        data,
        data,
        (s) {},
      );
      expect(barChartPainter.getChartUsableDrawSize(viewSize), const Size(1958, 2020));
    });

    test('test 3', () {
      const viewSize = Size(1000, 1000);

      final BarChartData data = BarChartData(
          titlesData: FlTitlesData(
        leftTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(reservedSize: 100, margin: 400, showTitles: true),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(showTitles: false),
      ));

      final BarChartPainter barChartPainter = BarChartPainter(
        data,
        data,
        (s) {},
      );
      expect(barChartPainter.getChartUsableDrawSize(viewSize), const Size(500, 1000));
    });

    test('test 4', () {
      const viewSize = Size(800, 1000);

      final BarChartData data = BarChartData(
          titlesData: FlTitlesData(
        leftTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(reservedSize: 10, margin: 0, showTitles: true),
        topTitles: SideTitles(reservedSize: 230, margin: 10, showTitles: true),
        bottomTitles: SideTitles(reservedSize: 10, margin: 312, showTitles: true),
      ));

      final BarChartPainter barChartPainter = BarChartPainter(
        data,
        data,
        (s) {},
      );
      expect(barChartPainter.getChartUsableDrawSize(viewSize), const Size(790, 438));
    });

    test('test 5', () {
      const viewSize = Size(600, 400);

      final BarChartData data = BarChartData(
          titlesData: FlTitlesData(
        leftTitles: SideTitles(reservedSize: 0, margin: 0, showTitles: true),
        rightTitles: SideTitles(reservedSize: 10, margin: 342134123, showTitles: false),
        topTitles: SideTitles(reservedSize: 80, margin: 0, showTitles: true),
        bottomTitles: SideTitles(reservedSize: 10, margin: 312, showTitles: false),
      ));

      final BarChartPainter barChartPainter = BarChartPainter(
        data,
        data,
        (s) {},
      );
      expect(barChartPainter.getChartUsableDrawSize(viewSize), const Size(600, 320));
    });
  });

  group('calculateGroupsX test', () {
    const delta = 0.01;

    test('test center', () {
      final data = barChartData1.copyWith(
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
      );

      // groupSpace = 23.0
      final painter = BarChartPainter(data, data, (touchHandler) {});
      final barGroups = [
        barChartGroupData1,
        // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
        barChartGroupData2,
        // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
        barChartGroupData3,
        // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
      ]; // Sum Width = 637
      const size = Size(800, 20);

      final xValues = painter.calculateGroupsX(size, barGroups, BarChartAlignment.center);
      expect(xValues, [
        closeTo(180, delta),
        closeTo(400, delta),
        closeTo(620, delta),
      ]);
    });

    test('test spaceAround', () {
      final data = barChartData1.copyWith(
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
      );

      // groupSpace = 23.0
      final painter = BarChartPainter(data, data, (touchHandler) {});
      final barGroups = [
        barChartGroupData1,
        // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
        barChartGroupData2,
        // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
        barChartGroupData3,
        // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
      ]; // Sum Width = 637
      const size = Size(800, 20);

      final xValues = painter.calculateGroupsX(size, barGroups, BarChartAlignment.spaceAround);
      expect(xValues, [
        closeTo(133.33, delta),
        closeTo(400, delta),
        closeTo(666.66, delta),
      ]);
    });

    test('test start', () {
      final data = barChartData1.copyWith(
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
      );

      // groupSpace = 23.0
      final painter = BarChartPainter(data, data, (touchHandler) {});
      final barGroups = [
        barChartGroupData1,
        // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
        barChartGroupData2,
        // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
        barChartGroupData3,
        // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
      ]; // Sum Width = 637
      const size = Size(800, 20);

      final xValues = painter.calculateGroupsX(size, barGroups, BarChartAlignment.start);
      expect(xValues, [
        closeTo(98.5, delta),
        closeTo(295.5, delta),
        closeTo(492.5, delta),
      ]);
    });
  });

  test('calculateGroupAndBarsPosition test', () {
    final data = barChartData1.copyWith(
      titlesData: FlTitlesData(show: false),
      axisTitleData: FlAxisTitleData(show: false),
    );

    // groupSpace = 23.0
    final painter = BarChartPainter(data, data, (touchHandler) {});
    final barGroups = [
      barChartGroupData1,
      // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
      barChartGroupData2,
      // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
      barChartGroupData3,
      // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
    ]; // Sum Width = 637
    const size = Size(800, 20);

    final groupXValues = painter.calculateGroupsX(size, barGroups, BarChartAlignment.center);
    final groupBarsXValues = painter.calculateGroupAndBarsPosition(size, groupXValues, barGroups);
    expect(groupBarsXValues, [
      GroupBarsPosition(180, [97.5, 152.5, 207.5, 262.5]),
      GroupBarsPosition(400, [317.5, 372.5, 427.5, 482.5]),
      GroupBarsPosition(620, [537.5, 592.5, 647.5, 702.5]),
    ]);
  });

  group('drawBars test', () {
    final BarChartRodData barChartRodData1 = BarChartRodData(
      colors: [Colors.red],
      y: 12,
      width: 32,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      rodStackItems: [
        BarChartRodStackItem(
          1,
          2,
          Colors.green,
        ),
        BarChartRodStackItem(
          2,
          4,
          Colors.red,
        ),
      ],
      backDrawRodData: BackgroundBarChartRodData(
        y: 21,
        colors: [Colors.blue],
        show: true,
      ),
    );

    final BarChartRodData barChartRodData2 = BarChartRodData(
      colors: [Colors.red],
      y: 233,
      width: 32,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      rodStackItems: null,
      backDrawRodData: BackgroundBarChartRodData(
        y: 21,
        colors: [Colors.blue],
        show: true,
      ),
    );

    final BarChartGroupData barChartGroupData1 = BarChartGroupData(
      x: 0,
      showingTooltipIndicators: [0, 1, 2],
      barRods: [
        barChartRodData1,
        barChartRodData2,
      ],
      barsSpace: 23,
    );

    final data = barChartData1.copyWith(
        titlesData: FlTitlesData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
        minY: 0,
        barGroups: [
          barChartGroupData1,
        ]);

    final painter = BarChartPainter(data, data, (touchHandler) {});

    final groupBarsPosition = [
      GroupBarsPosition(400, [300, 500]),
    ];

    const size = Size(800, 400);

    final canvasWrapper = MockCanvasWrapper();

    when(canvasWrapper.size).thenReturn(size);

    painter.drawBars(canvasWrapper, groupBarsPosition);

    final bar1BackDrawRRect = RRect.fromLTRBAndCorners(
      284,
      painter.getPixelY(21, size),
      316,
      painter.getPixelY(0, size),
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft: const Radius.circular(12),
      bottomRight: const Radius.circular(12),
    );

    final bar1RRect = RRect.fromLTRBAndCorners(
      284,
      painter.getPixelY(12, size),
      316,
      painter.getPixelY(0, size),
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft: const Radius.circular(12),
      bottomRight: const Radius.circular(12),
    );

    final bar2BackDrawRRect = RRect.fromLTRBAndCorners(
      484,
      painter.getPixelY(21, size),
      516,
      painter.getPixelY(0, size),
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft: const Radius.circular(12),
      bottomRight: const Radius.circular(12),
    );

    final bar2RRect = RRect.fromLTRBAndCorners(
      484,
      painter.getPixelY(233, size),
      516,
      painter.getPixelY(0, size),
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft: const Radius.circular(12),
      bottomRight: const Radius.circular(12),
    );

    test('test barRod draw', () {
      verifyInOrder([
        canvasWrapper.drawRRect(bar1BackDrawRRect, any),
        canvasWrapper.drawRRect(bar1RRect, any),
        canvasWrapper.drawRRect(bar2BackDrawRRect, any),
        canvasWrapper.drawRRect(bar2RRect, any),
      ]);
    });

    test('test barStack draw', () {
      final stackRect1 =
          Rect.fromLTRB(284, painter.getPixelY(2, size), 316, painter.getPixelY(1, size));
      final stackRect2 =
          Rect.fromLTRB(284, painter.getPixelY(4, size), 316, painter.getPixelY(2, size));

      verifyInOrder([
        // Stack 1 on Bar 1
        canvasWrapper.save(),
        canvasWrapper.clipRect(stackRect1),
        canvasWrapper.drawRRect(bar1RRect, any),
        canvasWrapper.restore(),
        // Stack 2 on Bar 1
        canvasWrapper.save(),
        canvasWrapper.clipRect(stackRect2),
        canvasWrapper.drawRRect(bar1RRect, any),
        canvasWrapper.restore(),
      ]);
    });
  });

  // Todo implement darTitlesTest later
  // group('drawTitles test', () {
  //   final data = barChartData1.copyWith(
  //       titlesData: FlTitlesData(
  //         show: true,
  //         leftTitles: SideTitles(getTitles: (value) => '$value ss', interval: 1),
  //       ),
  //       axisTitleData: FlAxisTitleData(show: false),
  //       minY: 0,
  //       barGroups: [
  //         barChartGroupData1,
  //       ]);
  //
  //   final painter = BarChartPainter(data, data, (touchHandler) {});
  //
  //   final groupBarsPosition = [
  //     GroupBarsPosition(400, [300, 500]),
  //   ];
  //
  //   const size = Size(800, 400);
  //
  //   final canvasWrapper = MockCanvasWrapper();
  //
  //   when(canvasWrapper.size).thenReturn(size);
  //
  //   painter.drawBars(canvasWrapper, groupBarsPosition);
  //
  //   final bar1BackDrawRRect = RRect.fromLTRBAndCorners(
  //     284,
  //     painter.getPixelY(21, size),
  //     316,
  //     painter.getPixelY(0, size),
  //     topLeft: const Radius.circular(12),
  //     topRight: const Radius.circular(12),
  //     bottomLeft: const Radius.circular(12),
  //     bottomRight: const Radius.circular(12),
  //   );
  //
  //   final bar1RRect = RRect.fromLTRBAndCorners(
  //     284,
  //     painter.getPixelY(12, size),
  //     316,
  //     painter.getPixelY(0, size),
  //     topLeft: const Radius.circular(12),
  //     topRight: const Radius.circular(12),
  //     bottomLeft: const Radius.circular(12),
  //     bottomRight: const Radius.circular(12),
  //   );
  //
  //   final bar2BackDrawRRect = RRect.fromLTRBAndCorners(
  //     484,
  //     painter.getPixelY(21, size),
  //     516,
  //     painter.getPixelY(0, size),
  //     topLeft: const Radius.circular(12),
  //     topRight: const Radius.circular(12),
  //     bottomLeft: const Radius.circular(12),
  //     bottomRight: const Radius.circular(12),
  //   );
  //
  //   final bar2RRect = RRect.fromLTRBAndCorners(
  //     484,
  //     painter.getPixelY(233, size),
  //     516,
  //     painter.getPixelY(0, size),
  //     topLeft: const Radius.circular(12),
  //     topRight: const Radius.circular(12),
  //     bottomLeft: const Radius.circular(12),
  //     bottomRight: const Radius.circular(12),
  //   );
  //
  //   test('test barRod draw', () {
  //     verifyInOrder([
  //       canvasWrapper.drawRRect(bar1BackDrawRRect, any),
  //       canvasWrapper.drawRRect(bar1RRect, any),
  //       canvasWrapper.drawRRect(bar2BackDrawRRect, any),
  //       canvasWrapper.drawRRect(bar2RRect, any),
  //     ]);
  //   });
  //
  //   test('test barStack draw', () {
  //     final stackRect1 = Rect.fromLTRB(
  //         284, painter.getPixelY(2, size), 316, painter.getPixelY(1, size));
  //     final stackRect2 = Rect.fromLTRB(
  //         284, painter.getPixelY(4, size), 316, painter.getPixelY(2, size));
  //
  //     verifyInOrder([
  //       // Stack 1 on Bar 1
  //       canvasWrapper.save(),
  //       canvasWrapper.clipRect(stackRect1),
  //       canvasWrapper.drawRRect(bar1RRect, any),
  //       canvasWrapper.restore(),
  //       // Stack 2 on Bar 1
  //       canvasWrapper.save(),
  //       canvasWrapper.clipRect(stackRect2),
  //       canvasWrapper.drawRRect(bar1RRect, any),
  //       canvasWrapper.restore(),
  //     ]);
  //   });
  // });

  group('drawTooltips test', () {
    final data = barChartData1.copyWith(
      titlesData: FlTitlesData(show: false),
      axisTitleData: FlAxisTitleData(show: false),
      minY: 0,
      barGroups: [
        BarChartGroupData(
          x: 12,
          showingTooltipIndicators: [0, 1, 2, 3],
          barRods: [
            barChartRodData1,
            barChartRodData2,
            barChartRodData3,
            barChartRodData4,
          ],
          barsSpace: 23,
        ),
      ],
    );

    final painter = BarChartPainter(data, data, (touchHandler) {});

    final groupBarsPosition = [
      GroupBarsPosition(400, [200, 300, 500, 600]),
    ];

    const size = Size(800, 400);

    final canvasWrapper = MockCanvasWrapper();

    when(canvasWrapper.size).thenReturn(size);

    painter.drawTooltips(canvasWrapper, groupBarsPosition);

    test('test', () {
      verify(canvasWrapper.drawRRect(any, any)).called(4);
    });
  });

  group('drawTouchTooltip test', () {
    final groupData = BarChartGroupData(
      x: 12,
      showingTooltipIndicators: [0, 1, 2, 3],
      barRods: [
        barChartRodData1,
        barChartRodData2,
        barChartRodData3,
        barChartRodData4,
      ],
      barsSpace: 23,
    );

    final data = barChartData1.copyWith(
      titlesData: FlTitlesData(show: false),
      axisTitleData: FlAxisTitleData(show: false),
      minY: 0,
      barGroups: [
        groupData,
      ],
    );

    final painter = BarChartPainter(data, data, (touchHandler) {});

    final groupBarsPosition = [
      GroupBarsPosition(400, [200, 300, 500, 600]),
    ];

    const size = Size(800, 400);

    final canvasWrapper = MockCanvasWrapper();

    when(canvasWrapper.size).thenReturn(size);

    final touchTooltipData = BarTouchTooltipData(
      tooltipBgColor: Colors.green,
      tooltipRoundedRadius: 12,
      tooltipPadding: const EdgeInsets.all(12),
      getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem(
        'itemm $groupIndex, $rodIndex',
        const TextStyle(
          color: Colors.red,
        ),
      ),
      maxContentWidth: 500,
      tooltipBottomMargin: 8,
    );

    test('test1', () {
      const TextSpan span = TextSpan(
          style: TextStyle(
            color: Colors.red,
          ),
          text: 'itemm 0, 0');
      final TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          textScaleFactor: 1.0);
      tp.layout(maxWidth: 500);

      painter.drawTouchTooltip(
          canvasWrapper, groupBarsPosition, touchTooltipData, groupData, 0, barChartRodData1, 0);
      verifyInOrder([
        canvasWrapper.drawRRect(any, any),
        canvasWrapper.drawText(
          any,
          any,
        ),
      ]);
    });
  });

  group('getExtraNeededHorizontalSpace test', () {
    test('test1', () {
      final data = barChartData1.copyWith(
          axisTitleData: FlAxisTitleData(show: false),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: SideTitles(reservedSize: 10, margin: 0, showTitles: true),
            rightTitles: SideTitles(reservedSize: 40, margin: 8, showTitles: true),
          ));
      final painter = BarChartPainter(data, data, (touchHandler) {});
      expect(painter.getExtraNeededHorizontalSpace(), 58);
    });

    test('test2', () {
      final data = barChartData1.copyWith(
          axisTitleData: FlAxisTitleData(
              show: true,
              leftTitle: AxisTitle(
                showTitle: true,
                reservedSize: 15,
                margin: 0,
              ),
              rightTitle: AxisTitle(
                showTitle: true,
                reservedSize: 0,
                margin: 40,
              )),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: SideTitles(reservedSize: 10, margin: 0, showTitles: true),
            rightTitles: SideTitles(reservedSize: 40, margin: 8, showTitles: false),
          ));
      final painter = BarChartPainter(data, data, (touchHandler) {});
      expect(painter.getExtraNeededHorizontalSpace(), 65);
    });

    test('test3', () {
      final data = barChartData1.copyWith(
          axisTitleData: FlAxisTitleData(
            show: false,
          ),
          titlesData: FlTitlesData(
            show: false,
            leftTitles: SideTitles(reservedSize: 10, margin: 0, showTitles: true),
            rightTitles: SideTitles(reservedSize: 40, margin: 8, showTitles: false),
          ));
      final painter = BarChartPainter(data, data, (touchHandler) {});
      expect(painter.getExtraNeededHorizontalSpace(), 0);
    });
  });

  group('getExtraNeededVerticalSpace test', () {
    test('test1', () {
      final data = barChartData1.copyWith(
          axisTitleData: FlAxisTitleData(show: false),
          titlesData: FlTitlesData(
            show: true,
            topTitles: SideTitles(reservedSize: 10, margin: 0, showTitles: true),
            bottomTitles: SideTitles(reservedSize: 40, margin: 8, showTitles: true),
          ));
      final painter = BarChartPainter(data, data, (touchHandler) {});
      expect(painter.getExtraNeededVerticalSpace(), 58);
    });

    test('test2', () {
      final data = barChartData1.copyWith(
          axisTitleData: FlAxisTitleData(
              show: true,
              topTitle: AxisTitle(
                showTitle: true,
                reservedSize: 15,
                margin: 0,
              ),
              bottomTitle: AxisTitle(
                showTitle: true,
                reservedSize: 0,
                margin: 40,
              )),
          titlesData: FlTitlesData(
            show: true,
            topTitles: SideTitles(reservedSize: 10, margin: 0, showTitles: true),
            bottomTitles: SideTitles(reservedSize: 40, margin: 8, showTitles: false),
          ));
      final painter = BarChartPainter(data, data, (touchHandler) {});
      expect(painter.getExtraNeededVerticalSpace(), 65);
    });

    test('test3', () {
      final data = barChartData1.copyWith(
          axisTitleData: FlAxisTitleData(
            show: false,
          ),
          titlesData: FlTitlesData(
            show: false,
            topTitles: SideTitles(reservedSize: 10, margin: 0, showTitles: true),
            bottomTitles: SideTitles(reservedSize: 40, margin: 8, showTitles: false),
          ));
      final painter = BarChartPainter(data, data, (touchHandler) {});
      expect(painter.getExtraNeededVerticalSpace(), 0);
    });
  });

  group('getLeftOffsetDrawSize test', () {
    test('test1', () {
      final data = barChartData1.copyWith(
          axisTitleData: FlAxisTitleData(show: false),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: SideTitles(reservedSize: 10, margin: 0, showTitles: true),
            rightTitles: SideTitles(reservedSize: 40, margin: 8, showTitles: true),
          ));
      final painter = BarChartPainter(data, data, (touchHandler) {});
      expect(painter.getLeftOffsetDrawSize(), 10);
    });

    test('test2', () {
      final data = barChartData1.copyWith(
          axisTitleData: FlAxisTitleData(
              show: true,
              leftTitle: AxisTitle(
                showTitle: true,
                reservedSize: 15,
                margin: 0,
              ),
              rightTitle: AxisTitle(
                showTitle: true,
                reservedSize: 0,
                margin: 40,
              )),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: SideTitles(reservedSize: 10, margin: 0, showTitles: false),
            rightTitles: SideTitles(reservedSize: 40, margin: 8, showTitles: true),
          ));
      final painter = BarChartPainter(data, data, (touchHandler) {});
      expect(painter.getLeftOffsetDrawSize(), 15);
    });

    test('test3', () {
      final data = barChartData1.copyWith(
          axisTitleData: FlAxisTitleData(
            show: false,
          ),
          titlesData: FlTitlesData(
            show: false,
            leftTitles: SideTitles(reservedSize: 10, margin: 0, showTitles: false),
            rightTitles: SideTitles(reservedSize: 40, margin: 8, showTitles: true),
          ));
      final painter = BarChartPainter(data, data, (touchHandler) {});
      expect(painter.getLeftOffsetDrawSize(), 0);
    });
  });

  group('getTopOffsetDrawSize test', () {
    test('test1', () {
      final data = barChartData1.copyWith(
          axisTitleData: FlAxisTitleData(show: false),
          titlesData: FlTitlesData(
            show: true,
            topTitles: SideTitles(reservedSize: 10, margin: 0, showTitles: true),
            bottomTitles: SideTitles(reservedSize: 40, margin: 8, showTitles: true),
          ));
      final painter = BarChartPainter(data, data, (touchHandler) {});
      expect(painter.getTopOffsetDrawSize(), 10);
    });

    test('test2', () {
      final data = barChartData1.copyWith(
          axisTitleData: FlAxisTitleData(
              show: true,
              topTitle: AxisTitle(
                showTitle: true,
                reservedSize: 15,
                margin: 0,
              ),
              bottomTitle: AxisTitle(
                showTitle: true,
                reservedSize: 0,
                margin: 40,
              )),
          titlesData: FlTitlesData(
            show: true,
            topTitles: SideTitles(reservedSize: 10, margin: 20, showTitles: true),
            bottomTitles: SideTitles(reservedSize: 40, margin: 8, showTitles: false),
          ));
      final painter = BarChartPainter(data, data, (touchHandler) {});
      expect(painter.getTopOffsetDrawSize(), 45);
    });

    test('test3', () {
      final data = barChartData1.copyWith(
          axisTitleData: FlAxisTitleData(
            show: false,
          ),
          titlesData: FlTitlesData(
            show: false,
            topTitles: SideTitles(reservedSize: 10, margin: 0, showTitles: false),
            bottomTitles: SideTitles(reservedSize: 40, margin: 8, showTitles: true),
          ));
      final painter = BarChartPainter(data, data, (touchHandler) {});
      expect(painter.getTopOffsetDrawSize(), 0);
    });
  });

  test('handleTouch test', () {
    final painter = BarChartPainter(barChartData1, barChartData1, (touchHandler) {});
    final response =
        painter.handleTouch(FlLongPressMoveUpdate(const Offset(100, 100)), const Size(800, 400));
    expect(response.touchInput, FlLongPressMoveUpdate(const Offset(100, 100)));

    final response2 =
        painter.handleTouch(FlPanMoveUpdate(const Offset(100, 100)), const Size(800, 400));
    expect(response2.touchInput, FlPanMoveUpdate(const Offset(100, 100)));
  });

  group('getNearestTouchedSpot test', () {
    final data = barChartData1.copyWith(
      titlesData: FlTitlesData(show: false),
      axisTitleData: FlAxisTitleData(show: false),
      minY: 0,
      maxY: 24,
      barTouchData: BarTouchData(
        touchTooltipData: barTouchTooltipData1,
        handleBuiltInTouches: false,
        touchCallback: barTouchCallback,
        enabled: false,
        allowTouchBarBackDraw: false,
        touchExtraThreshold: const EdgeInsets.all(4),
      ),
      barGroups: [
        BarChartGroupData(
          x: 12,
          showingTooltipIndicators: [0, 1, 2, 3],
          barRods: [
            barChartRodData1,
            barChartRodData2,
            barChartRodData3,
            barChartRodData4,
          ],
          barsSpace: 23,
        ),
        BarChartGroupData(
          x: 33,
          showingTooltipIndicators: [0, 1, 2, 3],
          barRods: [
            barChartRodData1,
            barChartRodData2,
            barChartRodData3,
            barChartRodData4,
          ],
          barsSpace: 23,
        ),
      ],
    );

    final painter = BarChartPainter(data, data, (touchHandler) {});

    final groupBarsPosition = [
      GroupBarsPosition(200, [100, 150, 250, 350]),
      GroupBarsPosition(600, [400, 500, 600, 700]),
    ];

    const size = Size(800, 400);

    final canvasWrapper = MockCanvasWrapper();

    when(canvasWrapper.size).thenReturn(size);

    test('test1', () {
      final touchResponse =
          painter.getNearestTouchedSpot(size, const Offset(100, 400), groupBarsPosition);
      expect(touchResponse.touchedBarGroupIndex, 0);
      expect(touchResponse.touchedRodDataIndex, 0);

      final touchResponse2 =
          painter.getNearestTouchedSpot(size, const Offset(80, 400), groupBarsPosition);
      expect(touchResponse2.touchedBarGroupIndex, 0);
      expect(touchResponse2.touchedRodDataIndex, 0);

      final touchResponse3 =
          painter.getNearestTouchedSpot(size, const Offset(79, 400), groupBarsPosition);
      expect(touchResponse3, null);

      final touchResponse4 =
          painter.getNearestTouchedSpot(size, const Offset(120, 400), groupBarsPosition);
      expect(touchResponse4.touchedBarGroupIndex, 0);
      expect(touchResponse4.touchedRodDataIndex, 0);

      final touchResponse5 =
          painter.getNearestTouchedSpot(size, const Offset(121, 400), groupBarsPosition);
      expect(touchResponse5, null);
    });

    test('test2', () {
      final touchResponse =
          painter.getNearestTouchedSpot(size, const Offset(250, 400), groupBarsPosition);
      expect(touchResponse.touchedBarGroupIndex, 0);
      expect(touchResponse.touchedRodDataIndex, 2);

      final touchResponse2 =
          painter.getNearestTouchedSpot(size, const Offset(230, 400), groupBarsPosition);
      expect(touchResponse2.touchedBarGroupIndex, 0);
      expect(touchResponse2.touchedRodDataIndex, 2);

      final touchResponse3 =
          painter.getNearestTouchedSpot(size, const Offset(229, 400), groupBarsPosition);
      expect(touchResponse3, null);

      final touchResponse4 =
          painter.getNearestTouchedSpot(size, const Offset(270, 400), groupBarsPosition);
      expect(touchResponse4.touchedBarGroupIndex, 0);
      expect(touchResponse4.touchedRodDataIndex, 2);

      final touchResponse5 =
          painter.getNearestTouchedSpot(size, const Offset(271, 400), groupBarsPosition);
      expect(touchResponse5, null);
    });

    test('test3', () {
      final touchResponse =
          painter.getNearestTouchedSpot(size, const Offset(500, 400), groupBarsPosition);
      expect(touchResponse.touchedBarGroupIndex, 1);
      expect(touchResponse.touchedRodDataIndex, 1);

      final touchResponse2 =
          painter.getNearestTouchedSpot(size, const Offset(480, 400), groupBarsPosition);
      expect(touchResponse2.touchedBarGroupIndex, 1);
      expect(touchResponse2.touchedRodDataIndex, 1);

      final touchResponse3 =
          painter.getNearestTouchedSpot(size, const Offset(470, 400), groupBarsPosition);
      expect(touchResponse3, null);

      final touchResponse4 =
          painter.getNearestTouchedSpot(size, const Offset(520, 400), groupBarsPosition);
      expect(touchResponse4.touchedBarGroupIndex, 1);
      expect(touchResponse4.touchedRodDataIndex, 1);

      final touchResponse5 =
          painter.getNearestTouchedSpot(size, const Offset(521, 400), groupBarsPosition);
      expect(touchResponse5, null);
    });

    test('test4', () {
      final touchResponse =
          painter.getNearestTouchedSpot(size, const Offset(700, 400), groupBarsPosition);
      expect(touchResponse.touchedBarGroupIndex, 1);
      expect(touchResponse.touchedRodDataIndex, 3);

      final touchResponse2 =
          painter.getNearestTouchedSpot(size, const Offset(700, 200), groupBarsPosition);
      expect(touchResponse2.touchedBarGroupIndex, 1);
      expect(touchResponse2.touchedRodDataIndex, 3);

      final touchResponse3 =
          painter.getNearestTouchedSpot(size, const Offset(700, 196), groupBarsPosition);
      expect(touchResponse3.touchedBarGroupIndex, 1);
      expect(touchResponse3.touchedRodDataIndex, 3);

      final touchResponse4 =
          painter.getNearestTouchedSpot(size, const Offset(700, 195), groupBarsPosition);
      expect(touchResponse4, null);
    });
  });

  test('shouldRepaint test', () {
    final painter1 = BarChartPainter(barChartData1, barChartData1, (touchHandler) {});
    final painter1Clone =
        BarChartPainter(barChartData1Clone, barChartData1Clone, (touchHandler) {});
    final painter2 = BarChartPainter(barChartData2, barChartData2, (touchHandler) {});
    expect(painter1.shouldRepaint(painter1Clone), false);
    expect(painter1.shouldRepaint(painter2), true);

    final painter3 = BarChartPainter(barChartData3, barChartData3, (touchHandler) {});
    final painter4 = BarChartPainter(barChartData4, barChartData4, (touchHandler) {});
    expect(painter3.shouldRepaint(painter4), true);

    final painter5 = BarChartPainter(barChartData5, barChartData5, (touchHandler) {});
    final painter6 = BarChartPainter(barChartData6, barChartData6, (touchHandler) {});
    expect(painter5.shouldRepaint(painter6), true);
  });
}
