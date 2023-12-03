import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/line.dart';
import 'package:flutter/material.dart';

class MockData {
  static const color0 = Color(0x00000000);
  static const color1 = Color(0x11111111);
  static const color2 = Color(0x22222222);
  static const color3 = Color(0x33333333);
  static const color4 = Color(0x44444444);
  static const color5 = Color(0x55555555);
  static const color6 = Color(0x66666666);

  static final path1 = Path()
    ..moveTo(10, 10)
    ..lineTo(20, 20)
    ..arcTo(
      Rect.fromCenter(center: Offset.zero, width: 44, height: 22),
      2,
      3,
      false,
    );

  static final path1Duplicate = Path()
    ..moveTo(10, 10)
    ..lineTo(20, 20)
    ..arcTo(
      Rect.fromCenter(center: Offset.zero, width: 44, height: 22),
      2,
      3,
      false,
    );

  static final path2 = Path()
    ..moveTo(10, 10)
    ..lineTo(20, 20)
    ..arcTo(
      Rect.fromCenter(center: Offset.zero, width: 44, height: 22.01),
      2,
      3,
      false,
    );

  static final path3 = Path()
    ..moveTo(10, 13)
    ..lineTo(20, 20)
    ..arcTo(
      Rect.fromCenter(center: Offset.zero, width: 44, height: 22),
      2,
      3,
      false,
    );

  static final path4 = Path()
    ..moveTo(24, 13)
    ..lineTo(20, 20)
    ..arcTo(
      Rect.fromCenter(center: Offset.zero, width: 44, height: 22),
      2,
      3,
      false,
    );

  static const borderSide1 = BorderSide(color: color1);
  static const borderSide2 = BorderSide(color: color2, width: 2);
  static const borderSide3 = BorderSide(color: color3, width: 3);
  static const borderSide4 = BorderSide(color: color4, width: 4);
  static const borderSide5 = BorderSide(color: color5, width: 5);
  static const borderSide6 = BorderSide(color: color6, width: 6);

  static const TextStyle textStyle1 =
      TextStyle(color: color1, fontWeight: FontWeight.w100);
  static const TextStyle textStyle2 =
      TextStyle(color: color2, fontWeight: FontWeight.w200);
  static const TextStyle textStyle3 =
      TextStyle(color: color3, fontWeight: FontWeight.w300);
  static const TextStyle textStyle4 =
      TextStyle(color: color4, fontWeight: FontWeight.w400);

  static const Offset offset1 = Offset(1, 1);
  static const Offset offset1Duplicate = Offset(1, 1);
  static const Offset offset2 = Offset(2, 2);
  static const Offset offset3 = Offset(2, 2);
  static const Offset offset4 = Offset(4, 4);
  static const Offset offset5 = Offset(5, 5);
  static const Offset offset6 = Offset(6, 6);

  static const size1 = Size(11, 11);
  static const size2 = Size(22, 22);

  static final textPainter1 = TextPainter();

  static final rect1 = Rect.fromCenter(center: offset1, width: 11, height: 11);
  static final rect2 = Rect.fromCenter(center: offset2, width: 22, height: 22);

  static final rRect1 = RRect.fromLTRBR(1, 1, 1, 1, const Radius.circular(11));
  static final rRect2 = RRect.fromLTRBR(2, 2, 2, 2, const Radius.circular(22));

  static final paint1 = Paint()
    ..color = color1
    ..strokeWidth = 11;
  static final paint2 = Paint()
    ..color = color2
    ..strokeWidth = 22;

  static Picture? _picture1;

  static Picture picture1() {
    if (_picture1 != null) {
      return _picture1!;
    }
    final recorder1 = PictureRecorder();
    Canvas(recorder1).drawLine(offset1, offset2, paint1);
    _picture1 = recorder1.endRecording();
    return _picture1!;
  }

  static Image? _image1;

  static Image image1() {
    if (_image1 != null) {
      return _image1!;
    }
    _image1 = Image.asset('asdf/asdf');
    return _image1!;
  }

  static final LineChartBarData lineChartBarData1 = LineChartBarData(
    dashArray: [0, 1],
    gradient: const LinearGradient(
      colors: [Colors.red, Colors.green],
      stops: [0, 1],
      begin: Alignment.center,
      end: Alignment.bottomRight,
    ),
    spots: [
      flSpot1,
      flSpot2,
    ],
    shadow: shadow1,
    aboveBarData: barAreaData1,
    belowBarData: barAreaData2,
    barWidth: 12,
    curveSmoothness: 12,
    dotData: flDotData1,
    isStrokeCapRound: true,
    preventCurveOvershootingThreshold: 1.2,
    showingIndicators: [0, 1],
  );

  static final LineChartBarData lineChartBarData2 = LineChartBarData(
    dashArray: [0, 1],
    gradient: const LinearGradient(
      colors: [Colors.red, Colors.green],
      stops: [0, 1],
      begin: Alignment.center,
      end: Alignment.bottomRight,
    ),
    spots: [
      flSpot1,
      flSpot2,
    ],
    shadow: shadow2,
    isStepLineChart: true,
    aboveBarData: barAreaData1,
    belowBarData: barAreaData2,
    barWidth: 12,
    curveSmoothness: 12,
    dotData: flDotData1,
    isStrokeCapRound: true,
    preventCurveOvershootingThreshold: 1.2,
    showingIndicators: [0, 4],
  );

  static const flSpot0 = FlSpot.zero;
  static const flSpot1 = FlSpot(1, 1);
  static const flSpot2 = FlSpot(2, 2);
  static const flSpot3 = FlSpot(3, 3);
  static const flSpot4 = FlSpot(4, 4);
  static const flSpot5 = FlSpot(5, 5);

  static final horizontalLine0 = HorizontalLine(y: 0, color: color0);
  static final horizontalLine1 = HorizontalLine(y: 1, color: color1);
  static final horizontalLine2 = HorizontalLine(y: 2, color: color2);
  static final horizontalLine3 = HorizontalLine(y: 3, color: color3);
  static final horizontalLine4 = HorizontalLine(y: 4, color: color4);
  static final horizontalLine5 = HorizontalLine(y: 5, color: color5);

  static final verticalLine0 = VerticalLine(x: 0, color: color0);
  static final verticalLine1 = VerticalLine(x: 1, color: color1);
  static final verticalLine2 = VerticalLine(x: 2, color: color2);
  static final verticalLine3 = VerticalLine(x: 3, color: color3);
  static final verticalLine4 = VerticalLine(x: 4, color: color4);
  static final verticalLine5 = VerticalLine(x: 5, color: color5);

  static final horizontalRangeAnnotation0 =
      HorizontalRangeAnnotation(y1: 0, y2: 1, color: color0);

  static final horizontalRangeAnnotation1 =
      HorizontalRangeAnnotation(y1: 1, y2: 2, color: color1);

  static final horizontalRangeAnnotation2 =
      HorizontalRangeAnnotation(y1: 2, y2: 3, color: color2);

  static final horizontalRangeAnnotation3 =
      HorizontalRangeAnnotation(y1: 3, y2: 4, color: color3);

  static final horizontalRangeAnnotation4 =
      HorizontalRangeAnnotation(y1: 4, y2: 5, color: color4);

  static final verticalRangeAnnotation0 =
      VerticalRangeAnnotation(x1: 0, x2: 1, color: color0);

  static final verticalRangeAnnotation1 =
      VerticalRangeAnnotation(x1: 1, x2: 2, color: color1);

  static final verticalRangeAnnotation2 =
      VerticalRangeAnnotation(x1: 2, x2: 3, color: color2);

  static final verticalRangeAnnotation3 =
      VerticalRangeAnnotation(x1: 3, x2: 4, color: color3);

  static final verticalRangeAnnotation4 =
      VerticalRangeAnnotation(x1: 4, x2: 5, color: color4);

  static const RadarEntry radarEntry0 = RadarEntry(value: 0);
  static const RadarEntry radarEntry1 = RadarEntry(value: 1);
  static const RadarEntry radarEntry2 = RadarEntry(value: 2);
  static const RadarEntry radarEntry3 = RadarEntry(value: 3);
  static const RadarEntry radarEntry4 = RadarEntry(value: 4);
  static final RadarDataSet radarDataSet1 = RadarDataSet(
    dataEntries: [radarEntry1, radarEntry2, radarEntry3],
  );
  static final RadarDataSet radarDataSet2 = RadarDataSet(
    dataEntries: [radarEntry3, radarEntry1, radarEntry2],
  );
  static final RadarTouchedSpot radarTouchedSpot = RadarTouchedSpot(
    radarDataSet1,
    0,
    radarEntry1,
    0,
    flSpot1,
    offset1,
  );

  static final pieChartSection0 = PieChartSectionData(
    value: 0,
    color: color0,
    radius: 0,
  );

  static final pieChartSection1 = PieChartSectionData(
    value: 1,
    color: color1,
    radius: 1,
  );

  static final pieChartSection2 = PieChartSectionData(
    value: 2,
    color: color2,
    radius: 2,
  );

  static final pieChartSection3 = PieChartSectionData(
    value: 3,
    color: color3,
    radius: 3,
  );

  static final pieChartSection4 = PieChartSectionData(
    value: 4,
    color: color4,
    radius: 4,
  );

  static final scatterSpot0 = ScatterSpot(
    0,
    0,
    dotPainter: FlDotCirclePainter(color: color0),
  );
  static final scatterSpot1 = ScatterSpot(
    1,
    1,
    dotPainter: FlDotCirclePainter(color: color1),
  );
  static final scatterSpot2 = ScatterSpot(
    2,
    2,
    dotPainter: FlDotCirclePainter(color: color2),
  );
  static final scatterSpot3 = ScatterSpot(
    3,
    3,
    dotPainter: FlDotCirclePainter(color: color3),
  );
  static final scatterSpot4 = ScatterSpot(
    4,
    4,
    dotPainter: FlDotCirclePainter(color: color4),
  );

  static final scatterTouchedSpot = ScatterTouchedSpot(scatterSpot1, 0);

  static final pieChartSectionData1 = PieChartSectionData(value: 12);
  static final pieTouchedSection1 = PieTouchedSection(
    pieChartSectionData1,
    0,
    12,
    33,
  );

  static final lineBarSpot1 = TouchLineBarSpot(
    lineChartBarData1,
    0,
    lineChartBarData1.spots.first,
    0,
  );
  static final lineBarSpot2 = TouchLineBarSpot(
    MockData.lineChartBarData1,
    1,
    MockData.lineChartBarData1.spots.last,
    2,
  );

  static final lineTouchResponse1 =
      LineTouchResponse([lineBarSpot1, lineBarSpot2]);

  static final barChartRodData1 = BarChartRodData(toY: 11);
  static final barChartRodData2 = BarChartRodData(toY: 22);
  static final barTouchedSpot = BarTouchedSpot(
    BarChartGroupData(x: 0, barRods: [barChartRodData1, barChartRodData2]),
    0,
    barChartRodData1,
    0,
    null,
    -1,
    flSpot1,
    offset1,
  );

  static const gradient1 = LinearGradient(
    colors: [
      MockData.color0,
      MockData.color1,
    ],
  );

  static final barGroupData0 = BarChartGroupData(
    x: 0,
    barRods: [MockData.barChartRodData1, MockData.barChartRodData2],
  );

  static final barGroupData1 = BarChartGroupData(
    x: 1,
    barRods: [MockData.barChartRodData1, MockData.barChartRodData2],
  );

  static final barGroupData2 = BarChartGroupData(
    x: 2,
    barRods: [MockData.barChartRodData1, MockData.barChartRodData2],
  );

  static final barChartData1 = BarChartData(
    barGroups: [barGroupData0, barGroupData1, barGroupData2],
  );

  static const sideTitles1 = SideTitles(
    reservedSize: 10,
    interval: 23,
  );
  static const sideTitles1Clone = SideTitles(
    reservedSize: 10,
    interval: 23,
  );
  static const sideTitles2 = SideTitles(
    reservedSize: 10,
    interval: 12,
  );
  static const sideTitles3 = SideTitles(
    reservedSize: 10,
    getTitlesWidget: getTitles,
    interval: 12,
  );
  static const sideTitles4 = SideTitles(
    reservedSize: 11,
    showTitles: true,
    getTitlesWidget: getTitles,
    interval: 12,
  );
  static const sideTitles5 = SideTitles(
    reservedSize: 10,
    getTitlesWidget: getTitles,
    interval: 43,
  );
  static const sideTitles6 = SideTitles(
    reservedSize: 10,
    getTitlesWidget: getTitles,
    interval: 22,
  );

