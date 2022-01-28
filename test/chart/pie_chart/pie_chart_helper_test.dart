import 'package:flutter/cupertino.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/src/chart/pie_chart/pie_chart_helper.dart';

void main() {
  test('Test List<PieChartSectionData>.toWidgets()', () {
    final widgets1 = [
      PieChartSectionData(value: 1),
      PieChartSectionData(value: 2),
      PieChartSectionData(value: 3),
    ].toWidgets();
    expect(widgets1, List.empty());

    final widgets2 = [
      PieChartSectionData(value: 1),
      PieChartSectionData(value: 2, badgeWidget: const Text('asdf')),
      PieChartSectionData(value: 3),
    ].toWidgets();
    expect(widgets2[0] is Container, true);
    expect(widgets2[1] is Text, true);
    expect(widgets2[2] is Container, true);

    final widgets3 = [
      PieChartSectionData(value: 1, badgeWidget: const Text('1')),
      PieChartSectionData(value: 2, badgeWidget: const Text('2')),
      PieChartSectionData(value: 3, badgeWidget: const Text('3')),
    ].toWidgets();
    expect((widgets3[0] as Text).data, '1');
    expect((widgets3[1] as Text).data, '2');
    expect((widgets3[2] as Text).data, '3');
  });
}
