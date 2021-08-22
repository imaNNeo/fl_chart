import 'dart:core';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_data.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../utils/utils.dart';
import 'bar_chart_extensions.dart';

/// Paints [BarChartData] in the canvas, it can be used in a [CustomPainter]
class BarChartPainter extends AxisChartPainter<BarChartData> {
  late Paint _barPaint, _barStrokePaint, _bgTouchTooltipPaint;

  List<_GroupBarsPosition>? _groupBarsPosition;

  /// Paints [data] into canvas, it is the animating [BarChartData],
  /// [targetData] is the animation's target and remains the same
  /// during animation, then we should use it  when we need to show
  /// tooltips or something like that, because [data] is changing constantly.
  ///
  /// [textScale] used for scaling texts inside the chart,
  /// parent can use [MediaQuery.textScaleFactor] to respect
  /// the system's font size.
  BarChartPainter() : super() {
    _barPaint = Paint()..style = PaintingStyle.fill;
    _barStrokePaint = Paint()..style = PaintingStyle.stroke;

    _bgTouchTooltipPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;
  }

  /// Paints [BarChartData] into the provided canvas.
  @override
  void paint(BuildContext context, CanvasWrapper canvasWrapper, PaintHolder<BarChartData> holder) {
    super.paint(context, canvasWrapper, holder);
    final data = holder.data;
    final targetData = holder.targetData;

    if (data.barGroups.isEmpty) {
      return;
    }

    final groupsX = _calculateGroupsX(canvasWrapper.size, data.barGroups, data.alignment, holder);
    _groupBarsPosition =
        _calculateGroupAndBarsPosition(canvasWrapper.size, groupsX, data.barGroups);

    _drawBars(canvasWrapper, _groupBarsPosition!, holder);
    drawAxisTitles(context, canvasWrapper, holder);
    _drawTitles(context, canvasWrapper, _groupBarsPosition!, holder);

    for (var i = 0; i < targetData.barGroups.length; i++) {
      final barGroup = targetData.barGroups[i];
      for (var j = 0; j < barGroup.barRods.length; j++) {
        if (!barGroup.showingTooltipIndicators.contains(j)) {
          continue;
        }
        final barRod = barGroup.barRods[j];

        _drawTouchTooltip(context, canvasWrapper, _groupBarsPosition!,
            targetData.barTouchData.touchTooltipData, barGroup, i, barRod, j, holder);
      }
    }
  }

  /// Calculates groups position for showing in the x axis using [alignment].
  List<double> _calculateGroupsX(Size viewSize, List<BarChartGroupData> barGroups,
      BarChartAlignment alignment, PaintHolder<BarChartData> holder) {
    final data = holder.data;
    final drawSize = getChartUsableDrawSize(viewSize, holder);

    final groupsX = List.filled(barGroups.length, 0.0, growable: false);

    final leftTextsSpace = getLeftOffsetDrawSize(holder);

    switch (alignment) {
      case BarChartAlignment.start:
        var tempX = 0.0;
        barGroups.asMap().forEach((i, group) {
          groupsX[i] = leftTextsSpace + tempX + group.width / 2;
          tempX += group.width;
        });
        break;

      case BarChartAlignment.end:
        var tempX = 0.0;
        for (var i = barGroups.length - 1; i >= 0; i--) {
          final group = barGroups[i];
          groupsX[i] = (leftTextsSpace + drawSize.width) - tempX - group.width / 2;
          tempX += group.width;
        }
        break;

      case BarChartAlignment.center:
        var sumWidth = barGroups.map((group) => group.width).reduce((a, b) => a + b);
        sumWidth += data.groupsSpace * (barGroups.length - 1);
        final horizontalMargin = (drawSize.width - sumWidth) / 2;

        var tempX = 0.0;
        for (var i = 0; i < barGroups.length; i++) {
          final group = barGroups[i];
          groupsX[i] = leftTextsSpace + horizontalMargin + tempX + group.width / 2;

          final groupSpace = i == barGroups.length - 1 ? 0 : data.groupsSpace;
          tempX += group.width + groupSpace;
        }
        break;

      case BarChartAlignment.spaceBetween:
        final sumWidth = barGroups.map((group) => group.width).reduce((a, b) => a + b);
        final spaceAvailable = drawSize.width - sumWidth;
        final eachSpace = spaceAvailable / (barGroups.length - 1);

        var tempX = 0.0;
        barGroups.asMap().forEach((index, group) {
          tempX += group.width / 2;
          if (index != 0) {
            tempX += eachSpace;
          }
          groupsX[index] = leftTextsSpace + tempX;
          tempX += group.width / 2;
        });
        break;

      case BarChartAlignment.spaceAround:
        final sumWidth = barGroups.map((group) => group.width).reduce((a, b) => a + b);
        final spaceAvailable = drawSize.width - sumWidth;
        final eachSpace = spaceAvailable / (barGroups.length * 2);

        var tempX = 0.0;
        barGroups.asMap().forEach((i, group) {
          tempX += eachSpace;
          tempX += group.width / 2;
          groupsX[i] = leftTextsSpace + tempX;
          tempX += group.width / 2;
          tempX += eachSpace;
        });
        break;

      case BarChartAlignment.spaceEvenly:
        final sumWidth = barGroups.map((group) => group.width).reduce((a, b) => a + b);
        final spaceAvailable = drawSize.width - sumWidth;
        final eachSpace = spaceAvailable / (barGroups.length + 1);

        var tempX = 0.0;
        barGroups.asMap().forEach((i, group) {
          tempX += eachSpace;
          tempX += group.width / 2;
          groupsX[i] = leftTextsSpace + tempX;
          tempX += group.width / 2;
        });
        break;
    }

    return groupsX;
  }

