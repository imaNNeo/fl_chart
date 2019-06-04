import '../../../../fl_chart_widget.dart';
import 'fl_chart_painter.dart';

/// FlChart is a base class for our charts,
/// each chart should extends this class and implement the [painter] method.
/// and the Painter should extends from [FlChartPainter].
/// the painter content will be painted on the [FlChartWidget] class.
/// you can find concrete examples here :
/// [LineChart], [BarChart], [PieChart]
abstract class FlChart {
  FlChartPainter painter();
}
