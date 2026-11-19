import 'package:fl_chart/src/utils/dashed_border.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

class _RecordingCanvas extends Fake implements Canvas {
  final paths = <Path>[];
  final paints = <Paint>[];

  @override
  void drawPath(Path path, Paint paint) {
    paths.add(path);
    paints.add(paint);
  }
}

void main() {
  const rect = Rect.fromLTWH(0, 0, 100, 50);

  group('DashedBorder', () {
    test('keeps the same dimensions as the original border', () {
      const border = Border(
        left: BorderSide(width: 1),
        top: BorderSide(width: 2),
        right: BorderSide(width: 3),
        bottom: BorderSide(width: 4),
      );

      final dashed = DashedBorder.fromBorder(border, const [5, 5]);

      expect(dashed.dimensions, border.dimensions);
      expect(dashed.top, border.top);
      expect(dashed.left, border.left);
    });

    test('paints every visible side with its own color and width', () {
      final canvas = _RecordingCanvas();
      DashedBorder.fromBorder(
        Border.all(color: const Color(0xFFFF0000), width: 2),
        const [4, 2],
      ).paint(canvas, rect);

      expect(canvas.paths.length, 4);
      for (final paint in canvas.paints) {
        expect(paint.color, const Color(0xFFFF0000));
        expect(paint.strokeWidth, 2);
        expect(paint.style, PaintingStyle.stroke);
      }
    });

    test('splits each side into dashes', () {
      final canvas = _RecordingCanvas();
      DashedBorder.fromBorder(
        const Border(top: BorderSide(width: 2)),
        const [10, 10],
      ).paint(canvas, rect);

      // The top side is 100 pixels long: 5 dashes of 10 with gaps of 10.
      expect(canvas.paths.length, 1);
      expect(canvas.paths.single.computeMetrics().length, 5);
    });

    test('skips sides with no width or no style', () {
      final canvas = _RecordingCanvas();
      DashedBorder.fromBorder(
        const Border(
          top: BorderSide(width: 2),
          right: BorderSide(width: 0),
          bottom: BorderSide(style: BorderStyle.none),
        ),
        const [4, 2],
      ).paint(canvas, rect);

      expect(canvas.paths.length, 1);
    });

    test('equality takes dashArray into account', () {
      final border = Border.all(width: 2);

      expect(
        DashedBorder.fromBorder(border, const [4, 2]),
        DashedBorder.fromBorder(border, const [4, 2]),
      );
      expect(
        DashedBorder.fromBorder(border, const [4, 2]) ==
            DashedBorder.fromBorder(border, const [8, 2]),
        false,
      );
      expect(DashedBorder.fromBorder(border, const [4, 2]) == border, false);
      expect(
        DashedBorder.fromBorder(border, const [4, 2]).hashCode,
        DashedBorder.fromBorder(border, const [4, 2]).hashCode,
      );
    });
  });
}
