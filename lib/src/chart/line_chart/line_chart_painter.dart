import 'dart:ui' as ui;

import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'line_chart_data.dart';

class LineChartPainter extends AxisChartPainter {
  final LineChartData data;

  /// [barPaint] is responsible to painting the bar line
  /// [belowBarPaint] is responsible to fill the below space of our bar line
  /// [dotPaint] is responsible to draw dots on spot points
  Paint barPaint, belowBarPaint, dotPaint;

  LineChartPainter(
    this.data,
  ) : super(data) {
    barPaint = Paint()
      ..style = PaintingStyle.stroke;

    belowBarPaint = Paint()..style = PaintingStyle.fill;

    dotPaint = Paint()
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size viewSize) {
    super.paint(canvas, viewSize);
    if (data.lineBarsData.isEmpty) {
      return;
    }

    /// draw each line independently on the chart
    data.lineBarsData.forEach((barData) {
      drawBarLine(canvas, viewSize, barData);
    });

    drawTitles(canvas, viewSize);
  }

  void drawBarLine(Canvas canvas, Size viewSize, LineChartBarData barData) {
    Path barPath = _generateBarPath(viewSize, barData);
    drawBelowBar(canvas, viewSize, barPath, barData);
    drawBar(canvas, viewSize, barPath, barData);
    drawDots(canvas, viewSize, barData);
  }

  /// firstly we generate the bar line that we should draw,
  /// then we reuse it to fill below bar space.
  /// there is two type of barPath that generate here,
  /// first one is the sharp corners line on spot connections
  /// second one is curved corners line on spot connections,
  /// and we use isCurved to find out how we should generate it,
  Path _generateBarPath(Size viewSize, LineChartBarData barData) {
    viewSize = getChartUsableDrawSize(viewSize);
    Path path = Path();
    int size = barData.spots.length;
    path.reset();

    double lX = 0.0, lY = 0.0;

    double x = getPixelX(barData.spots[0].x, viewSize);
    double y = getPixelY(barData.spots[0].y, viewSize);
    path.moveTo(x, y);
    for (int i = 1; i < size; i++) {
      /// CurrentSpot
      FlSpot p = barData.spots[i];
      double px = getPixelX(p.x, viewSize);
      double py = getPixelY(p.y, viewSize);

      /// previous spot
      FlSpot p0 = barData.spots[i - 1];
      double p0x = getPixelX(p0.x, viewSize);
      double p0y = getPixelY(p0.y, viewSize);

      double x1 = p0x + lX;
      double y1 = p0y + lY;

      /// next point
      FlSpot p1 = barData.spots[i + 1 < size ? i + 1 : i];
      double p1x = getPixelX(p1.x, viewSize);
      double p1y = getPixelY(p1.y, viewSize);

      /// if the isCurved is false, we set 0 for smoothness,
      /// it means we should not have any smoothness then we face with
      /// the sharped corners line
      double smoothness = barData.isCurved ? barData.curveSmoothness : 0.0;
      lX = ((p1x - p0x) / 2) * smoothness;
      lY = ((p1y - p0y) / 2) * smoothness;
      double x2 = px - lX;
      double y2 = py - lY;

      path.cubicTo(x1, y1, x2, y2, px, py);
    }

    return path;
  }

  /// in this phase we get the generated [barPath] as input
  /// that is the raw line bar.
  /// then we make a copy from it and call it [belowBarPath],
  /// we continue to complete the path to cover the below section.
  /// then we close the path to fill the below space with a color or gradient.
  void drawBelowBar(Canvas canvas, Size viewSize, Path barPath, LineChartBarData barData) {
    if (!barData.belowBarData.show) {
      return;
    }

    var belowBarPath = Path.from(barPath);

    Size chartViewSize = getChartUsableDrawSize(viewSize);

    /// Line To Bottom Right
    double x = getPixelX(barData.spots[barData.spots.length - 1].x, chartViewSize);
    double y = chartViewSize.height - getTopOffsetDrawSize();
    belowBarPath.lineTo(x, y);

    /// Line To Bottom Left
    x = getPixelX(barData.spots[0].x, chartViewSize);
    y = chartViewSize.height - getTopOffsetDrawSize();
    belowBarPath.lineTo(x, y);

    /// Line To Top Left
    x = getPixelX(barData.spots[0].x, chartViewSize);
    y = getPixelY(barData.spots[0].y, chartViewSize);
    belowBarPath.lineTo(x, y);
    belowBarPath.close();

    /// here we update the [belowBarPaint] to draw the solid color
    /// or the gradient based on the [BelowBarData] class.
    if (barData.belowBarData.colors.length == 1) {
      belowBarPaint.color = barData.belowBarData.colors[0];
      belowBarPaint.shader = null;
    } else {

      List<double> stops = [];
      if (barData.belowBarData.gradientColorStops == null
        || barData.belowBarData.gradientColorStops.length != barData.belowBarData.colors.length) {
        /// provided gradientColorStops is invalid and we calculate it here
        barData.colors.asMap().forEach((index, color) {
          double ss = 1.0 / barData.colors.length;
          stops.add(ss * (index + 1));
        });
      } else {
        stops = barData.colorStops;
      }

      var from = barData.belowBarData.gradientFrom;
      var to = barData.belowBarData.gradientTo;
      belowBarPaint.shader = ui.Gradient.linear(
        Offset(
          getLeftOffsetDrawSize() + (chartViewSize.width * from.dx),
          getTopOffsetDrawSize() + (chartViewSize.height * from.dy),
        ),
        Offset(
          getLeftOffsetDrawSize() + (chartViewSize.width * to.dx),
          getTopOffsetDrawSize() + (chartViewSize.height * to.dy),
        ),
        barData.belowBarData.colors,
        stops,
      );
    }

    canvas.drawPath(belowBarPath, belowBarPaint);
  }

