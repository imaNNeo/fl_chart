import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/extensions/fl_border_data_extension.dart';
import 'package:fl_chart/src/utils/dashed_border.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('test allSidesPadding', () {
    expect(
      FlBorderData(
        show: false,
        border: Border.all(
          color: Colors.red,
          width: 10,
        ),
      ).allSidesPadding,
      EdgeInsets.zero,
    );

    expect(
      FlBorderData(
        show: true,
        border: Border(
          left: const BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            width: 10,
            color: Colors.red.withValues(alpha: 0.5),
          ),
          bottom: const BorderSide(
            width: 4,
            color: Colors.red,
          ),
        ),
      ).allSidesPadding,
      const EdgeInsets.fromLTRB(1, 10, 0, 4),
    );
  });

  group('borderToPaint', () {
    final border = Border.all(color: Colors.red, width: 2);

    test('returns the border itself when dashArray is null', () {
      expect(FlBorderData(border: border).borderToPaint, same(border));
    });

    test('returns the border itself when dashArray is empty', () {
      expect(
        FlBorderData(border: border, dashArray: const []).borderToPaint,
        same(border),
      );
    });

    test('returns a DashedBorder when dashArray is set', () {
      final borderToPaint =
          FlBorderData(border: border, dashArray: const [5, 3]).borderToPaint;

      expect(borderToPaint, isA<DashedBorder>());
      expect((borderToPaint as DashedBorder).dashArray, const [5, 3]);
      expect(borderToPaint.dimensions, border.dimensions);
    });
  });
}
