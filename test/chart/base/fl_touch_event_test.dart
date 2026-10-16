import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/fl_touch_event.dart';
import 'package:fl_chart/src/chart/base/base_chart/render_base_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'render_base_chart_test.mocks.dart';

void main() {
  group('FlTouchEvent.localPosition', () {
    test('FlPanEndEvent exposes localPosition from DragEndDetails', () {
      const position = Offset(10, 20);
      final event = FlPanEndEvent(
        DragEndDetails(
          globalPosition: position,
          localPosition: position,
        ),
      );
      expect(event.localPosition, position);
    });

    test('position-less events return null', () {
      expect(const FlPanCancelEvent().localPosition, isNull);
      expect(const FlTapCancelEvent().localPosition, isNull);
    });
  });

  group('RenderBaseChart pan end response', () {
    test('touchCallback receives response on pan end', () {
      const position = Offset(10, 20);
      late FlTouchEvent receivedEvent;
      LineTouchResponse? receivedResponse;
      void callback(FlTouchEvent event, LineTouchResponse? response) {
        receivedEvent = event;
        receivedResponse = response;
      }

      final chart = PanEndTestRenderBaseChart(
        MockBuildContext(),
        PanEndTestTouchData(true, callback, null, null),
      );

      chart.panGestureRecognizer.onEnd!.call(
        DragEndDetails(
          globalPosition: position,
          localPosition: position,
        ),
      );

      expect(receivedEvent, isA<FlPanEndEvent>());
      expect(receivedEvent.localPosition, position);
      expect(receivedResponse, isA<LineTouchResponse>());
      expect(receivedResponse!.touchLocation, position);
    });
  });
}

class PanEndTestRenderBaseChart extends RenderBaseChart<LineTouchResponse> {
  PanEndTestRenderBaseChart(
    BuildContext context,
    FlTouchData<LineTouchResponse>? touchData,
  ) : super(touchData, context, canBeScaled: false);

  @override
  LineTouchResponse getResponseAtLocation(Offset localPosition) {
    return LineTouchResponse(
      touchLocation: localPosition,
      touchChartCoordinate: localPosition,
      lineBarSpots: [],
    );
  }
}

class PanEndTestTouchData extends FlTouchData<LineTouchResponse> {
  PanEndTestTouchData(
    super.enabled,
    super.touchCallback,
    super.mouseCursorResolver,
    super.longPressDuration,
  );
}