  /// Calculates bars position alongside group positions.
  List<_GroupBarsPosition> _calculateGroupAndBarsPosition(
      Size viewSize, List<double> groupsX, List<BarChartGroupData> barGroups) {
    if (groupsX.length != barGroups.length) {
      throw Exception('inconsistent state groupsX.length != barGroups.length');
    }

    final groupBarsPosition = <_GroupBarsPosition>[];
    for (var i = 0; i < barGroups.length; i++) {
      final barGroup = barGroups[i];
      final groupX = groupsX[i];

      var tempX = 0.0;
      final barsX = <double>[];
      barGroup.barRods.asMap().forEach((barIndex, barRod) {
        final widthHalf = barRod.width / 2;
        barsX.add(groupX - (barGroup.width / 2) + tempX + widthHalf);
        tempX += barRod.width + barGroup.barsSpace;
      });
      groupBarsPosition.add(_GroupBarsPosition(groupX, barsX));
    }
    return groupBarsPosition;
  }

  void _drawBars(
    CanvasWrapper canvasWrapper,
    List<_GroupBarsPosition> groupBarsPosition,
    PaintHolder<BarChartData> holder,
  ) {
    final data = holder.data;
    final viewSize = canvasWrapper.size;
    final drawSize = getChartUsableDrawSize(viewSize, holder);

    for (var i = 0; i < data.barGroups.length; i++) {
      final barGroup = data.barGroups[i];
      for (var j = 0; j < barGroup.barRods.length; j++) {
        final barRod = barGroup.barRods[j];
        final widthHalf = barRod.width / 2;
        final borderRadius = barRod.borderRadius ?? BorderRadius.circular(barRod.width / 2);
        final borderSide = barRod.borderSide;

        final x = groupBarsPosition[i].barsX[j];

        final left = x - widthHalf;
        final right = x + widthHalf;
        final cornerHeight = max(borderRadius.topLeft.y, borderRadius.topRight.y) +
            max(borderRadius.bottomLeft.y, borderRadius.bottomRight.y);

        RRect barRRect;

        /// Draw [BackgroundBarChartRodData]
        if (barRod.backDrawRodData.show && barRod.backDrawRodData.y != 0) {
          if (barRod.backDrawRodData.y > 0) {
            // positive
            final bottom = getPixelY(max(data.minY, 0), drawSize, holder);
            final top =
                min(getPixelY(barRod.backDrawRodData.y, drawSize, holder), bottom - cornerHeight);

            barRRect = RRect.fromLTRBAndCorners(left, top, right, bottom,
                topLeft: borderRadius.topLeft,
                topRight: borderRadius.topRight,
                bottomLeft: borderRadius.bottomLeft,
                bottomRight: borderRadius.bottomRight);
          } else {
            // negative
            final top = getPixelY(min(data.maxY, 0), drawSize, holder);
            final bottom =
                max(getPixelY(barRod.backDrawRodData.y, drawSize, holder), top + cornerHeight);

            barRRect = RRect.fromLTRBAndCorners(left, top, right, bottom,
                topLeft: borderRadius.topLeft,
                topRight: borderRadius.topRight,
                bottomLeft: borderRadius.bottomLeft,
                bottomRight: borderRadius.bottomRight);
          }

          if (barRod.backDrawRodData.colors.length == 1) {
            _barPaint.color = barRod.backDrawRodData.colors[0];
            _barPaint.shader = null;
          } else {
            final from = barRod.backDrawRodData.gradientFrom;
            final to = barRod.backDrawRodData.gradientTo;

            _barPaint.shader = ui.Gradient.linear(
              Offset(
                getLeftOffsetDrawSize(holder) + (drawSize.width * from.dx),
                getTopOffsetDrawSize(holder) + (drawSize.height * from.dy),
              ),
              Offset(
                getLeftOffsetDrawSize(holder) + (drawSize.width * to.dx),
                getTopOffsetDrawSize(holder) + (drawSize.height * to.dy),
              ),
              barRod.backDrawRodData.colors,
              barRod.backDrawRodData.getSafeColorStops(),
            );
          }

          canvasWrapper.drawRRect(barRRect, _barPaint);
        }

        // draw Main Rod
        if (barRod.y != 0) {
          if (barRod.y > 0) {
            // positive
            final bottom = getPixelY(max(data.minY, 0), drawSize, holder);
            final top = min(getPixelY(barRod.y, drawSize, holder), bottom - cornerHeight);

            barRRect = RRect.fromLTRBAndCorners(left, top, right, bottom,
                topLeft: borderRadius.topLeft,
                topRight: borderRadius.topRight,
                bottomLeft: borderRadius.bottomLeft,
                bottomRight: borderRadius.bottomRight);
          } else {
            // negative
            final top = getPixelY(min(data.maxY, 0), drawSize, holder);
            final bottom = max(getPixelY(barRod.y, drawSize, holder), top + cornerHeight);

            barRRect = RRect.fromLTRBAndCorners(left, top, right, bottom,
                topLeft: borderRadius.topLeft,
                topRight: borderRadius.topRight,
                bottomLeft: borderRadius.bottomLeft,
                bottomRight: borderRadius.bottomRight);
          }
          if (barRod.colors.length == 1) {
            _barPaint.color = barRod.colors[0];
            _barPaint.shader = null;
          } else {
            final from = barRod.gradientFrom;
            final to = barRod.gradientTo;

            _barPaint.shader = ui.Gradient.linear(
              Offset(
                getLeftOffsetDrawSize(holder) + (drawSize.width * from.dx),
                getTopOffsetDrawSize(holder) + (drawSize.height * from.dy),
              ),
              Offset(
                getLeftOffsetDrawSize(holder) + (drawSize.width * to.dx),
                getTopOffsetDrawSize(holder) + (drawSize.height * to.dy),
              ),
              barRod.colors,
              barRod.getSafeColorStops(),
            );
          }
          canvasWrapper.drawRRect(barRRect, _barPaint);

          // draw border stroke
          if (borderSide.width > 0 && borderSide.color.opacity > 0) {
            _barStrokePaint.color = borderSide.color;
            _barStrokePaint.strokeWidth = borderSide.width;
            canvasWrapper.drawRRect(barRRect, _barStrokePaint);
          }

          // draw rod stack
          if (barRod.rodStackItems.isNotEmpty) {
            for (var i = 0; i < barRod.rodStackItems.length; i++) {
              final stackItem = barRod.rodStackItems[i];
              final stackFromY = getPixelY(stackItem.fromY, drawSize, holder);
              final stackToY = getPixelY(stackItem.toY, drawSize, holder);

              _barPaint.color = stackItem.color;
              canvasWrapper.save();
              canvasWrapper.clipRect(Rect.fromLTRB(left, stackToY, right, stackFromY));
              canvasWrapper.drawRRect(barRRect, _barPaint);
              canvasWrapper.restore();

              // draw border stroke for each stack item
              _drawStackItemBorderStroke(canvasWrapper, stackItem, i, barRod.rodStackItems.length,
                  barRod.width, barRRect, drawSize, holder);
            }
          }
        }
      }
    }
  }

