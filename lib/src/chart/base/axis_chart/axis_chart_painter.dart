import 'dart:math' as math;

import 'package:fl_chart/src/chart/bar_chart/bar_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_painter.dart';
import 'package:fl_chart/src/extensions/canvas_extension.dart';
import 'package:fl_chart/src/extensions/paint_extension.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';

import 'axis_chart_data.dart';

/// This class is responsible to draw the grid behind all axis base charts.
/// also we have two useful function [getPixelX] and [getPixelY] that used
/// in child classes -> [BarChartPainter], [LineChartPainter]
/// [data] is the currently showing data (it may produced by an animation using lerp function),
/// [targetData] is the target data, that animation is going to show (if animating)
abstract class AxisChartPainter<D extends AxisChartData> extends BaseChartPainter<D> {
  late Paint _gridPaint, _backgroundPaint;

  /// [_rangeAnnotationPaint] draws range annotations;
  late Paint _rangeAnnotationPaint;

  AxisChartPainter() : super() {
    _gridPaint = Paint()..style = PaintingStyle.stroke;

    _backgroundPaint = Paint()..style = PaintingStyle.fill;

    _rangeAnnotationPaint = Paint()..style = PaintingStyle.fill;
  }

  /// Paints [AxisChartData] into the provided canvas.
  @override
  void paint(CanvasWrapper canvasWrapper, PaintHolder<D> holder) {
    super.paint(canvasWrapper, holder);
    _drawBackground(canvasWrapper, holder);
    _drawRangeAnnotation(canvasWrapper, holder);
    _drawGrid(canvasWrapper, holder);
  }

  /// Draws an axis titles in each side (left, top, right, bottom).
  ///
  /// AxisTitle is a title to describe each axis,
  /// It can be larger then axis values titles.
  void drawAxisTitles(CanvasWrapper canvasWrapper, PaintHolder<D> holder) {
    final data = holder.data;
    if (!data.axisTitleData.show) {
      return;
    }
    final viewSize = getChartUsableDrawSize(canvasWrapper.size, holder);

    final axisTitles = data.axisTitleData;

    // Left Title
    final leftTitle = axisTitles.leftTitle;
    if (leftTitle.showTitle) {
      final span = TextSpan(style: leftTitle.textStyle, text: leftTitle.titleText);
      final tp = TextPainter(
          text: span,
          textAlign: leftTitle.textAlign,
          textDirection: leftTitle.textDirection,
          textScaleFactor: holder.textScale);
      tp.layout(minWidth: viewSize.height);
      canvasWrapper.save();
      canvasWrapper.rotate(-math.pi * 0.5);
      canvasWrapper.drawText(
        tp,
        Offset(-viewSize.height - getTopOffsetDrawSize(holder), leftTitle.reservedSize - tp.height),
      );
      canvasWrapper.restore();
    }

    // Top title
    final topTitle = axisTitles.topTitle;
    if (topTitle.showTitle) {
      final span = TextSpan(style: topTitle.textStyle, text: topTitle.titleText);
      final tp = TextPainter(
          text: span,
          textAlign: topTitle.textAlign,
          textDirection: topTitle.textDirection,
          textScaleFactor: holder.textScale);
      tp.layout(minWidth: viewSize.width);
      canvasWrapper.drawText(
          tp, Offset(getLeftOffsetDrawSize(holder), topTitle.reservedSize - tp.height));
    }

    // Right Title
    final rightTitle = axisTitles.rightTitle;
    if (rightTitle.showTitle) {
      final span = TextSpan(style: rightTitle.textStyle, text: rightTitle.titleText);
      final tp = TextPainter(
          text: span,
          textAlign: rightTitle.textAlign,
          textDirection: rightTitle.textDirection,
          textScaleFactor: holder.textScale);
      tp.layout(minWidth: viewSize.height);
      canvasWrapper.save();
      canvasWrapper.rotate(-math.pi * 0.5);
      canvasWrapper.drawText(
          tp,
          Offset(-viewSize.height - getTopOffsetDrawSize(holder),
              viewSize.width + getExtraNeededHorizontalSpace(holder) - rightTitle.reservedSize));
      canvasWrapper.restore();
    }

    // Bottom title
    final bottomTitle = axisTitles.bottomTitle;
    if (bottomTitle.showTitle) {
      final span = TextSpan(style: bottomTitle.textStyle, text: bottomTitle.titleText);
      final tp = TextPainter(
          text: span,
          textAlign: bottomTitle.textAlign,
          textDirection: bottomTitle.textDirection,
          textScaleFactor: holder.textScale);
      tp.layout(minWidth: viewSize.width);
      canvasWrapper.drawText(
          tp,
          Offset(getLeftOffsetDrawSize(holder),
              getExtraNeededVerticalSpace(holder) - bottomTitle.reservedSize + viewSize.height));
    }
  }