  void drawBar(Canvas canvas, Size viewSize, Path barPath, LineChartBarData barData) {
    if (!barData.show) {
      return;
    }

    barPaint.strokeCap = barData.isStrokeCapRound ? StrokeCap.round : StrokeCap.butt;

    /// here we update the [barPaint] to draw the solid color or
    /// the gradient color,
    /// if we have one color, solid color will apply,
    /// but if we have more than one color, gradient will apply.
    if (barData.colors.length == 1) {
      barPaint.color = barData.colors[0];
      barPaint.shader = null;
    } else {

      List<double> stops = [];
      if (barData.colorStops == null || barData.colorStops.length != barData.colors.length) {
        /// provided colorStops is invalid and we calculate it here
        barData.colors.asMap().forEach((index, color) {
          double ss = 1.0 / barData.colors.length;
          stops.add(ss * (index + 1));
        });
      } else {
        stops = barData.colorStops;
      }

      barPaint.shader = ui.Gradient.linear(
        Offset(
          getLeftOffsetDrawSize(),
          getTopOffsetDrawSize() + (viewSize.height / 2),
        ),
        Offset(
          getLeftOffsetDrawSize() + viewSize.width,
          getTopOffsetDrawSize() + (viewSize.height / 2),
        ),
        barData.colors,
        stops,
      );
    }

    barPaint.strokeWidth = barData.barWidth;
    canvas.drawPath(barPath, barPaint);
  }

  void drawDots(Canvas canvas, Size viewSize, LineChartBarData barData) {
    if (!barData.dotData.show) {
      return;
    }
    viewSize = getChartUsableDrawSize(viewSize);
    barData.spots.forEach((spot) {
      if (barData.dotData.checkToShowDot(spot)) {
        double x = getPixelX(spot.x, viewSize);
        double y = getPixelY(spot.y, viewSize);
        dotPaint.color = barData.dotData.dotColor;
        canvas.drawCircle(Offset(x, y), barData.dotData.dotSize, dotPaint);
      }
    });
  }

  void drawTitles(Canvas canvas, Size viewSize) {
    if (!data.titlesData.show) {
      return;
    }
    viewSize = getChartUsableDrawSize(viewSize);

    // Vertical Titles
    if (data.titlesData.showVerticalTitles) {
      double verticalSeek = data.minY;
      while (verticalSeek <= data.maxY) {
        double x = 0 + getLeftOffsetDrawSize();
        double y = getPixelY(verticalSeek, viewSize) +
            getTopOffsetDrawSize();

        final String text =
            data.titlesData.getVerticalTitles(verticalSeek);

        final TextSpan span = TextSpan(style: data.titlesData.verticalTitlesTextStyle, text: text);
        final TextPainter tp = TextPainter(
            text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
        tp.layout(maxWidth: getExtraNeededHorizontalSpace());
        x -= tp.width + data.titlesData.verticalTitleMargin;
        y -= tp.height / 2;
        tp.paint(canvas, Offset(x, y));

        verticalSeek += data.gridData.verticalInterval;
      }
    }

    // Horizontal titles
    if (data.titlesData.showHorizontalTitles) {
      double horizontalSeek = data.minX;
      while (horizontalSeek <= data.maxX) {
        double x = getPixelX(horizontalSeek, viewSize);
        double y = viewSize.height + getTopOffsetDrawSize();

        String text = data.titlesData
            .getHorizontalTitles(horizontalSeek);

        TextSpan span = TextSpan(style: data.titlesData.horizontalTitlesTextStyle, text: text);
        TextPainter tp = TextPainter(
            text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
        tp.layout();

        x -= tp.width / 2;
        y += data.titlesData.horizontalTitleMargin;

        tp.paint(canvas, Offset(x, y));

        horizontalSeek += data.gridData.horizontalInterval;
      }
    }
  }

  /// We add our needed horizontal space to parent needed.
  /// we have some titles that maybe draw in the left side of our chart,
  /// then we should draw the chart a with some left space,
  /// the left space is [getLeftOffsetDrawSize], and the whole
  @override
  double getExtraNeededHorizontalSpace() {
    double parentNeeded = super.getExtraNeededHorizontalSpace();
    if (data.titlesData.show && data.titlesData.showVerticalTitles) {
      return parentNeeded +
        data.titlesData.verticalTitlesReservedWidth +
        data.titlesData.verticalTitleMargin;
    }
    return parentNeeded;
  }

  /// We add our needed vertical space to parent needed.
  /// we have some titles that maybe draw in the bottom side of our chart.
  @override
  double getExtraNeededVerticalSpace() {
    double parentNeeded = super.getExtraNeededVerticalSpace();
    if (data.titlesData.show && data.titlesData.showHorizontalTitles) {
      return parentNeeded +
        data.titlesData.horizontalTitlesReservedHeight +
        data.titlesData.horizontalTitleMargin;
    }
    return parentNeeded;
  }

  /// calculate left offset for draw the chart,
  /// maybe we want to show both left and right titles,
  /// then just the left titles will effect on this function.
  @override
  double getLeftOffsetDrawSize() {
    double parentNeeded = super.getLeftOffsetDrawSize();
    if (data.titlesData.show && data.titlesData.showVerticalTitles) {
      return parentNeeded +
        data.titlesData.verticalTitlesReservedWidth +
        data.titlesData.verticalTitleMargin;
    }
    return parentNeeded;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
