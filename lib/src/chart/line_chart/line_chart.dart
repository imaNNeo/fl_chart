import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';

import 'line_chart_data.dart';
import 'line_chart_painter.dart';

/// Renders a line chart as a widget, using provided [LineChartData].
class LineChart extends ImplicitlyAnimatedWidget {
  /// Determines how the [LineChart] should be look like.
  final LineChartData data;

  /// [data] determines how the [LineChart] should be look like,
  /// when you make any change in the [LineChartData], it updates
  /// new values with animation, and duration is [swapAnimationDuration].
  const LineChart(
    this.data, {
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
  }) : super(duration: swapAnimationDuration);

  /// Creates a [_LineChartState]
  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends AnimatedWidgetBaseState<LineChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [LineChartData] to the new one.
  LineChartDataTween _lineChartDataTween;

  TouchHandler _touchHandler;

  final GlobalKey _chartKey = GlobalKey();

  final List<ShowingTooltipIndicators> _showingTouchedTooltips = [];

  final Map<int, List<int>> _showingTouchedIndicators = {};

  @override
  Widget build(BuildContext context) {
    final showingData = _getData();
    final touchData = showingData.lineTouchData;

    return MouseRegion(
      onEnter: (e) {
        final chartSize = _getChartSize();
        if (chartSize == null) {
          return;
        }

        final LineTouchResponse response =
            _touchHandler?.handleTouch(FlPanStart(e.localPosition), chartSize);
        if (_canHandleTouch(response, touchData)) {
          touchData.touchCallback(response);
        }
      },
      onExit: (e) {
        final chartSize = _getChartSize();
        if (chartSize == null) {
          return;
        }

        final LineTouchResponse response =
            _touchHandler?.handleTouch(FlPanEnd(Offset.zero, Velocity.zero), chartSize);
        if (_canHandleTouch(response, touchData)) {
          touchData.touchCallback(response);
        }
      },
      onHover: (e) {
        final chartSize = _getChartSize();
        if (chartSize == null) {
          return;
        }

        final LineTouchResponse response =
            _touchHandler?.handleTouch(FlPanMoveUpdate(e.localPosition), chartSize);
        if (_canHandleTouch(response, touchData)) {
          touchData.touchCallback(response);
        }
      },
      child: GestureDetector(
        onLongPressStart: (d) {
          final chartSize = _getChartSize();
          if (chartSize == null) {
            return;
          }

          final LineTouchResponse response =
              _touchHandler?.handleTouch(FlLongPressStart(d.localPosition), chartSize);
          if (_canHandleTouch(response, touchData)) {
            touchData.touchCallback(response);
          }
        },
        onLongPressEnd: (d) {
          final chartSize = _getChartSize();
          if (chartSize == null) {
            return;
          }

          final LineTouchResponse response =
              _touchHandler?.handleTouch(FlLongPressEnd(d.localPosition), chartSize);
          if (_canHandleTouch(response, touchData)) {
            touchData.touchCallback(response);
          }
        },
        onLongPressMoveUpdate: (d) {
          final chartSize = _getChartSize();
          if (chartSize == null) {
            return;
          }

          final LineTouchResponse response =
              _touchHandler?.handleTouch(FlLongPressMoveUpdate(d.localPosition), chartSize);
          if (_canHandleTouch(response, touchData)) {
            touchData.touchCallback(response);
          }
        },
        onPanCancel: () {
          final chartSize = _getChartSize();
          if (chartSize == null) {
            return;
          }

          final LineTouchResponse response = _touchHandler?.handleTouch(
              FlPanEnd(Offset.zero, const Velocity(pixelsPerSecond: Offset.zero)), chartSize);
          if (_canHandleTouch(response, touchData)) {
            touchData.touchCallback(response);
          }
        },
        onPanEnd: (DragEndDetails details) {
          final chartSize = _getChartSize();
          if (chartSize == null) {
            return;
          }

          final LineTouchResponse response =
              _touchHandler?.handleTouch(FlPanEnd(Offset.zero, details.velocity), chartSize);
          if (_canHandleTouch(response, touchData)) {
            touchData.touchCallback(response);
          }
        },
        onPanDown: (DragDownDetails details) {
          final chartSize = _getChartSize();
          if (chartSize == null) {
            return;
          }

          final LineTouchResponse response =
              _touchHandler?.handleTouch(FlPanStart(details.localPosition), chartSize);
          if (_canHandleTouch(response, touchData)) {
            touchData.touchCallback(response);
          }
        },
        onPanUpdate: (DragUpdateDetails details) {
          final chartSize = _getChartSize();
          if (chartSize == null) {
            return;
          }

          final LineTouchResponse response =
              _touchHandler?.handleTouch(FlPanMoveUpdate(details.localPosition), chartSize);
          if (_canHandleTouch(response, touchData)) {
            touchData.touchCallback(response);
          }
        },
        child: CustomPaint(
          key: _chartKey,
          size: getDefaultSize(MediaQuery.of(context).size),
          painter: LineChartPainter(_withTouchedIndicators(_lineChartDataTween.evaluate(animation)),
              _withTouchedIndicators(showingData), (touchHandler) {
            setState(() {
              _touchHandler = touchHandler;
            });
          }, textScale: MediaQuery.of(context).textScaleFactor),
        ),
      ),
    );
  }

