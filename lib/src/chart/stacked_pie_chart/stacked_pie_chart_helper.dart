import 'package:fl_chart/src/chart/stacked_pie_chart/stacked_pie_chart_data.dart';
import 'package:flutter/material.dart';

extension StackedPieChartSectionDataListExtenion
    on List<StackedPieChartSectionData> {
  List<Widget> toWidgets() {
    final widgets = List<Widget>.filled(length, Container());
    var allWidgetsAreNull = true;
    asMap().entries.forEach((e) {
      final index = e.key;
      final section = e.value;
      if (section.badgeWidget != null) {
        widgets[index] = section.badgeWidget!;
        allWidgetsAreNull = false;
      }
    });
    if (allWidgetsAreNull) {
      return List.empty();
    }
    return widgets;
  }
}
