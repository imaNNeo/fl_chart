import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';

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
}
