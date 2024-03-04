import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/extensions/path_extension.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/cupertino.dart' hide Image;

typedef DrawCallback = void Function();

/// Proxies Canvas functions
///
/// We wrapped the canvas here, because we needed to write tests for our drawing system.
/// Now in tests we can verify that these functions called with a specific value.
class CanvasWrapper {
  CanvasWrapper(
    this.canvas,
    this.size,
  );
  final Canvas canvas;
  final Size size;

  /// Directly calls [Canvas.drawRRect]
  void drawRRect(RRect rrect, Paint paint) => canvas.drawRRect(rrect, paint);

  /// Directly calls [Canvas.save]
  void save() => canvas.save();

  /// Directly calls [Canvas.restore]
  void restore() => canvas.restore();

  /// Directly calls [Canvas.clipRect]
  void clipRect(
    Rect rect, {
    ClipOp clipOp = ClipOp.intersect,
    bool doAntiAlias = true,
  }) =>
      canvas.clipRect(rect, clipOp: clipOp, doAntiAlias: doAntiAlias);

  /// Directly calls [Canvas.translate]
  void translate(double dx, double dy) => canvas.translate(dx, dy);

  /// Directly calls [Canvas.rotate]
  void rotate(double radius) => canvas.rotate(radius);

  /// Directly calls [Canvas.drawPath]
  void drawPath(Path path, Paint paint) => canvas.drawPath(path, paint);

  /// Directly calls [Canvas.saveLayer]
  void saveLayer(Rect bounds, Paint paint) => canvas.saveLayer(bounds, paint);

  /// Directly calls [Canvas.drawPicture]
  void drawPicture(Picture picture) => canvas.drawPicture(picture);

  /// Directly calls [Canvas.drawImage]
  void drawImage(Image image, Offset offset, Paint paint) =>
      canvas.drawImage(image, offset, paint);

  /// Directly calls [Canvas.clipPath]
  void clipPath(Path path, {bool doAntiAlias = true}) =>
      canvas.clipPath(path, doAntiAlias: doAntiAlias);

  /// Directly calls [Canvas.drawRect]
  void drawRect(Rect rect, Paint paint) => canvas.drawRect(rect, paint);

  /// Directly calls [Canvas.drawLine]
  void drawLine(Offset p1, Offset p2, Paint paint) =>
      canvas.drawLine(p1, p2, paint);

  /// Directly calls [Canvas.drawCircle]
  void drawCircle(Offset center, double radius, Paint paint) =>
      canvas.drawCircle(center, radius, paint);

  /// Directly calls [Canvas.drawCircle]
  void drawArc(
    Rect rect,
    double startAngle,
    double sweepAngle,
    bool useCenter,
    Paint paint,
  ) =>
      canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);

  /// Paints a text on the [Canvas]
  ///
  /// Gets a [TextPainter] and call its [TextPainter.paint] using our canvas
  void drawText(TextPainter tp, Offset offset, [double? rotateAngle]) {
    if (rotateAngle == null) {
      tp.paint(canvas, offset);
    } else {
      drawRotated(
        size: tp.size,
        drawOffset: offset,
        angle: rotateAngle,
        drawCallback: () {
          tp.paint(canvas, offset);
        },
      );
    }
  }

  /// Paints a vertical text on the [Canvas]
  ///
  /// Gets a [TextPainter] and call its [TextPainter.paint] using our canvas
  void drawVerticalText(TextPainter tp, Offset offset) {
    save();
    translate(offset.dx, offset.dy);
    rotate(Utils().radians(90));
    translate(-offset.dx, -offset.dy);
    tp.paint(canvas, offset);
    restore();
  }

  /// Paints a dot using customized [FlDotPainter]
  ///
  /// Paints a customized dot using [FlDotPainter] at the [spot]'s position,
  /// with the [offset]
  void drawDot(FlDotPainter painter, FlSpot spot, Offset offset) {
    painter.draw(canvas, spot, offset);
  }

  /// Handles performing multiple draw actions rotated.
  void drawRotated({
    required Size size,
    Offset rotationOffset = Offset.zero,
    Offset drawOffset = Offset.zero,
    required double angle,
    required DrawCallback drawCallback,
  }) {
    save();
    translate(
      rotationOffset.dx + drawOffset.dx + size.width / 2,
      rotationOffset.dy + drawOffset.dy + size.height / 2,
    );
    rotate(Utils().radians(angle));
    translate(
      -drawOffset.dx - size.width / 2,
      -drawOffset.dy - size.height / 2,
    );
    drawCallback();
    restore();
  }

  /// Draws a dashed line from passed in offsets
  void drawDashedLine(
    Offset from,
    Offset to,
    Paint painter,
    List<int>? dashArray,
  ) {
    var path = Path()
      ..moveTo(from.dx, from.dy)
      ..lineTo(to.dx, to.dy);
    path = path.toDashedPath(dashArray);
    drawPath(path, painter);
  }
}
