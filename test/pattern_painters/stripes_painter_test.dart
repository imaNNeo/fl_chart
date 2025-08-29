import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../shaders/fake_shaders.dart';

void main() {
  late FakeStripesShader stripesShader;

  group('Initialization', () {
    test('should initialize shader', () async {
      final painter = StripesPatternPainter(
        stripesShader: stripesShader,
      );
      await painter.initialize();

      expect(painter.isInitialized, isTrue);
    });
  });

  setUpAll(() async {
    stripesShader = FakeStripesShader();
    await stripesShader.init();
  });

  group('StripesPatternPainter', () {
    test('should have correct default values', () {
      final painter = StripesPatternPainter(
        stripesShader: stripesShader,
      );
      expect(painter.color, Colors.black);
      expect(painter.width, 2);
      expect(painter.gap, 4);
      expect(painter.angle, 45);
    });

    test('should be equal if all fields are equal', () {
      final a = StripesPatternPainter(
        color: Colors.red,
        width: 3,
        gap: 5,
        angle: 30,
        stripesShader: stripesShader,
      );
      final b = StripesPatternPainter(
        color: Colors.red,
        width: 3,
        gap: 5,
        angle: 30,
        stripesShader: stripesShader,
      );

      expect(a.angle, equals(b.angle));
      expect(a.color, equals(b.color));
      expect(a.width, equals(b.width));
      expect(a.gap, equals(b.gap));
    });

    test('should not repaint if nothing changes', () {
      final painter = StripesPatternPainter(
        stripesShader: stripesShader,
      );
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
                stripesShader: stripesShader,
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
                stripesShader: stripesShader,
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
                stripesShader: stripesShader,
              ),
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );
    });

    test('lerp returns correct interpolated painter', () {
      final a = StripesPatternPainter(
        color: Colors.red,
        gap: 8,
        angle: 0,
        stripesShader: stripesShader,
      );
      final b = StripesPatternPainter(
        color: Colors.blue,
        width: 4,
        gap: 16,
        angle: 90,
        stripesShader: stripesShader,
      );
      final lerped = lerpSurfacePainter(a, b, 0.4)!;

      expect(lerped, isNotNull);
      expect(lerped, isA<StripesPatternPainter>());

      final l = lerped as StripesPatternPainter;
      expect(l.angle, a.angle);
      expect(l.color, a.color);
      expect(l.gap, a.gap);
      expect(l.width, a.width);
    });
  });

  group('StripesPatternPainter not initialized', () {
    final notInitializedShader = FakeStripesShader();

    test(
        'should throw StateError when accessing shader and setFloat before init',
        () {
      final painter = StripesPatternPainter(
        color: Colors.purple,
        stripesShader: notInitializedShader,
      );
      expect(() => painter.stripesShader.shader, throwsStateError);
      expect(() => painter.stripesShader.setFloat(0, 1), throwsStateError);
    });
  });
}
