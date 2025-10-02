import 'package:fl_chart/src/chart/stacked_pie_chart/stacked_pie_chart_data.dart';
import 'package:fl_chart/src/chart/stacked_pie_chart/stacked_pie_chart_renderer.dart';
import 'package:flutter/material.dart';

/// Renders a stacked pie chart as a widget, using provided [StackedPieChartData].
class StackedPieChart extends ImplicitlyAnimatedWidget {
  /// [data] defines the look of [StackedPieChart].
  /// When you make any change in the [StackedPieChartData], it updates
  /// new values with animation, and duration is [duration].
  /// also you can change the [curve]
  /// which default is [Curves.linear].
  const StackedPieChart(
    this.data, {
    super.key,
    super.duration = const Duration(milliseconds: 150),
    super.curve = Curves.linear,
  });

  /// Default duration to reuse externally.
  static const defaultDuration = Duration(milliseconds: 150);

  /// Determines how the [StackedPieChart] should be look like.
  final StackedPieChartData data;

  /// Creates a [_StackedPieChartState]
  @override
  _StackedPieChartState createState() => _StackedPieChartState();
}

class _StackedPieChartState extends AnimatedWidgetBaseState<StackedPieChart> {
  StackedPieChartDataTween? _stackedPieChartDataTween;

  @override
  void initState() {
    /// Make sure that [_widgetsPositionHandler] is updated.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final showingData = _getData();

    return StackedPieChartLeaf(
      data: _stackedPieChartDataTween!.evaluate(animation),
      targetData: showingData,
    );
  }

  /// if builtIn touches are enabled, we should recreate our [pieChartData]
  /// to handle built in touches
  StackedPieChartData _getData() {
    return widget.data;
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _stackedPieChartDataTween = visitor(
      _stackedPieChartDataTween,
      widget.data,
      (dynamic value) => StackedPieChartDataTween(
          begin: value as StackedPieChartData, end: widget.data),
    ) as StackedPieChartDataTween?;
  }
}

// TODO: implement BadgeWidgetsDelegate?
