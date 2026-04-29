import 'dart:math';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data_pool.dart';

void main() {
  group('GaugeChart Data equality check', () {
    test('GaugeChartData equality test', () {
      expect(gaugeChartData1 == gaugeChartData1Clone, true);

      expect(
        gaugeChartData1 ==
            gaugeChartData1Clone.copyWith(
              rings: const [
                GaugeProgressRing(value: 0.5, color: Colors.black),
              ],
            ),
        false,
      );

      expect(
        gaugeChartData1 ==
            gaugeChartData1Clone.copyWith(
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.green),
              ),
            ),
        false,
      );

      expect(
        gaugeChartData1 ==
            gaugeChartData1Clone.copyWith(
              rings: [gaugeRing1.copyWith(strokeCap: StrokeCap.square)],
            ),
        false,
      );

      expect(
        gaugeChartData1 ==
            gaugeChartData1Clone.copyWith(touchData: gaugeTouchData2),
        false,
      );

      expect(
        gaugeChartData1 == gaugeChartData1Clone.copyWith(startDegreeOffset: 0),
        false,
      );

      expect(
        gaugeChartData1 == gaugeChartData1Clone.copyWith(sweepAngle: 10),
        false,
      );

      expect(
        gaugeChartData1 ==
            gaugeChartData1Clone.copyWith(
              direction: GaugeDirection.counterClockwise,
            ),
        false,
      );

      expect(
        gaugeChartData1 == gaugeChartData1Clone.copyWith(defaultRingWidth: 7),
        false,
      );

      expect(
        gaugeChartData1 == gaugeChartData1Clone.copyWith(ringsSpace: 2),
        false,
      );
    });

    test('GaugeChartData asserts', () {
      expect(
        () => GaugeChartData(
          maxValue: 0,
          rings: const [GaugeProgressRing(value: 0, color: Colors.red)],
        ),
        throwsAssertionError,
      );

      expect(
        () => GaugeChartData(
          sweepAngle: 0,
          rings: const [
            GaugeProgressRing(value: 0.5, color: Colors.red),
          ],
        ),
        throwsAssertionError,
      );

      expect(
        () => GaugeChartData(
          sweepAngle: 400,
          rings: const [
            GaugeProgressRing(value: 0.5, color: Colors.red),
          ],
        ),
        throwsAssertionError,
      );

      // progress value outside [minValue, maxValue]
      expect(
        () => GaugeChartData(
          rings: const [GaugeProgressRing(value: 2, color: Colors.red)],
        ),
        throwsAssertionError,
      );

      // zone outside [minValue, maxValue]
      expect(
        () => GaugeChartData(
          rings: const [
            GaugeZonesRing(
              zones: [GaugeZone(from: 0, to: 2, color: Colors.red)],
            ),
          ],
        ),
        throwsAssertionError,
      );

      // empty zones in a chart rejected at GaugeChartData level
      expect(
        () => GaugeChartData(
          rings: const [GaugeZonesRing(zones: [])],
        ),
        throwsAssertionError,
      );

      // negative ringsSpace
      expect(
        () => GaugeChartData(
          rings: const [
            GaugeProgressRing(value: 0.5, color: Colors.red),
          ],
          ringsSpace: -1,
        ),
        throwsAssertionError,
      );

      // invalid ring width
      expect(
        () => GaugeProgressRing(value: 0.5, color: Colors.red, width: 0),
        throwsAssertionError,
      );

      // invalid zone range
      expect(
        () => GaugeZone(from: 0.5, to: 0.3, color: Colors.red),
        throwsAssertionError,
      );

      // negative zonesSpace
      expect(
        () => GaugeZonesRing(
          zones: const [GaugeZone(from: 0, to: 1, color: Colors.red)],
          zonesSpace: -1,
        ),
        throwsAssertionError,
      );
    });

    test('GaugeChartData.progress factory', () {
      final data = GaugeChartData.progress(
        value: 0.6,
        color: Colors.red,
        width: 20,
        backgroundColor: Colors.grey,
      );
      expect(data.rings.length, 1);
      final ring = data.rings.first as GaugeProgressRing;
      expect(ring.value, 0.6);
      expect(ring.color, Colors.red);
      expect(ring.width, 20);
      expect(ring.backgroundColor, Colors.grey);
      expect(data.defaultRingWidth, 20);

      final clampedHigh = GaugeChartData.progress(
        value: 2,
        color: Colors.red,
        width: 20,
      );
      expect(
        (clampedHigh.rings.first as GaugeProgressRing).value,
        1,
      );

      final clampedLow = GaugeChartData.progress(
        value: -1,
        color: Colors.red,
        width: 20,
      );
      expect((clampedLow.rings.first as GaugeProgressRing).value, 0);
    });

    test('GaugeProgressRing equality and copyWith', () {
      expect(gaugeRing1 == gaugeRing1.copyWith(), true);
      expect(gaugeRing1 == gaugeRing1.copyWith(value: 0.4), false);
      expect(gaugeRing1 == gaugeRing1.copyWith(color: Colors.red), false);
      expect(gaugeRing1 == gaugeRing1.copyWith(width: 10), false);
      expect(
        gaugeRing1 == gaugeRing1.copyWith(backgroundColor: Colors.pink),
        false,
      );
    });

    test('GaugeProgressRing.lerp', () {
      const a = GaugeProgressRing(
        value: 0.2,
        color: Colors.red,
        width: 10,
        backgroundColor: Colors.pink,
      );
      const b = GaugeProgressRing(
        value: 0.8,
        color: Colors.blue,
        width: 30,
        backgroundColor: Colors.lightBlue,
      );
      final mid = GaugeProgressRing.lerp(a, b, 0.5);
      expect(mid.value, closeTo(0.5, 1e-9));
      expect(mid.width, 20);
      expect(mid.color, Color.lerp(Colors.red, Colors.blue, 0.5));
      expect(
        mid.backgroundColor,
        Color.lerp(Colors.pink, Colors.lightBlue, 0.5),
      );
    });

    test('GaugeZone equality and lerp', () {
      const a = GaugeZone(from: 0.1, to: 0.5, color: Colors.red);
      const b = GaugeZone(from: 0.3, to: 0.9, color: Colors.blue);
      expect(a == a.copyWith(), true);
      expect(a == a.copyWith(from: 0.2), false);
      expect(a == a.copyWith(to: 0.4), false);
      expect(a == a.copyWith(color: Colors.green), false);

      final mid = GaugeZone.lerp(a, b, 0.5);
      expect(mid.from, closeTo(0.2, 1e-9));
      expect(mid.to, closeTo(0.7, 1e-9));
      expect(mid.color, Color.lerp(Colors.red, Colors.blue, 0.5));
    });

    test('GaugeZonesRing equality, copyWith, lerp', () {
      const a = GaugeZonesRing(
        zones: [
          GaugeZone(from: 0, to: 0.5, color: Colors.red),
          GaugeZone(from: 0.5, to: 1, color: Colors.green),
        ],
        zonesSpace: 4,
        width: 10,
      );
      const a2 = GaugeZonesRing(
        zones: [
          GaugeZone(from: 0, to: 0.5, color: Colors.red),
          GaugeZone(from: 0.5, to: 1, color: Colors.green),
        ],
        zonesSpace: 4,
        width: 10,
      );
      expect(a == a2, true);
      expect(a == a.copyWith(width: 20), false);
      expect(a == a.copyWith(zonesSpace: 8), false);

      const b = GaugeZonesRing(
        zones: [
          GaugeZone(from: 0, to: 0.3, color: Colors.red),
          GaugeZone(from: 0.3, to: 1, color: Colors.blue),
        ],
        zonesSpace: 8,
        width: 20,
      );
      final mid = GaugeZonesRing.lerp(a, b, 0.5);
      expect(mid.width, 15);
      expect(mid.zonesSpace, closeTo(6, 1e-9));
      expect(mid.zones[0].to, closeTo(0.4, 1e-9));
      expect(
        mid.zones[1].color,
        Color.lerp(Colors.green, Colors.blue, 0.5),
      );
    });

    test('GaugeRing.lerp dispatches by type', () {
      const progressA = GaugeProgressRing(value: 0.2, color: Colors.red);
      const progressB = GaugeProgressRing(value: 0.8, color: Colors.red);
      final progressMid =
          GaugeRing.lerp(progressA, progressB, 0.5) as GaugeProgressRing;
      expect(progressMid.value, closeTo(0.5, 1e-9));

      const zonesA = GaugeZonesRing(
        zones: [GaugeZone(from: 0, to: 0.5, color: Colors.red)],
        width: 10,
      );
      const zonesB = GaugeZonesRing(
        zones: [GaugeZone(from: 0, to: 0.5, color: Colors.red)],
        width: 20,
      );
      final zonesMid = GaugeRing.lerp(zonesA, zonesB, 0.5) as GaugeZonesRing;
      expect(zonesMid.width, 15);

      // Cross-type snaps to target
      expect(GaugeRing.lerp(progressA, zonesA, 0.2), zonesA);
      expect(GaugeRing.lerp(zonesA, progressA, 0.8), progressA);
    });

    test('GaugeZonesRing.copyWith with zones parameter', () {
      const a = GaugeZonesRing(
        zones: [GaugeZone(from: 0, to: 0.5, color: Colors.red)],
        width: 10,
      );
      final b = a.copyWith(
        zones: const [GaugeZone(from: 0.1, to: 0.9, color: Colors.green)],
      );
      expect(b.zones.length, 1);
      expect(b.zones.first.from, 0.1);
      expect(b.width, 10);
    });

    test('GaugeTouchData equality test', () {
      expect(gaugeTouchData1 == gaugeTouchData1Clone, true);
      expect(gaugeTouchData1 == gaugeTouchData2, false);

      expect(
        gaugeTouchData1 ==
            GaugeTouchData(enabled: true, touchCallback: (_, __) {}),
        false,
      );

      expect(
        gaugeTouchData1 ==
            GaugeTouchData(
              enabled: true,
              mouseCursorResolver: (_, __) => MouseCursor.uncontrolled,
            ),
        false,
      );

      expect(
        gaugeTouchData1 ==
            GaugeTouchData(enabled: true, longPressDuration: Duration.zero),
        false,
      );
    });

    test('GaugeTouchedRing equality test', () {
      expect(gaugeTouchedRing1 == gaugeTouchedRingClone1, true);
      expect(gaugeTouchedRing1 == gaugeTouchedRing2, false);
      expect(gaugeTouchedRing1 == gaugeTouchedRing3, false);
    });

    test('GaugeTicks equality, copyWith-free, lerp', () {
      const a = GaugeTicks(
        count: 5,
        offset: 4,
        labelStyle: TextStyle(fontSize: 10),
        labelOffset: 3,
      );
      const aClone = GaugeTicks(
        count: 5,
        offset: 4,
        labelStyle: TextStyle(fontSize: 10),
        labelOffset: 3,
      );
      const b = GaugeTicks(
        count: 9,
        offset: 8,
        position: GaugeTickPosition.inner,
        painter: GaugeTickLinePainter(length: 12),
        checkToShowTick: GaugeTicks.hideEndpoints,
        labelStyle: TextStyle(fontSize: 14),
        labelOffset: 7,
      );
      expect(a == aClone, true);
      expect(a == b, false);
      expect(
        a ==
            const GaugeTicks(
              count: 5,
              checkToShowTick: GaugeTicks.hideEndpoints,
            ),
        false,
      );

      // Null handling — lerp returns the non-null side (b).
      expect(GaugeTicks.lerp(null, null, 0.5), isNull);
      expect(GaugeTicks.lerp(null, a, 0.5), a);
      expect(GaugeTicks.lerp(a, null, 0.5), isNull);

      final mid = GaugeTicks.lerp(a, b, 0.5)!;
      expect(mid.count, 7);
      expect(mid.offset, 6);
      expect(mid.labelOffset, 5);
      expect(mid.position, GaugeTickPosition.inner); // snaps to b
      // CheckToShowGaugeTick snaps to b too.
      expect(identical(mid.checkToShowTick, GaugeTicks.hideEndpoints), true);
      final midPainter = mid.painter as GaugeTickLinePainter;
      expect(midPainter.length, 9);
    });

    test('GaugeTicks.hideEndpoints and showAll predicates', () {
      const info0 = GaugeTickInfo(
        index: 0,
        count: 5,
        value: 0,
        minValue: 0,
        maxValue: 100,
      );
      const infoMid = GaugeTickInfo(
        index: 2,
        count: 5,
        value: 50,
        minValue: 0,
        maxValue: 100,
      );
      const infoLast = GaugeTickInfo(
        index: 4,
        count: 5,
        value: 100,
        minValue: 0,
        maxValue: 100,
      );

      expect(GaugeTicks.showAll(info0), true);
      expect(GaugeTicks.showAll(infoMid), true);
      expect(GaugeTicks.showAll(infoLast), true);

      expect(GaugeTicks.hideEndpoints(info0), false);
      expect(GaugeTicks.hideEndpoints(infoMid), true);
      expect(GaugeTicks.hideEndpoints(infoLast), false);
    });

    test('GaugeTickLinePainter equality, getSize, lerp, draw', () {
      const a = GaugeTickLinePainter();
      const b = GaugeTickLinePainter();
      const c = GaugeTickLinePainter(length: 10);
      expect(a == b, true);
      expect(a == c, false);
      expect(a.getSize(), const Size(6, 2));

      // Cross-type lerp snaps to b.
      final fallback = a.lerp(const GaugeTickCirclePainter(), 0.3);
      expect(fallback, isA<GaugeTickCirclePainter>());

      // Same-type lerp blends lengths.
      final mid = a.lerp(c, 0.5) as GaugeTickLinePainter;
      expect(mid.length, 8);

      // draw calls canvas.drawLine(zero, (length, 0), paint).
      final canvas = _RecordingCanvas();
      a.draw(
        canvas,
        const GaugeTickInfo(
          index: 0,
          count: 1,
          value: 1,
          minValue: 1,
          maxValue: 2,
        ),
      );
      expect(canvas.lines.length, 1);
      expect(canvas.lines.first.p1, Offset.zero);
      expect(canvas.lines.first.p2, const Offset(6, 0));
    });

    test('GaugeTickCirclePainter equality, getSize, lerp, draw', () {
      const a = GaugeTickCirclePainter(color: Colors.red);
      const b = GaugeTickCirclePainter(color: Colors.red);
      const c = GaugeTickCirclePainter(radius: 5, color: Colors.red);
      expect(a == b, true);
      expect(a == c, false);
      expect(a.getSize(), const Size.fromRadius(3));

      // strokeWidth > 0 draws two circles (stroke + fill).
      const withStroke = GaugeTickCirclePainter(
        radius: 4,
        color: Colors.red,
        strokeWidth: 2,
        strokeColor: Colors.blue,
      );
      final canvas = _RecordingCanvas();
      withStroke.draw(
        canvas,
        const GaugeTickInfo(
          index: 0,
          count: 1,
          value: 1,
          minValue: 1,
          maxValue: 2,
        ),
      );
      expect(canvas.circles.length, 2);
      expect(canvas.circles[0].paint.style, PaintingStyle.stroke);
      expect(canvas.circles[1].paint.style, PaintingStyle.fill);

      // strokeWidth == 0 draws only fill.
      final canvas2 = _RecordingCanvas();
      const GaugeTickCirclePainter(radius: 4, color: Colors.red).draw(
        canvas2,
        const GaugeTickInfo(
          index: 0,
          count: 1,
          value: 1,
          minValue: 1,
          maxValue: 2,
        ),
      );
      expect(canvas2.circles.length, 1);
      expect(canvas2.circles.first.paint.style, PaintingStyle.fill);
    });

    test('GaugePointer equality, copyWith, lerp', () {
      const a = GaugePointer(
        value: 0.2,
        painter: GaugePointerNeedlePainter(length: 40),
      );
      const b = GaugePointer(
        value: 0.8,
        painter: GaugePointerNeedlePainter(length: 80),
      );
      expect(a == a.copyWith(), true);
      expect(a == a.copyWith(value: 0.5), false);
      expect(
        a == a.copyWith(painter: const GaugePointerNeedlePainter(length: 99)),
        false,
      );

      final mid = GaugePointer.lerp(a, b, 0.5);
      expect(mid.value, closeTo(0.5, 1e-9));
      expect(
        (mid.painter as GaugePointerNeedlePainter).length,
        closeTo(60, 1e-9),
      );
    });

    test('GaugePointerNeedlePainter equality, getSize, lerp, draw', () {
      const a = GaugePointerNeedlePainter(length: 40, width: 6);
      const b = GaugePointerNeedlePainter(length: 40, width: 6);
      const c = GaugePointerNeedlePainter(length: 80, width: 6);
      expect(a == b, true);
      expect(a == c, false);
      expect(a.getSize(), const Size(40, 6));

      // Cross-type lerp snaps to b.
      final fallback = a.lerp(const GaugePointerCirclePainter(), 0.2);
      expect(fallback, isA<GaugePointerCirclePainter>());

      // Same-type lerp blends.
      final mid = a.lerp(c, 0.5) as GaugePointerNeedlePainter;
      expect(mid.length, 60);

      // Draw emits a single filled triangle path.
      final canvas = _RecordingCanvas();
      a.draw(canvas);
      expect(canvas.paths.length, 1);
      expect(canvas.paths.first.paint.style, PaintingStyle.fill);
    });

    test('GaugePointerCirclePainter draws at anchorRadius on +x axis', () {
      // Non-const construction so assertion lines get runtime coverage.
      const a = GaugePointerCirclePainter(
        radius: 5,
        anchorRadius: 100,
        color: Colors.red,
      );
      final canvas = _RecordingCanvas();
      a.draw(canvas);
      // anchorRadius on +x: circle centered at (100, 0).
      expect(canvas.circles.length, 1);
      expect(canvas.circles.first.center, const Offset(100, 0));
      expect(canvas.circles.first.radius, 5);

      // With strokeWidth > 0, outline first then fill.
      const outlined = GaugePointerCirclePainter(
        radius: 5,
        strokeWidth: 2,
        strokeColor: Colors.blue,
      );
      final canvas2 = _RecordingCanvas();
      outlined.draw(canvas2);
      expect(canvas2.circles.length, 2);
      expect(canvas2.circles[0].paint.style, PaintingStyle.stroke);
      expect(canvas2.circles[1].paint.style, PaintingStyle.fill);

      // Asserts fire on invalid inputs.
      expect(
        () => GaugePointerCirclePainter(radius: 0),
        throwsAssertionError,
      );
      expect(
        () => GaugePointerCirclePainter(anchorRadius: -1),
        throwsAssertionError,
      );
      expect(
        () => GaugePointerCirclePainter(strokeWidth: -1),
        throwsAssertionError,
      );
    });

    test('GaugePointerCirclePainter equality, getSize, lerp', () {
      const a = GaugePointerCirclePainter(radius: 5, anchorRadius: 100);
      const b = GaugePointerCirclePainter(radius: 5, anchorRadius: 100);
      const c = GaugePointerCirclePainter(radius: 9, anchorRadius: 100);
      expect(a == b, true);
      expect(a == c, false);

      // getSize: width = anchorRadius + radius + strokeWidth; height = 2 * that.
      expect(a.getSize(), const Size(105, 10));
      const withStroke = GaugePointerCirclePainter(radius: 5, strokeWidth: 2);
      expect(withStroke.getSize(), const Size(7, 14));

      // Same-type lerp blends fields.
      final mid = a.lerp(c, 0.5) as GaugePointerCirclePainter;
      expect(mid.radius, 7);
      expect(mid.anchorRadius, 100);

      // Cross-type lerp snaps to b.
      final fallback = a.lerp(const GaugePointerNeedlePainter(), 0.3);
      expect(fallback, isA<GaugePointerNeedlePainter>());
    });

    test('GaugeTickCirclePainter lerp (same-type + cross-type)', () {
      const a = GaugeTickCirclePainter();
      const c = GaugeTickCirclePainter(radius: 9);
      final mid = a.lerp(c, 0.5) as GaugeTickCirclePainter;
      expect(mid.radius, 6);

      // Cross-type lerp to a line painter snaps to b.
      final fallback = a.lerp(const GaugeTickLinePainter(), 0.5);
      expect(fallback, isA<GaugeTickLinePainter>());

      // Non-const construction exercises the assertion branch.
      expect(() => GaugeTickCirclePainter(radius: 0), throwsAssertionError);
    });

    test('CheckToShowGaugeTickInfo equality and props', () {
      const a = GaugeTickInfo(
        index: 1,
        count: 5,
        value: 25,
        minValue: 0,
        maxValue: 100,
      );
      const b = GaugeTickInfo(
        index: 1,
        count: 5,
        value: 25,
        minValue: 0,
        maxValue: 100,
      );
      const c = GaugeTickInfo(
        index: 2,
        count: 5,
        value: 50,
        minValue: 0,
        maxValue: 100,
      );
      expect(a == b, true);
      expect(a == c, false);
      expect(a.props.length, 5);
    });

    test('GaugeMarker equality, copyWith, lerp', () {
      const a = GaugeMarker(
        value: 0.2,
        offset: 4,
      );
      const b = GaugeMarker(
        value: 0.8,
        offset: 12,
        position: GaugeTickPosition.inner,
        painter: _DummyMarkerPainter(),
      );
      expect(a == a.copyWith(), true);
      expect(a == a.copyWith(value: 0.5), false);
      expect(a == a.copyWith(offset: 5), false);
      expect(
        a == a.copyWith(position: GaugeTickPosition.inner),
        false,
      );
      expect(
        a ==
            a.copyWith(
              painter: const GaugeMarkerLinePainter(length: 99),
            ),
        false,
      );

      final mid = GaugeMarker.lerp(a, b, 0.5);
      expect(mid.value, closeTo(0.5, 1e-9));
      expect(mid.offset, closeTo(8, 1e-9));
      // Position snaps to b (matches GaugeTicks.lerp pattern).
      expect(mid.position, GaugeTickPosition.inner);
      // Cross-type painter lerp snaps to b.
      expect(mid.painter, isA<_DummyMarkerPainter>());
    });

    test('GaugeMarkerInfo equality and props', () {
      const a = GaugeMarkerInfo(
        value: 0.5,
        minValue: 0,
        maxValue: 1,
        angleDegrees: 0,
      );
      const b = GaugeMarkerInfo(
        value: 0.5,
        minValue: 0,
        maxValue: 1,
        angleDegrees: 0,
      );
      const c = GaugeMarkerInfo(
        value: 0.6,
        minValue: 0,
        maxValue: 1,
        angleDegrees: 0,
      );
      const d = GaugeMarkerInfo(
        value: 0.5,
        minValue: 0,
        maxValue: 1,
        angleDegrees: 45,
      );
      expect(a == b, true);
      expect(a == c, false);
      expect(a == d, false);
      expect(a.props.length, 4);
    });

    test('GaugeMarkerLinePainter equality, getSize, lerp', () {
      const a = GaugeMarkerLinePainter();
      const b = GaugeMarkerLinePainter();
      const c = GaugeMarkerLinePainter(length: 30);
      expect(a == b, true);
      expect(a == c, false);
      // Default alignment is centered → outward extent is length / 2.
      expect(a.getSize(), const Size(5, 2));
      // Outward alignment → outward extent is length.
      expect(
        const GaugeMarkerLinePainter(
          alignment: GaugeMarkerLineAlignment.outward,
        ).getSize(),
        const Size(10, 2),
      );

      // Same-type lerp blends scalar fields, snaps strokeCap /
      // alignment / label* to b.
      final mid = a.lerp(c, 0.5) as GaugeMarkerLinePainter;
      expect(mid.length, closeTo(20, 1e-9));

      // alignment, label, labelStyle, labelOffset, labelSide all
      // affect equality.
      const otherAlignment =
          GaugeMarkerLinePainter(alignment: GaugeMarkerLineAlignment.outward);
      expect(a == otherAlignment, false);
      const labeled =
          GaugeMarkerLinePainter(label: 'x', labelStyle: TextStyle());
      expect(a == labeled, false);

      // Cross-type lerp snaps to b.
      final fallback = a.lerp(const _DummyMarkerPainter(), 0.3);
      expect(fallback, isA<_DummyMarkerPainter>());
    });

    test('GaugeMarkerLinePainter draw — centered default + outward', () {
      // Default: centered → line spans [-length/2, length/2].
      const centered = GaugeMarkerLinePainter();
      final canvas = _RecordingCanvas();
      centered.draw(canvas, _markerInfo);
      expect(canvas.lines.length, 1);
      expect(canvas.lines.first.p1, const Offset(-5, 0));
      expect(canvas.lines.first.p2, const Offset(5, 0));

      // alignment: outward → line spans [0, length].
      const outward = GaugeMarkerLinePainter(
        alignment: GaugeMarkerLineAlignment.outward,
      );
      final canvas2 = _RecordingCanvas();
      outward.draw(canvas2, _markerInfo);
      expect(canvas2.lines.first.p1, Offset.zero);
      expect(canvas2.lines.first.p2, const Offset(10, 0));
    });

    test(
        'GaugeMarkerLinePainter draws label when label + labelStyle set, '
        'no flip on right hemisphere', () {
      const painter = GaugeMarkerLinePainter(
        label: 'X',
        labelStyle: TextStyle(fontSize: 12),
      );
      // angleDegrees=0 → cos(0) = 1 → no auto-flip.
      const info = GaugeMarkerInfo(
        value: 0.5,
        minValue: 0,
        maxValue: 1,
        angleDegrees: 0,
      );
      final canvas = _RecordingCanvas();
      painter.draw(canvas, info);

      // Line + text; text is recorded as a paragraph.
      expect(canvas.lines.length, 1);
      expect(canvas.paragraphs.length, 1);
      // No flip → no save / translate / rotate around the text.
      expect(canvas.transformOps, isEmpty);
    });

    test(
        'GaugeMarkerLinePainter auto-flips label on left hemisphere '
        'so it stays upright', () {
      const painter = GaugeMarkerLinePainter(
        label: 'X',
        labelStyle: TextStyle(fontSize: 12),
      );
      // angleDegrees=180 → cos(π) = -1 → flip.
      const info = GaugeMarkerInfo(
        value: 0.5,
        minValue: 0,
        maxValue: 1,
        angleDegrees: 180,
      );
      final canvas = _RecordingCanvas();
      painter.draw(canvas, info);

      // Line drawn, text drawn, plus a save + translate + rotate(π) +
      // restore around the text.
      expect(canvas.lines.length, 1);
      expect(canvas.paragraphs.length, 1);
      expect(canvas.transformOps, ['save', 'translate', 'rotate', 'restore']);
      expect(canvas.rotations.single, closeTo(pi, 1e-9));
    });

    test(
        'GaugeMarkerLinePainter labelSide and labelOffset position the '
        'text on either side of the line', () {
      // outward side: text origin x ≈ lineEndX + labelOffset.
      const outwardLabel = GaugeMarkerLinePainter(
        length: 20,
        label: 'X',
        labelStyle: TextStyle(fontSize: 12),
        labelOffset: 4,
      );
      final canvas = _RecordingCanvas();
      outwardLabel.draw(canvas, _markerInfo);
      // _lineEndX = 10 (centered, length 20), labelOffset = 4.
      expect(canvas.paragraphOffsets.single.dx, closeTo(14, 1e-9));

      // inward side: text origin x ≈ lineStartX - labelOffset - textWidth.
      // Negative because the text sits at negative x.
      const inwardLabel = GaugeMarkerLinePainter(
        length: 20,
        label: 'X',
        labelStyle: TextStyle(fontSize: 12),
        labelOffset: 4,
        labelSide: GaugeMarkerLabelSide.inward,
      );
      final canvas2 = _RecordingCanvas();
      inwardLabel.draw(canvas2, _markerInfo);
      // _lineStartX = -10, labelOffset = 4 → text origin <= -14 (label
      // width depends on the text painter's layout, which we can't
      // hard-code, but it must be < -14).
      expect(canvas2.paragraphOffsets.single.dx, lessThan(-14));
    });

    test('GaugeMarkerLinePainter ignores label when labelStyle is null', () {
      const painter = GaugeMarkerLinePainter(label: 'X');
      final canvas = _RecordingCanvas();
      painter.draw(canvas, _markerInfo);
      expect(canvas.lines.length, 1);
      expect(canvas.paragraphs, isEmpty);
    });

    test('GaugeMarkerLinePainter ignores empty label', () {
      const painter = GaugeMarkerLinePainter(
        label: '',
        labelStyle: TextStyle(fontSize: 12),
      );
      final canvas = _RecordingCanvas();
      painter.draw(canvas, _markerInfo);
      expect(canvas.lines.length, 1);
      expect(canvas.paragraphs, isEmpty);
    });

    test('GaugeChartData.markers default, copyWith, lerp', () {
      final empty = GaugeChartData(
        rings: const [GaugeProgressRing(value: 0.5, color: Colors.red)],
      );
      expect(empty.markers, isEmpty);

      final withMarkers = empty.copyWith(
        markers: const [GaugeMarker(value: 0.4)],
      );
      expect(withMarkers.markers, hasLength(1));
      expect(withMarkers.markers.first.value, 0.4);

      // Lerp two charts with marker lists of equal length.
      final a = empty.copyWith(
        markers: const [GaugeMarker(value: 0.2)],
      );
      final b = empty.copyWith(
        markers: const [GaugeMarker(value: 0.8)],
      );
      final mid = a.lerp(a, b, 0.5);
      expect(mid.markers.single.value, closeTo(0.5, 1e-9));
    });

    test('GaugeChartData.pointers default, copyWith, lerp', () {
      final empty = GaugeChartData(
        rings: const [GaugeProgressRing(value: 0.5, color: Colors.red)],
      );
      expect(empty.pointers, isEmpty);

      final withPointers = empty.copyWith(pointers: const [gaugePointer1]);
      expect(withPointers.pointers, hasLength(1));
      expect(withPointers.pointers.first.value, 0.6);

      // Lerp two charts with different pointer lists.
      final a = empty.copyWith(
        pointers: const [
          GaugePointer(value: 0.2),
        ],
      );
      final b = empty.copyWith(
        pointers: const [
          GaugePointer(value: 0.8),
        ],
      );
      final mid = a.lerp(a, b, 0.5);
      expect(mid.pointers.single.value, closeTo(0.5, 1e-9));
    });

    test('GaugeChartDataTween lerp', () {
      final a = GaugeChartData(
        rings: const [
          GaugeProgressRing(
            value: 0.2,
            color: MockData.color0,
            width: 5,
            strokeCap: StrokeCap.round,
          ),
        ],
        startDegreeOffset: 0,
        touchData: GaugeTouchData(
          touchCallback: (_, __) {},
          longPressDuration: const Duration(seconds: 7),
          mouseCursorResolver: (_, __) => MouseCursor.defer,
        ),
      );

      final b = GaugeChartData(
        rings: const [
          GaugeProgressRing(
            value: 0.8,
            color: MockData.color2,
            width: 3,
            strokeCap: StrokeCap.square,
          ),
        ],
        startDegreeOffset: 20,
        sweepAngle: 230,
        touchData: GaugeTouchData(
          touchCallback: (_, __) {},
          longPressDuration: const Duration(seconds: 7),
          mouseCursorResolver: (_, __) => MouseCursor.defer,
        ),
      );

      final data = GaugeChartDataTween(begin: a, end: b).lerp(0.5);

      expect(data.rings.length, 1);
      final lerped = data.rings.first as GaugeProgressRing;
      expect(lerped.value, closeTo(0.5, 1e-9));
      expect(lerped.width, 4);
      expect(data.startDegreeOffset, 10);
      expect(data.sweepAngle, 250);
      expect(lerped.strokeCap, StrokeCap.square);
      expect(data.gaugeTouchData, b.gaugeTouchData);
    });

    test('GaugeChartData.lerp throws on illegal state', () {
      final gauge = GaugeChartData(
        rings: const [
          GaugeProgressRing(value: 0.5, color: MockData.color0),
        ],
        sweepAngle: 180,
      );

      expect(
        () => gauge.lerp(_DummyData(), _DummyData(), 0.3),
        throwsA(isA<StateError>()),
      );
    });

    test('GaugeTouchResponse.copyWith', () {
      final response = GaugeTouchResponse(
        touchLocation: const Offset(10, 20),
        touchedRing: gaugeTouchedRing1,
      );

      final same = response.copyWith();
      expect(same.touchLocation, response.touchLocation);
      expect(same.touchedRing, response.touchedRing);

      final updated = response.copyWith(
        touchLocation: const Offset(30, 40),
        touchedRing: gaugeTouchedRing2,
      );
      expect(updated.touchLocation, const Offset(30, 40));
      expect(updated.touchedRing, gaugeTouchedRing2);
    });
  });
}

