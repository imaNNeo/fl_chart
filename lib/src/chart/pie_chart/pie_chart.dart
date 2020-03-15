import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
import 'package:fl_chart/src/chart/pie_chart/pie_chart_painter.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';

import 'pie_chart_data.dart';

/// Renders a pie chart as a widget, using provided [PieChartData].
class PieChart extends ImplicitlyAnimatedWidget {

  /// Determines how the [PieChart] should be look like.
  final PieChartData data;

  /// [data] determines how the [PieChart] should be look like,
  /// when you make any change in the [PieChartData], it updates
  /// new values with animation, and duration is [swapAnimationDuration].
  const PieChart(
    this.data, {
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
  }) : super(duration: swapAnimationDuration);

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends AnimatedWidgetBaseState<PieChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [PieChartData] to the new one.
  PieChartDataTween _pieChartDataTween;

  /// this is used to map the touch events to [PieTouchResponse]
  TouchHandler _touchHandler;

  /// this is used to retrieve the chart size to handle the touches
  final GlobalKey _chartKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final PieChartData showingData = _getDate();
    final PieTouchData touchData = showingData.pieTouchData;

    return GestureDetector(
      onLongPressStart: (d) {
        final Size chartSize = _getChartSize();
        if (chartSize == null) {
          return;
        }
        final PieTouchResponse response =
            _touchHandler?.handleTouch(FlLongPressStart(d.localPosition), chartSize);
        if (_canHandleTouch(response, touchData)) {
          touchData.touchCallback(response);
        }
      },
      onLongPressEnd: (d) {
        final Size chartSize = _getChartSize();
        if (chartSize == null) {
          return;
        }

        final PieTouchResponse response =
            _touchHandler?.handleTouch(FlLongPressEnd(d.localPosition), chartSize);
        if (_canHandleTouch(response, touchData)) {
          touchData.touchCallback(response);
        }
      },
      onLongPressMoveUpdate: (d) {
        final Size chartSize = _getChartSize();
        if (chartSize == null) {
          return;
        }

        final PieTouchResponse response =
            _touchHandler?.handleTouch(FlLongPressMoveUpdate(d.localPosition), chartSize);
        if (_canHandleTouch(response, touchData)) {
          touchData.touchCallback(response);
        }
      },
      onPanCancel: () {
        final Size chartSize = _getChartSize();
        if (chartSize == null) {
          return;
        }

        final PieTouchResponse response = _touchHandler?.handleTouch(
            FlPanEnd(Offset.zero, Velocity(pixelsPerSecond: Offset.zero)), chartSize);
        if (_canHandleTouch(response, touchData)) {
          touchData.touchCallback(response);
        }
      },
      onPanEnd: (DragEndDetails details) {
        final Size chartSize = _getChartSize();
        if (chartSize == null) {
          return;
        }

        final PieTouchResponse response =
            _touchHandler?.handleTouch(FlPanEnd(Offset.zero, details.velocity), chartSize);
        if (_canHandleTouch(response, touchData)) {
          touchData.touchCallback(response);
        }
      },
      onPanDown: (DragDownDetails details) {
        final Size chartSize = _getChartSize();
        if (chartSize == null) {
          return;
        }

        final PieTouchResponse response =
            _touchHandler?.handleTouch(FlPanStart(details.localPosition), chartSize);
        if (_canHandleTouch(response, touchData)) {
          touchData.touchCallback(response);
        }
      },
      onPanUpdate: (DragUpdateDetails details) {
        final Size chartSize = _getChartSize();
        if (chartSize == null) {
          return;
        }

        final PieTouchResponse response =
            _touchHandler?.handleTouch(FlPanMoveUpdate(details.localPosition), chartSize);
        if (_canHandleTouch(response, touchData)) {
          touchData.touchCallback(response);
        }
      },
      child: CustomPaint(
        key: _chartKey,
        size: getDefaultSize(MediaQuery.of(context).size),
        painter: PieChartPainter(
          _pieChartDataTween.evaluate(animation),
          showingData,
          (touchHandler) {
            setState(() {
              _touchHandler = touchHandler;
            });
          },
          textScale: MediaQuery.of(context).textScaleFactor,
        ),
      ),
    );
  }

  bool _canHandleTouch(PieTouchResponse response, PieTouchData touchData) {
    return response != null && touchData != null && touchData.touchCallback != null;
  }

  Size _getChartSize() {
    if (_chartKey.currentContext != null) {
      final RenderBox containerRenderBox = _chartKey.currentContext.findRenderObject();
      if (containerRenderBox.hasSize) {
        return containerRenderBox.size;
      }
      return null;
    } else {
      return null;
    }
  }

  /// if builtIn touches are enabled, we should recreate our [pieChartData]
  /// to handle built in touches
  PieChartData _getDate() {
    return widget.data;
  }

  @override
  void forEachTween(visitor) {
    _pieChartDataTween = visitor(
      _pieChartDataTween,
      widget.data,
      (dynamic value) => PieChartDataTween(begin: value),
    );
  }
}
