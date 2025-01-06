import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/axis_chart/scale_axis.dart';
import 'package:fl_chart/src/chart/base/axis_chart/side_titles/side_titles_widget.dart';
import 'package:fl_chart/src/chart/base/axis_chart/transformation_config.dart';
import 'package:fl_chart/src/chart/base/custom_interactive_viewer.dart';
import 'package:fl_chart/src/extensions/fl_titles_data_extension.dart';
import 'package:flutter/material.dart';

/// A builder to build a chart.
///
/// The [chartVirtualRect] is the virtual chart virtual rect to be used when
/// laying out the chart's content. It is transformed based on users'
/// interactions like scaling and panning.
typedef ChartBuilder = Widget Function(
  BuildContext context,
  Rect? chartVirtualRect,
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
    this.transformationConfig = const FlTransformationConfig(),
  });

  /// The builder to build the chart.
  final ChartBuilder chartBuilder;

  /// The data to build the chart.
  final AxisChartData data;

  /// {@template fl_chart.AxisChartScaffoldWidget.transformationConfig}
  /// The transformation configuration of the chart.
  ///
  /// Used to configure scaling and panning of the chart.
  /// {@endtemplate}
  final FlTransformationConfig transformationConfig;

  @override
  State<AxisChartScaffoldWidget> createState() =>
      _AxisChartScaffoldWidgetState();
}

class _AxisChartScaffoldWidgetState extends State<AxisChartScaffoldWidget> {
  late TransformationController _transformationController;

  final _chartKey = GlobalKey();

  Rect? _chartVirtualRect;

  FlTransformationConfig get _transformationConfig =>
      widget.transformationConfig;

  bool get _canScaleHorizontally =>
      _transformationConfig.scaleAxis == FlScaleAxis.horizontal ||
      _transformationConfig.scaleAxis == FlScaleAxis.free;

  bool get _canScaleVertically =>
      _transformationConfig.scaleAxis == FlScaleAxis.vertical ||
      _transformationConfig.scaleAxis == FlScaleAxis.free;

  @override
  void initState() {
    super.initState();
    _transformationController =
        _transformationConfig.transformationController ??
            TransformationController();
    _transformationController.addListener(_updateChartVirtualRect);
    updateRectPostFrame();
  }

  @override
  void dispose() {
    _transformationController.removeListener(_updateChartVirtualRect);
    if (_transformationConfig.transformationController == null) {
      _transformationController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(AxisChartScaffoldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    switch ((
      oldWidget.transformationConfig.transformationController,
      widget.transformationConfig.transformationController
    )) {
      case (null, null):
        break;
      case (null, TransformationController()):
        _transformationController.dispose();
        _transformationController =
            widget.transformationConfig.transformationController!;
        _transformationController.addListener(_updateChartVirtualRect);
      case (TransformationController(), null):
        _transformationController.removeListener(_updateChartVirtualRect);
        _transformationController = TransformationController();
        _transformationController.addListener(_updateChartVirtualRect);
      case (TransformationController(), TransformationController()):
        if (oldWidget.transformationConfig.transformationController !=
            widget.transformationConfig.transformationController) {
          _transformationController.removeListener(_updateChartVirtualRect);
          _transformationController =
              widget.transformationConfig.transformationController!;
          _transformationController.addListener(_updateChartVirtualRect);
        }
    }

    updateRectPostFrame();
  }

  void updateRectPostFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _updateChartVirtualRect();
    });
  }

  // Applies the inverse transformation to the chart to get the zoomed
  // bounding box.
  //
  // The transformation matrix is inverted because the bounding box needs to
  // grow beyond the chart's boundaries when the chart is scaled in order
  // for its content to be laid out on the larger area. This leads to the
  // scaling effect.
  void _updateChartVirtualRect() {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    if (scale == 1.0) {
      setState(() {
        _chartVirtualRect = null;
      });
      return;
    }
    final inverseMatrix = Matrix4.inverted(_transformationController.value);

    final chartVirtualQuad = CustomInteractiveViewer.transformViewport(
      inverseMatrix,
      _chartBoundaryRect,
    );

    final chartVirtualRect = CustomInteractiveViewer.axisAlignedBoundingBox(
      chartVirtualQuad,
    );

    final adjustedRect = Rect.fromLTWH(
      _canScaleHorizontally ? chartVirtualRect.left : _chartBoundaryRect.left,
      _canScaleVertically ? chartVirtualRect.top : _chartBoundaryRect.top,
      _canScaleHorizontally ? chartVirtualRect.width : _chartBoundaryRect.width,
      _canScaleVertically ? chartVirtualRect.height : _chartBoundaryRect.height,
    );

    setState(() {
      _chartVirtualRect = adjustedRect;
    });
  }

  // The Rect representing the chart.
  //
  // This represents the actual size and offset of the chart.
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
      child: widget.chartBuilder(context, _chartVirtualRect),
    );

    final interactiveChart = LayoutBuilder(
      builder: (context, constraints) {
        return CustomInteractiveViewer(
          transformationController: _transformationController,
          clipBehavior: Clip.none,
          trackpadScrollCausesScale:
              _transformationConfig.trackpadScrollCausesScale,
          maxScale: _transformationConfig.maxScale,
          minScale: _transformationConfig.minScale,
          panEnabled: _transformationConfig.panEnabled,
          scaleEnabled: _transformationConfig.scaleEnabled,
          child: SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: chart,
          ),
        );
      },
    );

    final widgets = <Widget>[
      Container(
        margin: widget.data.titlesData.allSidesPadding,
        decoration: BoxDecoration(
          border: widget.data.borderData.isVisible()
              ? widget.data.borderData.border
              : null,
        ),
        child: switch (_transformationConfig.scaleAxis) {
          FlScaleAxis.none => chart,
          FlScaleAxis() => interactiveChart,
        },
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
          chartVirtualRect: _chartVirtualRect,
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
          chartVirtualRect: _chartVirtualRect,
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
          chartVirtualRect: _chartVirtualRect,
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
          chartVirtualRect: _chartVirtualRect,
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RotatedBox(
          quarterTurns: widget.data.rotationQuarterTurns,
          child: Stack(
            children: stackWidgets(constraints),
          ),
        );
      },
    );
  }
}
