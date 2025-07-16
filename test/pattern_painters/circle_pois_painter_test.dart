import 'package:fl_chart/src/pattern_painters/circle_pois_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CirclePoisPatternPainter', () {
    test('should have correct default values', () {
      final painter = CirclePoisPatternPainter();
      expect(painter.color, Colors.black);
      expect(painter.dotsPerRow, 2);
      expect(painter.gap, 1.0);
      expect(painter.maxDotRadius, 3.0);
    });

    test('should be equal if all fields are equal', () {
      final a = CirclePoisPatternPainter(
        color: Colors.red,
        dotsPerRow: 3,
        gap: 2,
        maxDotRadius: 5,
      );
      final b = CirclePoisPatternPainter(
        color: Colors.red,
        dotsPerRow: 3,
        gap: 2,
        maxDotRadius: 5,
      );

      expect(a.color, b.color);
      expect(a.dotsPerRow, b.dotsPerRow);
      expect(a.gap, b.gap);
      expect(a.maxDotRadius, b.maxDotRadius);
    });

    test('should not repaint if nothing changes', () {
      final painter = CirclePoisPatternPainter();
      expect(painter.shouldRepaint(painter), false);
    });

    testWidgets('should paint without errors (smoke test)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: CirclePoisPatternPainter(
                color: Colors.purple,
                dotsPerRow: 4,
                gap: 2,
                maxDotRadius: 6,
              ),
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );
    });

    testWidgets('should paint without errors with 1 dot per row (smoke test)',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: CirclePoisPatternPainter(
                color: Colors.purple,
                dotsPerRow: 1,
                gap: 2,
                maxDotRadius: 6,
              ),
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );
    });
  });
}
