// coverage:ignore-file
import 'package:fl_chart/src/chart/bar_chart/bar_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart.dart';

/// This class is suitable for axis base charts
/// in the axis base charts we have a grid behind the charts
/// the direct subclasses are [LineChart], [BarChart]
abstract class AxisChart extends BaseChart {}
