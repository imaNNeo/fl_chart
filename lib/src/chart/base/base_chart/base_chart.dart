// coverage:ignore-file
import 'package:fl_chart/fl_chart.dart';

import 'base_chart_painter.dart';

/// BaseChart is a base class for our charts,
/// each chart should extends this class and implement the [painter] method.
/// and the Painter should extends from [BaseChartPainter].
/// the painter content will be painted on the [FlChart] class.
/// you can find concrete examples here :
/// [LineChart], [BarChart], [PieChart]
abstract class BaseChart {
  /// [baseChartData] is the currently showing data (it may produced by an animation using lerp function),
  /// [targetBaseChartData] is the target data, that animation is going to show (if animating)
  BaseChartPainter painter({
    BaseChartData baseChartData,
    BaseChartData targetBaseChartData,
  });

  /// get the data of the concrete chart
  BaseChartData getData();
}
