import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:flutter/widgets.dart';

class AxisChartDataController<T extends AxisChartData>
    extends ValueNotifier<T> {
  AxisChartDataController({required T data}) : super(data);
}