  static const sideTitleFitInsideData1 = SideTitleFitInsideData(
    enabled: true,
    axisPosition: 0,
    parentAxisSize: 100,
    distanceFromEdge: 0,
  );
  static const sideTitleFitInsideData1Clone = SideTitleFitInsideData(
    enabled: true,
    axisPosition: 0,
    parentAxisSize: 100,
    distanceFromEdge: 0,
  );
  static const sideTitleFitInsideData2 = SideTitleFitInsideData(
    enabled: true,
    axisPosition: 0,
    parentAxisSize: 100,
    distanceFromEdge: 10,
  );
  static const sideTitleFitInsideData3 = SideTitleFitInsideData(
    enabled: false,
    axisPosition: 0,
    parentAxisSize: 100,
    distanceFromEdge: 0,
  );
  static const sideTitleFitInsideData4 = SideTitleFitInsideData(
    enabled: true,
    axisPosition: 200,
    parentAxisSize: 200,
    distanceFromEdge: 0,
  );
  static const sideTitleFitInsideData5 = SideTitleFitInsideData(
    enabled: true,
    axisPosition: 200,
    parentAxisSize: 200,
    distanceFromEdge: 10,
  );
  static const sideTitleFitInsideData6 = SideTitleFitInsideData(
    enabled: false,
    axisPosition: 200,
    parentAxisSize: 200,
    distanceFromEdge: 0,
  );

  static const widget1 = Text('axis1');
  static const widget2 = Text('axis2');
  static const widget3 = Text('axis3');
  static const widget4 = Text('axis4');
  static const widget5 = Text('axis5');

  static const axisTitles1 = AxisTitles(
    axisNameWidget: widget1,
    sideTitles: sideTitles1,
  );
  static const axisTitles1Clone = AxisTitles(
    axisNameWidget: widget1,
    sideTitles: sideTitles1Clone,
  );
  static const axisTitles2 = AxisTitles(
    axisNameWidget: widget2,
    sideTitles: sideTitles2,
  );
  static const axisTitles3 = AxisTitles(
    axisNameWidget: widget3,
    sideTitles: sideTitles3,
  );
  static const axisTitles4 = AxisTitles(
    axisNameWidget: widget4,
    sideTitles: sideTitles4,
  );
  static const axisTitles5 = AxisTitles(
    axisNameWidget: widget5,
    axisNameSize: 889,
    sideTitles: sideTitles4,
  );

  static const flTitlesData1 = FlTitlesData(
    bottomTitles: axisTitles1,
    topTitles: axisTitles2,
    rightTitles: axisTitles3,
    leftTitles: axisTitles4,
  );
  static const flTitlesData1Clone = FlTitlesData(
    bottomTitles: axisTitles1Clone,
    topTitles: axisTitles2,
    rightTitles: axisTitles3,
    leftTitles: axisTitles4,
  );
  static const flTitlesData2 = FlTitlesData(
    topTitles: axisTitles2,
    rightTitles: axisTitles3,
    leftTitles: axisTitles4,
  );
  static const flTitlesData3 = FlTitlesData(
    bottomTitles: axisTitles1,
    rightTitles: axisTitles3,
    leftTitles: axisTitles4,
  );
  static const flTitlesData4 = FlTitlesData(
    bottomTitles: axisTitles1,
    topTitles: axisTitles2,
    leftTitles: axisTitles4,
  );
  static const flTitlesData5 = FlTitlesData(
    bottomTitles: axisTitles1,
    topTitles: axisTitles2,
    rightTitles: axisTitles3,
  );
  static const flTitlesData6 = FlTitlesData(
    show: false,
    bottomTitles: axisTitles1,
    topTitles: axisTitles2,
    rightTitles: axisTitles3,
    leftTitles: axisTitles4,
  );
}

final VerticalRangeAnnotation verticalRangeAnnotation1 =
    VerticalRangeAnnotation(color: Colors.green, x2: 12, x1: 12.1);
final VerticalRangeAnnotation verticalRangeAnnotation1Clone =
    VerticalRangeAnnotation(color: Colors.green, x2: 12, x1: 12.1);

final HorizontalRangeAnnotation horizontalRangeAnnotation1 =
    HorizontalRangeAnnotation(color: Colors.green, y2: 12, y1: 12.1);
final HorizontalRangeAnnotation horizontalRangeAnnotation1Clone =
    HorizontalRangeAnnotation(color: Colors.green, y2: 12, y1: 12.1);

final RangeAnnotations rangeAnnotations1 = RangeAnnotations(
  horizontalRangeAnnotations: [
    horizontalRangeAnnotation1,
    horizontalRangeAnnotation1Clone,
  ],
  verticalRangeAnnotations: [
    verticalRangeAnnotation1,
    verticalRangeAnnotation1Clone,
  ],
);
final RangeAnnotations rangeAnnotations1Clone = RangeAnnotations(
  horizontalRangeAnnotations: [
    horizontalRangeAnnotation1,
    horizontalRangeAnnotation1Clone,
  ],
  verticalRangeAnnotations: [
    verticalRangeAnnotation1,
    verticalRangeAnnotation1Clone,
  ],
);
final RangeAnnotations rangeAnnotations2 = RangeAnnotations(
  horizontalRangeAnnotations: [
    horizontalRangeAnnotation1Clone,
  ],
  verticalRangeAnnotations: [
    verticalRangeAnnotation1,
    verticalRangeAnnotation1Clone,
  ],
);

const FlLine flLine1 =
    FlLine(color: Colors.green, strokeWidth: 1, dashArray: [1, 2, 3]);
const FlLine flLine1Clone =
    FlLine(color: Colors.green, strokeWidth: 1, dashArray: [1, 2, 3]);

bool checkToShowLine(double value) => true;

FlLine getDrawingLine(double value) => const FlLine();

const FlSpot flSpot1 = FlSpot(1, 1);
final FlSpot flSpot1Clone = flSpot1.copyWith();

const FlSpot flSpot2 = FlSpot(4, 2);
final FlSpot flSpot2Clone = flSpot2.copyWith();

Widget getTitles(double value, TitleMeta meta) => const Text('sallam');

TextStyle getTextStyles(BuildContext context, double value) =>
    const TextStyle(color: Colors.green);

const FlGridData flGridData1 = FlGridData(
  verticalInterval: 12,
  horizontalInterval: 22,
  drawVerticalLine: false,
  checkToShowVerticalLine: checkToShowLine,
  getDrawingHorizontalLine: getDrawingLine,
);
const FlGridData flGridData1Clone = FlGridData(
  verticalInterval: 12,
  horizontalInterval: 22,
  drawVerticalLine: false,
  checkToShowVerticalLine: checkToShowLine,
  getDrawingHorizontalLine: getDrawingLine,
);
final FlGridData flGridData2 = FlGridData(
  verticalInterval: 12,
  horizontalInterval: 22,
  drawVerticalLine: false,
  checkToShowVerticalLine: checkToShowLine,
  getDrawingHorizontalLine: getDrawingLine,
  getDrawingVerticalLine: (value) => flLine1,
);
const FlGridData flGridData3 = FlGridData(
  verticalInterval: 12,
  horizontalInterval: 43,
  drawVerticalLine: false,
  checkToShowVerticalLine: checkToShowLine,
  getDrawingHorizontalLine: getDrawingLine,
);
const FlGridData flGridData4 = FlGridData(
  verticalInterval: 12,
  horizontalInterval: 22,
  drawVerticalLine: false,
  getDrawingHorizontalLine: getDrawingLine,
);
const FlGridData flGridData5 = FlGridData(
  verticalInterval: 12,
  horizontalInterval: 22,
  checkToShowVerticalLine: checkToShowLine,
  getDrawingHorizontalLine: getDrawingLine,
);

final FlBorderData borderData1 = FlBorderData(
  show: true,
  border: Border.all(color: Colors.green),
);
final FlBorderData borderData1Clone = FlBorderData(
  show: true,
  border: Border.all(color: Colors.green),
);
final FlBorderData borderData2 = FlBorderData(
  show: true,
  border: Border.all(color: Colors.green.withOpacity(0.5)),
);

bool checkToShowSpotLine(FlSpot spot) => true;

const BarAreaSpotsLine barAreaSpotsLine1 =
    BarAreaSpotsLine(show: true, checkToShowSpotLine: checkToShowSpotLine);
const BarAreaSpotsLine barAreaSpotsLine1Clone =
    BarAreaSpotsLine(show: true, checkToShowSpotLine: checkToShowSpotLine);

const BarAreaSpotsLine barAreaSpotsLine2 = BarAreaSpotsLine(
  show: true,
);

final BarAreaData barAreaData1 = BarAreaData(
  show: true,
  cutOffY: 12,
  gradient: const LinearGradient(
    colors: [Colors.green, Colors.blue],
    stops: [0, 0.5],
    begin: Alignment.topLeft,
    end: Alignment.bottomCenter,
  ),
  spotsLine: barAreaSpotsLine1,
);
final BarAreaData barAreaData1Clone = BarAreaData(
  show: true,
  cutOffY: 12,
  gradient: const LinearGradient(
    colors: [Colors.green, Colors.blue],
    stops: [0, 0.5],
    begin: Alignment.topLeft,
    end: Alignment.bottomCenter,
  ),
  spotsLine: barAreaSpotsLine1,
);

final BarAreaData barAreaData2 = BarAreaData(
  show: true,
  cutOffY: 12,
  gradient: const LinearGradient(
    colors: [Colors.green, Colors.blue],
    stops: [0, 0.5],
    begin: Alignment.topLeft,
    end: Alignment.bottomCenter,
  ),
  spotsLine: barAreaSpotsLine2,
);
final BarAreaData barAreaData3 = BarAreaData(
  show: true,
  cutOffY: 12,
  gradient: const LinearGradient(
    colors: [Colors.green, Colors.blue],
    stops: [0, 0.6],
    begin: Alignment.topLeft,
    end: Alignment.bottomCenter,
  ),
  spotsLine: barAreaSpotsLine2,
);
final BarAreaData barAreaData4 = BarAreaData(
  show: true,
  cutOffY: 12,
  gradient: const LinearGradient(
    colors: [Colors.green, Colors.blue],
    stops: [0],
    begin: Alignment.topLeft,
    end: Alignment.bottomCenter,
  ),
  spotsLine: barAreaSpotsLine2,
);

bool checkToShowDot(FlSpot spot, LineChartBarData barData) => true;

FlDotCirclePainter getDotDrawer(
  FlSpot spot,
  double percent,
  LineChartBarData barData,
  int index,
) =>
    FlDotCirclePainter(radius: 44, strokeWidth: 12);

FlDotCirclePainter getDotDrawer5(
  FlSpot spot,
  double percent,
  LineChartBarData barData,
  int index,
) =>
    FlDotCirclePainter(radius: 44, strokeWidth: 14);

FlDotCirclePainter getDotDrawer6(
  FlSpot spot,
  double percent,
  LineChartBarData barData,
  int index,
) =>
    FlDotCirclePainter(radius: 44.01, strokeWidth: 14);

FlDotCirclePainter getDotDrawerTouched(
  FlSpot spot,
  double percent,
  LineChartBarData barData,
  int index,
) =>
    FlDotCirclePainter(radius: 12, color: Colors.red);

FlDotCirclePainter getDotDrawerTouched4(
  FlSpot spot,
  double percent,
  LineChartBarData barData,
  int index,
) =>
    FlDotCirclePainter(radius: 12);

FlDotCirclePainter getDotDrawerTouched6(
  FlSpot spot,
  double percent,
  LineChartBarData barData,
  int index,
) =>
    FlDotCirclePainter(radius: 12.01, color: Colors.red);

const FlDotData flDotData1 = FlDotData(
  getDotPainter: getDotDrawer,
  checkToShowDot: checkToShowDot,
);
const FlDotData flDotData1Clone = FlDotData(
  getDotPainter: getDotDrawer,
  checkToShowDot: checkToShowDot,
);

const FlDotData flDotData4 = FlDotData(
  getDotPainter: getDotDrawer,
);

const FlDotData flDotData5 = FlDotData(
  getDotPainter: getDotDrawer5,
);

const FlDotData flDotData6 = FlDotData(
  getDotPainter: getDotDrawer6,
);

const Shadow shadow1 = Shadow(
  color: Colors.red,
  blurRadius: 12,
);
const Shadow shadow1Clone = Shadow(
  color: Colors.red,
  blurRadius: 12,
);
const Shadow shadow2 = Shadow(
  color: Colors.green,
  blurRadius: 12,
);
const Shadow shadow3 = Shadow(
  color: Colors.red,
  blurRadius: 14,
);
final Shadow shadow4 = Shadow(
  color: Colors.red.withOpacity(0.5),
  blurRadius: 12,
);

const LineChartStepData lineChartStepData1 = LineChartStepData();

const LineChartStepData lineChartStepData1Clone = LineChartStepData();

