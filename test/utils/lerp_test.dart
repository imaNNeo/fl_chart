import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter_test/flutter_test.dart';

import '../chart/data_pool.dart';

void main() {
  const tolerance = 0.001;

  test('test lerpList', () {
    List<double> list1 = [1.0, 1.0, 2.0];
    List<double> list2 = [1.0, 2.0, 3.0, 5.0];
    expect(lerpList(list1, list2, 0.0, lerp: lerpDouble), [1.0, 1.0, 2.0, 5.0]);
    expect(lerpList(list1, list2, 0.5, lerp: lerpDouble), [1.0, 1.5, 2.5, 5.0]);
    expect(lerpList(list1, list1, 0.5, lerp: lerpDouble), list1);
  });

  test('test lerpColorList', () {
    List<Color> list1 = const [
      MockData.color1,
      MockData.color1,
      MockData.color2,
    ];
    List<Color> list2 = const [
      MockData.color1,
      MockData.color2,
      MockData.color3,
      MockData.color5,
    ];
    expect(lerpColorList(list1, list2, 0.0), const [
      MockData.color1,
      MockData.color1,
      MockData.color2,
      MockData.color5,
    ]);
    expect(lerpColorList(list1, list2, 1.0), list2);
    expect(lerpColorList(list1, list2, 0.5), const [
      MockData.color1,
      Color(0x19191919),
      Color(0x2a2a2a2a),
      MockData.color5,
    ]);
  });

  test('test lerpColor', () {
    expect(lerpColor(MockData.color1, MockData.color1, 0.5), MockData.color1);
    expect(lerpColor(MockData.color1, MockData.color1, 0.0), MockData.color1);
    expect(lerpColor(MockData.color1, MockData.color1, 1), MockData.color1);

    expect(lerpColor(MockData.color1, MockData.color2, 0), MockData.color1);
    expect(
      lerpColor(MockData.color1, MockData.color2, 0.3),
      const Color(0x16161616),
    );
    expect(lerpColor(MockData.color1, MockData.color2, 1), MockData.color2);
  });

  test('test lerpDoubleAllowInfinity', () {
    expect(lerpDoubleAllowInfinity(12, 12, 0.0), 12);
    expect(lerpDoubleAllowInfinity(12, 12, 0.2), 12);
    expect(lerpDoubleAllowInfinity(12, 12, 0.5), 12);
    expect(lerpDoubleAllowInfinity(12, 12, 1.0), 12);

    expect(lerpDoubleAllowInfinity(12, double.infinity, 1.0), double.infinity);
    expect(lerpDoubleAllowInfinity(12, double.infinity, 0.0), double.infinity);
    expect(lerpDoubleAllowInfinity(12, double.infinity, 0.4), double.infinity);

    expect(lerpDoubleAllowInfinity(double.infinity, 12, 1.0), 12);
    expect(lerpDoubleAllowInfinity(double.infinity, 12, 0.0), 12);
    expect(lerpDoubleAllowInfinity(double.infinity, 12, 0.4), 12);

    expect(lerpDoubleAllowInfinity(0, 10, 0.4), 4);
    expect(lerpDoubleAllowInfinity(0, 10, 0.2), 2);
    expect(lerpDoubleAllowInfinity(0, 10, 0.8), 8);
  });

  test('test lerpDoubleList', () {
    List<double> list1 = const [
      0,
      0,
      0,
    ];
    List<double> list2 = const [
      10,
      100,
      1000,
      10000,
    ];
    expect(lerpDoubleList(list1, list2, 0.0), const [
      0,
      0,
      0,
      10000,
    ]);
    expect(lerpDoubleList(list1, list2, 0.5), [
      5,
      50,
      500,
      10000,
    ]);
    expect(lerpDoubleList(list1, list2, 1.0), list2);
  });

  test('test lerpIntList', () {
    List<int> list1 = const [
      0,
      0,
      0,
    ];
    List<int> list2 = const [
      10,
      100,
      1000,
      10000,
    ];
    expect(lerpIntList(list1, list2, 0.0), const [
      0,
      0,
      0,
      10000,
    ]);
    expect(lerpIntList(list1, list2, 0.5), [
      5,
      50,
      500,
      10000,
    ]);
    expect(lerpIntList(list1, list2, 1.0), list2);
  });

  test('test lerpInt', () {
    expect(lerpInt(0, 10, 1.0), 10);
    expect(lerpInt(0, 10, 0.34), 3);
    expect(lerpInt(0, 10, 0.38), 4);
  });

  test('test lerpNonNullDouble', () {
    expect(lerpNonNullDouble(0, 10, 1.0), 10);
    expect(lerpNonNullDouble(0, 10, 0.34), closeTo(3.4, tolerance));
    expect(lerpNonNullDouble(0, 10, 0.38), closeTo(3.8, tolerance));
  });

  test('test lerpFlSpotList', () {
    final list1 = [
      MockData.flSpot0,
      MockData.flSpot0,
      MockData.flSpot0,
    ];
    final list2 = [
      MockData.flSpot1,
      MockData.flSpot2,
      MockData.flSpot3,
      MockData.flSpot4,
    ];
    expect(lerpFlSpotList(list1, list2, 0.0), [
      MockData.flSpot0,
      MockData.flSpot0,
      MockData.flSpot0,
      MockData.flSpot4,
    ]);
    expect(lerpFlSpotList(list1, list2, 0.5), [
      const FlSpot(0.5, 0.5),
      MockData.flSpot1,
      const FlSpot(1.5, 1.5),
      MockData.flSpot4,
    ]);
    expect(lerpFlSpotList(list1, list2, 1.0), list2);
  });

  test('test lerpHorizontalLineList', () {
    final list1 = [
      MockData.horizontalLine0,
      MockData.horizontalLine0,
      MockData.horizontalLine0,
    ];
    final list2 = [
      MockData.horizontalLine1,
      MockData.horizontalLine2,
      MockData.horizontalLine3,
      MockData.horizontalLine4,
    ];
    expect(lerpHorizontalLineList(list1, list2, 0.0), [
      MockData.horizontalLine0,
      MockData.horizontalLine0,
      MockData.horizontalLine0,
      MockData.horizontalLine4,
    ]);
    expect(lerpHorizontalLineList(list1, list2, 0.5), [
      HorizontalLine(y: 0.5, color: const Color(0x08080808)),
      MockData.horizontalLine1,
      HorizontalLine(y: 1.5, color: const Color(0x19191919)),
      MockData.horizontalLine4,
    ]);
    expect(lerpHorizontalLineList(list1, list2, 1.0), list2);
  });

  test('test lerpVerticalLineList', () {
    final list1 = [
      MockData.verticalLine0,
      MockData.verticalLine0,
      MockData.verticalLine0,
    ];
    final list2 = [
      MockData.verticalLine1,
      MockData.verticalLine2,
      MockData.verticalLine3,
      MockData.verticalLine4,
    ];
    expect(lerpVerticalLineList(list1, list2, 0.0), [
      MockData.verticalLine0,
      MockData.verticalLine0,
      MockData.verticalLine0,
      MockData.verticalLine4,
    ]);
    expect(lerpVerticalLineList(list1, list2, 0.5), [
      VerticalLine(x: 0.5, color: const Color(0x08080808)),
      MockData.verticalLine1,
      VerticalLine(x: 1.5, color: const Color(0x19191919)),
      MockData.verticalLine4,
    ]);
    expect(lerpVerticalLineList(list1, list2, 1.0), list2);
  });

  test('test lerpHorizontalRangeAnnotationList', () {
    final list1 = [
      MockData.horizontalRangeAnnotation0,
      MockData.horizontalRangeAnnotation0,
      MockData.horizontalRangeAnnotation0,
    ];
    final list2 = [
      MockData.horizontalRangeAnnotation1,
      MockData.horizontalRangeAnnotation2,
      MockData.horizontalRangeAnnotation3,
      MockData.horizontalRangeAnnotation4,
    ];
    expect(lerpHorizontalRangeAnnotationList(list1, list2, 0.0), [
      MockData.horizontalRangeAnnotation0,
      MockData.horizontalRangeAnnotation0,
      MockData.horizontalRangeAnnotation0,
      MockData.horizontalRangeAnnotation4,
    ]);
    expect(lerpHorizontalRangeAnnotationList(list1, list2, 0.5), [
      HorizontalRangeAnnotation(
          y1: 0.5, y2: 1.5, color: const Color(0x08080808)),
      MockData.horizontalRangeAnnotation1,
      HorizontalRangeAnnotation(
          y1: 1.5, y2: 2.5, color: const Color(0x19191919)),
      MockData.horizontalRangeAnnotation4,
    ]);
    expect(lerpHorizontalRangeAnnotationList(list1, list2, 1.0), list2);
  });

  test('test lerpVerticalRangeAnnotationList', () {
    final list1 = [
      MockData.verticalRangeAnnotation0,
      MockData.verticalRangeAnnotation0,
      MockData.verticalRangeAnnotation0,
    ];
    final list2 = [
      MockData.verticalRangeAnnotation1,
      MockData.verticalRangeAnnotation2,
      MockData.verticalRangeAnnotation3,
      MockData.verticalRangeAnnotation4,
    ];
    expect(lerpVerticalRangeAnnotationList(list1, list2, 0.0), [
      MockData.verticalRangeAnnotation0,
      MockData.verticalRangeAnnotation0,
      MockData.verticalRangeAnnotation0,
      MockData.verticalRangeAnnotation4,
    ]);
    expect(lerpVerticalRangeAnnotationList(list1, list2, 0.5), [
      VerticalRangeAnnotation(x1: 0.5, x2: 1.5, color: const Color(0x08080808)),
      MockData.verticalRangeAnnotation1,
      VerticalRangeAnnotation(x1: 1.5, x2: 2.5, color: const Color(0x19191919)),
      MockData.verticalRangeAnnotation4,
    ]);
    expect(lerpVerticalRangeAnnotationList(list1, list2, 1.0), list2);
  });

  test('test lerpBetweenBarsDataList', () {
    final list1 = [
      MockData.verticalRangeAnnotation0,
      MockData.verticalRangeAnnotation0,
      MockData.verticalRangeAnnotation0,
    ];
    final list2 = [
      MockData.verticalRangeAnnotation1,
      MockData.verticalRangeAnnotation2,
      MockData.verticalRangeAnnotation3,
      MockData.verticalRangeAnnotation4,
    ];
    expect(lerpVerticalRangeAnnotationList(list1, list2, 0.0), [
      MockData.verticalRangeAnnotation0,
      MockData.verticalRangeAnnotation0,
      MockData.verticalRangeAnnotation0,
      MockData.verticalRangeAnnotation4,
    ]);
    expect(lerpVerticalRangeAnnotationList(list1, list2, 0.5), [
      VerticalRangeAnnotation(x1: 0.5, x2: 1.5, color: const Color(0x08080808)),
      MockData.verticalRangeAnnotation1,
      VerticalRangeAnnotation(x1: 1.5, x2: 2.5, color: const Color(0x19191919)),
      MockData.verticalRangeAnnotation4,
    ]);
    expect(lerpVerticalRangeAnnotationList(list1, list2, 1.0), list2);
  });

  test('test lerpRadarEntryList', () {
    final list1 = [
      MockData.radarEntry0,
      MockData.radarEntry0,
      MockData.radarEntry0,
    ];
    final list2 = [
      MockData.radarEntry1,
      MockData.radarEntry2,
      MockData.radarEntry3,
      MockData.radarEntry4,
    ];
    expect(lerpRadarEntryList(list1, list2, 0.0), [
      MockData.radarEntry0,
      MockData.radarEntry0,
      MockData.radarEntry0,
      MockData.radarEntry4,
    ]);
    expect(lerpRadarEntryList(list1, list2, 0.5), [
      const RadarEntry(value: 0.5),
      MockData.radarEntry1,
      const RadarEntry(value: 1.5),
      MockData.radarEntry4,
    ]);
    expect(lerpRadarEntryList(list1, list2, 1.0), list2);
  });

  test('test lerpScatterSpotList', () {
    final list1 = [
      MockData.scatterSpot0,
      MockData.scatterSpot0,
      MockData.scatterSpot0,
    ];
    final list2 = [
      MockData.scatterSpot1,
      MockData.scatterSpot2,
      MockData.scatterSpot3,
      MockData.scatterSpot4,
    ];
    expect(lerpScatterSpotList(list1, list2, 0.0), [
      MockData.scatterSpot0,
      MockData.scatterSpot0,
      MockData.scatterSpot0,
      MockData.scatterSpot4,
    ]);
    expect(lerpScatterSpotList(list1, list2, 0.5), [
      ScatterSpot(0.5, 0.5, color: const Color(0x08080808)),
      MockData.scatterSpot1,
      ScatterSpot(1.5, 1.5, color: const Color(0x19191919)),
      MockData.scatterSpot4,
    ]);
    expect(lerpScatterSpotList(list1, list2, 1.0), list2);
  });

  test('test lerpGradient', () {
    final colors = [
      MockData.color0,
      MockData.color1,
      MockData.color2,
      MockData.color3,
    ];
    expect(lerpGradient(colors, [], 0.0), const Color(0x00000000));
    expect(lerpGradient(colors, [], 0.2), const Color(0x00000000));
    expect(lerpGradient(colors, [], 0.4), const Color(0x0a0a0a0a));
    expect(lerpGradient(colors, [], 0.6), const Color(0x17171717));
    expect(lerpGradient(colors, [], 0.8), const Color(0x25252525));
    expect(lerpGradient(colors, [], 1), const Color(0x33333333));
  });
}
