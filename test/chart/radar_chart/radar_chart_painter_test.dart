import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RadarChart usable size', () {
    test('test 1', () {
      const viewSize = Size(728, 728);

      final RadarChartData data = RadarChartData(dataSets: [
        RadarDataSet(),
      ]);

      final RadarChartPainter radarChartPainter = RadarChartPainter(data, data, (s) {});
      expect(radarChartPainter.getChartUsableDrawSize(viewSize), const Size(728, 728));
    });
  });
}
