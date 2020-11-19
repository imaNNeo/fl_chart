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
        barChartGroupData1, // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
        barChartGroupData2, // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
        barChartGroupData3, // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
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
        barChartGroupData1, // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
        barChartGroupData2, // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
        barChartGroupData3, // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
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
        barChartGroupData1, // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
        barChartGroupData2, // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
        barChartGroupData3, // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
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
      barChartGroupData1, // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
      barChartGroupData2, // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
      barChartGroupData3, // Widths = [32, 32, 32, 32], barSpace = 23, sumWidth = 197
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
      ]
    );

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

      final stackRect1 = Rect.fromLTRB(284, painter.getPixelY(2, size), 316, painter.getPixelY(1, size));
      final stackRect2 = Rect.fromLTRB(284, painter.getPixelY(4, size), 316, painter.getPixelY(2, size));

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
}
