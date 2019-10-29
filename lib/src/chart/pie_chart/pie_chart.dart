import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart_data_tween.dart';
import 'package:fl_chart/src/chart/pie_chart/pie_chart_painter.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';

import 'pie_chart_data.dart';

class PieChart extends ImplicitlyAnimatedWidget {
  final PieChartData data;

  const PieChart(
    this.data, {
      Duration swapAnimationDuration = const Duration(milliseconds: 150),
    }) : super(duration: swapAnimationDuration);

  @override
  PieChartState createState() => PieChartState();
}

class PieChartState extends AnimatedWidgetBaseState<PieChart> {
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
        painter: PieChartPainter(_baseChartDataTween.evaluate(animation), widget.data,),
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