import 'dart:math' as math;

import 'package:fl_chart/src/chart/bar_chart/bar_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_painter.dart';
import 'package:fl_chart/src/extensions/canvas_extension.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';

import 'axis_chart_data.dart';

/// This class is responsible to draw the grid behind all axis base charts.
/// also we have two useful function [getPixelX] and [getPixelY] that used
/// in child classes -> [BarChartPainter], [LineChartPainter]
/// [data] is the currently showing data (it may produced by an animation using lerp function),
/// [targetData] is the target data, that animation is going to show (if animating)
abstract class AxisChartPainter<D extends AxisChartData> extends BaseChartPainter<D> {
  Paint _gridPaint, _backgroundPaint;

  /// [_rangeAnnotationPaint] draws range annotations;
  Paint _rangeAnnotationPaint;

  AxisChartPainter(D data, D targetData, {double textScale})
      : super(data, targetData, textScale: textScale) {
    _gridPaint = Paint()..style = PaintingStyle.stroke;

    _backgroundPaint = Paint()..style = PaintingStyle.fill;

    _rangeAnnotationPaint = Paint()..style = PaintingStyle.fill;
  }

  /// Paints [AxisChartData] into the provided canvas.
  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);

    _drawBackground(canvas, size);
    _drawRangeAnnotation(canvas, size);
    _drawGrid(canvas, size);
  }

  /// Draws an axis titles in each side (left, top, right, bottom).
  ///
  /// AxisTitle is a title to describe each axis,
  /// It can be larger then axis values titles.
  void drawAxisTitles(Canvas canvas, Size viewSize) {
    if (!data.axisTitleData.show) {
      return;
    }
    viewSize = getChartUsableDrawSize(viewSize);

    final axisTitles = data.axisTitleData;

    // Left Title
    final leftTitle = axisTitles.leftTitle;
    if (leftTitle.showTitle) {
      final TextSpan span = TextSpan(style: leftTitle.textStyle, text: leftTitle.titleText);
      final TextPainter tp = TextPainter(
          text: span,
          textAlign: leftTitle.textAlign,
          textDirection: TextDirection.ltr,
          textScaleFactor: textScale);
      tp.layout(minWidth: viewSize.height);
      canvas.save();
      canvas.rotate(-math.pi * 0.5);
      tp.paint(canvas,
          Offset(-viewSize.height - getTopOffsetDrawSize(), leftTitle.reservedSize - tp.height));
      canvas.restore();
    }

    // Top title
    final topTitle = axisTitles.topTitle;
    if (topTitle.showTitle) {
      final TextSpan span = TextSpan(style: topTitle.textStyle, text: topTitle.titleText);
      final TextPainter tp = TextPainter(
          text: span,
          textAlign: topTitle.textAlign,
          textDirection: TextDirection.ltr,
          textScaleFactor: textScale);
      tp.layout(minWidth: viewSize.width);
      tp.paint(canvas, Offset(getLeftOffsetDrawSize(), topTitle.reservedSize - tp.height));
    }

    // Right Title
    final rightTitle = axisTitles.rightTitle;
    if (rightTitle.showTitle) {
      final TextSpan span = TextSpan(style: rightTitle.textStyle, text: rightTitle.titleText);
      final TextPainter tp = TextPainter(
          text: span,
          textAlign: rightTitle.textAlign,
          textDirection: TextDirection.ltr,
          textScaleFactor: textScale);
      tp.layout(minWidth: viewSize.height);
      canvas.save();
      canvas.rotate(-math.pi * 0.5);
      tp.paint(
          canvas,
          Offset(-viewSize.height - getTopOffsetDrawSize(),
              viewSize.width + getExtraNeededHorizontalSpace() - rightTitle.reservedSize));
      canvas.restore();
    }

    // Bottom title
    final bottomTitle = axisTitles.bottomTitle;
    if (bottomTitle.showTitle) {
      final TextSpan span = TextSpan(style: bottomTitle.textStyle, text: bottomTitle.titleText);
      final TextPainter tp = TextPainter(
          text: span,
          textAlign: bottomTitle.textAlign,
          textDirection: TextDirection.ltr,
          textScaleFactor: textScale);
      tp.layout(minWidth: viewSize.width);
      tp.paint(
          canvas,
          Offset(getLeftOffsetDrawSize(),
              getExtraNeededVerticalSpace() - bottomTitle.reservedSize + viewSize.height));
    }
  }

  /// Returns needed extra space in the left and right side of the chart.
  ///
  /// We need some extra spaces around the chart, for showing titles, ...
  /// It returns extra needed spaces in left and right side of the chart.
  @override
  double getExtraNeededHorizontalSpace() {
    double sum = super.getExtraNeededHorizontalSpace();

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
  double getExtraNeededVerticalSpace() {
    double sum = super.getExtraNeededVerticalSpace();

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
  double getLeftOffsetDrawSize() {
    var sum = super.getLeftOffsetDrawSize();

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
  double getTopOffsetDrawSize() {
    var sum = super.getTopOffsetDrawSize();

    final topAxisTitle = data.axisTitleData.topTitle;
    if (data.axisTitleData.show && topAxisTitle.showTitle) {
      sum += topAxisTitle.reservedSize + topAxisTitle.margin;
    }

    return sum;
  }

  void _drawGrid(Canvas canvas, Size viewSize) {
    if (!data.gridData.show || data.gridData == null) {
      return;
    }
    final Size usableViewSize = getChartUsableDrawSize(viewSize);
    // Show Vertical Grid
    if (data.gridData.drawVerticalLine) {
      final int verticalInterval = data.gridData.verticalInterval ??
          getEfficientInterval(viewSize.width, data.horizontalDiff);
      double verticalSeek = data.minX + verticalInterval;

      final double delta = data.maxX - data.minX;
      final int count = delta ~/ verticalInterval;
      final double lastPosition = count * verticalSeek;
      final bool lastPositionOverlapsWithBorder = lastPosition == data.maxX;
      final end = lastPositionOverlapsWithBorder ? data.maxX - verticalInterval : data.maxX;

      while (verticalSeek <= end) {
        if (data.gridData.checkToShowVerticalLine(verticalSeek)) {
          final FlLine flLineStyle = data.gridData.getDrawingVerticalLine(verticalSeek);
          _gridPaint.color = flLineStyle.color;
          _gridPaint.strokeWidth = flLineStyle.strokeWidth;

          final double bothX = getPixelX(verticalSeek, usableViewSize);
          final double x1 = bothX;
          final double y1 = 0 + getTopOffsetDrawSize();
          final double x2 = bothX;
          final double y2 = usableViewSize.height + getTopOffsetDrawSize();
          canvas.drawDashedLine(Offset(x1, y1), Offset(x2, y2), _gridPaint, flLineStyle.dashArray);
        }
        verticalSeek += verticalInterval;
      }
    }

    // Show Horizontal Grid
    if (data.gridData.drawHorizontalLine) {
      final int horizontalInterval = data.gridData.horizontalInterval ??
          getEfficientInterval(viewSize.height, data.verticalDiff);
      double horizontalSeek = data.minY + horizontalInterval;

      final double delta = data.maxY - data.minY;
      final int count = delta ~/ horizontalInterval;
      final double lastPosition = count * horizontalSeek;
      final bool lastPositionOverlapsWithBorder = lastPosition == data.maxY;

      final end = lastPositionOverlapsWithBorder ? data.maxY - horizontalInterval : data.maxY;

      while (horizontalSeek <= end) {
        if (data.gridData.checkToShowHorizontalLine(horizontalSeek)) {
          final FlLine flLine = data.gridData.getDrawingHorizontalLine(horizontalSeek);
          _gridPaint.color = flLine.color;
          _gridPaint.strokeWidth = flLine.strokeWidth;

          final double bothY = getPixelY(horizontalSeek, usableViewSize);
          final double x1 = 0 + getLeftOffsetDrawSize();
          final double y1 = bothY;
          final double x2 = usableViewSize.width + getLeftOffsetDrawSize();
          final double y2 = bothY;
          canvas.drawDashedLine(Offset(x1, y1), Offset(x2, y2), _gridPaint, flLine.dashArray);
        }

        horizontalSeek += horizontalInterval;
      }
    }
  }

  /// This function draws a colored background behind the chart.
  void _drawBackground(Canvas canvas, Size viewSize) {
    if (data.backgroundColor == null) {
      return;
    }

    final Size usableViewSize = getChartUsableDrawSize(viewSize);
    _backgroundPaint.color = data.backgroundColor;
    canvas.drawRect(
      Rect.fromLTWH(
        getLeftOffsetDrawSize(),
        getTopOffsetDrawSize(),
        usableViewSize.width,
        usableViewSize.height,
      ),
      _backgroundPaint,
    );
  }

  void _drawRangeAnnotation(Canvas canvas, Size viewSize) {
    if (data.rangeAnnotations == null) {
      return;
    }

    final Size chartUsableSize = getChartUsableDrawSize(viewSize);

    if (data.rangeAnnotations.verticalRangeAnnotations.isNotEmpty) {
      for (VerticalRangeAnnotation annotation in data.rangeAnnotations.verticalRangeAnnotations) {
        final double topChartPadding = getTopOffsetDrawSize();
        final Offset from = Offset(getPixelX(annotation.x1, chartUsableSize), topChartPadding);

        final double bottomChartPadding = getExtraNeededVerticalSpace() - getTopOffsetDrawSize();
        final Offset to = Offset(
            getPixelX(annotation.x2, chartUsableSize), viewSize.height - bottomChartPadding); //9

        final Rect rect = Rect.fromPoints(from, to);

        _rangeAnnotationPaint.color = annotation.color;

        canvas.drawRect(rect, _rangeAnnotationPaint);
      }
    }

    if (data.rangeAnnotations.horizontalRangeAnnotations.isNotEmpty) {
      for (HorizontalRangeAnnotation annotation
          in data.rangeAnnotations.horizontalRangeAnnotations) {
        final double leftChartPadding = getLeftOffsetDrawSize();
        final Offset from = Offset(leftChartPadding, getPixelY(annotation.y1, chartUsableSize));

        final double rightChartPadding = getExtraNeededHorizontalSpace() - getLeftOffsetDrawSize();
        final Offset to =
            Offset(viewSize.width - rightChartPadding, getPixelY(annotation.y2, chartUsableSize));

        final Rect rect = Rect.fromPoints(from, to);

        _rangeAnnotationPaint.color = annotation.color;

        canvas.drawRect(rect, _rangeAnnotationPaint);
      }
    }
  }

  /// With this function we can convert our [FlSpot] x
  /// to the view base axis x .
  /// the view 0, 0 is on the top/left, but the spots is bottom/left
  double getPixelX(double spotX, Size chartUsableSize) {
    final double deltaX = data.maxX - data.minX;
    if (deltaX == 0.0) {
      return getLeftOffsetDrawSize();
    }
    return (((spotX - data.minX) / deltaX) * chartUsableSize.width) + getLeftOffsetDrawSize();
  }

  /// With this function we can convert our [FlSpot] y
  /// to the view base axis y.
  double getPixelY(
    double spotY,
    Size chartUsableSize,
  ) {
    final double deltaY = data.maxY - data.minY;
    if (deltaY == 0.0) {
      return chartUsableSize.height + getTopOffsetDrawSize();
    }

    double y = ((spotY - data.minY) / deltaY) * chartUsableSize.height;
    y = chartUsableSize.height - y;
    return y + getTopOffsetDrawSize();
  }
}
