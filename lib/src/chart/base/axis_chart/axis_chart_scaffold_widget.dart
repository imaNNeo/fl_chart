import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/side_titles/side_titles_widget.dart';
import 'package:fl_chart/src/chart/base/custom_interactive_viewer.dart';
import 'package:fl_chart/src/extensions/fl_titles_data_extension.dart';
import 'package:flutter/material.dart';

typedef ChartBuilder = Widget Function(
  BuildContext context,
  Rect? chartRect,
);

/// A scaffold to show a scalable axis-based chart
///
/// It contains some placeholders to represent an axis-based chart.
///
/// It's something like the below graph:
/// |----------------------|
/// |      |  top  |       |
/// |------|-------|-------|
/// | left | chart | right |
/// |------|-------|-------|
/// |      | bottom|       |
/// |----------------------|
///
/// `left`, `top`, `right`, `bottom` are some place holders to show titles
/// provided by [AxisChartData.titlesData] around the chart
/// `chart` is a centered place holder to show a raw chart. The chart is
/// built using [chartBuilder].
class AxisChartScaffoldWidget extends StatefulWidget {
  const AxisChartScaffoldWidget({
    super.key,
    required this.chartBuilder,
    required this.data,
    this.scaleAxis = ScaleAxis.none,
    this.maxScale = 2.5,
    this.trackpadScrollCausesScale = false,
  });

  final ChartBuilder chartBuilder;
  final AxisChartData data;

  /// Determines what axis should be scaled.
  final ScaleAxis scaleAxis;

  /// The maximum scale of the chart.
  ///
  /// Ignored when [scaleAxis] is [ScaleAxis.none].
  final double maxScale;

  /// Whether trackpad scroll causes scale.
  ///
  /// Ignored when [scaleAxis] is [ScaleAxis.none].
  final bool trackpadScrollCausesScale;

  @override
  State<AxisChartScaffoldWidget> createState() =>
      _AxisChartScaffoldWidgetState();
}

class _AxisChartScaffoldWidgetState extends State<AxisChartScaffoldWidget> {
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

  // Applies the inverse transformation to the chart to get the zoomed
  // bounding box.
  //
  // The transformation matrix is inverted because the bounding box needs to
  // grow beyond the chart's boundaries when the chart is scaled in order
  // for its content to be laid out on the larger area. This leads to the
  // scaling effect.
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

  bool get showLeftTitles {
    if (!widget.data.titlesData.show) {
      return false;
    }
    final showAxisTitles = widget.data.titlesData.leftTitles.showAxisTitles;
    final showSideTitles = widget.data.titlesData.leftTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  bool get showRightTitles {
    if (!widget.data.titlesData.show) {
      return false;
    }
    final showAxisTitles = widget.data.titlesData.rightTitles.showAxisTitles;
    final showSideTitles = widget.data.titlesData.rightTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  bool get showTopTitles {
    if (!widget.data.titlesData.show) {
      return false;
    }
    final showAxisTitles = widget.data.titlesData.topTitles.showAxisTitles;
    final showSideTitles = widget.data.titlesData.topTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  bool get showBottomTitles {
    if (!widget.data.titlesData.show) {
      return false;
    }
    final showAxisTitles = widget.data.titlesData.bottomTitles.showAxisTitles;
    final showSideTitles = widget.data.titlesData.bottomTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  List<Widget> stackWidgets(BoxConstraints constraints) {
    final chart = KeyedSubtree(
      key: _chartKey,
      child: widget.chartBuilder(context, _chartRect),
    );
    final widgets = <Widget>[
      Container(
        margin: widget.data.titlesData.allSidesPadding,
        decoration: BoxDecoration(
          border: widget.data.borderData.isVisible()
              ? widget.data.borderData.border
              : null,
        ),
        child: widget.scaleAxis == ScaleAxis.none
            ? chart
            : LayoutBuilder(
                builder: (context, constraints) {
                  return CustomInteractiveViewer(
                    transformationController: _transformationController,
                    clipBehavior: Clip.none,
                    trackpadScrollCausesScale: widget.trackpadScrollCausesScale,
                    maxScale: widget.maxScale,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: chart,
                    ),
                  );
                },
              ),
      ),
    ];

    int insertIndex(bool drawBelow) => drawBelow ? 0 : widgets.length;

    if (showLeftTitles) {
      widgets.insert(
        insertIndex(widget.data.titlesData.leftTitles.drawBelowEverything),
        SideTitlesWidget(
          side: AxisSide.left,
          axisChartData: widget.data,
          parentSize: constraints.biggest,
          boundingBox: _chartRect,
        ),
      );
    }

    if (showTopTitles) {
      widgets.insert(
        insertIndex(widget.data.titlesData.topTitles.drawBelowEverything),
        SideTitlesWidget(
          side: AxisSide.top,
          axisChartData: widget.data,
          parentSize: constraints.biggest,
          boundingBox: _chartRect,
        ),
      );
    }

    if (showRightTitles) {
      widgets.insert(
        insertIndex(widget.data.titlesData.rightTitles.drawBelowEverything),
        SideTitlesWidget(
          side: AxisSide.right,
          axisChartData: widget.data,
          parentSize: constraints.biggest,
          boundingBox: _chartRect,
        ),
      );
    }

    if (showBottomTitles) {
      widgets.insert(
        insertIndex(widget.data.titlesData.bottomTitles.drawBelowEverything),
        SideTitlesWidget(
          side: AxisSide.bottom,
          axisChartData: widget.data,
          parentSize: constraints.biggest,
          boundingBox: _chartRect,
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(children: stackWidgets(constraints));
      },
    );
  }
}
