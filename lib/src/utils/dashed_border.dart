import 'package:fl_chart/src/extensions/path_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A rectangular [Border] that paints each of its sides as a dashed line.
///
/// It keeps the same [dimensions] as a normal [Border] with the same sides,
/// so swapping it in doesn't change the layout of the chart.
///
/// [dashArray] works like the `dashArray` of grid lines, for example
/// `[5, 10]` draws dashes 5 pixels long followed by blank spaces 10 pixels
/// long.
class DashedBorder extends Border {
  /// Creates a dashed copy of [border].
  DashedBorder.fromBorder(Border border, this.dashArray)
      : super(
          top: border.top,
          right: border.right,
          bottom: border.bottom,
          left: border.left,
        );

  /// The dash pattern used for every side.
  final List<int> dashArray;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    // Each line is drawn along the middle of its side, so a stroke of
    // `side.width` fills exactly the space the side takes in the layout.
    _paintSide(
      canvas,
      top,
      Offset(rect.left, rect.top + top.width / 2),
      Offset(rect.right, rect.top + top.width / 2),
    );
    _paintSide(
      canvas,
      right,
      Offset(rect.right - right.width / 2, rect.top),
      Offset(rect.right - right.width / 2, rect.bottom),
    );
    _paintSide(
      canvas,
      bottom,
      Offset(rect.left, rect.bottom - bottom.width / 2),
      Offset(rect.right, rect.bottom - bottom.width / 2),
    );
    _paintSide(
      canvas,
      left,
      Offset(rect.left + left.width / 2, rect.top),
      Offset(rect.left + left.width / 2, rect.bottom),
    );
  }

  void _paintSide(Canvas canvas, BorderSide side, Offset from, Offset to) {
    if (side.style == BorderStyle.none || side.width == 0) {
      return;
    }
    final path = (Path()
          ..moveTo(from.dx, from.dy)
          ..lineTo(to.dx, to.dy))
        .toDashedPath(dashArray);
    canvas.drawPath(
      path,
      Paint()
        ..color = side.color
        ..strokeWidth = side.width
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is DashedBorder &&
      super == other &&
      listEquals(other.dashArray, dashArray);

  @override
  int get hashCode => Object.hash(super.hashCode, Object.hashAll(dashArray));
}
