library fl_chart;

import 'package:flutter/material.dart';

import 'src/chart/bar_chart/bar_chart.dart';
import 'src/chart/base/base_chart/base_chart.dart';
import 'src/chart/base/base_chart/base_chart_painter.dart';
import 'src/chart/base/base_chart/touch_input.dart';
import 'src/chart/line_chart/line_chart.dart';
import 'src/chart/pie_chart/pie_chart.dart';

export 'src/chart/bar_chart/bar_chart.dart';
export 'src/chart/bar_chart/bar_chart_data.dart';
export 'src/chart/base/axis_chart/axis_chart_data.dart';
export 'src/chart/base/base_chart/base_chart_data.dart';
export 'src/chart/base/base_chart/touch_input.dart';
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

  ///We will notify Touch Events through this Notifier in form of a [FlTouchInput],
  ///then the painter returns touched details through a StreamSink.a
  FlTouchInputNotifier _touchInputNotifier;

  @override
  void initState() {
    super.initState();
    _touchInputNotifier = FlTouchInputNotifier(null);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (d) {
        _touchInputNotifier.value = FlLongPressStart(d.localPosition);
      },
      onLongPressEnd: (d) {
        _touchInputNotifier.value = FlLongPressEnd(d.localPosition);
      },
      onLongPressMoveUpdate: (d) {
        _touchInputNotifier.value = FlLongPressMoveUpdate(d.localPosition);
      },
      onPanCancel: () {
        _touchInputNotifier.value = FlPanEnd(Offset.zero);
      },
      onPanEnd: (DragEndDetails details) {
        _touchInputNotifier.value = FlPanEnd(Offset.zero);
      },
      onPanDown: (DragDownDetails details) {
        _touchInputNotifier.value = FlPanStart(details.localPosition);
      },
      onPanUpdate: (DragUpdateDetails details) {
        _touchInputNotifier.value = FlPanMoveUpdate(details.localPosition);
      },
      child: CustomPaint(
        painter: widget.chart.painter(
          touchInputNotifier: _touchInputNotifier,
          touchResponseSink: widget.chart.getData().touchData.touchResponseSink,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _touchInputNotifier.dispose();
  }
}