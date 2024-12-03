import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_scaffold_widget.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_helper.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_renderer.dart';
import 'package:fl_chart/src/utils/chart_transformation_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

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
  });

  /// Determines how the [LineChart] should be look like.
  final LineChartData data;

  /// We pass this key to our renderers which are supposed to
  /// render the chart itself (without anything around the chart).
  final Key? chartRendererKey;

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

  late double _viewWidth;
  late double _viewHeight;

  final double _minScale = 1;
  final double _maxScale = 3;

  final ChartTransformationController _chartTransformationController =
      ChartTransformationController();

  double? _scaleStart;

  @override
  void dispose() {
    _chartTransformationController.dispose();
    super.dispose();
  }

  void _onScaleUpdate(ScaleUpdateDetails details, {bool isTouch = false}) {
    // Skip if no change in scale or translation
    final isScaleUpdate = details.scale != 1.0;
    final isTranslationUpdate = details.focalPointDelta != Offset.zero;
    if (!(isScaleUpdate || isTranslationUpdate)) {
      return;
    }

    final matrix = _chartTransformationController.value.clone();

    if (details.scale != 1.0) {
      late double scaleChange;
      if (_scaleStart != null) {
        final desiredScale = details.scale * _scaleStart!;
        final currentScale = matrix.scaleX;
        scaleChange = desiredScale / currentScale;
      } else {
        scaleChange = details.scale;
      }
      matrix
        ..scale(scaleChange)
        ..clamp(
          minScale: _minScale,
          maxScale: _maxScale,
        );
    }

    final data = _getData();

    final dataRangeX = data.maxX - data.minX;
    final dataRangeY = data.maxY - data.minY;

    final scaledDataRangeX = dataRangeX / matrix.scaleX;
    final scaledDataRangeY = dataRangeY / matrix.scaleY;

    final translationX = details.focalPointDelta.dx * (isTouch ? -1 : 1);
    final translationY = details.focalPointDelta.dy;

    final normalizedTranslationX = translationX / _viewWidth * scaledDataRangeX;
    final normalizedTranslationY =
        translationY / _viewHeight * scaledDataRangeY;

    matrix
      ..translate(
        x: normalizedTranslationX,
        y: normalizedTranslationY,
      )
      ..clamp(
        minX: data.minX,
        maxX: data.maxX - scaledDataRangeX,
        minY: data.minY,
        maxY: data.maxY - scaledDataRangeY,
      );

    // Update the transformation controller
    _chartTransformationController.value = matrix;
  }

  void _onPointerSignal(PointerSignalEvent event) {
    switch (event) {
      case final PointerScaleEvent scaleEvent:
        _onScaleUpdate(
          ScaleUpdateDetails(
            scale: scaleEvent.scale,
            focalPointDelta: scaleEvent.delta,
          ),
        );

      case final PointerScrollEvent scrollEvent:
        // TODO(Peter): Add flag to enable scaling via trackpad scroll
        if (scrollEvent.kind == PointerDeviceKind.trackpad) {
          _onScaleUpdate(
            ScaleUpdateDetails(
              focalPointDelta: scrollEvent.scrollDelta,
            ),
          );
          return;
        }

        // Ignore left and right mouse wheel scroll.
        if (scrollEvent.scrollDelta.dy == 0.0) {
          return;
        }

        // This value reduces the amount of scaling that occurs with each scroll
        // to make it feel more natural. It was eyeballed to feel right.
        const scaleFactor = 100;
        final scale = math.exp(
          -scrollEvent.scrollDelta.dy /
              _chartTransformationController.value.scaleY /
              scaleFactor,
        );
        _onScaleUpdate(
          ScaleUpdateDetails(
            scale: scale,
            focalPointDelta: scrollEvent.scrollDelta,
          ),
        );

      default:
        return;
    }
  }

  void _resetScale() {
    _chartTransformationController.value = Matrix3.identity();
  }

  LineChartData _transformData(LineChartData data, Matrix3 matrix) {
    final isTransformed = matrix.scaleX != 1.0 ||
        matrix.scaleY != 1.0 ||
        matrix.translationX != 0 ||
        matrix.translationY != 0;

    final newData = data.copyWith(
      minX: (data.minX * matrix.scaleX) + matrix.translationX,
      maxX: (data.maxX / matrix.scaleX) + matrix.translationX,
      minY: (data.minY * matrix.scaleY) + matrix.translationY,
      maxY: (data.maxY / matrix.scaleY) + matrix.translationY,
      clipData: isTransformed ? const FlClipData.all() : null,
    );

    if (newData.minX.isNaN ||
        newData.maxX.isNaN ||
        newData.minY.isNaN ||
        newData.maxY.isNaN) {
      throw Exception('Invalid data range');
    }

    return newData;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: _onPointerSignal,
      child: GestureDetector(
        onDoubleTap: _resetScale,
        child: ValueListenableBuilder<Matrix3>(
          valueListenable: _chartTransformationController,
          builder: (context, matrix, child) {
            final transformedData = _transformData(_getData(), matrix);
            _lineChartDataTween = LineChartDataTween(
              begin: transformedData,
              end: widget.data,
            );
            return AxisChartScaffoldWidget(
              chart: LayoutBuilder(
                builder: (context, constraints) {
                  _viewWidth = constraints.maxWidth;
                  _viewHeight = constraints.maxHeight;
                  return LineChartLeaf(
                    data: _withTouchedIndicators(
                      _lineChartDataTween!.evaluate(animation),
                    ),
                    targetData: _withTouchedIndicators(transformedData),
                    key: widget.chartRendererKey,
                  );
                },
              ),
              data: transformedData,
            );
          },
        ),
      ),
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
            // TODO(Peetee06): Add scale/translate touch callback also when enabled or handleBuiltInTouches are false
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
    if (event is FlScaleStartEvent) {
      _scaleStart = _chartTransformationController.value.scaleX;
    } else if (event is FlScaleEndEvent) {
      _scaleStart = null;
    } else if (event is FlScaleUpdateEvent) {
      _onScaleUpdate(
        ScaleUpdateDetails(
          scale: event.details.scale,
          focalPointDelta: event.details.focalPointDelta,
        ),
        isTouch: true,
      );
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
      _transformData(_getData(), _chartTransformationController.value),
      (dynamic value) =>
          LineChartDataTween(begin: value as LineChartData, end: widget.data),
    ) as LineChartDataTween?;
  }
}