  bool _canHandleTouch(LineTouchResponse response, LineTouchData touchData) {
    return response != null && touchData != null && touchData.touchCallback != null;
  }

  LineChartData _withTouchedIndicators(LineChartData lineChartData) {
    if (lineChartData == null) {
      return lineChartData;
    }

    if (!lineChartData.lineTouchData.enabled || !lineChartData.lineTouchData.handleBuiltInTouches) {
      return lineChartData;
    }

    return lineChartData.copyWith(
      showingTooltipIndicators: _showingTouchedTooltips,
      lineBarsData: lineChartData.lineBarsData.map((barData) {
        final index = lineChartData.lineBarsData.indexOf(barData);
        return barData.copyWith(
          showingIndicators: _showingTouchedIndicators[index] ?? [],
        );
      }).toList(),
    );
  }

  Size _getChartSize() {
    final RenderBox containerRenderBox = _chartKey.currentContext?.findRenderObject();
    if (containerRenderBox != null && containerRenderBox.hasSize) {
      return containerRenderBox.size;
    }
    return null;
  }

  LineChartData _getData() {
    final lineTouchData = widget.data.lineTouchData;
    if (lineTouchData.enabled && lineTouchData.handleBuiltInTouches) {
      return widget.data.copyWith(
        lineTouchData: widget.data.lineTouchData.copyWith(touchCallback: _handleBuiltInTouch),
      );
    }
    return widget.data;
  }

  void _handleBuiltInTouch(LineTouchResponse touchResponse) {
    if (widget.data.lineTouchData.touchCallback != null) {
      widget.data.lineTouchData.touchCallback(touchResponse);
    }

    if (touchResponse.touchInput is FlPanStart ||
        touchResponse.touchInput is FlPanMoveUpdate ||
        touchResponse.touchInput is FlLongPressStart ||
        touchResponse.touchInput is FlLongPressMoveUpdate) {
      setState(() {
        final sortedLineSpots = List.of(touchResponse.lineBarSpots);
        sortedLineSpots.sort((spot1, spot2) => spot2.y.compareTo(spot1.y));

        _showingTouchedIndicators.clear();
        for (var i = 0; i < touchResponse.lineBarSpots.length; i++) {
          final touchedBarSpot = touchResponse.lineBarSpots[i];
          final barPos = touchedBarSpot.barIndex;
          _showingTouchedIndicators[barPos] = [touchedBarSpot.spotIndex];
        }

        _showingTouchedTooltips.clear();
        _showingTouchedTooltips.add(ShowingTooltipIndicators(0, sortedLineSpots));
      });
    } else {
      setState(() {
        _showingTouchedTooltips.clear();
        _showingTouchedIndicators.clear();
      });
    }
  }

  @override
  void forEachTween(visitor) {
    _lineChartDataTween = visitor(
      _lineChartDataTween,
      _getData(),
      (dynamic value) => LineChartDataTween(begin: value),
    );
  }
}
