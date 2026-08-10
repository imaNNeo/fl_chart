import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/gauge_chart/gauge_chart_painter.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:fl_chart/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../data_pool.dart';
import 'gauge_chart_painter_test.mocks.dart';

@GenerateMocks([Canvas, CanvasWrapper, BuildContext, Utils])
void main() {
  final utilsMainInstance = Utils();

  /// Installs a mocked [Utils] whose [radians] / [degrees] methods pass
  /// values through unchanged. This lets tests assert on the *degree*
  /// arguments passed to [Canvas.drawArc] instead of radian values.
  MockUtils installIdentityUtilsMock() {
    final mockUtils = MockUtils();
    Utils.changeInstance(mockUtils);
    when(mockUtils.radians(any)).thenAnswer(
      (inv) => inv.positionalArguments[0] as double,
    );
    when(mockUtils.degrees(any)).thenAnswer(
      (inv) => inv.positionalArguments[0] as double,
    );
    when(mockUtils.getThemeAwareTextStyle(any, any)).thenAnswer(
      (inv) => (inv.positionalArguments[1] as TextStyle?) ?? const TextStyle(),
    );
    return mockUtils;
  }

  /// Installs a mocked [Utils] that delegates radians/degrees to the real
  /// implementation — used by handleTouch tests that need honest
  /// conversions.
  MockUtils installRealUtilsMock() {
    final mockUtils = MockUtils();
    Utils.changeInstance(mockUtils);
    when(mockUtils.radians(any)).thenAnswer(
      (inv) => utilsMainInstance.radians(inv.positionalArguments[0] as double),
    );
    when(mockUtils.degrees(any)).thenAnswer(
      (inv) => utilsMainInstance.degrees(inv.positionalArguments[0] as double),
    );
    return mockUtils;
  }

  group('paint()', () {
    test('dispatches to drawSections (no ticks)', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        rings: const [
          GaugeProgressRing(value: 0.5, color: Colors.red, width: 2),
        ],
        sweepAngle: 90,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
      gaugePainter.paint(MockBuildContext(), mockCanvasWrapper, holder);

      // One drawArc for the ring's filled portion (no background).
      verify(mockCanvasWrapper.drawArc(any, any, any, any, any)).called(1);
      Utils.changeInstance(utilsMainInstance);
    });
  });

  group('drawSections()', () {
    test('single ring draws only filled arc when backgroundColor is null', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        rings: const [
          GaugeProgressRing(value: 0.5, color: MockData.color0, width: 2),
        ],
        startDegreeOffset: 0,
        sweepAngle: 90,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final captured = <Map<String, dynamic>>[];
      when(
        mockCanvasWrapper.drawArc(
          captureAny,
          captureAny,
          captureAny,
          captureAny,
          captureAny,
        ),
      ).thenAnswer((inv) {
        captured.add({
          'rect': inv.positionalArguments[0] as Rect,
          'start_angle': inv.positionalArguments[1] as double,
          'sweep_angle': inv.positionalArguments[2] as double,
          'paint_color': (inv.positionalArguments[4] as Paint).color,
          'paint_stroke_width':
              (inv.positionalArguments[4] as Paint).strokeWidth,
        });
      });

      gaugePainter.drawSections(mockCanvasWrapper, holder);

      expect(captured.length, 1);
      expect(captured[0]['start_angle'], 0);
      // 0.5/1.0 * 90° = 45°
      expect(captured[0]['sweep_angle'], 45);
      expect(captured[0]['paint_color'], isSameColorAs(MockData.color0));
      expect(captured[0]['paint_stroke_width'], 2);
      Utils.changeInstance(utilsMainInstance);
    });

    test('draws background arc + filled arc when backgroundColor is set', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        rings: const [
          GaugeProgressRing(
            value: 0.5,
            color: MockData.color0,
            width: 8,
            backgroundColor: MockData.color1,
          ),
        ],
        startDegreeOffset: 10,
        sweepAngle: 90,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final captured = <Map<String, dynamic>>[];
      when(
        mockCanvasWrapper.drawArc(
          captureAny,
          captureAny,
          captureAny,
          captureAny,
          captureAny,
        ),
      ).thenAnswer((inv) {
        captured.add({
          'start_angle': inv.positionalArguments[1] as double,
          'sweep_angle': inv.positionalArguments[2] as double,
          'paint_color': (inv.positionalArguments[4] as Paint).color,
          'paint_stroke_width':
              (inv.positionalArguments[4] as Paint).strokeWidth,
        });
      });

      gaugePainter.drawSections(mockCanvasWrapper, holder);

      expect(captured.length, 2);
      // Background: full sweep
      expect(captured[0]['start_angle'], 10);
      expect(captured[0]['sweep_angle'], 90);
      expect(captured[0]['paint_color'], isSameColorAs(MockData.color1));
      // Filled: value/range * sweep
      expect(captured[1]['start_angle'], 10);
      expect(captured[1]['sweep_angle'], 45);
      expect(captured[1]['paint_color'], isSameColorAs(MockData.color0));
      Utils.changeInstance(utilsMainInstance);
    });

    test('multiple rings stack innermost-first with ringsSpace', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        rings: const [
          // innermost
          GaugeProgressRing(value: 0.5, color: Colors.red, width: 10),
          GaugeProgressRing(value: 0.8, color: Colors.green, width: 20),
          // outermost
          GaugeProgressRing(value: 0.3, color: Colors.blue, width: 15),
        ],
        sweepAngle: 180,
        ringsSpace: 4,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final rects = <Rect>[];
      when(
        mockCanvasWrapper.drawArc(captureAny, any, any, any, any),
      ).thenAnswer((inv) {
        rects.add(inv.positionalArguments[0] as Rect);
      });

      gaugePainter.drawSections(mockCanvasWrapper, holder);

      // 3 rings, no backgroundColor → 3 draws.
      expect(rects.length, 3);

      // Outer = 200. Widths 10, 20, 15; gaps 4 each; total depth = 53.
      // innermost edge = 200 - 53 = 147.
      // Section 0 (innermost, width 10): stroke center = 147 + 5 = 152.
      // Section 1 (width 20, space 4):  161 + 10 = 171.
      // Section 2 (outermost, width 15): 185 + 7.5 = 192.5.
      expect(rects[0].shortestSide / 2, 152);
      expect(rects[1].shortestSide / 2, 171);
      expect(rects[2].shortestSide / 2, 192.5);
      Utils.changeInstance(utilsMainInstance);
    });

    test('non-default min/max scales the filled sweep proportionally', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        maxValue: 100,
        rings: const [
          GaugeProgressRing(value: 75, color: Colors.red, width: 10),
        ],
        sweepAngle: 180,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final sweeps = <double>[];
      when(
        mockCanvasWrapper.drawArc(any, any, captureAny, any, any),
      ).thenAnswer((inv) {
        sweeps.add(inv.positionalArguments[2] as double);
      });

      gaugePainter.drawSections(mockCanvasWrapper, holder);
      expect(sweeps.length, 1);
      // 75/100 * 180 = 135
      expect(sweeps[0], 135);
      Utils.changeInstance(utilsMainInstance);
    });

    test('counterClockwise direction flips the filled sweep sign', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        rings: const [
          GaugeProgressRing(value: 0.5, color: Colors.red, width: 5),
        ],
        sweepAngle: 100,
        direction: GaugeDirection.counterClockwise,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final sweeps = <double>[];
      when(
        mockCanvasWrapper.drawArc(any, any, captureAny, any, any),
      ).thenAnswer((inv) {
        sweeps.add(inv.positionalArguments[2] as double);
      });

      gaugePainter.drawSections(mockCanvasWrapper, holder);
      // -100 * 0.5/1.0 = -50
      expect(sweeps[0], -50);
      Utils.changeInstance(utilsMainInstance);
    });
  });

  group('handleTouch()', () {
    test('returns null for touches outside the arc angular range', () {
      const viewSize = Size(250, 250);
      final data = GaugeChartData(
        rings: const [
          GaugeProgressRing(value: 1, color: Colors.red, width: 30),
        ],
        startDegreeOffset: 0,
        sweepAngle: 90, // arc from 0° to 90°
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installRealUtilsMock();

      // Touch above center (angle = -90°), outside [0°, 90°].
      final result = gaugePainter.handleTouch(
        const Offset(125, 30),
        viewSize,
        holder,
      );
      expect(result, isNull);
      Utils.changeInstance(utilsMainInstance);
    });

    test('reports correct ring and isOnValue for a touch on the filled part',
        () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        maxValue: 100,
        rings: const [
          GaugeProgressRing(value: 70, color: Colors.red, width: 20),
        ],
        startDegreeOffset: 0,
        sweepAngle: 180,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installRealUtilsMock();

      // Ring stroke center at 200 - 10 = 190.
      // Touch the ring at 45° (value 25 — on the filled portion since 25 < 70).
      const center = Offset(200, 200);
      const deg = 45.0;
      const rad = deg * pi / 180;
      final touch = center + Offset(cos(rad), sin(rad)) * 190;
      final hit = gaugePainter.handleTouch(touch, viewSize, holder);

      expect(hit, isNotNull);
      expect(hit!.touchedRingIndex, 0);
      expect(hit.touchValue, closeTo(25, 1e-6));
      expect(hit.isOnValue, isTrue);
      Utils.changeInstance(utilsMainInstance);
    });

    test(
        'ring hit on background part returns isOnValue=false with a '
        'valid touchValue', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        maxValue: 100,
        rings: const [
          GaugeProgressRing(value: 70, color: Colors.red, width: 20),
        ],
        startDegreeOffset: 0,
        sweepAngle: 180,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installRealUtilsMock();

      // Touch at 162° (value 90 — past 70, on the background portion).
      const center = Offset(200, 200);
      const deg = 162.0;
      const rad = deg * pi / 180;
      final touch = center + Offset(cos(rad), sin(rad)) * 190;
      final hit = gaugePainter.handleTouch(touch, viewSize, holder);

      expect(hit, isNotNull);
      expect(hit!.touchedRingIndex, 0);
      expect(hit.touchValue, closeTo(90, 1e-6));
      expect(hit.isOnValue, isFalse);
      Utils.changeInstance(utilsMainInstance);
    });

    test('inner rings are reachable when stacked with ringsSpace', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        rings: const [
          GaugeProgressRing(value: 1, color: Colors.red, width: 10),
          GaugeProgressRing(value: 1, color: Colors.blue, width: 10),
        ],
        ringsSpace: 4,
        startDegreeOffset: 0,
        sweepAngle: 180,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installRealUtilsMock();

      // Sections listed innermost-first: total depth = 10 + 4 + 10 = 24,
      // innermost edge at 200 - 24 = 176. Ring 0 (innermost) stroke center
      // 181; ring 1 (outermost) stroke center 195.
      const center = Offset(200, 200);
      final hitInner = gaugePainter.handleTouch(
        center + const Offset(181, 0),
        viewSize,
        holder,
      );
      expect(hitInner!.touchedRingIndex, 0);

      final hitOuter = gaugePainter.handleTouch(
        center + const Offset(195, 0),
        viewSize,
        holder,
      );
      expect(hitOuter!.touchedRingIndex, 1);

      // Touch far inside the gauge (radius 50) — on-arc angularly but
      // outside every ring's radial band, even after the threshold
      // extension.
      final miss = gaugePainter.handleTouch(
        center + const Offset(50, 0),
        viewSize,
        holder,
      );
      expect(miss, isNotNull);
      expect(miss!.touchedRing, isNull);
      expect(miss.touchedRingIndex, -1);
      expect(miss.isOnValue, isFalse);
      Utils.changeInstance(utilsMainInstance);
    });
  });

  group('drawSections() — zones ring', () {
    test('draws one arc per zone with correct sweep and color', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        maxValue: 100,
        rings: const [
          GaugeZonesRing(
            width: 10,
            zones: [
              GaugeZone(from: 0, to: 50, color: MockData.color0),
              GaugeZone(from: 50, to: 80, color: MockData.color1),
              GaugeZone(from: 80, to: 100, color: MockData.color2),
            ],
          ),
        ],
        startDegreeOffset: 0,
        sweepAngle: 180,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final captured = <Map<String, dynamic>>[];
      when(
        mockCanvasWrapper.drawArc(
          captureAny,
          captureAny,
          captureAny,
          captureAny,
          captureAny,
        ),
      ).thenAnswer((inv) {
        captured.add({
          'start': inv.positionalArguments[1] as double,
          'sweep': inv.positionalArguments[2] as double,
          'color': (inv.positionalArguments[4] as Paint).color,
        });
      });

      gaugePainter.drawSections(mockCanvasWrapper, holder);

      expect(captured.length, 3);
      // Zone 0: 0..50 → 90°
      expect(captured[0]['start'], 0);
      expect(captured[0]['sweep'], 90);
      expect(captured[0]['color'], isSameColorAs(MockData.color0));
      // Zone 1: 50..80 → starts at 90°, sweeps 54°
      expect(captured[1]['start'], 90);
      expect(captured[1]['sweep'], closeTo(54, 1e-9));
      // Zone 2: 80..100 → starts at 144°, sweeps 36°
      expect(captured[2]['start'], closeTo(144, 1e-9));
      expect(captured[2]['sweep'], closeTo(36, 1e-9));
      Utils.changeInstance(utilsMainInstance);
    });

    test(
        'zonesSpace draws zones full-angular and clears internal-boundary '
        'strips via saveLayer + BlendMode.clear', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        maxValue: 100,
        rings: const [
          GaugeZonesRing(
            width: 10,
            zonesSpace: 8,
            zones: [
              GaugeZone(from: 0, to: 50, color: MockData.color0),
              GaugeZone(from: 50, to: 80, color: MockData.color1),
              GaugeZone(from: 80, to: 100, color: MockData.color2),
            ],
          ),
        ],
        startDegreeOffset: 0,
        sweepAngle: 180,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final arcs = <Map<String, dynamic>>[];
      when(
        mockCanvasWrapper.drawArc(
          captureAny,
          captureAny,
          captureAny,
          captureAny,
          captureAny,
        ),
      ).thenAnswer((inv) {
        arcs.add({
          'start': inv.positionalArguments[1] as double,
          'sweep': inv.positionalArguments[2] as double,
          'color': (inv.positionalArguments[4] as Paint).color,
        });
      });
      final clearPaths = <Paint>[];
      when(mockCanvasWrapper.drawPath(captureAny, captureAny))
          .thenAnswer((inv) {
        clearPaths.add(inv.positionalArguments[1] as Paint);
      });

      gaugePainter.drawSections(mockCanvasWrapper, holder);

      // saveLayer/restore wrap the zones-ring paint.
      verify(mockCanvasWrapper.saveLayer(any, any)).called(1);
      verify(mockCanvasWrapper.restore()).called(1);

      // Every zone is drawn at its raw full angular range — no shrink.
      expect(arcs.length, 3);
      expect(arcs[0]['start'], 0);
      expect(arcs[0]['sweep'], closeTo(90, 1e-9));
      expect(arcs[1]['start'], closeTo(90, 1e-9));
      expect(arcs[1]['sweep'], closeTo(54, 1e-9));
      expect(arcs[2]['start'], closeTo(144, 1e-9));
      expect(arcs[2]['sweep'], closeTo(36, 1e-9));

      // One clear strip per internal boundary (zones.length - 1).
      expect(clearPaths.length, 2);
      for (final paint in clearPaths) {
        expect(paint.blendMode, BlendMode.clear);
        expect(paint.style, PaintingStyle.fill);
      }
      Utils.changeInstance(utilsMainInstance);
    });

    test(
        'zonesSpace with StrokeCap.round zones re-adds cap circles on '
        'each side of the carved gap', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        maxValue: 100,
        rings: const [
          GaugeZonesRing(
            width: 10,
            zonesSpace: 16,
            zones: [
              GaugeZone(
                from: 0,
                to: 50,
                color: MockData.color0,
                strokeCap: StrokeCap.round,
              ),
              GaugeZone(
                from: 50,
                to: 100,
                color: MockData.color1,
                strokeCap: StrokeCap.round,
              ),
            ],
          ),
        ],
        startDegreeOffset: 0,
        sweepAngle: 180,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final caps = <Color>[];
      when(mockCanvasWrapper.drawCircle(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        caps.add((inv.positionalArguments[2] as Paint).color);
      });

      gaugePainter.drawSections(mockCanvasWrapper, holder);

      // At the single internal boundary, a cap is re-drawn on each side —
      // one in zone 0's color, one in zone 1's color.
      expect(caps.length, 2);
      expect(caps[0], isSameColorAs(MockData.color0));
      expect(caps[1], isSameColorAs(MockData.color1));
      Utils.changeInstance(utilsMainInstance);
    });

    test(
        'zonesSpace with mixed StrokeCap — only round zones get cap '
        're-added', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        maxValue: 100,
        rings: const [
          GaugeZonesRing(
            width: 10,
            zonesSpace: 16,
            zones: [
              GaugeZone(
                from: 0,
                to: 50,
                color: MockData.color0,
                strokeCap: StrokeCap.round,
              ),
              GaugeZone(from: 50, to: 100, color: MockData.color1),
            ],
          ),
        ],
        startDegreeOffset: 0,
        sweepAngle: 180,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final caps = <Color>[];
      when(mockCanvasWrapper.drawCircle(captureAny, captureAny, captureAny))
          .thenAnswer((inv) {
        caps.add((inv.positionalArguments[2] as Paint).color);
      });

      gaugePainter.drawSections(mockCanvasWrapper, holder);

      // Only zone 0 (round) gets a cap re-added; zone 1 (butt) does not.
      expect(caps, [isSameColorAs(MockData.color0)]);
      Utils.changeInstance(utilsMainInstance);
    });

    test('zonesSpace == 0 skips saveLayer and draws zones directly', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        maxValue: 100,
        rings: const [
          GaugeZonesRing(
            width: 10,
            zones: [
              GaugeZone(from: 0, to: 50, color: MockData.color0),
              GaugeZone(from: 50, to: 100, color: MockData.color1),
            ],
          ),
        ],
        startDegreeOffset: 0,
        sweepAngle: 180,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      gaugePainter.drawSections(mockCanvasWrapper, holder);

      verifyNever(mockCanvasWrapper.saveLayer(any, any));
      verifyNever(mockCanvasWrapper.restore());
      verifyNever(mockCanvasWrapper.drawPath(any, any));
      verify(mockCanvasWrapper.drawArc(any, any, any, any, any)).called(2);
      Utils.changeInstance(utilsMainInstance);
    });
  });

  group('handleTouch() — zones ring', () {
    test('returns the hit zone for a touch inside a zone', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        maxValue: 100,
        rings: const [
          GaugeZonesRing(
            width: 20,
            zones: [
              GaugeZone(from: 0, to: 50, color: Colors.red),
              GaugeZone(from: 50, to: 80, color: Colors.amber),
              GaugeZone(from: 80, to: 100, color: Colors.green),
            ],
          ),
        ],
        startDegreeOffset: 0,
        sweepAngle: 180,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installRealUtilsMock();

      // ring stroke center = 200 - 10 = 190
      const center = Offset(200, 200);
      // Touch at 45° — value = 25 → zone 0
      {
        const rad = 45 * pi / 180;
        final touch = center + Offset(cos(rad), sin(rad)) * 190;
        final hit = gaugePainter.handleTouch(touch, viewSize, holder);
        expect(hit, isNotNull);
        expect(hit!.touchedRingIndex, 0);
        expect(hit.touchedZoneIndex, 0);
        expect(hit.touchedZone?.color, Colors.red);
        expect(hit.isOnValue, isFalse); // zones never flag isOnValue
      }
      // Touch at 135° — value = 75 → zone 1
      {
        const rad = 135 * pi / 180;
        final touch = center + Offset(cos(rad), sin(rad)) * 190;
        final hit = gaugePainter.handleTouch(touch, viewSize, holder);
        expect(hit!.touchedZoneIndex, 1);
        expect(hit.touchedZone?.color, Colors.amber);
      }
      Utils.changeInstance(utilsMainInstance);
    });

    test('reports null zone when touch falls in a gap between zones', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        maxValue: 100,
        rings: const [
          GaugeZonesRing(
            width: 20,
            zones: [
              GaugeZone(from: 0, to: 30, color: Colors.red),
              // gap 30..70
              GaugeZone(from: 70, to: 100, color: Colors.green),
            ],
          ),
        ],
        startDegreeOffset: 0,
        sweepAngle: 180,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installRealUtilsMock();

      // Touch at 90° — value = 50, sits in the gap
      const center = Offset(200, 200);
      const rad = 90 * pi / 180;
      final touch = center + Offset(cos(rad), sin(rad)) * 190;
      final hit = gaugePainter.handleTouch(touch, viewSize, holder);

      expect(hit, isNotNull);
      // Ring itself IS hit
      expect(hit!.touchedRingIndex, 0);
      expect(hit.touchedRing, isA<GaugeZonesRing>());
      // But no zone contains value 50
      expect(hit.touchedZone, isNull);
      expect(hit.touchedZoneIndex, -1);
      Utils.changeInstance(utilsMainInstance);
    });
  });

  group('drawTicks()', () {
    test('no-op when ticks is null', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        rings: const [
          GaugeProgressRing(value: 1, color: Colors.red, width: 10),
        ],
        sweepAngle: 90,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      gaugePainter.drawTicks(MockBuildContext(), mockCanvasWrapper, holder);

      verifyNever(mockCanvasWrapper.save());
      verifyNever(mockCanvasWrapper.translate(any, any));
      verifyNever(mockCanvasWrapper.rotate(any));
      verifyNever(mockCanvasWrapper.drawText(any, any));
      Utils.changeInstance(utilsMainInstance);
    });

    test('draws one save+translate+rotate+restore per tick and calls painter',
        () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        rings: const [
          GaugeProgressRing(value: 1, color: Colors.red, width: 10),
        ],
        startDegreeOffset: 0,
        sweepAngle: 90,
        ticks: const GaugeTicks(
          count: 5,
        ),
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final rotations = <double>[];
      when(mockCanvasWrapper.rotate(captureAny)).thenAnswer((inv) {
        rotations.add(inv.positionalArguments[0] as double);
      });

      gaugePainter.drawTicks(MockBuildContext(), mockCanvasWrapper, holder);

      // Save / restore wraps every tick's transform.
      verify(mockCanvasWrapper.save()).called(5);
      verify(mockCanvasWrapper.restore()).called(5);
      verify(mockCanvasWrapper.translate(any, any)).called(5);
      // Evenly spaced rotations from 0° to 90° (identity mock → degrees).
      expect(rotations.length, 5);
      expect(rotations[0], 0);
      expect(rotations[1], closeTo(22.5, 1e-9));
      expect(rotations[2], closeTo(45, 1e-9));
      expect(rotations[3], closeTo(67.5, 1e-9));
      expect(rotations[4], closeTo(90, 1e-9));
      // No labels configured → no drawText.
      verifyNever(mockCanvasWrapper.drawText(any, any));
      Utils.changeInstance(utilsMainInstance);
    });

    test(
        'center position places ticks radially between inner and outer '
        'ring edges', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        rings: const [
          GaugeProgressRing(value: 1, color: Colors.red, width: 20),
        ],
        startDegreeOffset: 0,
        sweepAngle: 90,
        ticks: const GaugeTicks(
          count: 2,
          position: GaugeTickPosition.center,
        ),
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      gaugePainter.drawTicks(MockBuildContext(), mockCanvasWrapper, holder);

      // Center position uses (outer + inner) / 2 + offset — just asserting
      // the branch is exercised (paths hit, no crash).
      verify(mockCanvasWrapper.save()).called(2);
      verify(mockCanvasWrapper.restore()).called(2);
      Utils.changeInstance(utilsMainInstance);
    });

    test('inner position adds π to rotation so +x points toward center', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        rings: const [
          GaugeProgressRing(value: 1, color: Colors.red, width: 10),
        ],
        startDegreeOffset: 0,
        sweepAngle: 90,
        ticks: const GaugeTicks(
          count: 2,
          position: GaugeTickPosition.inner,
        ),
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final rotations = <double>[];
      when(mockCanvasWrapper.rotate(captureAny)).thenAnswer((inv) {
        rotations.add(inv.positionalArguments[0] as double);
      });

      gaugePainter.drawTicks(MockBuildContext(), mockCanvasWrapper, holder);

      // Identity mock means `rotate` received a radian-value-identical-to-
      // the-degree; we just want to see the +π offset.
      expect(rotations.length, 2);
      expect(rotations[0], closeTo(pi, 1e-9));
      expect(rotations[1], closeTo(90 + pi, 1e-9));
      Utils.changeInstance(utilsMainInstance);
    });

    test('labelBuilder + labelStyle paints text at each tick', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        rings: const [
          GaugeProgressRing(value: 1, color: Colors.red, width: 10),
        ],
        startDegreeOffset: 0,
        sweepAngle: 90,
        maxValue: 100,
        ticks: GaugeTicks(
          painter: const GaugeTickLinePainter(length: 4, thickness: 1),
          labelBuilder: (v) => v.toStringAsFixed(0),
          labelStyle: const TextStyle(fontSize: 10),
        ),
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final labels = <String>[];
      when(mockCanvasWrapper.drawText(captureAny, captureAny))
          .thenAnswer((inv) {
        final tp = inv.positionalArguments[0] as TextPainter;
        labels.add((tp.text! as TextSpan).text!);
      });

      gaugePainter.drawTicks(MockBuildContext(), mockCanvasWrapper, holder);

      // 3 ticks across minValue=0, maxValue=100 → "0", "50", "100".
      expect(labels, ['0', '50', '100']);
      Utils.changeInstance(utilsMainInstance);
    });

    test('GaugeTicks.hideEndpoints skips first and last ticks + labels', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        maxValue: 100,
        rings: const [
          GaugeProgressRing(value: 1, color: Colors.red, width: 10),
        ],
        startDegreeOffset: 0,
        sweepAngle: 90,
        ticks: GaugeTicks(
          count: 5,
          checkToShowTick: GaugeTicks.hideEndpoints,
          labelBuilder: (v) => v.toStringAsFixed(0),
          labelStyle: const TextStyle(fontSize: 10),
        ),
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final labels = <String>[];
      when(mockCanvasWrapper.drawText(captureAny, captureAny))
          .thenAnswer((inv) {
        final tp = inv.positionalArguments[0] as TextPainter;
        labels.add((tp.text! as TextSpan).text!);
      });

      gaugePainter.drawTicks(MockBuildContext(), mockCanvasWrapper, holder);

      // 5 ticks total; endpoints (0 and 100) skipped, 3 interior draw.
      verify(mockCanvasWrapper.save()).called(3);
      verify(mockCanvasWrapper.restore()).called(3);
      expect(labels, ['25', '50', '75']);
      Utils.changeInstance(utilsMainInstance);
    });

    test(
        'CheckToShowGaugeTick receives index, count, value, min/max and can '
        'hide arbitrary ticks', () {
      const viewSize = Size(400, 400);
      final captured = <GaugeTickInfo>[];
      final data = GaugeChartData(
        maxValue: 100,
        rings: const [
          GaugeProgressRing(value: 1, color: Colors.red, width: 10),
        ],
        startDegreeOffset: 0,
        sweepAngle: 90,
        ticks: GaugeTicks(
          checkToShowTick: (info) {
            captured.add(info);
            // Hide only the middle tick.
            return info.index != 1;
          },
          labelBuilder: (v) => v.toStringAsFixed(0),
          labelStyle: const TextStyle(fontSize: 10),
        ),
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final labels = <String>[];
      when(mockCanvasWrapper.drawText(captureAny, captureAny))
          .thenAnswer((inv) {
        final tp = inv.positionalArguments[0] as TextPainter;
        labels.add((tp.text! as TextSpan).text!);
      });

      gaugePainter.drawTicks(MockBuildContext(), mockCanvasWrapper, holder);

      // Callback invoked once per tick, carrying full info.
      expect(captured.length, 3);
      expect(captured[0].index, 0);
      expect(captured[0].value, 0);
      expect(captured[0].minValue, 0);
      expect(captured[0].maxValue, 100);
      expect(captured[0].count, 3);
      expect(captured[1].index, 1);
      expect(captured[1].value, 50);
      expect(captured[2].index, 2);
      expect(captured[2].value, 100);

      // Middle hidden, endpoints shown.
      expect(labels, ['0', '100']);
      Utils.changeInstance(utilsMainInstance);
    });
  });

  group('drawPointers()', () {
    test('no-op when pointers list is empty', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        rings: const [
          GaugeProgressRing(value: 1, color: Colors.red, width: 10),
        ],
        sweepAngle: 90,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      gaugePainter.drawPointers(mockCanvasWrapper, holder);

      verifyNever(mockCanvasWrapper.save());
      verifyNever(mockCanvasWrapper.translate(any, any));
      verifyNever(mockCanvasWrapper.rotate(any));
      Utils.changeInstance(utilsMainInstance);
    });

    test(
        'one save/translate/rotate/restore per pointer, angle = '
        'startDegreeOffset + dir * sweepAngle * progress', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        maxValue: 100,
        rings: const [
          GaugeProgressRing(value: 1, color: Colors.red, width: 10),
        ],
        startDegreeOffset: 0,
        sweepAngle: 180,
        pointers: const [
          GaugePointer(value: 0),
          GaugePointer(value: 50),
          GaugePointer(value: 100),
        ],
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final translations = <Offset>[];
      when(mockCanvasWrapper.translate(captureAny, captureAny))
          .thenAnswer((inv) {
        translations.add(
          Offset(
            inv.positionalArguments[0] as double,
            inv.positionalArguments[1] as double,
          ),
        );
      });
      final rotations = <double>[];
      when(mockCanvasWrapper.rotate(captureAny)).thenAnswer((inv) {
        rotations.add(inv.positionalArguments[0] as double);
      });

      gaugePainter.drawPointers(mockCanvasWrapper, holder);

      verify(mockCanvasWrapper.save()).called(3);
      verify(mockCanvasWrapper.restore()).called(3);

      // Every translate goes to the gauge center (viewSize / 2).
      expect(translations, everyElement(const Offset(200, 200)));

      // Angles match: value 0 → 0°, value 50 → 90°, value 100 → 180°
      // (identity mock passes the degree through unchanged).
      expect(rotations[0], 0);
      expect(rotations[1], closeTo(90, 1e-9));
      expect(rotations[2], closeTo(180, 1e-9));
      Utils.changeInstance(utilsMainInstance);
    });

    test('counter-clockwise direction flips the angle sign', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        maxValue: 100,
        rings: const [
          GaugeProgressRing(value: 1, color: Colors.red, width: 10),
        ],
        startDegreeOffset: 0,
        sweepAngle: 180,
        direction: GaugeDirection.counterClockwise,
        pointers: const [
          GaugePointer(value: 50),
        ],
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final rotations = <double>[];
      when(mockCanvasWrapper.rotate(captureAny)).thenAnswer((inv) {
        rotations.add(inv.positionalArguments[0] as double);
      });

      gaugePainter.drawPointers(mockCanvasWrapper, holder);

      // dir = -1, progress 0.5, so angle = 0 + -1 * 180 * 0.5 = -90.
      expect(rotations.single, closeTo(-90, 1e-9));
      Utils.changeInstance(utilsMainInstance);
    });
  });

  group('drawMarkers()', () {
    test('no-op when markers list is empty', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        rings: const [
          GaugeProgressRing(value: 1, color: Colors.red, width: 10),
        ],
        sweepAngle: 90,
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      gaugePainter.drawMarkers(mockCanvasWrapper, holder);

      verifyNever(mockCanvasWrapper.save());
      verifyNever(mockCanvasWrapper.translate(any, any));
      verifyNever(mockCanvasWrapper.rotate(any));
      Utils.changeInstance(utilsMainInstance);
    });

    test(
        'one save/translate/rotate/restore per marker, angle from value, '
        'painter receives marker info', () {
      const viewSize = Size(400, 400);
      final captured = <GaugeMarkerInfo>[];
      final data = GaugeChartData(
        maxValue: 100,
        rings: const [
          GaugeProgressRing(value: 1, color: Colors.red, width: 10),
        ],
        startDegreeOffset: 0,
        sweepAngle: 180,
        markers: [
          GaugeMarker(
            value: 0,
            painter: _RecordingMarkerPainter(captured),
          ),
          GaugeMarker(
            value: 25,
            painter: _RecordingMarkerPainter(captured),
          ),
          GaugeMarker(
            value: 100,
            painter: _RecordingMarkerPainter(captured),
          ),
        ],
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final rotations = <double>[];
      when(mockCanvasWrapper.rotate(captureAny)).thenAnswer((inv) {
        rotations.add(inv.positionalArguments[0] as double);
      });

      gaugePainter.drawMarkers(mockCanvasWrapper, holder);

      verify(mockCanvasWrapper.save()).called(3);
      verify(mockCanvasWrapper.restore()).called(3);
      verify(mockCanvasWrapper.translate(any, any)).called(3);

      // value 0 → 0°, value 25 → 45°, value 100 → 180° (identity mock).
      expect(rotations[0], 0);
      expect(rotations[1], closeTo(45, 1e-9));
      expect(rotations[2], closeTo(180, 1e-9));

      // Painter received the right marker value each time.
      expect(captured.length, 3);
      expect(captured[0].value, 0);
      expect(captured[1].value, 25);
      expect(captured[2].value, 100);
      // minValue / maxValue propagated.
      expect(captured.first.minValue, 0);
      expect(captured.first.maxValue, 100);
      // angleDegrees matches the canvas rotation:
      // dir = 1, sweep = 180, start = 0
      // value 0 → 0°, value 25 → 45°, value 100 → 180°.
      expect(captured[0].angleDegrees, 0);
      expect(captured[1].angleDegrees, closeTo(45, 1e-9));
      expect(captured[2].angleDegrees, closeTo(180, 1e-9));
      Utils.changeInstance(utilsMainInstance);
    });

    test('counter-clockwise direction flips the angle sign', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        maxValue: 100,
        rings: const [
          GaugeProgressRing(value: 1, color: Colors.red, width: 10),
        ],
        startDegreeOffset: 0,
        sweepAngle: 180,
        direction: GaugeDirection.counterClockwise,
        markers: const [GaugeMarker(value: 50)],
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final rotations = <double>[];
      when(mockCanvasWrapper.rotate(captureAny)).thenAnswer((inv) {
        rotations.add(inv.positionalArguments[0] as double);
      });

      gaugePainter.drawMarkers(mockCanvasWrapper, holder);

      // dir = -1, progress 0.5 → angle = 0 + -1 * 180 * 0.5 = -90.
      expect(rotations.single, closeTo(-90, 1e-9));
      Utils.changeInstance(utilsMainInstance);
    });

    test('inner position adds π to rotation so +x points toward center', () {
      const viewSize = Size(400, 400);
      final data = GaugeChartData(
        rings: const [
          GaugeProgressRing(value: 1, color: Colors.red, width: 10),
        ],
        startDegreeOffset: 0,
        sweepAngle: 90,
        markers: const [
          GaugeMarker(value: 0, position: GaugeTickPosition.inner),
          GaugeMarker(value: 1, position: GaugeTickPosition.inner),
        ],
      );
      final gaugePainter = GaugeChartPainter();
      final holder =
          PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
      installIdentityUtilsMock();

      final mockCanvasWrapper = MockCanvasWrapper();
      when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
      when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());

      final rotations = <double>[];
      when(mockCanvasWrapper.rotate(captureAny)).thenAnswer((inv) {
        rotations.add(inv.positionalArguments[0] as double);
      });

      gaugePainter.drawMarkers(mockCanvasWrapper, holder);

      expect(rotations.length, 2);
      expect(rotations[0], closeTo(pi, 1e-9));
      expect(rotations[1], closeTo(90 + pi, 1e-9));
      Utils.changeInstance(utilsMainInstance);
    });

    test(
        'outer markers reserve padding so rings shrink to fit '
        '(picks max across ticks + markers)', () {
      // Two charts: one with no overlay, one with a big outer marker.
      // The marker should shrink the ring's outer radius by exactly
      // (offset + painter width), proven by comparing drawArc rect.
      const viewSize = Size(400, 400);
      const ringWidth = 20.0;

      Rect? rectFor(GaugeChartData data) {
        final gaugePainter = GaugeChartPainter();
        final holder =
            PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
        installIdentityUtilsMock();
        final mockCanvasWrapper = MockCanvasWrapper();
        when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
        when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
        Rect? captured;
        when(
          mockCanvasWrapper.drawArc(captureAny, any, any, any, any),
        ).thenAnswer((inv) {
          captured = inv.positionalArguments[0] as Rect;
        });
        gaugePainter.drawSections(mockCanvasWrapper, holder);
        Utils.changeInstance(utilsMainInstance);
        return captured;
      }

      final base = GaugeChartData(
        rings: const [
          GaugeProgressRing(value: 1, color: Colors.red, width: ringWidth),
        ],
        sweepAngle: 90,
      );

      // Centered line (default): outward extent is length / 2.
      // padding = offset (4) + length / 2 (6) = 10 → width diff = 20.
      final centered = base.copyWith(
        markers: const [
          GaugeMarker(
            value: 0.5,
            offset: 4,
            painter: GaugeMarkerLinePainter(length: 12),
          ),
        ],
      );
      final baseRect = rectFor(base)!;
      final centeredRect = rectFor(centered)!;
      expect(baseRect.width - centeredRect.width, closeTo(20, 1e-9));
      expect(baseRect.height - centeredRect.height, closeTo(20, 1e-9));

      // Outward alignment: outward extent is the full length.
      // padding = offset (4) + length (12) = 16 → width diff = 32.
      final outward = base.copyWith(
        markers: const [
          GaugeMarker(
            value: 0.5,
            offset: 4,
            painter: GaugeMarkerLinePainter(
              length: 12,
              alignment: GaugeMarkerLineAlignment.outward,
            ),
          ),
        ],
      );
      final outwardRect = rectFor(outward)!;
      expect(baseRect.width - outwardRect.width, closeTo(32, 1e-9));
      expect(baseRect.height - outwardRect.height, closeTo(32, 1e-9));
    });

    test(
        'inner / center markers do not affect outer padding '
        '(rings keep their original radius)', () {
      const viewSize = Size(400, 400);
      const ringWidth = 20.0;

      Rect? rectFor(GaugeChartData data) {
        final gaugePainter = GaugeChartPainter();
        final holder =
            PaintHolder<GaugeChartData>(data, data, TextScaler.noScaling);
        installIdentityUtilsMock();
        final mockCanvasWrapper = MockCanvasWrapper();
        when(mockCanvasWrapper.size).thenAnswer((_) => viewSize);
        when(mockCanvasWrapper.canvas).thenReturn(MockCanvas());
        Rect? captured;
        when(
          mockCanvasWrapper.drawArc(captureAny, any, any, any, any),
        ).thenAnswer((inv) {
          captured = inv.positionalArguments[0] as Rect;
        });
        gaugePainter.drawSections(mockCanvasWrapper, holder);
        Utils.changeInstance(utilsMainInstance);
        return captured;
      }

      final base = GaugeChartData(
        rings: const [
          GaugeProgressRing(value: 1, color: Colors.red, width: ringWidth),
        ],
        sweepAngle: 90,
      );
      final innerMarker = base.copyWith(
        markers: const [
          GaugeMarker(
            value: 0.5,
            position: GaugeTickPosition.inner,
            offset: 99,
            painter: GaugeMarkerLinePainter(length: 99),
          ),
        ],
      );
      final centerMarker = base.copyWith(
        markers: const [
          GaugeMarker(
            value: 0.5,
            position: GaugeTickPosition.center,
            offset: 99,
          ),
        ],
      );

      expect(rectFor(base), rectFor(innerMarker));
      expect(rectFor(base), rectFor(centerMarker));
    });
  });
}

class _RecordingMarkerPainter extends GaugeMarkerPainter {
  _RecordingMarkerPainter(this.captured);

  final List<GaugeMarkerInfo> captured;

  @override
  void draw(Canvas canvas, GaugeMarkerInfo markerInfo) {
    captured.add(markerInfo);
  }

  @override
  Size getSize() => Size.zero;

  @override
  GaugeMarkerPainter lerp(GaugeMarkerPainter b, double t) => b;

  @override
  List<Object?> get props => [captured];
}
