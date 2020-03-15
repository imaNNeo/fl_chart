import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_data.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_painter.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';

/// Renders a pie chart as a widget, using provided [ScatterChartData].
class ScatterChart extends ImplicitlyAnimatedWidget {

  /// Determines how the [ScatterChart] should be look like.
  final ScatterChartData data;

  /// [data] determines how the [ScatterChart] should be look like,
  /// when you make any change in the [ScatterChartData], it updates
  /// new values with animation, and duration is [swapAnimationDuration].
  const ScatterChart(
    this.data, {
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
  }) : super(duration: swapAnimationDuration);

  @override
  _ScatterChartState createState() => _ScatterChartState();
}

class _ScatterChartState extends AnimatedWidgetBaseState<ScatterChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [ScatterChartData] to the new one.
  ScatterChartDataTween _scatterChartDataTween;

  TouchHandler<ScatterTouchResponse> _touchHandler;

  final GlobalKey _chartKey = GlobalKey();

  List<int> touchedSpots = [];

  @override
  Widget build(BuildContext context) {
    final ScatterChartData showingData = _getDate();
    final ScatterTouchData touchData = showingData.scatterTouchData;

    return GestureDetector(
      onLongPressStart: (d) {
        final Size chartSize = _getChartSize();
        if (chartSize == null) {
          return;
        }

        final ScatterTouchResponse response =
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

        final ScatterTouchResponse response =
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

        final ScatterTouchResponse response =
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

        final ScatterTouchResponse response = _touchHandler?.handleTouch(
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

        final ScatterTouchResponse response =
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

        final ScatterTouchResponse response =
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

        final ScatterTouchResponse response =
            _touchHandler?.handleTouch(FlPanMoveUpdate(details.localPosition), chartSize);
        if (_canHandleTouch(response, touchData)) {
          touchData.touchCallback(response);
        }
      },
      child: CustomPaint(
        key: _chartKey,
        size: getDefaultSize(MediaQuery.of(context).size),
        painter: ScatterChartPainter(
          _withTouchedIndicators(_scatterChartDataTween.evaluate(animation)),
          _withTouchedIndicators(showingData),
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

  bool _canHandleTouch(ScatterTouchResponse response, ScatterTouchData touchData) {
    return response != null && touchData != null && touchData.touchCallback != null;
  }

  ScatterChartData _withTouchedIndicators(ScatterChartData scatterChartData) {
    if (scatterChartData == null) {
      return scatterChartData;
    }

    if (!scatterChartData.scatterTouchData.enabled ||
        !scatterChartData.scatterTouchData.handleBuiltInTouches) {
      return scatterChartData;
    }

    return scatterChartData.copyWith(
      showingTooltipIndicators: touchedSpots,
    );
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

  ScatterChartData _getDate() {
    final scatterTouchData = widget.data.scatterTouchData;
    if (scatterTouchData.enabled && scatterTouchData.handleBuiltInTouches) {
      return widget.data.copyWith(
        scatterTouchData: widget.data.scatterTouchData.copyWith(touchCallback: _handleBuiltInTouch),
      );
    }
    return widget.data;
  }

  void _handleBuiltInTouch(ScatterTouchResponse touchResponse) {
    if (widget.data.scatterTouchData.touchCallback != null) {
      widget.data.scatterTouchData.touchCallback(touchResponse);
    }

    if (touchResponse.touchInput is FlPanStart ||
        touchResponse.touchInput is FlPanMoveUpdate ||
        touchResponse.touchInput is FlLongPressStart ||
        touchResponse.touchInput is FlLongPressMoveUpdate) {
      setState(() {
        touchedSpots.clear();
        touchedSpots.add(touchResponse.touchedSpotIndex);
      });
    } else {
      setState(() {
        touchedSpots.clear();
      });
    }
  }

  @override
  void forEachTween(visitor) {
    _scatterChartDataTween = visitor(
      _scatterChartDataTween,
      _getDate(),
      (dynamic value) => ScatterChartDataTween(begin: value),
    );
  }
}
