import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../shaders/fake_shaders.dart';

void main() {
  late FakeSquarePoisShader poisShader;

  setUpAll(() async {
    poisShader = FakeSquarePoisShader();
    await poisShader.init();
  });

  group('SquarePoisPatternPainter', () {
    test('should have correct default values', () {
      final painter = SquarePoisPatternPainter(
        mockShader: poisShader,
      );
      expect(painter.color, Colors.black);
      expect(painter.squaresPerRow, 3);
      expect(painter.gap, 2.0);
      expect(painter.verticalGap, 2.0);
      expect(painter.margin, 2.0);
    });

    test('should be equal if all fields are equal', () {
      final a = SquarePoisPatternPainter(
        color: Colors.red,
        squaresPerRow: 2,
        gap: 3,
        mockShader: poisShader,
      );
      final b = SquarePoisPatternPainter(
        color: Colors.red,
        squaresPerRow: 2,
        gap: 3,
        mockShader: poisShader,
      );

      expect(a.color, b.color);
      expect(a.squaresPerRow, b.squaresPerRow);
      expect(a.gap, b.gap);
      expect(a.verticalGap, b.verticalGap);
      expect(a.margin, b.margin);
    });

    test('should not repaint if nothing changes', () {
      final painter = SquarePoisPatternPainter(
        mockShader: poisShader,
      );
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
                mockShader: poisShader,
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
                mockShader: poisShader,
              ),
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );
    });
  });

  group('MockSquarePoisShader not initialized', () {
    final notInitializedShader = FakeSquarePoisShader();

    test(
        'should throw StateError when accessing shader and setFloat before init',
        () {
      final painter = SquarePoisPatternPainter(
        color: Colors.purple,
        mockShader: notInitializedShader,
      );
      expect(() => painter.flShader.shader, throwsStateError);
      expect(() => painter.flShader.setFloat(0, 1), throwsStateError);
    });
  });
}
