import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/fl_touch_event.dart';
import 'package:fl_chart/src/chart/base/base_chart/render_base_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_data.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'render_base_chart_test.mocks.dart';

@GenerateMocks([
  BuildContext,
  PanGestureRecognizer,
  TapGestureRecognizer,
  LongPressGestureRecognizer,
])
void main() {
  group('RenderBaseChart', () {
    late BuildContext mockContext;
    late PanGestureRecognizer panGestureRecognizer;
    late TapGestureRecognizer tapGestureRecognizer;
    late LongPressGestureRecognizer longPressGestureRecognizer;
    late TestTouchData data;
    void touchCallback(_, __) {}

    setUp(() {
      mockContext = MockBuildContext();
      panGestureRecognizer = MockPanGestureRecognizer();
      tapGestureRecognizer = MockTapGestureRecognizer();
      longPressGestureRecognizer = MockLongPressGestureRecognizer();
      data = TestTouchData(
        false,
        touchCallback,
        null,
        null,
      );
    });

    group('handleEvent', () {
      test('respects canBeScaled for pan gestures for PointerDownEvent', () {
        const pointerDownEvent = PointerDownEvent();
        final scalableChart = TestRenderBaseChart(
          mockContext,
          data,
          canBeScaled: true,
          panGestureRecognizerOverride: panGestureRecognizer,
          tapGestureRecognizerOverride: tapGestureRecognizer,
          longPressGestureRecognizerOverride: longPressGestureRecognizer,
        );

        final nonScalableChart = TestRenderBaseChart(
          mockContext,
          data,
          canBeScaled: false,
          panGestureRecognizerOverride: panGestureRecognizer,
          tapGestureRecognizerOverride: tapGestureRecognizer,
          longPressGestureRecognizerOverride: longPressGestureRecognizer,
        );

        final hitTestEntry = BoxHitTestEntry(
          scalableChart,
          Offset.zero,
        );

        scalableChart.handleEvent(pointerDownEvent, hitTestEntry);
        verifyNever(panGestureRecognizer.addPointer(pointerDownEvent));
        verify(longPressGestureRecognizer.addPointer(pointerDownEvent))
            .called(1);
        verify(tapGestureRecognizer.addPointer(pointerDownEvent)).called(1);

        nonScalableChart.handleEvent(pointerDownEvent, hitTestEntry);
        verify(panGestureRecognizer.addPointer(pointerDownEvent)).called(1);
        verify(longPressGestureRecognizer.addPointer(pointerDownEvent))
            .called(1);
        verify(tapGestureRecognizer.addPointer(pointerDownEvent)).called(1);
      });

      test(
        'does not add pointers for PointerDownEvent when no '
        'touchCallback provided',
        () {
          const pointerDownEvent = PointerDownEvent();
          final chart = TestRenderBaseChart(
            mockContext,
            TestTouchData(
              false,
              null,
              null,
              null,
            ),
            canBeScaled: true,
            panGestureRecognizerOverride: panGestureRecognizer,
            tapGestureRecognizerOverride: tapGestureRecognizer,
            longPressGestureRecognizerOverride: longPressGestureRecognizer,
          );

          final hitTestEntry = BoxHitTestEntry(
            chart,
            Offset.zero,
          );
          chart.handleEvent(pointerDownEvent, hitTestEntry);

          verifyNever(panGestureRecognizer.addPointer(pointerDownEvent));
          verifyNever(tapGestureRecognizer.addPointer(pointerDownEvent));
          verifyNever(longPressGestureRecognizer.addPointer(pointerDownEvent));
        },
      );

      test('calls touchCallback for PointerHoverEvent', () {
        late FlTouchEvent testEvent;
        late LineTouchResponse? testResponse;
        void callback(FlTouchEvent event, LineTouchResponse? response) {
          testEvent = event;
          testResponse = response;
        }

        const pointerHoverEvent = PointerHoverEvent();
        final chart = TestRenderBaseChart(
          mockContext,
          TestTouchData(
            false,
            callback,
            null,
            null,
          ),
          canBeScaled: false,
          panGestureRecognizerOverride: panGestureRecognizer,
          tapGestureRecognizerOverride: tapGestureRecognizer,
          longPressGestureRecognizerOverride: longPressGestureRecognizer,
        );

        final hitTestEntry = BoxHitTestEntry(
          chart,
          Offset.zero,
        );
        chart.handleEvent(pointerHoverEvent, hitTestEntry);

        expect(testEvent, isA<FlPointerHoverEvent>());
        expect(testResponse, isA<LineTouchResponse>());
      });
    });
  });
}

// Modify TestRenderBaseChart to track gesture recognizer calls
class TestRenderBaseChart extends RenderBaseChart<LineTouchResponse> {
  TestRenderBaseChart(
    BuildContext context,
    FlTouchData<LineTouchResponse>? touchData, {
    required bool canBeScaled,
    required this.panGestureRecognizerOverride,
    required this.tapGestureRecognizerOverride,
    required this.longPressGestureRecognizerOverride,
  }) : super(touchData, context, canBeScaled: canBeScaled);

  final PanGestureRecognizer panGestureRecognizerOverride;
  final TapGestureRecognizer tapGestureRecognizerOverride;
  final LongPressGestureRecognizer longPressGestureRecognizerOverride;

  @override
  void initGestureRecognizers() {
    super.initGestureRecognizers();
    panGestureRecognizer = panGestureRecognizerOverride;
    tapGestureRecognizer = tapGestureRecognizerOverride;
    longPressGestureRecognizer = longPressGestureRecognizerOverride;
  }

  @override
  LineTouchResponse getResponseAtLocation(Offset localPosition) {
    return LineTouchResponse(
      touchLocation: Offset.zero,
      touchChartCoordinate: Offset.zero,
      lineBarSpots: [],
    );
  }
}

class TestTouchData extends FlTouchData<LineTouchResponse> {
  TestTouchData(
    super.enabled,
    super.touchCallback,
    super.mouseCursorResolver,
    super.longPressDuration,
  );
}
