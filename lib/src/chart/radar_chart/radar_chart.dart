import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_data.dart';
import 'package:fl_chart/src/chart/radar_chart/radar_chart_painter.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';

/// Renders a radar chart as a widget, using provided [RadarChartData].
class RadarChart extends ImplicitlyAnimatedWidget {
  /// Determines how the [RadarChart] should be look like.
  final RadarChartData data;

  /// [data] determines how the [RadarChart] should be look like,
  /// when you make any change in the [RadarChart], it updates
  /// new values with animation, and duration is [swapAnimationDuration].
  const RadarChart(
    this.data, {
    Key? key,
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
  }) : super(key: key, duration: swapAnimationDuration);

  @override
  _RadarChartState createState() => _RadarChartState();
}

class _RadarChartState extends AnimatedWidgetBaseState<RadarChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [RadarChartData] to the new one.
  RadarChartDataTween? _radarChartDataTween;

  /// this is used to map the touch events to [RadarChartResponse]
  TouchHandler<RadarTouchResponse>? _touchHandler;

  /// this is used to retrieve the chart size to handle the touches
  final GlobalKey _chartKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final showingData = _getDate();
    final touchData = showingData.radarTouchData;

    return GestureDetector(
      onLongPressStart: (d) {
        final chartSize = _getChartSize();
        if (chartSize == null || _touchHandler == null) {
          return;
        }

        final response = _touchHandler!.handleTouch(FlLongPressStart(d.localPosition), chartSize);
        touchData.touchCallback?.call(response);
      },
      onLongPressEnd: (d) {
        final chartSize = _getChartSize();
        if (chartSize == null || _touchHandler == null) {
          return;
        }

        final response = _touchHandler!.handleTouch(FlLongPressEnd(d.localPosition), chartSize);
        touchData.touchCallback?.call(response);
      },
      onLongPressMoveUpdate: (d) {
        final chartSize = _getChartSize();
        if (chartSize == null || _touchHandler == null) {
          return;
        }

        final response = _touchHandler!.handleTouch(
          FlLongPressMoveUpdate(d.localPosition),
          chartSize,
        );
        touchData.touchCallback?.call(response);
      },
      onPanCancel: () {
        final chartSize = _getChartSize();
        if (chartSize == null || _touchHandler == null) {
          return;
        }

        final response = _touchHandler!.handleTouch(
          FlPanEnd(Offset.zero, const Velocity(pixelsPerSecond: Offset.zero)),
          chartSize,
        );
        touchData.touchCallback?.call(response);
      },
      onPanEnd: (DragEndDetails details) {
        final chartSize = _getChartSize();
        if (chartSize == null || _touchHandler == null) {
          return;
        }

        final response =
            _touchHandler!.handleTouch(FlPanEnd(Offset.zero, details.velocity), chartSize);
        touchData.touchCallback?.call(response);
      },
      onPanDown: (DragDownDetails details) {
        final chartSize = _getChartSize();
        if (chartSize == null || _touchHandler == null) {
          return;
        }

        final response = _touchHandler!.handleTouch(FlPanStart(details.localPosition), chartSize);
        touchData.touchCallback?.call(response);
      },
      onPanUpdate: (DragUpdateDetails details) {
        final chartSize = _getChartSize();
        if (chartSize == null || _touchHandler == null) {
          return;
        }

        final response =
            _touchHandler!.handleTouch(FlPanMoveUpdate(details.localPosition), chartSize);
        touchData.touchCallback?.call(response);
      },
      child: CustomPaint(
        key: _chartKey,
        size: getDefaultSize(MediaQuery.of(context).size),
        painter: RadarChartPainter(
          _radarChartDataTween!.evaluate(animation),
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

  RadarChartData _getDate() {
    return widget.data;
  }

  Size? _getChartSize() {
    final containerRenderBox = _chartKey.currentContext?.findRenderObject();
    if (containerRenderBox == null || containerRenderBox is! RenderBox) {
      return null;
    }
    if (containerRenderBox.hasSize) {
      return containerRenderBox.size;
    }
    return null;
  }

  @override
  void forEachTween(visitor) {
    _radarChartDataTween = visitor(
      _radarChartDataTween,
      widget.data,
      (dynamic value) => RadarChartDataTween(begin: value, end: widget.data),
    ) as RadarChartDataTween;
  }
}
