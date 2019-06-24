import 'package:fl_chart/fl_chart.dart';

import 'base_chart_painter.dart';
import 'touch_input.dart';

/// BaseChart is a base class for our charts,
/// each chart should extends this class and implement the [painter] method.
/// and the Painter should extends from [BaseChartPainter].
/// the painter content will be painted on the [FlChart] class.
/// you can find concrete examples here :
/// [LineChart], [BarChart], [PieChart]
abstract class BaseChart {
  BaseChartPainter painter({FlTouchInputNotifier touchController,});
}
