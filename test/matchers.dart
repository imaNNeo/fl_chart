import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_data.dart';
import 'package:flutter_test/flutter_test.dart';

Matcher matchesScatterSpotWithCirclePainter(ScatterSpot spot) {
  return isA<ScatterSpot>()
      .having(
        (spot) => spot.x,
        'x',
        spot.x,
      )
      .having(
        (spot) => spot.y,
        'y',
        spot.y,
      )
      .having(
        (spot) => spot.show,
        'show',
        spot.show,
      )
      .having(
        (spot) => spot.dotPainter,
        'dotPainter',
        isA<FlDotCirclePainter>().having(
          (painter) => painter.color,
          'color',
          isSameColorAs((spot.dotPainter as FlDotCirclePainter).color),
        ),
      );
}

Matcher matchesVerticalRangeAnnotation(VerticalRangeAnnotation annotation) {
  return isA<VerticalRangeAnnotation>()
      .having(
        (annotation) => annotation.x1,
        'x1',
        annotation.x1,
      )
      .having(
        (annotation) => annotation.x2,
        'x2',
        annotation.x2,
      )
      .having(
        (annotation) => annotation.color,
        'color',
        isSameColorAs(annotation.color!),
      );
}

Matcher matchesHorizontalRangeAnnotation(HorizontalRangeAnnotation annotation) {
  return isA<HorizontalRangeAnnotation>()
      .having(
        (annotation) => annotation.y1,
        'y1',
        annotation.y1,
      )
      .having(
        (annotation) => annotation.y2,
        'y2',
        annotation.y2,
      )
      .having(
        (annotation) => annotation.color,
        'color',
        isSameColorAs(annotation.color!),
      );
}

Matcher matchesVerticalLine(VerticalLine line) {
  return isA<VerticalLine>()
      .having(
        (line) => line.x,
        'x',
        line.x,
      )
      .having(
        (line) => line.color,
        'color',
        isSameColorAs(line.color!),
      );
}

Matcher matchesHorizontalLine(HorizontalLine line) {
  return isA<HorizontalLine>()
      .having(
        (line) => line.y,
        'y',
        line.y,
      )
      .having(
        (line) => line.color,
        'color',
        isSameColorAs(line.color!),
      );
}
