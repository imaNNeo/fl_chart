import 'package:fl_chart/src/chart/pie_chart/pie_chart_data.dart';
import 'package:flutter/widgets.dart';

extension PieChartSectionDataListExtension on List<PieChartSectionData> {
  List<Widget> toWidgets() {
    List<Widget> widgets = List.filled(length, Container());
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