const LineChartStepData lineChartStepData2 = LineChartStepData(
  stepDirection: LineChartStepData.stepDirectionForward,
);

final LineChartBarData lineChartBarData1 = LineChartBarData(
  dashArray: [0, 1],
  gradient: const LinearGradient(
    colors: [Colors.red, Colors.green],
    stops: [0, 1],
    begin: Alignment.center,
    end: Alignment.bottomRight,
  ),
  spots: [
    flSpot1,
    flSpot2,
  ],
  shadow: shadow1,
  aboveBarData: barAreaData1,
  belowBarData: barAreaData2,
  barWidth: 12,
  curveSmoothness: 12,
  dotData: flDotData1,
  isStrokeCapRound: true,
  preventCurveOvershootingThreshold: 1.2,
  showingIndicators: [0, 1],
);
final LineChartBarData lineChartBarData1Clone = LineChartBarData(
  dashArray: [0, 1],
  gradient: const LinearGradient(
    colors: [Colors.red, Colors.green],
    stops: [0, 1],
    begin: Alignment.center,
    end: Alignment.bottomRight,
  ),
  spots: [
    flSpot1Clone,
    flSpot2,
  ],
  shadow: shadow1Clone,
  aboveBarData: barAreaData1Clone,
  belowBarData: barAreaData2,
  barWidth: 12,
  curveSmoothness: 12,
  dotData: flDotData1Clone,
  isStrokeCapRound: true,
  preventCurveOvershootingThreshold: 1.2,
  showingIndicators: [0, 1],
);

final LineChartBarData lineChartBarData2 = LineChartBarData(
  dashArray: [0, 1],
  gradient: const LinearGradient(
    colors: [Colors.red, Colors.green],
    stops: [0, 1],
    begin: Alignment.center,
    end: Alignment.bottomRight,
  ),
  spots: [
    flSpot1,
    flSpot2,
  ],
  shadow: shadow2,
  isStepLineChart: true,
  aboveBarData: barAreaData1,
  belowBarData: barAreaData2,
  barWidth: 12,
  curveSmoothness: 12,
  dotData: flDotData1,
  isStrokeCapRound: true,
  preventCurveOvershootingThreshold: 1.2,
  showingIndicators: [0, 4],
);

final LineChartBarData lineChartBarData3 = LineChartBarData(
  gradient: const LinearGradient(
    colors: [Colors.red, Colors.green],
    stops: [0, 1],
    begin: Alignment.center,
    end: Alignment.bottomRight,
  ),
  spots: [
    flSpot1,
    flSpot2,
  ],
  shadow: shadow3,
  isStepLineChart: true,
  lineChartStepData: lineChartStepData2,
  aboveBarData: barAreaData1,
  belowBarData: barAreaData2,
  barWidth: 12,
  curveSmoothness: 12,
  dotData: flDotData1,
  isStrokeCapRound: true,
  preventCurveOvershootingThreshold: 1.2,
  showingIndicators: [0, 1],
);

final LineChartBarData lineChartBarData4 = LineChartBarData(
  dashArray: [0, 1],
  gradient: const LinearGradient(
    colors: [Colors.red, Colors.green],
    stops: [0, 1],
    begin: Alignment.center,
    end: Alignment.bottomRight,
  ),
  spots: [
    flSpot2,
    flSpot1,
  ],
  shadow: shadow4,
  lineChartStepData: lineChartStepData2,
  aboveBarData: barAreaData1,
  belowBarData: barAreaData2,
  barWidth: 12,
  curveSmoothness: 12,
  dotData: flDotData1,
  isStrokeCapRound: true,
  preventCurveOvershootingThreshold: 1.2,
  showingIndicators: [0, 1],
);

final LineChartBarData lineChartBarData5 = LineChartBarData(
  dashArray: [0, 1],
  gradient: const LinearGradient(
    colors: [Colors.red, Colors.green],
    stops: [0, 1],
    begin: Alignment.center,
    end: Alignment.bottomRight,
  ),
  spots: [
    flSpot1,
    flSpot2,
  ],
  aboveBarData: barAreaData2,
  belowBarData: barAreaData1,
  barWidth: 12,
  curveSmoothness: 12,
  dotData: flDotData1,
  isStrokeCapRound: true,
  preventCurveOvershootingThreshold: 1.2,
  showingIndicators: [0, 1],
);

final LineChartBarData lineChartBarData6 = LineChartBarData(
  dashArray: [0, 1],
  gradient: const LinearGradient(
    colors: [Colors.red, Colors.green],
    stops: [0, 1],
    begin: Alignment.center,
    end: Alignment.bottomRight,
  ),
  spots: [
    flSpot1,
    flSpot2,
  ],
  aboveBarData: barAreaData1,
  belowBarData: barAreaData2,
  barWidth: 12,
  curveSmoothness: 12,
  dotData: flDotData1,
  isStrokeCapRound: true,
  preventCurveOvershootingThreshold: 1.2,
  showingIndicators: [0, 1],
);

final LineChartBarData lineChartBarData7 = LineChartBarData(
  dashArray: [0, 1],
  gradient: LinearGradient(
    colors: [Colors.red, Colors.green.withOpacity(0.4)],
    stops: const [0, 1],
    begin: Alignment.center,
    end: Alignment.bottomRight,
  ),
  spots: [
    flSpot1,
    flSpot2,
  ],
  aboveBarData: barAreaData1,
  belowBarData: barAreaData2,
  barWidth: 12,
  curveSmoothness: 12,
  dotData: flDotData1,
  isStrokeCapRound: true,
  preventCurveOvershootingThreshold: 1.2,
  showingIndicators: [0, 1],
);

final LineChartBarData lineChartBarData8 = LineChartBarData(
  dashArray: [0, 1],
  gradient: const LinearGradient(
    colors: [Colors.red, Colors.green],
    stops: [0, 1],
    begin: Alignment.center,
    end: Alignment.bottomRight,
  ),
  spots: [
    flSpot1,
    flSpot2,
  ],
  aboveBarData: barAreaData1,
  belowBarData: barAreaData2,
  barWidth: 12,
  curveSmoothness: 12.01,
  dotData: flDotData1,
  isStrokeCapRound: true,
  preventCurveOvershootingThreshold: 1.2,
  showingIndicators: [0, 1],
);

final LineChartBarData lineChartBarData9 = LineChartBarData(
  dashArray: [0, 1],
  gradient: const LinearGradient(
    colors: [Colors.red, Colors.green],
    stops: [0, 1],
    begin: Alignment.center,
    end: Alignment.bottomRight,
  ),
  spots: [
    flSpot1,
    flSpot2,
  ],
  aboveBarData: barAreaData1,
  belowBarData: barAreaData2,
  barWidth: 12,
  curveSmoothness: 12,
  dotData: flDotData1,
  isStrokeCapRound: true,
  preventCurveOverShooting: true,
  preventCurveOvershootingThreshold: 1.2,
  showingIndicators: [0, 1],
);

final TouchLineBarSpot lineBarSpot1 = TouchLineBarSpot(
  lineChartBarData1,
  0,
  flSpot1,
  0,
);
final TouchLineBarSpot lineBarSpot1Clone = TouchLineBarSpot(
  lineChartBarData1Clone,
  0,
  flSpot1Clone,
  0,
);

final TouchLineBarSpot lineBarSpot2 =
    TouchLineBarSpot(lineChartBarData1, 2, flSpot1, 2);

final TouchLineBarSpot lineBarSpot3 = TouchLineBarSpot(
  lineChartBarData1,
  100,
  flSpot1,
  2,
);

final LineTouchResponse lineTouchResponse1 = LineTouchResponse(
  [
    lineBarSpot1,
    lineBarSpot2,
  ],
);
final LineTouchResponse lineTouchResponse1Clone = LineTouchResponse(
  [
    lineBarSpot1Clone,
    lineBarSpot2,
  ],
);

final LineTouchResponse lineTouchResponse2 = LineTouchResponse(
  [
    lineBarSpot2,
    lineBarSpot1,
  ],
);

const LineTouchResponse lineTouchResponse3 = LineTouchResponse(
  [],
);

final LineTouchResponse lineTouchResponse4 = LineTouchResponse(
  [
    lineBarSpot1,
    lineBarSpot2,
  ],
);

final LineTouchResponse lineTouchResponse5 = LineTouchResponse(
  [
    lineBarSpot1,
    lineBarSpot2,
  ],
);

const TouchedSpotIndicatorData touchedSpotIndicatorData1 =
    TouchedSpotIndicatorData(
  FlLine(
    color: Colors.red,
    dashArray: [],
  ),
  FlDotData(
    getDotPainter: getDotDrawerTouched,
    checkToShowDot: checkToShowDot,
  ),
);
const TouchedSpotIndicatorData touchedSpotIndicatorData1Clone =
    TouchedSpotIndicatorData(
  FlLine(
    color: Colors.red,
    dashArray: [],
  ),
  FlDotData(
    getDotPainter: getDotDrawerTouched,
    checkToShowDot: checkToShowDot,
  ),
);

const TouchedSpotIndicatorData touchedSpotIndicatorData2 =
    TouchedSpotIndicatorData(
  FlLine(
    color: Colors.red,
    dashArray: [],
  ),
  FlDotData(
    getDotPainter: getDotDrawerTouched,
  ),
);
const TouchedSpotIndicatorData touchedSpotIndicatorData3 =
    TouchedSpotIndicatorData(
  FlLine(
    color: Colors.red,
  ),
  FlDotData(
    getDotPainter: getDotDrawerTouched,
    checkToShowDot: checkToShowDot,
  ),
);
const TouchedSpotIndicatorData touchedSpotIndicatorData4 =
    TouchedSpotIndicatorData(
  FlLine(
    color: Colors.green,
    dashArray: [],
  ),
  FlDotData(
    getDotPainter: getDotDrawerTouched4,
    checkToShowDot: checkToShowDot,
  ),
);
const TouchedSpotIndicatorData touchedSpotIndicatorData5 =
    TouchedSpotIndicatorData(
  FlLine(
    color: Colors.red,
    dashArray: [],
  ),
  FlDotData(
    getDotPainter: getDotDrawerTouched,
    checkToShowDot: checkToShowDot,
    show: false,
  ),
);
const TouchedSpotIndicatorData touchedSpotIndicatorData6 =
    TouchedSpotIndicatorData(
  FlLine(
    color: Colors.red,
    dashArray: [],
  ),
  FlDotData(
    getDotPainter: getDotDrawerTouched6,
    checkToShowDot: checkToShowDot,
  ),
);

const LineTooltipItem lineTooltipItem1 =
    LineTooltipItem('', TextStyle(color: Colors.green));
const LineTooltipItem lineTooltipItem1Clone =
    LineTooltipItem('', TextStyle(color: Colors.green));

const LineTooltipItem lineTooltipItem2 =
    LineTooltipItem('ss', TextStyle(color: Colors.green));
const LineTooltipItem lineTooltipItem3 =
    LineTooltipItem('', TextStyle(color: Colors.blue));
const LineTooltipItem lineTooltipItem4 =
    LineTooltipItem('', TextStyle(fontSize: 33));

List<LineTooltipItem?> lineChartGetTooltipItems(List<LineBarSpot> list) {
  return list.map((s) => lineTooltipItem1).toList();
}

const LineTouchTooltipData lineTouchTooltipData1 = LineTouchTooltipData(
  tooltipPadding: EdgeInsets.all(0.1),
  tooltipBgColor: Colors.green,
  maxContentWidth: 12,
  getTooltipItems: lineChartGetTooltipItems,
  fitInsideHorizontally: true,
  tooltipRoundedRadius: 12,
  tooltipMargin: 33,
  tooltipBorder: BorderSide(color: Colors.red),
);
const LineTouchTooltipData lineTouchTooltipData1Clone = LineTouchTooltipData(
  tooltipPadding: EdgeInsets.all(0.1),
  tooltipBgColor: Colors.green,
  maxContentWidth: 12,
  getTooltipItems: lineChartGetTooltipItems,
  fitInsideHorizontally: true,
  tooltipRoundedRadius: 12,
  tooltipMargin: 33,
  tooltipBorder: BorderSide(color: Colors.red),
);

