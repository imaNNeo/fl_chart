library fl_chart;

import 'package:flutter/material.dart';

import 'src/chart/bar_chart/bar_chart.dart';
import 'src/chart/base/base_chart/base_chart.dart';
import 'src/chart/base/base_chart/base_chart_painter.dart';
import 'src/chart/line_chart/line_chart.dart';
import 'src/chart/pie_chart/pie_chart.dart';

export 'src/chart/bar_chart/bar_chart.dart';
export 'src/chart/bar_chart/bar_chart_data.dart';
export 'src/chart/base/axis_chart/axis_chart_data.dart';
export 'src/chart/base/base_chart/base_chart_data.dart';
export 'src/chart/line_chart/line_chart.dart';
export 'src/chart/line_chart/line_chart_data.dart';
export 'src/chart/pie_chart/pie_chart.dart';
export 'src/chart/pie_chart/pie_chart_data.dart';


/// A base widget that holds a [BaseChart] class
/// that contains [BaseChartPainter] extends from [CustomPainter]
/// to paint the relative content on our [CustomPaint] class
/// [BaseChart] is an abstract class and we should use a concrete class
/// such as [LineChart], [BarChart], [PieChart].
class FlChart extends StatefulWidget {
  final BaseChart chart;

  FlChart({
    Key key,
    @required this.chart,
  }) : super(key: key) {
    if (chart == null) {
      throw Exception('chart should not be null');
    }
  }

  @override
  State<StatefulWidget> createState() => _FlChartState();
}

class _FlChartState extends State<FlChart> {

  FlTouchInputNotifier flTouchInputNotifier;

  @override
  void initState() {
    super.initState();
    flTouchInputNotifier = FlTouchInputNotifier(null);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (d) {
        final RenderBox box = context.findRenderObject();
        final Offset offset = box.globalToLocal(d.globalPosition);
        updateTouchedPoint(offset);
      },
      onLongPressEnd: (d) {
        updateTouchedPoint(null);
      },
      onLongPressMoveUpdate: (d) {
        final RenderBox box = context.findRenderObject();
        final Offset offset = box.globalToLocal(d.globalPosition);
        updateTouchedPoint(offset);
      },
      child: CustomPaint(
        painter: widget.chart.painter(
          touchController: flTouchInputNotifier,
        ),
      ),
    );
  }

  void updateTouchedPoint(Offset newOffset) {
    flTouchInputNotifier.value = newOffset;
  }
}