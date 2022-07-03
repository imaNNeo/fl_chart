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
    Key? key,
    Duration swapAnimationDuration = defaultDuration,
    Curve swapAnimationCurve = Curves.linear,
  }) : super(
            key: key,
            duration: swapAnimationDuration,
            curve: swapAnimationCurve);

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
    _ambiguate(WidgetsBinding.instance)!.addPostFrameCallback((timeStamp) {
      if (mounted) {
        setState(() {});
      }
    });

    super.initState();
  }

  /// This allows a value of type T or T? to be treated as a value of type T?.
  ///
  /// We use this so that APIs that have become non-nullable can still be used
  /// with `!` and `?` to support older versions of the API as well.
  T? _ambiguate<T>(T? value) => value;

  @override
  Widget build(BuildContext context) {
    final showingData = _getData();

    return PieChartLeaf(
      data: _pieChartDataTween!.evaluate(animation),
      targetData: showingData,
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
      final key = badgeWidgetsOffsets.keys.elementAt(index);

      final finalSize = layoutChild(
        key,
        BoxConstraints(
          maxWidth: size.width,
          maxHeight: size.height,
        ),
      );

      positionChild(
        key,
        Offset(
          badgeWidgetsOffsets[key]!.dx - (finalSize.width / 2),
          badgeWidgetsOffsets[key]!.dy - (finalSize.height / 2),
        ),
      );
    }
  }

  @override
  bool shouldRelayout(BadgeWidgetsDelegate oldDelegate) {
    return oldDelegate.badgeWidgetsOffsets != badgeWidgetsOffsets;
  }
}
