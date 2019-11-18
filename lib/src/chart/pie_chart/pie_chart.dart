import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/touch_input.dart';
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
  /// it lerps between the old [PieChartData] to the new one.
  PieChartDataTween _pieChartDataTween;

  /// this is used to map the touch events to [PieTouchResponse]
  TouchHandler _touchHandler;

  /// this is used to retrieve the chart size to handle the touches
  final GlobalKey _chartKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final PieChartData showingData = _getDate();
    final Size chartSize = _getChartSize();
    final PieTouchData touchData = showingData.pieTouchData;

    return GestureDetector(
      onLongPressStart: (d) {
        final PieTouchResponse response =
            _touchHandler?.handleTouch(FlLongPressStart(d.localPosition), chartSize);
        if (_canHandleTouch(response, touchData)) {
          touchData.touchCallback(response);
        }
      },
      onLongPressEnd: (d) async {
        final PieTouchResponse response =
            _touchHandler?.handleTouch(FlLongPressEnd(d.localPosition), chartSize);
        if (_canHandleTouch(response, touchData)) {
          touchData.touchCallback(response);
        }
      },
      onLongPressMoveUpdate: (d) {
        final PieTouchResponse response =
            _touchHandler?.handleTouch(FlLongPressMoveUpdate(d.localPosition), chartSize);
        if (_canHandleTouch(response, touchData)) {
          touchData.touchCallback(response);
        }
      },
      onPanCancel: () async {
        final PieTouchResponse response =
            _touchHandler?.handleTouch(FlPanEnd(Offset.zero), chartSize);
        if (_canHandleTouch(response, touchData)) {
          touchData.touchCallback(response);
        }
      },
      onPanEnd: (DragEndDetails details) async {
        final PieTouchResponse response =
            _touchHandler?.handleTouch(FlPanEnd(Offset.zero), chartSize);
        if (_canHandleTouch(response, touchData)) {
          touchData.touchCallback(response);
        }
      },
      onPanDown: (DragDownDetails details) {
        final PieTouchResponse response =
            _touchHandler?.handleTouch(FlPanStart(details.localPosition), chartSize);
        if (_canHandleTouch(response, touchData)) {
          touchData.touchCallback(response);
        }
      },
      onPanUpdate: (DragUpdateDetails details) {
        final PieTouchResponse response =
            _touchHandler?.handleTouch(FlPanMoveUpdate(details.localPosition), chartSize);
        if (_canHandleTouch(response, touchData)) {
          touchData.touchCallback(response);
        }
      },
      child: CustomPaint(
        key: _chartKey,
        size: getDefaultSize(context),
        painter: PieChartPainter(
          _pieChartDataTween.evaluate(animation),
          showingData,
          (touchHandler) {
            setState(() {
              _touchHandler = touchHandler;
            });
          },
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
      return containerRenderBox.constraints.biggest;
    } else {
      return getDefaultSize(context);
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