  void _drawTitles(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    List<_GroupBarsPosition> groupBarsPosition,
    PaintHolder<BarChartData> holder,
  ) {
    final data = holder.data;
    final targetData = holder.targetData;
    if (!targetData.titlesData.show) {
      return;
    }
    final viewSize = canvasWrapper.size;
    final drawSize = getChartUsableDrawSize(viewSize, holder);

    // Left Titles
    final leftTitles = targetData.titlesData.leftTitles;
    final leftInterval =
        leftTitles.interval ?? getEfficientInterval(viewSize.height, data.verticalDiff);
    if (leftTitles.showTitles) {
      var verticalSeek = data.minY;
      while (verticalSeek <= data.maxY) {
        if (leftTitles.checkToShowTitle(
            data.minY, data.maxY, leftTitles, leftInterval, verticalSeek)) {
          var x = 0 + getLeftOffsetDrawSize(holder);
          var y = getPixelY(verticalSeek, drawSize, holder);

          final text = leftTitles.getTitles(verticalSeek);

          final span = TextSpan(
              style:
                  getThemeAwareTextStyle(context, leftTitles.getTextStyles(context, verticalSeek)),
              text: text);
          final tp = TextPainter(
              text: span,
              textAlign: TextAlign.center,
              textDirection: leftTitles.textDirection,
              textScaleFactor: holder.textScale);
          tp.layout(maxWidth: getExtraNeededHorizontalSpace(holder));
          x -= tp.width + leftTitles.margin;
          y -= tp.height / 2;
          x += calculateRotationOffset(tp.size, leftTitles.rotateAngle).dx;
          canvasWrapper.drawText(tp, Offset(x, y), leftTitles.rotateAngle);
        }
        if (data.maxY - verticalSeek < leftInterval && data.maxY != verticalSeek) {
          verticalSeek = data.maxY;
        } else {
          verticalSeek += leftInterval;
        }
      }
    }

    // Top Titles
    final topTitles = targetData.titlesData.topTitles;
    if (topTitles.showTitles) {
      for (var index = 0; index < groupBarsPosition.length; index++) {
        final groupBarPos = groupBarsPosition[index];

        final xValue = data.barGroups[index].x.toDouble();
        final text = topTitles.getTitles(xValue);
        final span = TextSpan(
            style: getThemeAwareTextStyle(context, topTitles.getTextStyles(context, xValue)),
            text: text);
        final tp = TextPainter(
            text: span,
            textAlign: TextAlign.center,
            textDirection: topTitles.textDirection,
            textScaleFactor: holder.textScale);
        tp.layout();
        var x = groupBarPos.groupX;
        var y = 0.0;

        x -= tp.width / 2;
        y += calculateRotationOffset(tp.size, topTitles.rotateAngle).dy;
        canvasWrapper.drawText(tp, Offset(x, y), topTitles.rotateAngle);
      }
    }

    // Right Titles
    final rightTitles = targetData.titlesData.rightTitles;
    final rightInterval =
        rightTitles.interval ?? getEfficientInterval(viewSize.height, data.verticalDiff);
    if (rightTitles.showTitles) {
      var verticalSeek = data.minY;
      while (verticalSeek <= data.maxY) {
        if (rightTitles.checkToShowTitle(
            data.minY, data.maxY, rightTitles, rightInterval, verticalSeek)) {
          var x = drawSize.width + getLeftOffsetDrawSize(holder);
          var y = getPixelY(verticalSeek, drawSize, holder);

          final text = rightTitles.getTitles(verticalSeek);

          final span = TextSpan(
              style:
                  getThemeAwareTextStyle(context, rightTitles.getTextStyles(context, verticalSeek)),
              text: text);
          final tp = TextPainter(
              text: span,
              textAlign: TextAlign.center,
              textDirection: rightTitles.textDirection,
              textScaleFactor: holder.textScale);
          tp.layout(maxWidth: getExtraNeededHorizontalSpace(holder));
          x += rightTitles.margin;
          y -= tp.height / 2;
          x -= calculateRotationOffset(tp.size, rightTitles.rotateAngle).dx;
          canvasWrapper.drawText(tp, Offset(x, y), rightTitles.rotateAngle);
        }
        if (data.maxY - verticalSeek < rightInterval && data.maxY != verticalSeek) {
          verticalSeek = data.maxY;
        } else {
          verticalSeek += rightInterval;
        }
      }
    }

    // Bottom titles
    final bottomTitles = targetData.titlesData.bottomTitles;
    if (bottomTitles.showTitles) {
      final interval = bottomTitles.interval?.toInt() ?? 1;

      for (var index = 0; index < groupBarsPosition.length; index += interval) {
        final groupBarPos = groupBarsPosition[index];

        final xValue = data.barGroups[index].x.toDouble();
        final text = bottomTitles.getTitles(xValue);
        // ignore: omit_local_variable_types
        final span = TextSpan(
            style: getThemeAwareTextStyle(context, bottomTitles.getTextStyles(context, xValue)),
            text: text);
        final tp = TextPainter(
            text: span,
            textAlign: TextAlign.center,
            textDirection: bottomTitles.textDirection,
            textScaleFactor: holder.textScale);
        tp.layout();
        var x = groupBarPos.groupX;
        var y = drawSize.height + getTopOffsetDrawSize(holder) + bottomTitles.margin;
        x -= tp.width / 2;
        y -= calculateRotationOffset(tp.size, bottomTitles.rotateAngle).dy;
        canvasWrapper.drawText(tp, Offset(x, y), bottomTitles.rotateAngle);
      }
    }
  }