const LineTouchTooltipData lineTouchTooltipData2 = LineTouchTooltipData(
  tooltipPadding: EdgeInsets.all(0.1),
  tooltipBgColor: Colors.red,
  maxContentWidth: 12,
  getTooltipItems: lineChartGetTooltipItems,
  fitInsideHorizontally: true,
  tooltipRoundedRadius: 12,
  tooltipMargin: 33,
  tooltipBorder: BorderSide(color: Colors.red),
);
const LineTouchTooltipData lineTouchTooltipData3 = LineTouchTooltipData(
  tooltipPadding: EdgeInsets.all(0.2),
  tooltipBgColor: Colors.green,
  maxContentWidth: 12,
  getTooltipItems: lineChartGetTooltipItems,
  fitInsideHorizontally: true,
  tooltipRoundedRadius: 12,
  tooltipMargin: 33,
  tooltipBorder: BorderSide(color: Colors.red),
  tooltipHorizontalAlignment: FLHorizontalAlignment.left,
);
const LineTouchTooltipData lineTouchTooltipData4 = LineTouchTooltipData(
  tooltipPadding: EdgeInsets.all(0.1),
  tooltipBgColor: Colors.green,
  maxContentWidth: 13,
  getTooltipItems: lineChartGetTooltipItems,
  fitInsideHorizontally: true,
  tooltipRoundedRadius: 12,
  tooltipMargin: 33,
  tooltipBorder: BorderSide(color: Colors.red),
  tooltipHorizontalAlignment: FLHorizontalAlignment.right,
);
const LineTouchTooltipData lineTouchTooltipData5 = LineTouchTooltipData(
  tooltipPadding: EdgeInsets.all(0.1),
  tooltipBgColor: Colors.green,
  maxContentWidth: 12,
  getTooltipItems: lineChartGetTooltipItems,
  fitInsideHorizontally: true,
  tooltipRoundedRadius: 12,
  tooltipMargin: 34,
  tooltipBorder: BorderSide(color: Colors.red),
  tooltipHorizontalOffset: 10,
);
const LineTouchTooltipData lineTouchTooltipData6 = LineTouchTooltipData(
  tooltipPadding: EdgeInsets.all(0.1),
  tooltipBgColor: Colors.green,
  maxContentWidth: 12,
  getTooltipItems: lineChartGetTooltipItems,
  fitInsideHorizontally: true,
  tooltipRoundedRadius: 12,
  tooltipMargin: 33,
  tooltipBorder: BorderSide(color: Colors.pink),
  tooltipHorizontalAlignment: FLHorizontalAlignment.left,
  tooltipHorizontalOffset: -10,
);
const LineTouchTooltipData lineTouchTooltipData7 = LineTouchTooltipData(
  tooltipPadding: EdgeInsets.all(0.1),
  tooltipBgColor: Colors.green,
  maxContentWidth: 12,
  getTooltipItems: lineChartGetTooltipItems,
  fitInsideHorizontally: true,
  tooltipRoundedRadius: 12,
  tooltipMargin: 33,
  tooltipBorder: BorderSide(color: Colors.red, width: 2),
  tooltipHorizontalAlignment: FLHorizontalAlignment.right,
  tooltipHorizontalOffset: 10,
);

void lineTouchCallback(FlTouchEvent event, LineTouchResponse? response) {}

List<TouchedSpotIndicatorData?> getTouchedSpotIndicator(
  LineChartBarData barData,
  List<int> indexes,
) =>
    indexes.map((i) => touchedSpotIndicatorData1).toList();

const LineTouchData lineTouchData1 = LineTouchData(
  touchCallback: lineTouchCallback,
  getTouchedSpotIndicator: getTouchedSpotIndicator,
  handleBuiltInTouches: false,
  touchSpotThreshold: 12,
  touchTooltipData: lineTouchTooltipData1,
);
const LineTouchData lineTouchData1Clone = LineTouchData(
  touchCallback: lineTouchCallback,
  getTouchedSpotIndicator: getTouchedSpotIndicator,
  handleBuiltInTouches: false,
  touchSpotThreshold: 12,
  touchTooltipData: lineTouchTooltipData1,
);

const LineTouchData lineTouchData2 = LineTouchData(
  getTouchedSpotIndicator: getTouchedSpotIndicator,
  handleBuiltInTouches: false,
  touchSpotThreshold: 12,
  touchTooltipData: lineTouchTooltipData1,
);
const LineTouchData lineTouchData3 = LineTouchData(
  touchCallback: lineTouchCallback,
  handleBuiltInTouches: false,
  touchSpotThreshold: 12,
  touchTooltipData: lineTouchTooltipData1,
);
const LineTouchData lineTouchData4 = LineTouchData(
  touchCallback: lineTouchCallback,
  getTouchedSpotIndicator: getTouchedSpotIndicator,
  handleBuiltInTouches: false,
  touchSpotThreshold: 12,
);
const LineTouchData lineTouchData5 = LineTouchData(
  touchCallback: lineTouchCallback,
  getTouchedSpotIndicator: getTouchedSpotIndicator,
  handleBuiltInTouches: false,
  touchSpotThreshold: 12.001,
  touchTooltipData: lineTouchTooltipData1,
);
const LineTouchData lineTouchData6 = LineTouchData(
  touchCallback: lineTouchCallback,
  getTouchedSpotIndicator: getTouchedSpotIndicator,
  touchSpotThreshold: 12,
  touchTooltipData: lineTouchTooltipData1,
);
final LineTouchData lineTouchData7 = LineTouchData(
  touchCallback: lineTouchCallback,
  getTouchedSpotIndicator: getTouchedSpotIndicator,
  handleBuiltInTouches: false,
  touchSpotThreshold: 12,
  touchTooltipData: lineTouchTooltipData1,
  getTouchLineEnd: (barData, index) => double.infinity,
);
const LineTouchData lineTouchData8 = LineTouchData(
  touchCallback: lineTouchCallback,
  getTouchedSpotIndicator: getTouchedSpotIndicator,
  handleBuiltInTouches: false,
  touchSpotThreshold: 12,
  touchTooltipData: lineTouchTooltipData1,
  longPressDuration: Duration.zero,
);

String horizontalLabelResolver(HorizontalLine horizontalLine) => 'test';

String verticalLabelResolver(VerticalLine horizontalLine) => 'test';

final HorizontalLineLabel horizontalLineLabel1 = HorizontalLineLabel(
  show: true,
  style: const TextStyle(color: Colors.green),
  labelResolver: horizontalLabelResolver,
  alignment: Alignment.topCenter,
  padding: const EdgeInsets.all(12),
);
final HorizontalLineLabel horizontalLineLabel1Clone = HorizontalLineLabel(
  show: true,
  style: const TextStyle(color: Colors.green),
  labelResolver: horizontalLabelResolver,
  alignment: Alignment.topCenter,
  padding: const EdgeInsets.all(12),
);
final HorizontalLineLabel horizontalLineLabel2 = HorizontalLineLabel(
  style: const TextStyle(color: Colors.green),
  labelResolver: horizontalLabelResolver,
  alignment: Alignment.topCenter,
  padding: const EdgeInsets.all(12),
);
final HorizontalLineLabel horizontalLineLabel3 = HorizontalLineLabel(
  show: true,
  labelResolver: horizontalLabelResolver,
  alignment: Alignment.topCenter,
  padding: const EdgeInsets.all(12),
);
final HorizontalLineLabel horizontalLineLabel4 = HorizontalLineLabel(
  show: true,
  style: const TextStyle(color: Colors.green),
  alignment: Alignment.topCenter,
  padding: const EdgeInsets.all(12),
);
final HorizontalLineLabel horizontalLineLabel5 = HorizontalLineLabel(
  show: true,
  style: const TextStyle(color: Colors.green),
  labelResolver: horizontalLabelResolver,
  alignment: Alignment.bottomRight,
  padding: const EdgeInsets.all(12),
);
final HorizontalLineLabel horizontalLineLabel6 = HorizontalLineLabel(
  show: true,
  style: const TextStyle(color: Colors.green),
  labelResolver: horizontalLabelResolver,
  alignment: Alignment.topCenter,
  padding: const EdgeInsets.all(44),
);
final HorizontalLineLabel horizontalLineLabel7 = HorizontalLineLabel(
  style: const TextStyle(color: Colors.green),
  labelResolver: horizontalLabelResolver,
  alignment: Alignment.topCenter,
  padding: const EdgeInsets.all(12),
);

final VerticalLineLabel verticalLineLabel1 = VerticalLineLabel(
  show: true,
  style: const TextStyle(color: Colors.green),
  labelResolver: verticalLabelResolver,
  alignment: Alignment.topCenter,
  padding: const EdgeInsets.all(12),
);
final VerticalLineLabel verticalLineLabel1Clone = VerticalLineLabel(
  show: true,
  style: const TextStyle(color: Colors.green),
  labelResolver: verticalLabelResolver,
  alignment: Alignment.topCenter,
  padding: const EdgeInsets.all(12),
);
final VerticalLineLabel verticalLineLabel2 = VerticalLineLabel(
  show: false,
  style: const TextStyle(color: Colors.green),
  labelResolver: verticalLabelResolver,
  alignment: Alignment.topCenter,
  padding: const EdgeInsets.all(12),
);
final VerticalLineLabel verticalLineLabel3 = VerticalLineLabel(
  show: true,
  labelResolver: verticalLabelResolver,
  alignment: Alignment.topCenter,
  padding: const EdgeInsets.all(12),
);
final VerticalLineLabel verticalLineLabel4 = VerticalLineLabel(
  show: true,
  style: const TextStyle(color: Colors.green),
  alignment: Alignment.topCenter,
  padding: const EdgeInsets.all(12),
);
final VerticalLineLabel verticalLineLabel5 = VerticalLineLabel(
  show: true,
  style: const TextStyle(color: Colors.green),
  labelResolver: verticalLabelResolver,
  alignment: Alignment.bottomRight,
  padding: const EdgeInsets.all(12),
);
final VerticalLineLabel verticalLineLabel6 = VerticalLineLabel(
  show: true,
  style: const TextStyle(color: Colors.green),
  labelResolver: verticalLabelResolver,
  alignment: Alignment.topCenter,
  padding: const EdgeInsets.all(44),
);
final VerticalLineLabel verticalLineLabel7 = VerticalLineLabel(
  show: false,
  style: const TextStyle(color: Colors.green),
  labelResolver: verticalLabelResolver,
  alignment: Alignment.topCenter,
  padding: const EdgeInsets.all(12),
);

final HorizontalLine horizontalLine1 = HorizontalLine(
  y: 12,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: horizontalLineLabel1,
);
final HorizontalLine horizontalLine1Clone = HorizontalLine(
  y: 12,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: horizontalLineLabel1,
);
final HorizontalLine horizontalLine2 = HorizontalLine(
  y: 12,
  color: Colors.red,
  dashArray: [0, 1, 3],
  strokeWidth: 21,
  label: horizontalLineLabel1,
);
final HorizontalLine horizontalLine3 = HorizontalLine(
  y: 12,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 22,
  label: horizontalLineLabel1,
);
final HorizontalLine horizontalLine4 = HorizontalLine(
  y: 12,
  color: Colors.red,
  dashArray: [1, 0],
  strokeWidth: 21,
  label: horizontalLineLabel1,
);
final HorizontalLine horizontalLine5 = HorizontalLine(
  y: 33,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: horizontalLineLabel1,
);
final HorizontalLine horizontalLine6 = HorizontalLine(
  y: 12,
  color: Colors.green,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: horizontalLineLabel1,
);
final HorizontalLine horizontalLine7 = HorizontalLine(
  y: 12,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: horizontalLineLabel2,
);
final HorizontalLine horizontalLine8 = HorizontalLine(
  y: 12,
  color: Colors.red,
  strokeWidth: 21,
  label: horizontalLineLabel1,
);
final HorizontalLine horizontalLine9 = HorizontalLine(
  y: 12,
  color: Colors.red,
  dashArray: [0, 12, 44],
  strokeWidth: 21,
  label: horizontalLineLabel1,
);

final VerticalLine verticalLine1 = VerticalLine(
  x: 12,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: verticalLineLabel1,
);
final VerticalLine verticalLine1Clone = VerticalLine(
  x: 12,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: verticalLineLabel1,
);
final VerticalLine verticalLine2 = VerticalLine(
  x: 12,
  color: Colors.green,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: verticalLineLabel1,
);
final VerticalLine verticalLine3 = VerticalLine(
  x: 12,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 22,
  label: verticalLineLabel1,
);
final VerticalLine verticalLine4 = VerticalLine(
  x: 12,
  color: Colors.red,
  dashArray: [1, 0],
  strokeWidth: 21,
  label: verticalLineLabel1,
);
final VerticalLine verticalLine5 = VerticalLine(
  x: 33,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: verticalLineLabel1,
);
final VerticalLine verticalLine6 = VerticalLine(
  x: 12,
  color: Colors.green,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: verticalLineLabel1,
);
final VerticalLine verticalLine7 = VerticalLine(
  x: 12,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: verticalLineLabel2,
);
final VerticalLine verticalLine8 = VerticalLine(
  x: 12,
  color: Colors.red,
  strokeWidth: 21,
  label: verticalLineLabel1,
);
final VerticalLine verticalLine9 = VerticalLine(
  x: 12,
  color: Colors.red,
  dashArray: [0, 12, 44],
  strokeWidth: 21,
  label: verticalLineLabel1,
);

