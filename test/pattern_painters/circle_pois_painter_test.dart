import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../shaders/fake_shaders.dart';

void main() {
  late FakeCirclePoisShader poisShader;

  setUpAll(() async {
    poisShader = FakeCirclePoisShader();
    await poisShader.init();
  });

  group('CirclePoisPatternPainter', () {
    test('should have correct default values', () {
      final painter = CirclePoisPatternPainter(
        poisShader: poisShader,
      );
      expect(painter.color, Colors.black);
      expect(painter.dotsPerRow, 2);
      expect(painter.gap, 2.0);
      expect(painter.verticalGap, 2.0);
      expect(painter.margin, 2.0);
    });

    test('should be equal if all fields are equal', () {
      final a = CirclePoisPatternPainter(
        color: Colors.red,
        dotsPerRow: 3,
        poisShader: poisShader,
      );
      final b = CirclePoisPatternPainter(
        color: Colors.red,
        dotsPerRow: 3,
        poisShader: poisShader,
      );

      expect(a.color, b.color);
      expect(a.dotsPerRow, b.dotsPerRow);
      expect(a.gap, b.gap);
      expect(a.verticalGap, b.verticalGap);
      expect(a.margin, b.margin);
      expect(a.poisShader, b.poisShader);
    });

    test('should not repaint if nothing changes', () {
      final painter = CirclePoisPatternPainter(
        poisShader: poisShader,
      );
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
                poisShader: poisShader,
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
                poisShader: poisShader,
              ),
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );
    });
  });

  group('CirclePoisPatternPainter not initialized', () {
    final notInitializedShader = FakeCirclePoisShader();

    test(
        'should throw StateError when accessing shader and setFloat before init',
        () {
      final painter = CirclePoisPatternPainter(
        color: Colors.purple,
        dotsPerRow: 4,
        poisShader: notInitializedShader,
      );
      expect(() => painter.poisShader.shader, throwsStateError);
      expect(() => painter.poisShader.setFloat(0, 1), throwsStateError);
    });
  });
}
