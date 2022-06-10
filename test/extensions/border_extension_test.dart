import 'package:fl_chart/src/extensions/border_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Border isVisible()', () {
    test('test 1', () {
      final border = Border(
        left: BorderSide(
          color: Colors.red.withOpacity(0.00001),
          width: 10,
        ),
        top: BorderSide.none,
        right: BorderSide.none,
        bottom: BorderSide.none,
      );
      expect(border.isVisible(), true);
    });

    test('test 2', () {
      final border = Border.all(color: Colors.black, width: 0);
      expect(border.isVisible(), false);
    });

    test('test 3', () {
      Border border = Border.all(
        color: Colors.red.withOpacity(0),
        width: 10,
      );
      expect(border.isVisible(), false);
    });
  });
}
