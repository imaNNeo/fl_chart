import 'package:fl_chart/src/extensions/rect_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RectExtension', () {
    group('addPadding', () {
      test('should not affect with EdgeInsets.zero', () {
        const rect = Rect.fromLTWH(1, 1, 1, 1);
        const padding = EdgeInsets.zero;

        expect(rect.applyPadding(padding), rect);
      });

      // Adjust tooltip start heights?

      test('should add correct amount of padding', () {
        const rect = Rect.fromLTRB(25, 50, 100, 100);
        const padding = EdgeInsets.symmetric(vertical: 16, horizontal: 8);
        expect(
          rect.applyPadding(padding),
          Rect.fromLTRB(
            25 - padding.left,
            50 - padding.top,
            100 + padding.right,
            100 + padding.bottom,
          ),
        );
      });
    });
  });
}