  void _drawTouchTooltip(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    List<_GroupBarsPosition> groupPositions,
    BarTouchTooltipData tooltipData,
    BarChartGroupData showOnBarGroup,
    int barGroupIndex,
    BarChartRodData showOnRodData,
    int barRodIndex,
    PaintHolder<BarChartData> holder,
  ) {
    final viewSize = canvasWrapper.size;
    final chartUsableSize = getChartUsableDrawSize(viewSize, holder);

    const textsBelowMargin = 4;

    final tooltipItem = tooltipData.getTooltipItem(
      showOnBarGroup,
      barGroupIndex,
      showOnRodData,
      barRodIndex,
    );

    if (tooltipItem == null) {
      return;
    }

    final span = TextSpan(
      style: getThemeAwareTextStyle(context, tooltipItem.textStyle),
      text: tooltipItem.text,
      children: tooltipItem.children,
    );

    final tp = TextPainter(
        text: span,
        textAlign: tooltipItem.textAlign,
        textDirection: tooltipItem.textDirection,
        textScaleFactor: holder.textScale);
    tp.layout(maxWidth: tooltipData.maxContentWidth);

    /// creating TextPainters to calculate the width and height of the tooltip
    final drawingTextPainter = tp;

    /// biggerWidth
    /// some texts maybe larger, then we should
    /// draw the tooltip' width as wide as biggerWidth
    ///
    /// sumTextsHeight
    /// sum up all Texts height, then we should
    /// draw the tooltip's height as tall as sumTextsHeight
    final textWidth = drawingTextPainter.width;
    final textHeight = drawingTextPainter.height + textsBelowMargin;

    /// if we have multiple bar lines,
    /// there are more than one FlCandidate on touch area,
    /// we should get the most top FlSpot Offset to draw the tooltip on top of it
    final barOffset = Offset(
      groupPositions[barGroupIndex].barsX[barRodIndex],
      getPixelY(showOnRodData.y, chartUsableSize, holder),
    );

    final tooltipWidth = textWidth + tooltipData.tooltipPadding.horizontal;
    final tooltipHeight = textHeight + tooltipData.tooltipPadding.vertical;

    final zeroY = getPixelY(0, chartUsableSize, holder);
    final barTopY = min(zeroY, barOffset.dy);
    final barBottomY = max(zeroY, barOffset.dy);
    final drawTooltipOnTop = tooltipData.direction == TooltipDirection.top ||
        (tooltipData.direction == TooltipDirection.auto && showOnRodData.y > 0);
    final tooltipTop = drawTooltipOnTop
        ? barTopY - tooltipHeight - tooltipData.tooltipMargin
        : barBottomY + tooltipData.tooltipMargin;

    /// draw the background rect with rounded radius
    // ignore: omit_local_variable_types
    Rect rect =
        Rect.fromLTWH(barOffset.dx - (tooltipWidth / 2), tooltipTop, tooltipWidth, tooltipHeight);

    if (tooltipData.fitInsideHorizontally) {
      if (rect.left < 0) {
        final shiftAmount = 0 - rect.left;
        rect = Rect.fromLTRB(
          rect.left + shiftAmount,
          rect.top,
          rect.right + shiftAmount,
          rect.bottom,
        );
      }

      if (rect.right > viewSize.width) {
        final shiftAmount = rect.right - viewSize.width;
        rect = Rect.fromLTRB(
          rect.left - shiftAmount,
          rect.top,
          rect.right - shiftAmount,
          rect.bottom,
        );
      }
    }

    if (tooltipData.fitInsideVertically) {
      if (rect.top < 0) {
        final shiftAmount = 0 - rect.top;
        rect = Rect.fromLTRB(
          rect.left,
          rect.top + shiftAmount,
          rect.right,
          rect.bottom + shiftAmount,
        );
      }

      if (rect.bottom > viewSize.height) {
        final shiftAmount = rect.bottom - viewSize.height;
        rect = Rect.fromLTRB(
          rect.left,
          rect.top - shiftAmount,
          rect.right,
          rect.bottom - shiftAmount,
        );
      }
    }

    final radius = Radius.circular(tooltipData.tooltipRoundedRadius);
    final roundedRect = RRect.fromRectAndCorners(rect,
        topLeft: radius, topRight: radius, bottomLeft: radius, bottomRight: radius);
    _bgTouchTooltipPaint.color = tooltipData.tooltipBgColor;

    final rotateAngle = tooltipData.rotateAngle;
    final rectRotationOffset = Offset(0, calculateRotationOffset(rect.size, rotateAngle).dy);
    final rectDrawOffset = Offset(roundedRect.left, roundedRect.top);

    final textRotationOffset = calculateRotationOffset(tp.size, rotateAngle);

    /// draw the texts one by one in below of each other
    final top = tooltipData.tooltipPadding.top;
    final drawOffset = Offset(
      rect.center.dx - (tp.width / 2),
      rect.topCenter.dy + top - textRotationOffset.dy + rectRotationOffset.dy,
    );
    canvasWrapper.drawRotated(
      size: rect.size,
      rotationOffset: rectRotationOffset,
      drawOffset: rectDrawOffset,
      angle: rotateAngle,
      drawCallback: () {
        canvasWrapper.drawRRect(roundedRect, _bgTouchTooltipPaint);
        canvasWrapper.drawText(tp, drawOffset);
      },
    );
  }

