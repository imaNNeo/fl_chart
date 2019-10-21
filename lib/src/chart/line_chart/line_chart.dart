import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart_data_tween.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';

import 'line_chart_data.dart';
import 'line_chart_painter.dart';

class LineChart extends ImplicitlyAnimatedWidget {
  final LineChartData data;

  const LineChart(
    this.data, {
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
  }) : super(duration: swapAnimationDuration);

  @override
  LineChartState createState() => LineChartState();
}

class LineChartState extends AnimatedWidgetBaseState<LineChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [BaseChartData] to the new one.
  BaseChartDataTween _baseChartDataTween;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (d) {},
      onLongPressEnd: (d) async {},
      onLongPressMoveUpdate: (d) {},
      onPanCancel: () async {},
      onPanEnd: (DragEndDetails details) async {},
      onPanDown: (DragDownDetails details) {},
      onPanUpdate: (DragUpdateDetails details) {},
      child: CustomPaint(
        size: getDefaultSize(context),
        painter: LineChartPainter(_baseChartDataTween.evaluate(animation), widget.data, null, null),
      ),
    );
  }

  @override
  void forEachTween(visitor) {
    _baseChartDataTween = visitor(
      _baseChartDataTween,
      widget.data,
      (dynamic value) => BaseChartDataTween(begin: value),
    );
  }
}
