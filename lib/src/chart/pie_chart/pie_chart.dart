import 'package:fl_chart/src/chart/pie_chart/pie_chart_renderer.dart';
import 'package:flutter/material.dart';

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
  /// also you can change the [swapAnimationCurve]
  /// which default is [Curves.linear].
  const PieChart(
    this.data, {
    Duration swapAnimationDuration = defaultDuration,
    Curve swapAnimationCurve = Curves.linear,
  }) : super(duration: swapAnimationDuration, curve: swapAnimationCurve);

  /// Creates a [_PieChartState]
  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends AnimatedWidgetBaseState<PieChart> {
  /// We handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [PieChartData] to the new one.
  PieChartDataTween? _pieChartDataTween;

  @override
  void initState() {
    /// Make sure that [_widgetsPositionHandler] is updated.
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final showingData = _getData();

    /// Wr wrapped our chart with [GestureDetector], and onLongPressStart callback.
    /// because we wanted to lock the widget from being scrolled when user long presses on it.
    /// If we found a solution for solve this issue, then we can remove this undoubtedly.
    return GestureDetector(
      onLongPressStart: (details) {},
      child: PieChartLeaf(
        data: _pieChartDataTween!.evaluate(animation),
        targetData: showingData,
        touchCallback: (response) {
          showingData.pieTouchData.touchCallback?.call(response);
        },
      ),
    );
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
      (dynamic value) => PieChartDataTween(begin: value, end: widget.data),
    ) as PieChartDataTween;
  }
}

/// Positions the badge widgets on their respective sections.
class BadgeWidgetsDelegate extends MultiChildLayoutDelegate {
  final int badgeWidgetsCount;
  final Map<int, Offset> badgeWidgetsOffsets;

  BadgeWidgetsDelegate({
    required this.badgeWidgetsCount,
    required this.badgeWidgetsOffsets,
  });

  @override
  void performLayout(Size size) {
    for (var index = 0; index < badgeWidgetsCount; index++) {
      final _key = badgeWidgetsOffsets.keys.elementAt(index);

      final _size = layoutChild(
        _key,
        BoxConstraints(
          maxWidth: size.width,
          maxHeight: size.height,
        ),
      );

      positionChild(
        _key,
        Offset(
          badgeWidgetsOffsets[_key]!.dx - (_size.width / 2),
          badgeWidgetsOffsets[_key]!.dy - (_size.height / 2),
        ),
      );
    }
  }

  @override
  bool shouldRelayout(BadgeWidgetsDelegate oldDelegate) {
    return oldDelegate.badgeWidgetsOffsets != badgeWidgetsOffsets;
  }
}