final ExtraLinesData extraLinesData1 = ExtraLinesData(
  horizontalLines: [
    horizontalLine1,
    horizontalLine2,
    horizontalLine3,
  ],
  verticalLines: [
    verticalLine1,
    verticalLine2,
    verticalLine3,
  ],
  extraLinesOnTop: false,
);
final ExtraLinesData extraLinesData1Clone = ExtraLinesData(
  horizontalLines: [
    horizontalLine1Clone,
    horizontalLine2,
    horizontalLine3,
  ],
  verticalLines: [
    verticalLine1Clone,
    verticalLine2,
    verticalLine3,
  ],
  extraLinesOnTop: false,
);

final ExtraLinesData extraLinesData2 = ExtraLinesData(
  horizontalLines: [
    horizontalLine3,
    horizontalLine1,
    horizontalLine2,
  ],
  verticalLines: [
    verticalLine3,
    verticalLine1,
    verticalLine2,
  ],
  extraLinesOnTop: false,
);
final ExtraLinesData extraLinesData3 = ExtraLinesData(
  horizontalLines: [
    horizontalLine1,
    horizontalLine2,
  ],
  verticalLines: [
    verticalLine1,
    verticalLine2,
  ],
  extraLinesOnTop: false,
);
final ExtraLinesData extraLinesData4 = ExtraLinesData(
  horizontalLines: [
    horizontalLine1,
    horizontalLine2,
    horizontalLine3,
  ],
  extraLinesOnTop: false,
);
final ExtraLinesData extraLinesData5 = ExtraLinesData(
  verticalLines: [
    verticalLine1,
    verticalLine2,
    verticalLine3,
  ],
  extraLinesOnTop: false,
);
final ExtraLinesData extraLinesData6 = ExtraLinesData(
  horizontalLines: [
    horizontalLine1,
    horizontalLine2,
    horizontalLine3,
  ],
  verticalLines: [
    verticalLine1,
    verticalLine2,
    verticalLine3,
  ],
);

final SizedPicture sizedPicture1 = SizedPicture(
  PictureRecorder().endRecording(),
  10,
  30,
);
final SizedPicture sizedPicture1Clone = SizedPicture(
  PictureRecorder().endRecording(),
  10,
  30,
);

final SizedPicture sizedPicture2 = SizedPicture(
  PictureRecorder().endRecording(),
  11,
  30,
);
final SizedPicture sizedPicture3 = SizedPicture(
  PictureRecorder().endRecording(),
  10,
  32,
);
final SizedPicture sizedPicture4 = SizedPicture(
  PictureRecorder().endRecording(),
  442,
  30,
);

final BetweenBarsData betweenBarsData1 = BetweenBarsData(
  fromIndex: 1,
  toIndex: 2,
  gradient: const LinearGradient(
    begin: Alignment(1, 3),
    end: Alignment(4, 1),
    stops: [1, 2, 3],
    colors: [Colors.green, Colors.blue, Colors.red],
  ),
);
final BetweenBarsData betweenBarsData1Clone = BetweenBarsData(
  fromIndex: 1,
  toIndex: 2,
  gradient: const LinearGradient(
    begin: Alignment(1, 3),
    end: Alignment(4, 1),
    stops: [1, 2, 3],
    colors: [Colors.green, Colors.blue, Colors.red],
  ),
);
final BetweenBarsData betweenBarsData2 = BetweenBarsData(
  fromIndex: 2,
  toIndex: 2,
  gradient: const LinearGradient(
    begin: Alignment(1, 3),
    end: Alignment(4, 1),
    stops: [1, 2, 3],
    colors: [Colors.green, Colors.blue, Colors.red],
  ),
);
final BetweenBarsData betweenBarsData3 = BetweenBarsData(
  fromIndex: 1,
  toIndex: 1,
  gradient: const LinearGradient(
    begin: Alignment(1, 4),
    end: Alignment(4, 1),
    stops: [1, 2, 3],
    colors: [Colors.green, Colors.blue, Colors.red],
  ),
);
final BetweenBarsData betweenBarsData4 = BetweenBarsData(
  fromIndex: 1,
  toIndex: 2,
  gradient: const LinearGradient(
    begin: Alignment(1, 3),
    end: Alignment(5, 1),
    stops: [1, 2, 3],
    colors: [Colors.green, Colors.blue, Colors.red],
  ),
);
final BetweenBarsData betweenBarsData5 = BetweenBarsData(
  fromIndex: 1,
  toIndex: 2,
  gradient: const LinearGradient(
    begin: Alignment(1, 3),
    end: Alignment(4, 1),
    colors: [Colors.green, Colors.blue, Colors.red],
  ),
);
final BetweenBarsData betweenBarsData6 = BetweenBarsData(
  fromIndex: 1,
  toIndex: 2,
  gradient: const LinearGradient(
    begin: Alignment(1, 3),
    end: Alignment(4, 1),
    stops: [1, 2, 3],
    colors: [Colors.green, Colors.blue],
  ),
);
final BetweenBarsData betweenBarsData7 = BetweenBarsData(
  fromIndex: 1,
  toIndex: 2,
  gradient: const LinearGradient(
    begin: Alignment(1, 22),
    end: Alignment(4, 1),
    stops: [1, 2, 3],
    colors: [Colors.green, Colors.blue],
  ),
);
final BetweenBarsData betweenBarsData8 = BetweenBarsData(
  fromIndex: 1,
  toIndex: 2,
  gradient: const LinearGradient(
    begin: Alignment(1, 3),
    end: Alignment(4, 1),
    stops: [1, 2, 3],
    colors: [],
  ),
);

final ShowingTooltipIndicators showingTooltipIndicator1 =
    ShowingTooltipIndicators(
  [lineBarSpot1, lineBarSpot2],
);
final ShowingTooltipIndicators showingTooltipIndicator1Clone =
    ShowingTooltipIndicators(
  [lineBarSpot1, lineBarSpot2],
);
const ShowingTooltipIndicators showingTooltipIndicator2 =
    ShowingTooltipIndicators(
  [],
);
final ShowingTooltipIndicators showingTooltipIndicator3 =
    ShowingTooltipIndicators(
  [lineBarSpot2],
);
final ShowingTooltipIndicators showingTooltipIndicator4 =
    ShowingTooltipIndicators(
  [lineBarSpot2, lineBarSpot1],
);
final ShowingTooltipIndicators showingTooltipIndicator5 =
    ShowingTooltipIndicators(
  [lineBarSpot1, lineBarSpot2, lineBarSpot2],
);