class _DummyData extends BaseChartData {
  _DummyData();

  @override
  BaseChartData lerp(BaseChartData a, BaseChartData b, double t) => this;
}

class _RecordedCircle {
  const _RecordedCircle(this.center, this.radius, this.paint);

  final Offset center;
  final double radius;
  final Paint paint;
}

class _RecordedLine {
  const _RecordedLine(this.p1, this.p2, this.paint);

  final Offset p1;
  final Offset p2;
  final Paint paint;
}

class _RecordedPath {
  const _RecordedPath(this.path, this.paint);

  final Path path;
  final Paint paint;
}

class _RecordingCanvas implements Canvas {
  final List<_RecordedCircle> circles = <_RecordedCircle>[];
  final List<_RecordedLine> lines = <_RecordedLine>[];
  final List<_RecordedPath> paths = <_RecordedPath>[];
  final List<Paragraph> paragraphs = <Paragraph>[];
  final List<Offset> paragraphOffsets = <Offset>[];
  // Order of save / translate / rotate / restore calls — useful for
  // verifying the auto-flip transform structure.
  final List<String> transformOps = <String>[];
  final List<double> rotations = <double>[];

  @override
  void drawCircle(Offset c, double radius, Paint paint) {
    circles.add(_RecordedCircle(c, radius, paint));
  }

