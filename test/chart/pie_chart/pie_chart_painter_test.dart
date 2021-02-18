import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/pie_chart/pie_chart_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PieChart usable size', () {
    test('test 1', () {
      const viewSize = Size(728, 728);

      final PieChartData data = PieChartData(sections: [
        PieChartSectionData(),
        PieChartSectionData(),
        PieChartSectionData(),
      ]);
      final PieChartPainter barChartPainter = PieChartPainter(
        data,
        data,
        (s) {},
      );
      expect(barChartPainter.getChartUsableDrawSize(viewSize), const Size(728, 728));
    });
  });
}
