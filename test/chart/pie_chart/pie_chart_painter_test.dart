import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/pie_chart/pie_chart_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';

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
      expect(barChartPainter.getChartUsableDrawSize(viewSize, holder), const Size(728, 728));
    });
  });
}