  void _drawStackItemBorderStroke(
      CanvasWrapper canvasWrapper,
      BarChartRodStackItem stackItem,
      int index,
      int rodStacksSize,
      double barThickSize,
      RRect barRRect,
      Size drawSize,
      PaintHolder<BarChartData> holder) {
    if (stackItem.borderSide.width == 0 || stackItem.borderSide.color.opacity == 0) return;
    RRect strokeBarRect;
    if (index == 0) {
      strokeBarRect = RRect.fromLTRBAndCorners(
        barRRect.left,
        getPixelY(stackItem.toY, drawSize, holder),
        barRRect.right,
        getPixelY(stackItem.fromY, drawSize, holder),
        bottomLeft: stackItem.fromY < stackItem.toY ? barRRect.blRadius : Radius.zero,
        bottomRight: stackItem.fromY < stackItem.toY ? barRRect.brRadius : Radius.zero,
        topLeft: stackItem.fromY < stackItem.toY ? Radius.zero : barRRect.tlRadius,
        topRight: stackItem.fromY < stackItem.toY ? Radius.zero : barRRect.trRadius,
      );
    } else if (index == rodStacksSize - 1) {
      strokeBarRect = RRect.fromLTRBAndCorners(
        barRRect.left,
        max(getPixelY(stackItem.toY, drawSize, holder), barRRect.top),
        barRRect.right,
        getPixelY(stackItem.fromY, drawSize, holder),
        bottomLeft: stackItem.fromY < stackItem.toY ? Radius.zero : barRRect.blRadius,
        bottomRight: stackItem.fromY < stackItem.toY ? Radius.zero : barRRect.brRadius,
        topLeft: stackItem.fromY < stackItem.toY ? barRRect.tlRadius : Radius.zero,
        topRight: stackItem.fromY < stackItem.toY ? barRRect.trRadius : Radius.zero,
      );
    } else {
      strokeBarRect = RRect.fromLTRBR(barRRect.left, getPixelY(stackItem.toY, drawSize, holder),
          barRRect.right, getPixelY(stackItem.fromY, drawSize, holder), Radius.zero);
    }
    _barStrokePaint.color = stackItem.borderSide.color;
    _barStrokePaint.strokeWidth = min(stackItem.borderSide.width, barThickSize / 2);
    canvasWrapper.drawRRect(strokeBarRect, _barStrokePaint);
  }

