import 'package:fl_chart/src/chart/bar_chart/bar_chart_data.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_helper.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_renderer.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_scaffold_widget.dart';
import 'package:fl_chart/src/chart/base/axis_chart/scale_axis.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/fl_touch_event.dart';
import 'package:flutter/cupertino.dart';

/// Renders a bar chart as a widget, using provided [BarChartData].
class BarChart extends ImplicitlyAnimatedWidget {
  /// [data] determines how the [BarChart] should be look like,
  /// when you make any change in the [BarChartData], it updates
  /// new values with animation, and duration is [duration].
  /// also you can change the [curve]
  /// which default is [Curves.linear].
  BarChart(
    this.data, {
    this.chartRendererKey,
    super.key,
    @Deprecated('Please use [duration] instead')
    Duration? swapAnimationDuration,
    Duration duration = const Duration(milliseconds: 150),
    @Deprecated('Please use [curve] instead') Curve? swapAnimationCurve,
    Curve curve = Curves.linear,
    this.transformationController,
    this.scaleAxis = ScaleAxis.none,
    this.maxScale = 2.5,
    this.minScale = 1,
    this.trackpadScrollCausesScale = false,
  })  : assert(
          switch (data.alignment) {
            BarChartAlignment.center ||
            BarChartAlignment.end ||
            BarChartAlignment.start =>
              scaleAxis != ScaleAxis.horizontal && scaleAxis != ScaleAxis.free,
            _ => true,
          },
          'Can not scale horizontally when BarChartAlignment is center, '
          'end or start',
        ),
        super(
          duration: swapAnimationDuration ?? duration,
          curve: swapAnimationCurve ?? curve,
        );

  /// Determines how the [BarChart] should be look like.
  final BarChartData data;

  /// The transformation controller to control the transformation of the chart.
  final TransformationController? transformationController;

  /// We pass this key to our renderers which are supposed to
  /// render the chart itself (without anything around the chart).
  final Key? chartRendererKey;

  /// Determines what axis should be scaled.
  final ScaleAxis scaleAxis;

  /// The maximum scale of the chart.
  ///
  /// Ignored when [scaleAxis] is [ScaleAxis.none].
  final double maxScale;

  /// The minimum scale of the chart.
  ///
  /// Ignored when [scaleAxis] is [ScaleAxis.none].
  final double minScale;

  /// Whether trackpad scroll causes scale.
  ///
  /// Ignored when [scaleAxis] is [ScaleAxis.none].
  final bool trackpadScrollCausesScale;

  /// Creates a [_BarChartState]
  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends AnimatedWidgetBaseState<BarChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [BarChartData] to the new one.
  BarChartDataTween? _barChartDataTween;

  /// If [BarTouchData.handleBuiltInTouches] is true, we override the callback to handle touches internally,
  /// but we need to keep the provided callback to notify it too.
  BaseTouchCallback<BarTouchResponse>? _providedTouchCallback;

  final Map<int, List<int>> _showingTouchedTooltips = {};

  final _barChartHelper = BarChartHelper();

  @override
  Widget build(BuildContext context) {
    final showingData = _getData();

    return AxisChartScaffoldWidget(
      data: showingData,
      transformationController: widget.transformationController,
      scaleAxis: widget.scaleAxis,
      maxScale: widget.maxScale,
      minScale: widget.minScale,
      trackpadScrollCausesScale: widget.trackpadScrollCausesScale,
      chartBuilder: (context, chartRect) => BarChartLeaf(
        data: _withTouchedIndicators(_barChartDataTween!.evaluate(animation)),
        targetData: _withTouchedIndicators(showingData),
        key: widget.chartRendererKey,
        boundingBox: chartRect,
        canBeScaled: widget.scaleAxis != ScaleAxis.none,
      ),
    );
  }

  BarChartData _withTouchedIndicators(BarChartData barChartData) {
    if (!barChartData.barTouchData.enabled ||
        !barChartData.barTouchData.handleBuiltInTouches) {
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

  BarChartData _getData() {
    var newData = widget.data;
    if (newData.minY.isNaN || newData.maxY.isNaN) {
      final (minY, maxY) =
          _barChartHelper.calculateMaxAxisValues(newData.barGroups);
      newData = newData.copyWith(
        minY: newData.minY.isNaN ? minY : newData.minY,
        maxY: newData.maxY.isNaN ? maxY : newData.maxY,
      );
    }

    final barTouchData = newData.barTouchData;
    if (barTouchData.enabled && barTouchData.handleBuiltInTouches) {
      _providedTouchCallback = barTouchData.touchCallback;
      return newData.copyWith(
        barTouchData:
            newData.barTouchData.copyWith(touchCallback: _handleBuiltInTouch),
      );
    }
    return newData;
  }

  void _handleBuiltInTouch(
    FlTouchEvent event,
    BarTouchResponse? touchResponse,
  ) {
    if (!mounted) {
      return;
    }
    _providedTouchCallback?.call(event, touchResponse);

    if (!event.isInterestedForInteractions ||
        touchResponse == null ||
        touchResponse.spot == null) {
      setState(_showingTouchedTooltips.clear);
      return;
    }
    setState(() {
      final spot = touchResponse.spot!;
      final groupIndex = spot.touchedBarGroupIndex;
      final rodIndex = spot.touchedRodDataIndex;

      _showingTouchedTooltips.clear();
      _showingTouchedTooltips[groupIndex] = [rodIndex];
    });
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _barChartDataTween = visitor(
      _barChartDataTween,
      _getData(),
      (dynamic value) =>
          BarChartDataTween(begin: value as BarChartData, end: widget.data),
    ) as BarChartDataTween?;
  }
}
