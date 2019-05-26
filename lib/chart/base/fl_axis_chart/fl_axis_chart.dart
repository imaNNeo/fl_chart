import 'package:fl_chart/chart/bar_chart/bar_chart.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart.dart';
import 'package:fl_chart/chart/line_chart/line_chart.dart';

/// This class is suitable for axis base charts
/// in the axis base charts we have a grid behind the charts
/// the direct subclasses are [LineChart], [BarChart]
abstract class FlAxisChart extends FlChart {}