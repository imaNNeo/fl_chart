import 'package:fl_chart/chart/bar_chart/bar_chart.dart';
import 'package:fl_chart/chart/base/fl_chart/fl_chart_painter.dart';
import 'package:fl_chart/chart/line_chart/line_chart.dart';
import 'package:fl_chart/chart/pie_chart/pie_chart.dart';
import 'package:fl_chart/fl_chart_widget.dart';

/// FlChart is a base class for our charts,
/// each chart should extends this class and implement the [painter] method.
/// and the Painter should extends from [FlChartPainter].
/// the painter content will be painted on the [FlChartWidget] class.
/// you can find concrete examples here :
/// [LineChart], [BarChart], [PieChart]
abstract class FlChart {
  FlChartPainter painter();
}
