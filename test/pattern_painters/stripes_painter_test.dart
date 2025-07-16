import 'package:fl_chart/src/pattern_painters/stripes_painter.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StripesPatternPainter', () {
    test('should have correct default values', () {
      final painter = StripesPatternPainter();
      expect(painter.color, Colors.black);
      expect(painter.width, 2);
      expect(painter.gap, 10);
      expect(painter.angle, 45);
    });

    test('should be equal if all fields are equal', () {
      final a =
          StripesPatternPainter(color: Colors.red, width: 3, gap: 5, angle: 30);
      final b =
          StripesPatternPainter(color: Colors.red, width: 3, gap: 5, angle: 30);

      expect(a.angle, equals(b.angle));
      expect(a.color, equals(b.color));
      expect(a.width, equals(b.width));
      expect(a.gap, equals(b.gap));
    });

    test('should not repaint if nothing changes', () {
      final painter = StripesPatternPainter();
      expect(painter.shouldRepaint(painter), false);
    });

    testWidgets('should paint without errors with right angle (smoke test)',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: StripesPatternPainter(
                color: Colors.green,
                width: 4,
                gap: 12,
                angle: 90,
              ),
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );
    });

    testWidgets('should paint without errors with flat angle (smoke test)',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: StripesPatternPainter(
                color: Colors.green,
                width: 4,
                gap: 12,
                angle: 180,
              ),
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );
    });

    testWidgets('should paint without errors with 45 angle (smoke test)',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: StripesPatternPainter(
                color: Colors.green,
                width: 4,
                gap: 12,
              ),
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );
    });

    test('lerp returns correct interpolated painter', () {
      final a = StripesPatternPainter(color: Colors.red, gap: 8, angle: 0);
      final b = StripesPatternPainter(
        color: Colors.blue,
        width: 4,
        gap: 16,
        angle: 90,
      );
      final lerped = lerpPatternPainter(a, b, 0.4)!;

      expect(lerped, isNotNull);
      expect(lerped, isA<StripesPatternPainter>());

      final l = lerped as StripesPatternPainter;
      expect(l.angle, a.angle);
      expect(l.color, a.color);
      expect(l.gap, a.gap);
      expect(l.width, a.width);
    });
  });
}