  /// We add our needed horizontal space to parent needed.
  /// we have some titles that maybe draw in the left and right side of our chart,
  /// then we should draw the chart a with some left space,
  /// the left space is [getLeftOffsetDrawSize],
  /// and the whole space is [getExtraNeededHorizontalSpace]
  @override
  double getExtraNeededHorizontalSpace(PaintHolder<BarChartData> holder) {
    final data = holder.data;
    var sum = super.getExtraNeededHorizontalSpace(holder);
    if (data.titlesData.show) {
      final leftSide = data.titlesData.leftTitles;
      if (leftSide.showTitles) {
        sum += leftSide.reservedSize + leftSide.margin;
      }

      final rightSide = data.titlesData.rightTitles;
      if (rightSide.showTitles) {
        sum += rightSide.reservedSize + rightSide.margin;
      }
    }
    return sum;
  }

  /// We add our needed vertical space to parent needed.
  /// we have some titles that maybe draw in the top and bottom side of our chart,
  /// then we should draw the chart a with some top space,
  /// the top space is [getTopOffsetDrawSize()],
  /// and the whole space is [getExtraNeededVerticalSpace]
  @override
  double getExtraNeededVerticalSpace(PaintHolder<BarChartData> holder) {
    final data = holder.data;
    var sum = super.getExtraNeededVerticalSpace(holder);
    if (data.titlesData.show) {
      final bottomSide = data.titlesData.bottomTitles;
      if (bottomSide.showTitles) {
        sum += bottomSide.reservedSize + bottomSide.margin;
      }

      final topSide = data.titlesData.topTitles;
      if (topSide.showTitles) {
        sum += topSide.reservedSize + topSide.margin;
      }
    }
    return sum;
  }