  @override
  void drawLine(Offset p1, Offset p2, Paint paint) {
    lines.add(_RecordedLine(p1, p2, paint));
  }

  @override
  void drawPath(Path path, Paint paint) {
    paths.add(_RecordedPath(path, paint));
  }

  @override
  void drawParagraph(Paragraph paragraph, Offset offset) {
    paragraphs.add(paragraph);
    paragraphOffsets.add(offset);
  }

  @override
  void save() => transformOps.add('save');

  @override
  void restore() => transformOps.add('restore');

  @override
  void translate(double dx, double dy) => transformOps.add('translate');

  @override
  void rotate(double radians) {
    transformOps.add('rotate');
    rotations.add(radians);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

const _markerInfo = GaugeMarkerInfo(
  value: 0.5,
  minValue: 0,
  maxValue: 1,
  angleDegrees: 0,
);

/// Tiny marker painter used to exercise the cross-type lerp fallback
/// path in [GaugeMarkerLinePainter] / [GaugeMarker]. Not a built-in.
class _DummyMarkerPainter extends GaugeMarkerPainter {
  const _DummyMarkerPainter();

  @override
  void draw(Canvas canvas, GaugeMarkerInfo markerInfo) {}

  @override
  Size getSize() => Size.zero;

  @override
  GaugeMarkerPainter lerp(GaugeMarkerPainter b, double t) => b;

  @override
  List<Object?> get props => const [];
}