  /// Returns needed extra space in the left and right side of the chart.
  ///
  /// We need some extra spaces around the chart, for showing titles, ...
  /// It returns extra needed spaces in left and right side of the chart.
  @override
  double getExtraNeededHorizontalSpace(PaintHolder<D> holder) {
    final data = holder.data;
    var sum = super.getExtraNeededHorizontalSpace(holder);

    if (data.axisTitleData.show) {
      final leftSide = data.axisTitleData.leftTitle;
      if (leftSide.showTitle) {
        sum += leftSide.reservedSize + leftSide.margin;
      }

      final rightSide = data.axisTitleData.rightTitle;
      if (rightSide.showTitle) {
        sum += rightSide.reservedSize + rightSide.margin;
      }
    }

    return sum;
  }

  /// Returns needed extra space in the bottom and tom side of the chart.
  ///
  /// We need some extra spaces around the chart, for showing titles, ...
  /// It returns extra needed spaces in bottom and top side of the chart.
  @override
  double getExtraNeededVerticalSpace(PaintHolder<D> holder) {
    final data = holder.data;
    var sum = super.getExtraNeededVerticalSpace(holder);

    if (data.axisTitleData.show) {
      final topSide = data.axisTitleData.topTitle;
      if (topSide.showTitle) {
        sum += topSide.reservedSize + topSide.margin;
      }

      final bottomSide = data.axisTitleData.bottomTitle;
      if (bottomSide.showTitle) {
        sum += bottomSide.reservedSize + bottomSide.margin;
      }
    }

    return sum;
  }

  /// Returns left offset for drawing chart's content.
  ///
  /// It returns left offset that we have apply it
  /// to our draws to fit inside the chart's area.
  @override
  double getLeftOffsetDrawSize(PaintHolder<D> holder) {
    final data = holder.data;
    var sum = super.getLeftOffsetDrawSize(holder);

    final leftAxisTitle = data.axisTitleData.leftTitle;
    if (data.axisTitleData.show && leftAxisTitle.showTitle) {
      sum += leftAxisTitle.reservedSize + leftAxisTitle.margin;
    }

    return sum;
  }

  /// Returns top offset for drawing chart's content.
  ///
  /// It returns left offset that we have apply it
  /// to our draws to fit inside the chart's area.
  @override
  double getTopOffsetDrawSize(PaintHolder<D> holder) {
    final data = holder.data;
    var sum = super.getTopOffsetDrawSize(holder);

    final topAxisTitle = data.axisTitleData.topTitle;
    if (data.axisTitleData.show && topAxisTitle.showTitle) {
      sum += topAxisTitle.reservedSize + topAxisTitle.margin;
    }

    return sum;
  }

  void _drawGrid(CanvasWrapper canvasWrapper, PaintHolder<D> holder) {
    final data = holder.data;
    if (!data.gridData.show) {
      return;
    }
    final viewSize = canvasWrapper.size;
    final usableViewSize = getChartUsableDrawSize(viewSize, holder);
    // Show Vertical Grid
    if (data.gridData.drawVerticalLine) {
      final verticalInterval = data.gridData.verticalInterval ??
          getEfficientInterval(viewSize.width, data.horizontalDiff);
      var verticalSeek = data.minX + verticalInterval;

      final delta = data.maxX - data.minX;
      final count = delta ~/ verticalInterval;
      final lastPosition = count * verticalSeek;
      final lastPositionOverlapsWithBorder = lastPosition == data.maxX;
      final end = lastPositionOverlapsWithBorder ? data.maxX - verticalInterval : data.maxX;

      while (verticalSeek <= end) {
        if (data.gridData.checkToShowVerticalLine(verticalSeek)) {
          final flLineStyle = data.gridData.getDrawingVerticalLine(verticalSeek);
          _gridPaint.color = flLineStyle.color;
          _gridPaint.strokeWidth = flLineStyle.strokeWidth;
          _gridPaint.transparentIfWidthIsZero();

          final bothX = getPixelX(verticalSeek, usableViewSize, holder);
          final x1 = bothX;
          final y1 = 0 + getTopOffsetDrawSize(holder);
          final x2 = bothX;
          final y2 = usableViewSize.height + getTopOffsetDrawSize(holder);
          canvasWrapper.drawDashedLine(
              Offset(x1, y1), Offset(x2, y2), _gridPaint, flLineStyle.dashArray);
        }
        verticalSeek += verticalInterval;
      }
    }

    // Show Horizontal Grid
    if (data.gridData.drawHorizontalLine) {
      final horizontalInterval = data.gridData.horizontalInterval ??
          getEfficientInterval(viewSize.height, data.verticalDiff);
      var horizontalSeek = data.minY + horizontalInterval;

      final delta = data.maxY - data.minY;
      final count = delta ~/ horizontalInterval;
      final lastPosition = count * horizontalSeek;
      final lastPositionOverlapsWithBorder = lastPosition == data.maxY;

      final end = lastPositionOverlapsWithBorder ? data.maxY - horizontalInterval : data.maxY;

      while (horizontalSeek <= end) {
        if (data.gridData.checkToShowHorizontalLine(horizontalSeek)) {
          final flLine = data.gridData.getDrawingHorizontalLine(horizontalSeek);
          _gridPaint.color = flLine.color;
          _gridPaint.strokeWidth = flLine.strokeWidth;
          _gridPaint.transparentIfWidthIsZero();

          final bothY = getPixelY(horizontalSeek, usableViewSize, holder);
          final x1 = 0 + getLeftOffsetDrawSize(holder);
          final y1 = bothY;
          final x2 = usableViewSize.width + getLeftOffsetDrawSize(holder);
          final y2 = bothY;
          canvasWrapper.drawDashedLine(
              Offset(x1, y1), Offset(x2, y2), _gridPaint, flLine.dashArray);
        }

        horizontalSeek += horizontalInterval;
      }
    }
  }