  /// calculate left offset for draw the chart,
  /// maybe we want to show both left and right titles,
  /// then just the left titles will effect on this function.
  @override
  double getLeftOffsetDrawSize(PaintHolder<BarChartData> holder) {
    final data = holder.data;
    var sum = super.getLeftOffsetDrawSize(holder);

    final leftTitles = data.titlesData.leftTitles;
    if (data.titlesData.show && leftTitles.showTitles) {
      sum += leftTitles.reservedSize + leftTitles.margin;
    }

    return sum;
  }

  /// calculate top offset for draw the chart,
  /// maybe we want to show both top and bottom titles,
  /// then just the top titles will effect on this function.
  @override
  double getTopOffsetDrawSize(PaintHolder<BarChartData> holder) {
    final data = holder.data;
    var sum = super.getTopOffsetDrawSize(holder);

    final topTitles = data.titlesData.topTitles;
    if (data.titlesData.show && topTitles.showTitles) {
      sum += topTitles.reservedSize + topTitles.margin;
    }

    return sum;
  }

  /// Makes a [BarTouchedSpot] based on the provided [localPosition]
  ///
  /// Processes [localPosition] and checks
  /// the elements of the chart that are near the offset,
  /// then makes a [BarTouchedSpot] from the elements that has been touched.
  ///
  /// Returns null if finds nothing!
  BarTouchedSpot? handleTouch(
    Offset localPosition,
    Size viewSize,
    PaintHolder<BarChartData> holder,
  ) {
    final data = holder.data;
    final targetData = holder.targetData;
    final touchedPoint = localPosition;
    if (_groupBarsPosition == null) {
      final groupsX = _calculateGroupsX(viewSize, data.barGroups, data.alignment, holder);
      _groupBarsPosition = _calculateGroupAndBarsPosition(viewSize, groupsX, data.barGroups);
    }

    final chartViewSize = getChartUsableDrawSize(viewSize, holder);

    /// Find the nearest barRod
    for (var i = 0; i < _groupBarsPosition!.length; i++) {
      final groupBarPos = _groupBarsPosition![i];
      for (var j = 0; j < groupBarPos.barsX.length; j++) {
        final barX = groupBarPos.barsX[j];
        final barWidth = targetData.barGroups[i].barRods[j].width;
        final halfBarWidth = barWidth / 2;

        double barTopY;
        double barBotY;

        final isPositive = targetData.barGroups[i].barRods[j].y > 0;
        if (isPositive) {
          barTopY = getPixelY(targetData.barGroups[i].barRods[j].y, chartViewSize, holder);
          barBotY = getPixelY(0, chartViewSize, holder);
        } else {
          barTopY = getPixelY(0, chartViewSize, holder);
          barBotY = getPixelY(targetData.barGroups[i].barRods[j].y, chartViewSize, holder);
        }

        final backDrawBarY =
            getPixelY(targetData.barGroups[i].barRods[j].backDrawRodData.y, chartViewSize, holder);
        final touchExtraThreshold = targetData.barTouchData.touchExtraThreshold;

        final isXInTouchBounds =
            (touchedPoint.dx <= barX + halfBarWidth + touchExtraThreshold.right) &&
                (touchedPoint.dx >= barX - halfBarWidth - touchExtraThreshold.left);

        final isYInBarBounds = (touchedPoint.dy <= barBotY + touchExtraThreshold.bottom) &&
            (touchedPoint.dy >= barTopY - touchExtraThreshold.top);

        bool isYInBarBackDrawBounds;
        if (isPositive) {
          isYInBarBackDrawBounds = (touchedPoint.dy <= barBotY + touchExtraThreshold.bottom) &&
              (touchedPoint.dy >= backDrawBarY - touchExtraThreshold.top);
        } else {
          isYInBarBackDrawBounds = (touchedPoint.dy >= barTopY - touchExtraThreshold.top) &&
              (touchedPoint.dy <= backDrawBarY + touchExtraThreshold.bottom);
        }

        final isYInTouchBounds =
            (targetData.barTouchData.allowTouchBarBackDraw && isYInBarBackDrawBounds) ||
                isYInBarBounds;

        if (isXInTouchBounds && isYInTouchBounds) {
          final nearestGroup = targetData.barGroups[i];
          final nearestBarRod = nearestGroup.barRods[j];
          final nearestSpot = FlSpot(nearestGroup.x.toDouble(), nearestBarRod.y);
          final nearestSpotPos = Offset(barX, getPixelY(nearestSpot.y, chartViewSize, holder));

          var touchedStackIndex = -1;
          BarChartRodStackItem? touchedStack;
          for (var stackIndex = 0; stackIndex < nearestBarRod.rodStackItems.length; stackIndex++) {
            final stackItem = nearestBarRod.rodStackItems[stackIndex];
            final fromPixel = getPixelY(stackItem.fromY, chartViewSize, holder);
            final toPixel = getPixelY(stackItem.toY, chartViewSize, holder);
            if (touchedPoint.dy <= fromPixel && touchedPoint.dy >= toPixel) {
              touchedStackIndex = stackIndex;
              touchedStack = stackItem;
              break;
            }
          }

          return BarTouchedSpot(nearestGroup, i, nearestBarRod, j, touchedStack, touchedStackIndex,
              nearestSpot, nearestSpotPos);
        }
      }
    }

    return null;
  }
}

class _GroupBarsPosition {
  final double groupX;
  final List<double> barsX;

  _GroupBarsPosition(this.groupX, this.barsX);
}
