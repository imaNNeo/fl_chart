import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';

void main() {
  group('RadarChart usable size', () {
    test('test 1', () {
      const viewSize = Size(728, 728);

      final RadarChartData data = RadarChartData(dataSets: [
        RadarDataSet(),
      ]);

      final RadarChartPainter radarChartPainter = RadarChartPainter();
      final holder = PaintHolder<RadarChartData>(data, data, 1.0);
      expect(radarChartPainter.getChartUsableDrawSize(viewSize, holder), const Size(728, 728));
    });
  });
}
