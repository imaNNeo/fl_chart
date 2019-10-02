library fl_chart;

import 'package:fl_chart/src/chart/base/base_chart_data_tween.dart';
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
class FlChart extends ImplicitlyAnimatedWidget {
  final BaseChart chart;

  /// [swapAnimationDuration] is the duration of animation when swapping between
  /// a [BaseChartData] to another one, you can disable animations by setting 0 duration,
  /// check [ImplicitlyAnimatedWidget]
  FlChart({
    Key key,
    @required this.chart,
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
  }) : super(key: key, duration: swapAnimationDuration) {
    if (chart == null) {
      throw Exception('chart should not be null');
    }
  }

  @override
  _FlChartState createState() => _FlChartState();
}

class _FlChartState extends AnimatedWidgetBaseState<FlChart> {
  ///We will notify Touch Events through this Notifier in form of a [FlTouchInput],
  ///then the painter returns touched details through a StreamSink.a
  FlTouchInputNotifier _touchInputNotifier;

  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [BaseChartData] to the new one.
  BaseChartDataTween _baseChartDataTween;

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
      onLongPressEnd: (d) async {
        _touchInputNotifier.value = FlLongPressEnd(d.localPosition);
        _releaseTouch();
      },
      onLongPressMoveUpdate: (d) {
        _touchInputNotifier.value = FlLongPressMoveUpdate(d.localPosition);
      },
      onPanCancel: () async {
        _touchInputNotifier.value = FlPanEnd(Offset.zero);
        _releaseTouch();
      },
      onPanEnd: (DragEndDetails details) async {
        _touchInputNotifier.value = FlPanEnd(Offset.zero);
        _releaseTouch();
      },
      onPanDown: (DragDownDetails details) {
        _touchInputNotifier.value = FlPanStart(details.localPosition);
      },
      onPanUpdate: (DragUpdateDetails details) {
        _touchInputNotifier.value = FlPanMoveUpdate(details.localPosition);
      },
      child: CustomPaint(
        painter: widget.chart.painter(
          baseChartData: _baseChartDataTween.evaluate(animation),
          targetBaseChartData: widget.chart.getData(),
          touchInputNotifier: _touchInputNotifier,
          touchResponseSink: widget.chart.getData().touchData.touchResponseSink,
        ),
      ),
    );
  }

  void _releaseTouch() {
    // bugFix to this issue: https://github.com/imaNNeoFighT/fl_chart/issues/64
    // the problem is that wen user touches on screen we notify the touch result
    // via touchResponseSink, and the listener tries to change the state of chart,
    // then the chart again puts the new touchResult inside the touchResponseSink,
    // and it got stuck in a loop, now we pass a NonTouch to break the loop
    // Todo: we should find a better way to handle it
    Future<dynamic>.delayed(Duration(milliseconds: 100)).then((dynamic s) {
      _touchInputNotifier.value = NonTouch();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _touchInputNotifier.dispose();
  }

  @override
  void forEachTween(visitor) {
    _baseChartDataTween = visitor(
      _baseChartDataTween,
      widget.chart.getData(),
      (dynamic value) => BaseChartDataTween(begin: value),
    );
  }
}