final LineChartData lineChartData1 = LineChartData(
  borderData: borderData1,
  lineTouchData: lineTouchData1,
  showingTooltipIndicators: [
    showingTooltipIndicator1,
    showingTooltipIndicator2,
  ],
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: MockData.flTitlesData1,
  lineBarsData: [lineChartBarData1, lineChartBarData2, lineChartBarData3],
  betweenBarsData: [betweenBarsData1, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData1,
  maxX: 23,
  minX: 11,
  minY: 43,
);
final LineChartData lineChartData1Clone = LineChartData(
  borderData: borderData1Clone,
  lineTouchData: lineTouchData1Clone,
  showingTooltipIndicators: [
    showingTooltipIndicator1Clone,
    showingTooltipIndicator2,
  ],
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1Clone,
  titlesData: MockData.flTitlesData1Clone,
  lineBarsData: [lineChartBarData1Clone, lineChartBarData2, lineChartBarData3],
  betweenBarsData: [betweenBarsData1Clone, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData1Clone,
  maxX: 23,
  minX: 11,
  minY: 43,
);
final LineChartData lineChartData2 = LineChartData(
  lineTouchData: lineTouchData1,
  showingTooltipIndicators: [
    showingTooltipIndicator1,
    showingTooltipIndicator2,
  ],
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: MockData.flTitlesData1,
  lineBarsData: [lineChartBarData1, lineChartBarData2, lineChartBarData3],
  betweenBarsData: [betweenBarsData1, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData1,
  maxX: 23,
  minX: 11,
  minY: 43,
);
final LineChartData lineChartData3 = LineChartData(
  borderData: borderData1,
  lineTouchData: lineTouchData2,
  showingTooltipIndicators: [
    showingTooltipIndicator1,
    showingTooltipIndicator2,
  ],
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: MockData.flTitlesData1,
  lineBarsData: [lineChartBarData1, lineChartBarData2, lineChartBarData3],
  betweenBarsData: [betweenBarsData1, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData1,
  maxX: 23,
  minX: 11,
  minY: 43,
);
final LineChartData lineChartData4 = LineChartData(
  borderData: borderData1,
  lineTouchData: lineTouchData1,
  showingTooltipIndicators: [],
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: MockData.flTitlesData1,
  lineBarsData: [lineChartBarData1, lineChartBarData2, lineChartBarData3],
  betweenBarsData: [betweenBarsData1, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData1,
  maxX: 23,
  minX: 11,
  minY: 43,
);
final LineChartData lineChartData5 = LineChartData(
  borderData: borderData1,
  lineTouchData: lineTouchData1,
  showingTooltipIndicators: [
    showingTooltipIndicator2,
    showingTooltipIndicator1,
  ],
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: MockData.flTitlesData1,
  lineBarsData: [lineChartBarData1, lineChartBarData2, lineChartBarData3],
  betweenBarsData: [betweenBarsData1, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData1,
  maxX: 23,
  minX: 11,
  minY: 43,
);
final LineChartData lineChartData6 = LineChartData(
  borderData: borderData1,
  lineTouchData: lineTouchData1,
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: MockData.flTitlesData1,
  lineBarsData: [lineChartBarData1, lineChartBarData2, lineChartBarData3],
  betweenBarsData: [betweenBarsData1, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData1,
  maxX: 23,
  minX: 11,
  minY: 43,
);
final LineChartData lineChartData7 = LineChartData(
  borderData: borderData1,
  lineTouchData: lineTouchData1,
  showingTooltipIndicators: [
    showingTooltipIndicator1,
    showingTooltipIndicator2,
  ],
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: MockData.flTitlesData2,
  lineBarsData: [lineChartBarData1, lineChartBarData2, lineChartBarData3],
  betweenBarsData: [betweenBarsData1, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData1,
  maxX: 23,
  minX: 11,
  minY: 43,
);
final LineChartData lineChartData8 = LineChartData(
  borderData: borderData1,
  lineTouchData: lineTouchData1,
  showingTooltipIndicators: [
    showingTooltipIndicator1,
    showingTooltipIndicator2,
  ],
  clipData: const FlClipData.all(),
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: MockData.flTitlesData1,
  lineBarsData: [lineChartBarData1, lineChartBarData2, lineChartBarData3],
  betweenBarsData: [betweenBarsData1, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData1,
  maxX: 23,
  minX: 11,
  minY: 43,
);
final LineChartData lineChartData9 = LineChartData(
  borderData: borderData1,
  lineTouchData: lineTouchData1,
  showingTooltipIndicators: [
    showingTooltipIndicator1,
    showingTooltipIndicator2,
  ],
  backgroundColor: Colors.red.withOpacity(0.2),
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: MockData.flTitlesData1,
  lineBarsData: [lineChartBarData1, lineChartBarData2, lineChartBarData3],
  betweenBarsData: [betweenBarsData1, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData1,
  maxX: 23,
  minX: 11,
  minY: 43,
);
final LineChartData lineChartData10 = LineChartData(
  borderData: borderData1,
  lineTouchData: lineTouchData1,
  showingTooltipIndicators: [
    showingTooltipIndicator1,
    showingTooltipIndicator2,
  ],
  backgroundColor: Colors.red,
  maxY: 24,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: MockData.flTitlesData1,
  lineBarsData: [lineChartBarData1, lineChartBarData2, lineChartBarData3],
  betweenBarsData: [betweenBarsData1, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData1,
  maxX: 23,
  minX: 11,
  minY: 43,
);
final LineChartData lineChartData11 = LineChartData(
  borderData: borderData1,
  lineTouchData: lineTouchData1,
  showingTooltipIndicators: [
    showingTooltipIndicator1,
    showingTooltipIndicator2,
  ],
  backgroundColor: Colors.red,
  maxY: 23,
  gridData: flGridData1,
  titlesData: MockData.flTitlesData1,
  lineBarsData: [lineChartBarData1, lineChartBarData2, lineChartBarData3],
  betweenBarsData: [betweenBarsData1, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData1,
  maxX: 23,
  minX: 11,
  minY: 43,
);
final LineChartData lineChartData12 = LineChartData(
  borderData: borderData1,
  lineTouchData: lineTouchData1,
  showingTooltipIndicators: [
    showingTooltipIndicator1,
    showingTooltipIndicator2,
  ],
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData2,
  titlesData: MockData.flTitlesData1,
  lineBarsData: [lineChartBarData1, lineChartBarData2, lineChartBarData3],
  betweenBarsData: [betweenBarsData1, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData1,
  maxX: 23,
  minX: 11,
  minY: 43,
);
final LineChartData lineChartData13 = LineChartData(
  borderData: borderData1,
  lineTouchData: lineTouchData1,
  showingTooltipIndicators: [
    showingTooltipIndicator1,
    showingTooltipIndicator2,
  ],
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: MockData.flTitlesData3,
  lineBarsData: [lineChartBarData1, lineChartBarData2, lineChartBarData3],
  betweenBarsData: [betweenBarsData1, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData1,
  maxX: 23,
  minX: 11,
  minY: 43,
);
final LineChartData lineChartData14 = LineChartData(
  borderData: borderData1,
  lineTouchData: lineTouchData1,
  showingTooltipIndicators: [
    showingTooltipIndicator1,
    showingTooltipIndicator2,
  ],
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: MockData.flTitlesData1,
  lineBarsData: [lineChartBarData2, lineChartBarData3, lineChartBarData1],
  betweenBarsData: [betweenBarsData1, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData1,
  maxX: 23,
  minX: 11,
  minY: 43,
);
final LineChartData lineChartData15 = LineChartData(
  borderData: borderData1,
  lineTouchData: lineTouchData1,
  showingTooltipIndicators: [
    showingTooltipIndicator1,
    showingTooltipIndicator2,
  ],
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: MockData.flTitlesData1,
  betweenBarsData: [betweenBarsData1, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData1,
  maxX: 23,
  minX: 11,
  minY: 43,
);
final LineChartData lineChartData16 = LineChartData(
  borderData: borderData1,
  lineTouchData: lineTouchData1,
  showingTooltipIndicators: [
    showingTooltipIndicator1,
    showingTooltipIndicator2,
  ],
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: MockData.flTitlesData1,
  lineBarsData: [lineChartBarData1, lineChartBarData2, lineChartBarData3],
  betweenBarsData: [betweenBarsData2, betweenBarsData3, betweenBarsData1],
  extraLinesData: extraLinesData1,
  maxX: 23,
  minX: 11,
  minY: 43,
);
final LineChartData lineChartData17 = LineChartData(
  borderData: borderData1,
  lineTouchData: lineTouchData1,
  showingTooltipIndicators: [
    showingTooltipIndicator1,
    showingTooltipIndicator2,
  ],
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: MockData.flTitlesData1,
  lineBarsData: [lineChartBarData1, lineChartBarData2, lineChartBarData3],
  betweenBarsData: [betweenBarsData1, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData2,
  maxX: 23,
  minX: 11,
  minY: 43,
);
final LineChartData lineChartData18 = LineChartData(
  borderData: borderData1,
  lineTouchData: lineTouchData1,
  showingTooltipIndicators: [
    showingTooltipIndicator1,
    showingTooltipIndicator2,
  ],
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: MockData.flTitlesData1,
  lineBarsData: [lineChartBarData1, lineChartBarData2, lineChartBarData3],
  betweenBarsData: [betweenBarsData1, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData1,
  maxX: 23.01,
  minX: 11,
  minY: 43,
);
final LineChartData lineChartData19 = LineChartData(
  borderData: borderData1,
  lineTouchData: lineTouchData1,
  showingTooltipIndicators: [
    showingTooltipIndicator1,
    showingTooltipIndicator2,
  ],
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: MockData.flTitlesData1,
  lineBarsData: [lineChartBarData1, lineChartBarData2, lineChartBarData3],
  betweenBarsData: [betweenBarsData1, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData1,
  maxX: 23,
  minX: 44,
  minY: 43,
);
final LineChartData lineChartData20 = LineChartData(
  borderData: borderData1,
  lineTouchData: lineTouchData1,
  showingTooltipIndicators: [
    showingTooltipIndicator1,
    showingTooltipIndicator2,
  ],
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: MockData.flTitlesData1,
  lineBarsData: [lineChartBarData1, lineChartBarData2, lineChartBarData3],
  betweenBarsData: [betweenBarsData1, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData1,
  maxX: 23,
  minX: 11,
  minY: 302,
);

final PieChartData pieChartData1 = PieChartData(
  borderData: FlBorderData(show: false, border: Border.all()),
  startDegreeOffset: 0,
  sections: [
    PieChartSectionData(value: 12, color: Colors.red),
    PieChartSectionData(value: 22, color: Colors.green),
  ],
  centerSpaceColor: Colors.white,
  centerSpaceRadius: 12,
  pieTouchData: PieTouchData(
    enabled: false,
  ),
  sectionsSpace: 44,
);
final PieChartData pieChartData1Clone = pieChartData1.copyWith();

bool gridCheckToShowLine(double value) => true;

FlLine gridGetDrawingLine(double value) => const FlLine();

ScatterTooltipItem? scatterChartGetTooltipItems(ScatterSpot spots) {
  return ScatterTooltipItem(
    'check',
    textStyle: const TextStyle(color: Colors.blue),
    bottomMargin: 23,
  );
}

final ScatterSpot scatterSpot1 = ScatterSpot(1, 40);
final ScatterSpot scatterSpot1Clone = ScatterSpot(1, 40);
final ScatterSpot scatterSpot2 = ScatterSpot(-4, -8);
final ScatterSpot scatterSpot2Clone = scatterSpot2.copyWith();
final ScatterSpot scatterSpot3 = ScatterSpot(-14, 5);
final ScatterSpot scatterSpot4 = ScatterSpot(-0, 0);

String getLabel(int spotIndex, ScatterSpot spot) => 'label';

TextStyle getLabelTextStyle(int spotIndex, ScatterSpot spot) =>
    const TextStyle(color: Colors.green);

final ScatterChartData scatterChartData1 = ScatterChartData(
  minY: 0,
  maxY: 12,
  maxX: 22,
  minX: 11,
  gridData: const FlGridData(
    show: false,
    getDrawingHorizontalLine: gridGetDrawingLine,
    getDrawingVerticalLine: gridGetDrawingLine,
    checkToShowHorizontalLine: gridCheckToShowLine,
    checkToShowVerticalLine: gridCheckToShowLine,
    drawVerticalLine: false,
    horizontalInterval: 33,
    verticalInterval: 1,
  ),
  backgroundColor: Colors.black,
  clipData: const FlClipData.none(),
  borderData: FlBorderData(
    show: true,
    border: Border.all(
      color: Colors.white,
    ),
  ),
  scatterSpots: [
    ScatterSpot(
      0,
      0,
      show: false,
      dotPainter: FlDotCirclePainter(radius: 33, color: Colors.yellow),
    ),
    ScatterSpot(
      2,
      2,
      show: false,
      dotPainter: FlDotCirclePainter(radius: 11, color: Colors.purple),
    ),
    ScatterSpot(
      1,
      2,
      show: false,
      dotPainter: FlDotCirclePainter(radius: 11, color: Colors.white),
    ),
  ],
  scatterTouchData: ScatterTouchData(
    enabled: true,
    touchTooltipData: ScatterTouchTooltipData(
      getTooltipItems: scatterChartGetTooltipItems,
      fitInsideHorizontally: true,
      fitInsideVertically: false,
      maxContentWidth: 33,
      tooltipBgColor: Colors.white,
      tooltipPadding: const EdgeInsets.all(23),
      tooltipRoundedRadius: 534,
    ),
    handleBuiltInTouches: false,
    touchCallback: scatterTouchCallback,
    touchSpotThreshold: 12,
  ),
  showingTooltipIndicators: [0, 1, 2],
  titlesData: const FlTitlesData(
    leftTitles: AxisTitles(
      axisNameSize: 33,
      axisNameWidget: MockData.widget1,
    ),
    rightTitles: AxisTitles(
      axisNameSize: 1326,
      axisNameWidget: MockData.widget3,
      sideTitles: SideTitles(reservedSize: 500, showTitles: true),
    ),
    topTitles: AxisTitles(
      axisNameSize: 34,
      axisNameWidget: MockData.widget4,
    ),
    bottomTitles: AxisTitles(
      axisNameSize: 22,
      axisNameWidget: MockData.widget2,
    ),
  ),
  scatterLabelSettings: ScatterLabelSettings(
    showLabel: true,
    getLabelTextStyleFunction: getLabelTextStyle,
    getLabelFunction: getLabel,
  ),
);
final ScatterChartData scatterChartData1Clone = scatterChartData1.copyWith();
final ScatterTouchTooltipData scatterTouchTooltipData1 =
    ScatterTouchTooltipData(
  tooltipRoundedRadius: 23,
  tooltipPadding: const EdgeInsets.all(11),
  tooltipBgColor: Colors.green,
  maxContentWidth: 33,
  fitInsideVertically: true,
  fitInsideHorizontally: false,
  getTooltipItems: scatterChartGetTooltipItems,
  tooltipBorder: const BorderSide(color: Colors.red),
);
final ScatterTouchTooltipData scatterTouchTooltipData1Clone =
    ScatterTouchTooltipData(
  tooltipRoundedRadius: 23,
  tooltipPadding: const EdgeInsets.all(11),
  tooltipBgColor: Colors.green,
  maxContentWidth: 33,
  fitInsideVertically: true,
  fitInsideHorizontally: false,
  getTooltipItems: scatterChartGetTooltipItems,
  tooltipBorder: const BorderSide(color: Colors.red),
);
final ScatterTouchTooltipData scatterTouchTooltipData2 =
    ScatterTouchTooltipData(
  tooltipRoundedRadius: 23,
  tooltipPadding: const EdgeInsets.all(11),
  tooltipBgColor: Colors.green,
  maxContentWidth: 33,
  fitInsideVertically: true,
  fitInsideHorizontally: false,
  getTooltipItems: scatterChartGetTooltipItems,
  tooltipBorder: const BorderSide(color: Colors.blue),
  tooltipHorizontalAlignment: FLHorizontalAlignment.left,
);
final ScatterTouchTooltipData scatterTouchTooltipData3 =
    ScatterTouchTooltipData(
  tooltipRoundedRadius: 23,
  tooltipPadding: const EdgeInsets.all(11),
  tooltipBgColor: Colors.green,
  maxContentWidth: 33,
  fitInsideVertically: true,
  fitInsideHorizontally: false,
  getTooltipItems: scatterChartGetTooltipItems,
  tooltipBorder: const BorderSide(color: Colors.red, width: 2),
  tooltipHorizontalAlignment: FLHorizontalAlignment.right,
  tooltipHorizontalOffset: 10,
);

final BarChartRodStackItem barChartRodStackItem1 = BarChartRodStackItem(
  1,
  2,
  Colors.green,
);
final BarChartRodStackItem barChartRodStackItem1Clone =
    barChartRodStackItem1.copyWith();

final BarChartRodStackItem barChartRodStackItem2 = BarChartRodStackItem(
  2,
  3,
  Colors.green,
);

final BackgroundBarChartRodData backgroundBarChartRodData1 =
    BackgroundBarChartRodData(
  toY: 21,
  color: Colors.blue,
  show: true,
);
final BackgroundBarChartRodData backgroundBarChartRodData1Clone =
    BackgroundBarChartRodData(
  toY: 21,
  color: Colors.blue,
  show: true,
);
final BackgroundBarChartRodData backgroundBarChartRodData2 =
    BackgroundBarChartRodData(
  toY: 44,
  color: Colors.red,
  show: true,
);
final BackgroundBarChartRodData backgroundBarChartRodData3 =
    BackgroundBarChartRodData(
  toY: 44,
  color: Colors.green,
  show: true,
);

final BarChartRodData barChartRodData1 = BarChartRodData(
  color: Colors.red,
  toY: 12,
  width: 32,
  borderRadius: const BorderRadius.all(Radius.circular(12)),
  rodStackItems: [
    barChartRodStackItem1,
    barChartRodStackItem2,
  ],
  backDrawRodData: backgroundBarChartRodData1,
);

final BarChartRodData barChartRodData1Clone = barChartRodData1.copyWith(
  rodStackItems: [
    barChartRodStackItem1Clone,
    barChartRodStackItem2,
  ],
);

final BarChartRodData barChartRodData2 = BarChartRodData(
  color: Colors.red,
  toY: 1132,
  width: 32,
  borderRadius: const BorderRadius.all(Radius.circular(12)),
  rodStackItems: [
    barChartRodStackItem1,
    barChartRodStackItem2,
  ],
  backDrawRodData: backgroundBarChartRodData1,
);
final BarChartRodData barChartRodData3 = BarChartRodData(
  color: Colors.green,
  toY: 12,
  width: 32,
  borderRadius: const BorderRadius.all(Radius.circular(12)),
  rodStackItems: [
    barChartRodStackItem2,
  ],
  backDrawRodData: backgroundBarChartRodData1,
);
final BarChartRodData barChartRodData4 = BarChartRodData(
  color: Colors.red,
  toY: 12,
  width: 32,
  borderRadius: const BorderRadius.all(Radius.circular(12)),
  rodStackItems: [
    barChartRodStackItem2,
    barChartRodStackItem1,
  ],
  backDrawRodData: backgroundBarChartRodData1,
);
final BarChartRodData barChartRodData5 = BarChartRodData(
  color: Colors.red,
  toY: 12,
  width: 55,
  borderRadius: const BorderRadius.all(Radius.circular(12)),
  rodStackItems: [
    barChartRodStackItem1,
    barChartRodStackItem2,
  ],
  backDrawRodData: backgroundBarChartRodData1,
);
final BarChartRodData barChartRodData6 = BarChartRodData(
  color: Colors.red,
  toY: 12,
  width: 32,
  borderRadius: const BorderRadius.all(Radius.circular(12)),
  backDrawRodData: backgroundBarChartRodData1,
);
final BarChartRodData barChartRodData7 = BarChartRodData(
  color: Colors.red,
  toY: 12,
  width: 32,
  borderRadius: const BorderRadius.all(Radius.circular(12)),
  rodStackItems: [
    barChartRodStackItem1,
    barChartRodStackItem2,
  ],
  backDrawRodData: backgroundBarChartRodData2,
);
final BarChartRodData barChartRodData8 = BarChartRodData(
  color: Colors.red,
  toY: 12,
  width: 32,
  borderRadius: const BorderRadius.all(Radius.circular(14)),
  rodStackItems: [
    barChartRodStackItem1,
    barChartRodStackItem2,
  ],
  backDrawRodData: backgroundBarChartRodData1,
);

final BarChartGroupData barChartGroupData1 = BarChartGroupData(
  x: 12,
  showingTooltipIndicators: [0, 1, 2],
  barRods: [
    barChartRodData1,
    barChartRodData2,
    barChartRodData3,
    barChartRodData4,
  ],
  barsSpace: 23,
);
final BarChartGroupData barChartGroupData1Clone = BarChartGroupData(
  x: 12,
  showingTooltipIndicators: [0, 1, 2],
  barRods: [
    barChartRodData1Clone,
    barChartRodData2,
    barChartRodData3,
    barChartRodData4,
  ],
  barsSpace: 23,
);
final BarChartGroupData barChartGroupData2 = BarChartGroupData(
  x: 13,
  showingTooltipIndicators: [0, 1, 2],
  barRods: [
    barChartRodData1,
    barChartRodData2,
    barChartRodData3,
    barChartRodData4,
  ],
  barsSpace: 23,
);
final BarChartGroupData barChartGroupData3 = BarChartGroupData(
  x: 12,
  showingTooltipIndicators: [0, 1],
  barRods: [
    barChartRodData1,
    barChartRodData2,
    barChartRodData3,
    barChartRodData4,
  ],
  barsSpace: 23,
);
final BarChartGroupData barChartGroupData4 = BarChartGroupData(
  x: 12,
  showingTooltipIndicators: [0, 1, 2],
  barRods: [
    barChartRodData1,
    barChartRodData2,
    barChartRodData4,
  ],
  barsSpace: 23,
);
final BarChartGroupData barChartGroupData5 = BarChartGroupData(
  x: 12,
  showingTooltipIndicators: [0, 1, 2],
  barsSpace: 23,
);
final BarChartGroupData barChartGroupData6 = BarChartGroupData(
  x: 12,
  showingTooltipIndicators: [0, 1, 2],
  barRods: [
    barChartRodData2,
    barChartRodData3,
    barChartRodData4,
    barChartRodData1,
  ],
  barsSpace: 23,
);
final BarChartGroupData barChartGroupData7 = BarChartGroupData(
  x: 12,
  showingTooltipIndicators: [0, 1, 2],
  barRods: [
    barChartRodData1,
    barChartRodData2,
    barChartRodData3,
    barChartRodData4,
  ],
  barsSpace: 44,
);
final BarChartGroupData barChartGroupData8 = BarChartGroupData(
  x: 12,
  barRods: [
    barChartRodData1,
    barChartRodData2,
    barChartRodData3,
    barChartRodData4,
  ],
  barsSpace: 23,
);
final BarChartGroupData barChartGroupData9 = BarChartGroupData(
  x: 12,
  showingTooltipIndicators: [0, 1, 2],
  barRods: [
    barChartRodData1,
    barChartRodData2,
    barChartRodData3,
    barChartRodData4,
  ],
  barsSpace: 0,
);

final BarTouchedSpot barTouchedSpot1 = BarTouchedSpot(
  barChartGroupData1,
  1,
  barChartRodData1,
  2,
  barChartRodStackItem1,
  1,
  flSpot1,
  Offset.zero,
);
final BarTouchedSpot barTouchedSpot1Clone = BarTouchedSpot(
  barChartGroupData1Clone,
  1,
  barChartRodData1Clone,
  2,
  barChartRodStackItem1Clone,
  1,
  flSpot1Clone,
  Offset.zero,
);
final BarTouchedSpot barTouchedSpot2 = BarTouchedSpot(
  barChartGroupData2,
  1,
  barChartRodData1,
  2,
  barChartRodStackItem2,
  2,
  flSpot1,
  Offset.zero,
);
final BarTouchedSpot barTouchedSpot3 = BarTouchedSpot(
  barChartGroupData1,
  1,
  barChartRodData2,
  2,
  barChartRodStackItem2,
  2,
  flSpot1,
  Offset.zero,
);
final BarTouchedSpot barTouchedSpot4 = BarTouchedSpot(
  barChartGroupData1,
  2,
  barChartRodData1,
  2,
  barChartRodStackItem2,
  2,
  flSpot1,
  Offset.zero,
);
final BarTouchedSpot barTouchedSpot5 = BarTouchedSpot(
  barChartGroupData1,
  1,
  barChartRodData1,
  3,
  barChartRodStackItem2,
  2,
  flSpot1,
  Offset.zero,
);
final BarTouchedSpot barTouchedSpot6 = BarTouchedSpot(
  barChartGroupData1,
  1,
  barChartRodData1,
  2,
  barChartRodStackItem2,
  2,
  flSpot2,
  Offset.zero,
);
final BarTouchedSpot barTouchedSpot7 = BarTouchedSpot(
  barChartGroupData1,
  1,
  barChartRodData1,
  2,
  barChartRodStackItem2,
  2,
  flSpot1,
  const Offset(1, 10),
);

final BarTouchResponse barTouchResponse1 = BarTouchResponse(
  barTouchedSpot1,
);
final BarTouchResponse barTouchResponse1Clone = BarTouchResponse(
  barTouchedSpot1Clone,
);
final BarTouchResponse barTouchResponse2 = BarTouchResponse(
  barTouchedSpot2,
);

final BarTooltipItem barTooltipItem1 = BarTooltipItem(
  'pashmam 1',
  const TextStyle(color: Colors.red),
);
final BarTooltipItem barTooltipItem1Clone = BarTooltipItem(
  'pashmam 1',
  const TextStyle(color: Colors.red),
);
final BarTooltipItem barTooltipItem2 = BarTooltipItem(
  'pashmam 2',
  const TextStyle(color: Colors.red),
);
final BarTooltipItem barTooltipItem3 = BarTooltipItem(
  'pashmam 1',
  const TextStyle(color: Colors.green),
);
final BarTooltipItem barTooltipItem4 = BarTooltipItem(
  'null',
  const TextStyle(color: Colors.red),
);
final BarTooltipItem barTooltipItem5 = BarTooltipItem(
  'pashmam 1',
  const TextStyle(fontSize: 85),
);

BarTooltipItem getTooltipItem(
  BarChartGroupData group,
  int groupIndex,
  BarChartRodData rod,
  int rodIndex,
) {
  const textStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  return BarTooltipItem(rod.toY.toString(), textStyle);
}

final BarTouchTooltipData barTouchTooltipData1 = BarTouchTooltipData(
  tooltipRoundedRadius: 12,
  fitInsideVertically: false,
  fitInsideHorizontally: true,
  maxContentWidth: 23,
  tooltipBgColor: Colors.green,
  tooltipPadding: const EdgeInsets.all(23),
  getTooltipItem: getTooltipItem,
  tooltipMargin: 12,
  tooltipBorder: const BorderSide(color: Colors.red),
);
final BarTouchTooltipData barTouchTooltipData1Clone = BarTouchTooltipData(
  tooltipRoundedRadius: 12,
  fitInsideVertically: false,
  fitInsideHorizontally: true,
  maxContentWidth: 23,
  tooltipBgColor: Colors.green,
  tooltipPadding: const EdgeInsets.all(23),
  getTooltipItem: getTooltipItem,
  tooltipMargin: 12,
  tooltipBorder: const BorderSide(color: Colors.red),
);
final BarTouchTooltipData barTouchTooltipData2 = BarTouchTooltipData(
  tooltipRoundedRadius: 13,
  fitInsideVertically: false,
  fitInsideHorizontally: true,
  maxContentWidth: 23,
  tooltipBgColor: Colors.green,
  tooltipPadding: const EdgeInsets.all(23),
  getTooltipItem: getTooltipItem,
  tooltipMargin: 12,
  tooltipBorder: const BorderSide(color: Colors.red),
  tooltipHorizontalAlignment: FLHorizontalAlignment.center,
);
final BarTouchTooltipData barTouchTooltipData3 = BarTouchTooltipData(
  tooltipRoundedRadius: 12,
  fitInsideVertically: true,
  fitInsideHorizontally: true,
  maxContentWidth: 23,
  tooltipBgColor: Colors.green,
  tooltipPadding: const EdgeInsets.all(23),
  getTooltipItem: getTooltipItem,
  tooltipMargin: 12,
  tooltipBorder: const BorderSide(color: Colors.red),
  tooltipHorizontalAlignment: FLHorizontalAlignment.left,
);
final BarTouchTooltipData barTouchTooltipData4 = BarTouchTooltipData(
  tooltipRoundedRadius: 12,
  fitInsideVertically: false,
  fitInsideHorizontally: false,
  maxContentWidth: 23,
  tooltipBgColor: Colors.green,
  tooltipPadding: const EdgeInsets.all(23),
  getTooltipItem: getTooltipItem,
  tooltipMargin: 12,
  tooltipBorder: const BorderSide(color: Colors.red),
  tooltipHorizontalAlignment: FLHorizontalAlignment.right,
);
final BarTouchTooltipData barTouchTooltipData5 = BarTouchTooltipData(
  tooltipRoundedRadius: 12,
  fitInsideVertically: false,
  fitInsideHorizontally: true,
  maxContentWidth: 23.00001,
  tooltipBgColor: Colors.green,
  tooltipPadding: const EdgeInsets.all(23),
  getTooltipItem: getTooltipItem,
  tooltipMargin: 12,
  tooltipBorder: const BorderSide(color: Colors.red),
  tooltipHorizontalAlignment: FLHorizontalAlignment.center,
  tooltipHorizontalOffset: 10,
);
final BarTouchTooltipData barTouchTooltipData6 = BarTouchTooltipData(
  tooltipRoundedRadius: 12,
  fitInsideVertically: false,
  fitInsideHorizontally: true,
  maxContentWidth: 23,
  tooltipBgColor: Colors.blue,
  tooltipPadding: const EdgeInsets.all(23),
  getTooltipItem: getTooltipItem,
  tooltipMargin: 12,
  tooltipBorder: const BorderSide(color: Colors.red),
  tooltipHorizontalAlignment: FLHorizontalAlignment.left,
  tooltipHorizontalOffset: -10,
);
final BarTouchTooltipData barTouchTooltipData7 = BarTouchTooltipData(
  tooltipRoundedRadius: 12,
  fitInsideVertically: false,
  fitInsideHorizontally: true,
  maxContentWidth: 23,
  tooltipBgColor: Colors.green,
  getTooltipItem: getTooltipItem,
  tooltipMargin: 12,
  tooltipBorder: const BorderSide(color: Colors.red),
  tooltipHorizontalAlignment: FLHorizontalAlignment.right,
  tooltipHorizontalOffset: 10,
);
final BarTouchTooltipData barTouchTooltipData8 = BarTouchTooltipData(
  tooltipRoundedRadius: 12,
  fitInsideVertically: false,
  fitInsideHorizontally: true,
  maxContentWidth: 23,
  tooltipBgColor: Colors.green,
  tooltipPadding: const EdgeInsets.all(23),
  tooltipMargin: 12,
  tooltipBorder: const BorderSide(color: Colors.red),
);
final BarTouchTooltipData barTouchTooltipData9 = BarTouchTooltipData(
  tooltipRoundedRadius: 12,
  fitInsideVertically: false,
  fitInsideHorizontally: true,
  maxContentWidth: 23,
  tooltipBgColor: Colors.green,
  tooltipPadding: const EdgeInsets.all(23),
  getTooltipItem: getTooltipItem,
  tooltipMargin: 333,
  tooltipBorder: const BorderSide(color: Colors.red),
);
final BarTouchTooltipData barTouchTooltipData10 = BarTouchTooltipData(
  tooltipRoundedRadius: 12,
  fitInsideVertically: false,
  fitInsideHorizontally: true,
  maxContentWidth: 23,
  tooltipBgColor: Colors.green,
  tooltipPadding: const EdgeInsets.all(23),
  getTooltipItem: getTooltipItem,
  tooltipMargin: 12,
  tooltipBorder: const BorderSide(color: Colors.blue),
);
final BarTouchTooltipData barTouchTooltipData11 = BarTouchTooltipData(
  tooltipRoundedRadius: 12,
  fitInsideVertically: false,
  fitInsideHorizontally: true,
  maxContentWidth: 23,
  tooltipBgColor: Colors.green,
  tooltipPadding: const EdgeInsets.all(23),
  getTooltipItem: getTooltipItem,
  tooltipMargin: 12,
  tooltipBorder: const BorderSide(color: Colors.red, width: 2),
);

void barTouchCallback(FlTouchEvent event, BarTouchResponse? response) {}

void scatterTouchCallback(FlTouchEvent event, ScatterTouchResponse? response) {}

final BarTouchData barTouchData1 = BarTouchData(
  touchTooltipData: barTouchTooltipData1,
  handleBuiltInTouches: false,
  touchCallback: barTouchCallback,
  enabled: false,
  allowTouchBarBackDraw: true,
  touchExtraThreshold: const EdgeInsets.all(12),
);
final BarTouchData barTouchData1Clone = BarTouchData(
  touchTooltipData: barTouchTooltipData1Clone,
  handleBuiltInTouches: false,
  touchCallback: barTouchCallback,
  enabled: false,
  allowTouchBarBackDraw: true,
  touchExtraThreshold: const EdgeInsets.all(12),
);
final BarTouchData barTouchData2 = BarTouchData(
  handleBuiltInTouches: false,
  touchCallback: barTouchCallback,
  enabled: false,
  allowTouchBarBackDraw: true,
  touchExtraThreshold: const EdgeInsets.all(12),
);
final BarTouchData barTouchData3 = BarTouchData(
  touchTooltipData: barTouchTooltipData1,
  handleBuiltInTouches: true,
  touchCallback: barTouchCallback,
  enabled: false,
  allowTouchBarBackDraw: true,
  touchExtraThreshold: const EdgeInsets.all(12),
);
final BarTouchData barTouchData4 = BarTouchData(
  touchTooltipData: barTouchTooltipData2,
  handleBuiltInTouches: false,
  touchCallback: barTouchCallback,
  enabled: false,
  allowTouchBarBackDraw: true,
  touchExtraThreshold: const EdgeInsets.all(12),
);
final BarTouchData barTouchData5 = BarTouchData(
  touchTooltipData: barTouchTooltipData1,
  handleBuiltInTouches: false,
  enabled: false,
  allowTouchBarBackDraw: true,
  touchExtraThreshold: const EdgeInsets.all(12),
);
final BarTouchData barTouchData6 = BarTouchData(
  touchTooltipData: barTouchTooltipData1,
  handleBuiltInTouches: false,
  touchCallback: barTouchCallback,
  enabled: true,
  allowTouchBarBackDraw: true,
  touchExtraThreshold: const EdgeInsets.all(12),
);
final BarTouchData barTouchData7 = BarTouchData(
  touchTooltipData: barTouchTooltipData1,
  handleBuiltInTouches: false,
  touchCallback: barTouchCallback,
  enabled: false,
  allowTouchBarBackDraw: false,
  touchExtraThreshold: const EdgeInsets.all(12),
);
final BarTouchData barTouchData8 = BarTouchData(
  touchTooltipData: barTouchTooltipData1,
  handleBuiltInTouches: false,
  touchCallback: barTouchCallback,
  enabled: false,
  allowTouchBarBackDraw: true,
);
final BarTouchData barTouchData9 = BarTouchData(
  touchTooltipData: barTouchTooltipData1,
  handleBuiltInTouches: false,
  touchCallback: barTouchCallback,
  enabled: false,
  allowTouchBarBackDraw: true,
  touchExtraThreshold: const EdgeInsets.only(left: 12),
);
final BarTouchData barTouchData10 = BarTouchData(
  touchTooltipData: barTouchTooltipData1,
  handleBuiltInTouches: false,
  touchCallback: barTouchCallback,
  enabled: false,
  allowTouchBarBackDraw: true,
  touchExtraThreshold: const EdgeInsets.all(12),
  longPressDuration: Duration.zero,
);

final BarChartData barChartData1 = BarChartData(
  minY: 12,
  titlesData: MockData.flTitlesData1,
  gridData: flGridData1,
  rangeAnnotations: rangeAnnotations1,
  maxY: 23,
  backgroundColor: Colors.green,
  borderData: borderData1,
  alignment: BarChartAlignment.spaceAround,
  barGroups: [
    barChartGroupData1,
    barChartGroupData2,
    barChartGroupData3,
  ],
  barTouchData: barTouchData1,
  groupsSpace: 23,
  extraLinesData: extraLinesData1,
);
final BarChartData barChartData1Clone = barChartData1.copyWith(
  titlesData: MockData.flTitlesData1Clone,
  gridData: flGridData1Clone,
  borderData: borderData1Clone,
  barTouchData: barTouchData1Clone,
  rangeAnnotations: rangeAnnotations1Clone,
);

final BarChartData barChartData2 = barChartData1.copyWith(
  minY: 11,
);
final BarChartData barChartData3 = barChartData1.copyWith(
  titlesData: MockData.flTitlesData2,
);
final BarChartData barChartData4 = barChartData1.copyWith(
  gridData: flGridData2,
);
final BarChartData barChartData5 = barChartData1.copyWith(
  rangeAnnotations: rangeAnnotations2,
);
final BarChartData barChartData6 = barChartData1.copyWith(
  maxY: 52345,
);
final BarChartData barChartData7 = barChartData1.copyWith(
  backgroundColor: Colors.red,
);
final BarChartData barChartData8 = barChartData1.copyWith(
  titlesData: MockData.flTitlesData3,
);
final BarChartData barChartData9 = barChartData1.copyWith(
  borderData: borderData2,
);
final BarChartData barChartData10 = barChartData1.copyWith(
  alignment: BarChartAlignment.center,
);
final BarChartData barChartData11 = barChartData1.copyWith(
  barGroups: [],
);
final BarChartData barChartData12 = barChartData1.copyWith(
  barGroups: [
    barChartGroupData3,
    barChartGroupData1,
    barChartGroupData2,
  ],
);
final BarChartData barChartData13 = barChartData1.copyWith(
  barTouchData: barTouchData2,
);
final BarChartData barChartData14 = barChartData1.copyWith(
  groupsSpace: 444,
);
final BarChartData barChartData15 = barChartData1.copyWith(
  extraLinesData: extraLinesData2,
);

final RadarDataSet radarDataSet1 = RadarDataSet(
  dataEntries: const [
    RadarEntry(value: 0),
    RadarEntry(value: 1),
    RadarEntry(value: 2),
    RadarEntry(value: 3),
    RadarEntry(value: 4),
  ],
  borderColor: Colors.blue,
  borderWidth: 3,
  entryRadius: 3,
  fillColor: Colors.grey,
);

final RadarDataSet radarDataSet1Clone = radarDataSet1.copyWith();

final RadarDataSet radarDataSet2 = RadarDataSet(
  dataEntries: const [
    RadarEntry(value: 10),
    RadarEntry(value: 9),
    RadarEntry(value: 8),
    RadarEntry(value: 7),
    RadarEntry(value: 6),
  ],
  borderColor: Colors.red,
  borderWidth: 5,
  entryRadius: 5,
  fillColor: Colors.black,
);

final RadarTouchData radarTouchData1 = RadarTouchData(
  enabled: true,
  touchCallback: radarTouchCallback,
  touchSpotThreshold: 12,
);

final RadarTouchData radarTouchData2 = RadarTouchData(
  enabled: false,
  touchCallback: radarTouchCallback,
  touchSpotThreshold: 5,
);

final RadarTouchData radarTouchData1Clone = radarTouchData1;

void radarTouchCallback(FlTouchEvent event, RadarTouchResponse? response) {}

final radarTouchedSpot1 = RadarTouchedSpot(
  radarDataSet1,
  0,
  radarDataSet1.dataEntries.first,
  0,
  flSpot1,
  Offset.zero,
);

final radarTouchedSpotClone1 = radarTouchedSpot1;

final radarTouchedSpot2 = RadarTouchedSpot(
  radarDataSet2,
  0,
  radarDataSet1.dataEntries.first,
  0,
  flSpot1,
  Offset.zero,
);

final radarTouchedSpot3 = RadarTouchedSpot(
  radarDataSet1,
  1,
  radarDataSet1.dataEntries.first,
  0,
  flSpot1,
  Offset.zero,
);

final radarTouchedSpot4 = RadarTouchedSpot(
  radarDataSet1,
  0,
  radarDataSet1.dataEntries.last,
  0,
  flSpot1,
  Offset.zero,
);

final radarTouchedSpot5 = RadarTouchedSpot(
  radarDataSet1,
  0,
  radarDataSet1.dataEntries.first,
  1,
  flSpot1,
  Offset.zero,
);

final radarTouchedSpot6 = RadarTouchedSpot(
  radarDataSet1,
  0,
  radarDataSet1.dataEntries.first,
  0,
  flSpot2,
  Offset.zero,
);

final radarTouchedSpot7 = RadarTouchedSpot(
  radarDataSet1,
  0,
  radarDataSet1.dataEntries.first,
  0,
  flSpot1,
  const Offset(3, 5),
);

final RadarChartData radarChartData1 = RadarChartData(
  dataSets: [radarDataSet1],
  radarBackgroundColor: Colors.yellow,
  radarBorderData: const BorderSide(color: Colors.purple, width: 5),
  borderData: borderData1,
  gridBorderData: const BorderSide(color: Colors.blue, width: 2),
  getTitle: (index, angle) => RadarChartTitle(text: 'testTitle', angle: angle),
  titlePositionPercentageOffset: 0.2,
  titleTextStyle: const TextStyle(color: Colors.white, fontSize: 12),
  radarTouchData: radarTouchData1,
  tickCount: 5,
  tickBorderData: const BorderSide(width: 4),
  ticksTextStyle: const TextStyle(color: Colors.white, fontSize: 12),
);

final RadarChartData radarChartData1Clone = radarChartData1.copyWith();

final RadarChartData radarChartData2 = RadarChartData(
  dataSets: [radarDataSet2],
  radarBackgroundColor: Colors.blue,
  radarBorderData: const BorderSide(color: Colors.pink, width: 3),
  borderData: borderData1,
  gridBorderData: const BorderSide(color: Colors.red, width: 3),
  getTitle: (index, angle) => RadarChartTitle(text: 'testTitle2', angle: angle),
  titlePositionPercentageOffset: 0.5,
  titleTextStyle: const TextStyle(color: Colors.black, fontSize: 5),
  radarTouchData: radarTouchData2,
  tickCount: 1,
  tickBorderData: const BorderSide(color: Colors.pink, width: 2),
  ticksTextStyle: const TextStyle(color: Colors.purple, fontSize: 10),
);

const Line line1 = Line(Offset.zero, Offset(10, 10));
const Line line2 = Line(Offset(-4, -12), Offset(6, 8));
const Line line3 = Line(Offset(18, -1), Offset.zero);
const Line line4 = Line(Offset(8, 8), Offset(-4, -22));
const Line line5 = Line(Offset(2, 3), Offset(5, 8));

const TextStyle textStyle1 =
    TextStyle(color: Colors.red, fontWeight: FontWeight.bold);
const TextStyle textStyle2 =
    TextStyle(color: Colors.green, fontWeight: FontWeight.w200);

const TextSpan textSpan1 = TextSpan(text: 'faketext1', style: textStyle1);
const TextSpan textSpan2 = TextSpan(text: 'faketext2', style: textStyle2);

final DefaultTextStyle defaultTextStyle1 = DefaultTextStyle(
  style: const TextStyle(),
  child: Container(),
);
