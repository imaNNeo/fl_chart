import 'package:flutter/material.dart';

import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
import 'package:fl_chart/src/chart/pie_chart/pie_chart_painter.dart';
import 'package:fl_chart/src/utils/utils.dart';

import 'pie_chart_data.dart';

/// Renders a pie chart as a widget, using provided [PieChartData].
class PieChart extends ImplicitlyAnimatedWidget {
  /// Default duration to reuse externally.
  static const defaultDuration = Duration(milliseconds: 150);

  /// Determines how the [PieChart] should be look like.
  final PieChartData data;

  /// [data] determines how the [PieChart] should be look like,
  /// when you make any change in the [PieChartData], it updates
  /// new values with animation, and duration is [swapAnimationDuration].
  const PieChart(
    this.data, {
    Duration swapAnimationDuration = defaultDuration,
  }) : super(duration: swapAnimationDuration);

  /// Creates a [_PieChartState]
  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends AnimatedWidgetBaseState<PieChart> {
  /// We handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [PieChartData] to the new one.
  PieChartDataTween _pieChartDataTween;

  /// This is used to map the touch events to [PieTouchResponse]
  TouchHandler _touchHandler;

  /// For storing the badge widgets' offsets.
  Map<int, Offset> _badgeWidgetsOffsets = <int, Offset>{};

  /// this is used to retrieve the chart size to handle the touches
  final GlobalKey _chartKey = GlobalKey();

  @override
  void initState() {
    /// Make sure that [_badgeWidgetsOffsets] is updated.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PieChartData showingData = _getData();
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
            FlPanEnd(Offset.zero, const Velocity(pixelsPerSecond: Offset.zero)), chartSize);
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
          badgeWidgetsOffsetsProvider: (offsetsMap) {
            /// Store badge widget offsets from painter.
            _badgeWidgetsOffsets = Map.from(offsetsMap);
          },
        ),
        child: _badgeWidgetsOffsets.isEmpty
            ? null
            : CustomMultiChildLayout(
                delegate: BadgeWidgetsDelegate(
                  badgeWidgetsCount: _badgeWidgetsOffsets.length,
                  badgeWidgetsOffsets: _badgeWidgetsOffsets,
                ),
                children: List.generate(
                  _badgeWidgetsOffsets.length,
                  (index) {
                    final int _key = _badgeWidgetsOffsets.keys.elementAt(index);
                    final Widget _badgeWidget = widget.data.sections[_key].badgeWidget;

                    if (_badgeWidget == null) {
                      return null;
                    }

                    return LayoutId(
                      id: _key,
                      child: _badgeWidget,
                    );
                  },
                ),
              ),
      ),
    );
  }

  bool _canHandleTouch(PieTouchResponse response, PieTouchData touchData) {
    return response != null && touchData != null && touchData.touchCallback != null;
  }

  Size _getChartSize() {
    final RenderBox containerRenderBox = _chartKey.currentContext?.findRenderObject();
    if (containerRenderBox != null && containerRenderBox.hasSize) {
      return containerRenderBox.size;
    }
    return null;
  }

  /// if builtIn touches are enabled, we should recreate our [pieChartData]
  /// to handle built in touches
  PieChartData _getData() {
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

/// Positions the badge widgets on their respective sections.
class BadgeWidgetsDelegate extends MultiChildLayoutDelegate {
  final int badgeWidgetsCount;
  final Map<int, Offset> badgeWidgetsOffsets;

  BadgeWidgetsDelegate({
    this.badgeWidgetsCount,
    this.badgeWidgetsOffsets,
  });

  @override
  void performLayout(Size size) {
    for (int index = 0; index < badgeWidgetsCount; index++) {
      final int _key = badgeWidgetsOffsets.keys.elementAt(index);

      final Size _size = layoutChild(
        _key,
        BoxConstraints(
          maxWidth: size.width,
          maxHeight: size.height,
        ),
      );

      positionChild(
        _key,
        Offset(
          badgeWidgetsOffsets[_key].dx - (_size.width / 2),
          badgeWidgetsOffsets[_key].dy - (_size.height / 2),
        ),
      );
    }
  }

  @override
  bool shouldRelayout(BadgeWidgetsDelegate oldDelegate) {
    return oldDelegate.badgeWidgetsOffsets != badgeWidgetsOffsets;
  }
}
