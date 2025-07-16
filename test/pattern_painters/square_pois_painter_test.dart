import 'package:fl_chart/src/pattern_painters/square_pois_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SquarePoisPatternPainter', () {
    test('should have correct default values', () {
      final painter = SquarePoisPatternPainter();
      expect(painter.color, Colors.black);
      expect(painter.squaresPerRow, 3);
      expect(painter.gap, 2.0);
      expect(painter.maxSquareSize, 4.0);
    });

    test('should be equal if all fields are equal', () {
      final a = SquarePoisPatternPainter(
        color: Colors.red,
        squaresPerRow: 2,
        gap: 3,
        maxSquareSize: 5,
      );
      final b = SquarePoisPatternPainter(
        color: Colors.red,
        squaresPerRow: 2,
        gap: 3,
        maxSquareSize: 5,
      );

      expect(a.color, b.color);
      expect(a.squaresPerRow, b.squaresPerRow);
      expect(a.gap, b.gap);
      expect(a.maxSquareSize, b.maxSquareSize);
    });

    test('should not repaint if nothing changes', () {
      final painter = SquarePoisPatternPainter();
      expect(painter.shouldRepaint(painter), false);
    });

    testWidgets('should paint without errors (smoke test)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: SquarePoisPatternPainter(
                color: Colors.orange,
                squaresPerRow: 4,
                maxSquareSize: 6,
              ),
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );
    });

    testWidgets(
        'should paint without errors with 1 square per row (smoke test)',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: SquarePoisPatternPainter(
                color: Colors.orange,
                squaresPerRow: 1,
                maxSquareSize: 6,
              ),
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );
    });
  });
}