  /// This function draws a colored background behind the chart.
  void _drawBackground(CanvasWrapper canvasWrapper, PaintHolder<D> holder) {
    final data = holder.data;
    if (data.backgroundColor.opacity == 0.0) {
      return;
    }

    final viewSize = canvasWrapper.size;
    final usableViewSize = getChartUsableDrawSize(viewSize, holder);
    _backgroundPaint.color = data.backgroundColor;
    canvasWrapper.drawRect(
      Rect.fromLTWH(
        getLeftOffsetDrawSize(holder),
        getTopOffsetDrawSize(holder),
        usableViewSize.width,
        usableViewSize.height,
      ),
      _backgroundPaint,
    );
  }

  void _drawRangeAnnotation(CanvasWrapper canvasWrapper, PaintHolder<D> holder) {
    final data = holder.data;
    final viewSize = canvasWrapper.size;
    final chartUsableSize = getChartUsableDrawSize(viewSize, holder);

    if (data.rangeAnnotations.verticalRangeAnnotations.isNotEmpty) {
      for (var annotation in data.rangeAnnotations.verticalRangeAnnotations) {
        final topChartPadding = getTopOffsetDrawSize(holder);
        final from = Offset(getPixelX(annotation.x1, chartUsableSize, holder), topChartPadding);

        final bottomChartPadding =
            getExtraNeededVerticalSpace(holder) - getTopOffsetDrawSize(holder);
        final to = Offset(
          getPixelX(annotation.x2, chartUsableSize, holder),
          viewSize.height - bottomChartPadding,
        );

        final rect = Rect.fromPoints(from, to);

        _rangeAnnotationPaint.color = annotation.color;

        canvasWrapper.drawRect(rect, _rangeAnnotationPaint);
      }
    }

    if (data.rangeAnnotations.horizontalRangeAnnotations.isNotEmpty) {
      for (var annotation in data.rangeAnnotations.horizontalRangeAnnotations) {
        final leftChartPadding = getLeftOffsetDrawSize(holder);
        final from = Offset(leftChartPadding, getPixelY(annotation.y1, chartUsableSize, holder));

        final rightChartPadding =
            getExtraNeededHorizontalSpace(holder) - getLeftOffsetDrawSize(holder);
        final to = Offset(
          viewSize.width - rightChartPadding,
          getPixelY(annotation.y2, chartUsableSize, holder),
        );

        final rect = Rect.fromPoints(from, to);

        _rangeAnnotationPaint.color = annotation.color;

        canvasWrapper.drawRect(rect, _rangeAnnotationPaint);
      }
    }
  }

  /// With this function we can convert our [FlSpot] x
  /// to the view base axis x .
  /// the view 0, 0 is on the top/left, but the spots is bottom/left
  double getPixelX(double spotX, Size chartUsableSize, PaintHolder<D> holder) {
    final data = holder.data;
    final deltaX = data.maxX - data.minX;
    if (deltaX == 0.0) {
      return getLeftOffsetDrawSize(holder);
    }
    return (((spotX - data.minX) / deltaX) * chartUsableSize.width) + getLeftOffsetDrawSize(holder);
  }

  /// With this function we can convert our [FlSpot] y
  /// to the view base axis y.
  double getPixelY(double spotY, Size chartUsableSize, PaintHolder<D> holder) {
    final data = holder.data;
    final deltaY = data.maxY - data.minY;
    if (deltaY == 0.0) {
      return chartUsableSize.height + getTopOffsetDrawSize(holder);
    }

    var y = ((spotY - data.minY) / deltaY) * chartUsableSize.height;
    y = chartUsableSize.height - y;
    return y + getTopOffsetDrawSize(holder);
  }
}
