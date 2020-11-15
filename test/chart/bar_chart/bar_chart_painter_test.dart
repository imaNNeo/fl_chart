import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import '../data_pool.dart';

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

  group('_calculateGroupsX test', () {
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
  });
}
