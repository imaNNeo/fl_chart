import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';

/// Renders a bar chart as a widget, using provided [BarChartData].
class BarChart extends ImplicitlyAnimatedWidget {
  /// Determines how the [BarChart] should be look like.
  final BarChartData data;

  /// [data] determines how the [BarChart] should be look like,
  /// when you make any change in the [BarChartData], it updates
  /// new values with animation, and duration is [swapAnimationDuration].
  const BarChart(
    this.data, {
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
  }) : super(duration: swapAnimationDuration);

  /// Creates a [_BarChartState]
  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends AnimatedWidgetBaseState<BarChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [BarChartData] to the new one.
  BarChartDataTween? _barChartDataTween;

  TouchHandler<BarTouchResponse>? _touchHandler;

  final GlobalKey _chartKey = GlobalKey();

  final Map<int, List<int>> _showingTouchedTooltips = {};

  @override
  Widget build(BuildContext context) {
    final showingData = _getData();
    final touchData = showingData.barTouchData;

    return MouseRegion(
      onEnter: (e) {
        final chartSize = _getChartSize();
        if (chartSize == null || _touchHandler == null) {
          return;
        }

        final response = _touchHandler!.handleTouch(FlPanStart(e.localPosition), chartSize);
        touchData.touchCallback?.call(response);
      },
      onExit: (e) {
        final chartSize = _getChartSize();
        if (chartSize == null || _touchHandler == null) {
          return;
        }

        final response = _touchHandler!.handleTouch(
            FlPanEnd(Offset.zero, const Velocity(pixelsPerSecond: Offset.zero)), chartSize);
        touchData.touchCallback?.call(response);
      },
      onHover: (e) {
        final chartSize = _getChartSize();
        if (chartSize == null || _touchHandler == null) {
          return;
        }

        final response = _touchHandler!.handleTouch(FlPanMoveUpdate(e.localPosition), chartSize);
        touchData.touchCallback?.call(response);
      },
      child: GestureDetector(
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

          final response =
              _touchHandler!.handleTouch(FlLongPressMoveUpdate(d.localPosition), chartSize);
          touchData.touchCallback?.call(response);
        },
        onPanCancel: () {
          final chartSize = _getChartSize();
          if (chartSize == null || _touchHandler == null) {
            return;
          }

          final response = _touchHandler!.handleTouch(
              FlPanEnd(Offset.zero, const Velocity(pixelsPerSecond: Offset.zero)), chartSize);
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
          painter: BarChartPainter(
            _withTouchedIndicators(_barChartDataTween!.evaluate(animation)),
            _withTouchedIndicators(showingData),
            (touchHandler) {
              setState(() {
                _touchHandler = touchHandler;
              });
            },
            textScale: MediaQuery.of(context).textScaleFactor,
          ),
        ),
      ),
    );
  }

  BarChartData _withTouchedIndicators(BarChartData barChartData) {
    if (!barChartData.barTouchData.enabled || !barChartData.barTouchData.handleBuiltInTouches) {
      return barChartData;
    }

    final newGroups = <BarChartGroupData>[];
    for (var i = 0; i < barChartData.barGroups.length; i++) {
      final group = barChartData.barGroups[i];

      newGroups.add(
        group.copyWith(
          showingTooltipIndicators: _showingTouchedTooltips[i],
        ),
      );
    }

    return barChartData.copyWith(
      barGroups: newGroups,
    );
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

  BarChartData _getData() {
    final barTouchData = widget.data.barTouchData;
    if (barTouchData.enabled && barTouchData.handleBuiltInTouches) {
      return widget.data.copyWith(
        barTouchData: widget.data.barTouchData.copyWith(touchCallback: _handleBuiltInTouch),
      );
    }
    return widget.data;
  }

  void _handleBuiltInTouch(BarTouchResponse touchResponse) {
    widget.data.barTouchData.touchCallback?.call(touchResponse);

    if (touchResponse.touchInput is FlPanStart ||
        touchResponse.touchInput is FlPanMoveUpdate ||
        touchResponse.touchInput is FlLongPressStart ||
        touchResponse.touchInput is FlLongPressMoveUpdate) {
      setState(() {
        final spot = touchResponse.spot;
        if (spot == null) {
          _showingTouchedTooltips.clear();
          return;
        }
        final groupIndex = spot.touchedBarGroupIndex;
        final rodIndex = spot.touchedRodDataIndex;

        _showingTouchedTooltips.clear();
        _showingTouchedTooltips[groupIndex] = [rodIndex];
      });
    } else {
      setState(() {
        _showingTouchedTooltips.clear();
      });
    }
  }

  @override
  void forEachTween(visitor) {
    _barChartDataTween = visitor(
      _barChartDataTween,
      widget.data,
      (dynamic value) => BarChartDataTween(begin: value, end: widget.data),
    ) as BarChartDataTween;
  }
}
