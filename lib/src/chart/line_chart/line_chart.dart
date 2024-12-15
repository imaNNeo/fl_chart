import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_scaffold_widget.dart';
import 'package:fl_chart/src/chart/base/custom_interactive_viewer.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_helper.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_renderer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ScaleAxis {
  /// Scales the horizontal axis.
  horizontal,

  /// Scales the vertical axis.
  vertical,

  /// Scales both the horizontal and vertical axes.
  free,

  /// Does not scale the axes.
  none,
}

/// Renders a line chart as a widget, using provided [LineChartData].
class LineChart extends ImplicitlyAnimatedWidget {
  /// [data] determines how the [LineChart] should be look like,
  /// when you make any change in the [LineChartData], it updates
  /// new values with animation, and duration is [duration].
  /// also you can change the [curve]
  /// which default is [Curves.linear].
  const LineChart(
    this.data, {
    this.chartRendererKey,
    super.key,
    super.duration = const Duration(milliseconds: 150),
    super.curve = Curves.linear,
    this.scaleAxis = ScaleAxis.none,
    this.maxScale = 2.5,
  });

  /// Determines how the [LineChart] should be look like.
  final LineChartData data;

  /// We pass this key to our renderers which are supposed to
  /// render the chart itself (without anything around the chart).
  final Key? chartRendererKey;

  /// Determines what axis should be scaled.
  final ScaleAxis scaleAxis;

  /// The maximum scale of the chart.
  ///
  /// Ignored when [scaleAxis] is [ScaleAxis.none].
  final double maxScale;

  /// Creates a [_LineChartState]
  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends AnimatedWidgetBaseState<LineChart> {
  /// we handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [LineChartData] to the new one.
  LineChartDataTween? _lineChartDataTween;

  /// If [LineTouchData.handleBuiltInTouches] is true, we override the callback to handle touches internally,
  /// but we need to keep the provided callback to notify it too.
  BaseTouchCallback<LineTouchResponse>? _providedTouchCallback;

  final List<ShowingTooltipIndicators> _showingTouchedTooltips = [];

  final Map<int, List<int>> _showingTouchedIndicators = {};

  final _lineChartHelper = LineChartHelper();

  final _transformationController = CustomTransformationController();

  final _chartKey = GlobalKey();

  Rect? _chartRect;

  bool get _canScaleHorizontally =>
      widget.scaleAxis == ScaleAxis.horizontal ||
      widget.scaleAxis == ScaleAxis.free;

  bool get _canScaleVertically =>
      widget.scaleAxis == ScaleAxis.vertical ||
      widget.scaleAxis == ScaleAxis.free;

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_updateChartRect);
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _updateChartRect() {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    if (scale == 1.0) {
      setState(() {
        _chartRect = null;
      });
      return;
    }
    final inverseMatrix = Matrix4.inverted(_transformationController.value);

    final quad = CustomInteractiveViewer.transformViewport(
      inverseMatrix,
      _chartBoundaryRect,
    );

    final boundingRect = CustomInteractiveViewer.axisAlignedBoundingBox(quad);

    final adjustedRect = Rect.fromLTWH(
      _canScaleHorizontally ? boundingRect.left : _chartBoundaryRect.left,
      _canScaleVertically ? boundingRect.top : _chartBoundaryRect.top,
      _canScaleHorizontally ? boundingRect.width : _chartBoundaryRect.width,
      _canScaleVertically ? boundingRect.height : _chartBoundaryRect.height,
    );

    setState(() {
      _chartRect = adjustedRect;
    });
  }

  // The Rect representing the chart.
  Rect get _chartBoundaryRect {
    assert(_chartKey.currentContext != null);
    final childRenderBox =
        _chartKey.currentContext!.findRenderObject()! as RenderBox;
    return Offset.zero & childRenderBox.size;
  }

  @override
  Widget build(BuildContext context) {
    final showingData = _getData();

    final chart = KeyedSubtree(
      key: _chartKey,
      child: LineChartLeaf(
        data: _withTouchedIndicators(
          _lineChartDataTween!.evaluate(animation),
        ),
        targetData: _withTouchedIndicators(showingData),
        key: widget.chartRendererKey,
        boundingBox: _chartRect,
        canBeScaled: widget.scaleAxis != ScaleAxis.none,
      ),
    );

    return AxisChartScaffoldWidget(
      chart: widget.scaleAxis == ScaleAxis.none
          ? chart
          : LayoutBuilder(
              builder: (context, constraints) {
                return CustomInteractiveViewer(
                  transformationController: _transformationController,
                  clipBehavior: Clip.none,
                  maxScale: widget.maxScale,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: chart,
                  ),
                );
              },
            ),
      data: showingData,
      boundingBox: _chartRect,
    );
  }

  LineChartData _withTouchedIndicators(LineChartData lineChartData) {
    if (!lineChartData.lineTouchData.enabled ||
        !lineChartData.lineTouchData.handleBuiltInTouches) {
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

  LineChartData _getData() {
    var newData = widget.data;

    /// Calculate minX, maxX, minY, maxY for [LineChartData] if they are null,
    /// it is necessary to render the chart correctly.
    if (newData.minX.isNaN ||
        newData.maxX.isNaN ||
        newData.minY.isNaN ||
        newData.maxY.isNaN) {
      final (minX, maxX, minY, maxY) = _lineChartHelper.calculateMaxAxisValues(
        newData.lineBarsData,
      );
      newData = newData.copyWith(
        minX: newData.minX.isNaN ? minX : newData.minX,
        maxX: newData.maxX.isNaN ? maxX : newData.maxX,
        minY: newData.minY.isNaN ? minY : newData.minY,
        maxY: newData.maxY.isNaN ? maxY : newData.maxY,
      );
    }

    final lineTouchData = newData.lineTouchData;
    if (lineTouchData.enabled && lineTouchData.handleBuiltInTouches) {
      _providedTouchCallback = lineTouchData.touchCallback;
      newData = newData.copyWith(
        lineTouchData:
            newData.lineTouchData.copyWith(touchCallback: _handleBuiltInTouch),
      );
    }

    return newData;
  }

  void _handleBuiltInTouch(
    FlTouchEvent event,
    LineTouchResponse? touchResponse,
  ) {
    if (!mounted) {
      return;
    }
    _providedTouchCallback?.call(event, touchResponse);

    if (!event.isInterestedForInteractions ||
        touchResponse?.lineBarSpots == null ||
        touchResponse!.lineBarSpots!.isEmpty) {
      setState(() {
        _showingTouchedTooltips.clear();
        _showingTouchedIndicators.clear();
      });
      return;
    }

    setState(() {
      final sortedLineSpots = List.of(touchResponse.lineBarSpots!)
        ..sort((spot1, spot2) => spot2.y.compareTo(spot1.y));

      _showingTouchedIndicators.clear();
      for (var i = 0; i < touchResponse.lineBarSpots!.length; i++) {
        final touchedBarSpot = touchResponse.lineBarSpots![i];
        final barPos = touchedBarSpot.barIndex;
        _showingTouchedIndicators[barPos] = [touchedBarSpot.spotIndex];
      }

      _showingTouchedTooltips
        ..clear()
        ..add(ShowingTooltipIndicators(sortedLineSpots));
    });
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _lineChartDataTween = visitor(
      _lineChartDataTween,
      _getData(),
      (dynamic value) =>
          LineChartDataTween(begin: value as LineChartData, end: widget.data),
    ) as LineChartDataTween?;
  }
}
