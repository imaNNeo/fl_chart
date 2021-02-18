import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

final VerticalRangeAnnotation verticalRangeAnnotation1 =
    VerticalRangeAnnotation(color: Colors.green, x2: 12, x1: 12.1);
final VerticalRangeAnnotation verticalRangeAnnotation1Clone =
    VerticalRangeAnnotation(color: Colors.green, x2: 12, x1: 12.1);

final HorizontalRangeAnnotation horizontalRangeAnnotation1 =
    HorizontalRangeAnnotation(color: Colors.green, y2: 12, y1: 12.1);
final HorizontalRangeAnnotation horizontalRangeAnnotation1Clone =
    HorizontalRangeAnnotation(color: Colors.green, y2: 12, y1: 12.1);

final RangeAnnotations rangeAnnotations1 = RangeAnnotations(horizontalRangeAnnotations: [
  horizontalRangeAnnotation1,
  horizontalRangeAnnotation1Clone,
], verticalRangeAnnotations: [
  verticalRangeAnnotation1,
  verticalRangeAnnotation1Clone,
]);
final RangeAnnotations rangeAnnotations1Clone = RangeAnnotations(horizontalRangeAnnotations: [
  horizontalRangeAnnotation1,
  horizontalRangeAnnotation1Clone,
], verticalRangeAnnotations: [
  verticalRangeAnnotation1,
  verticalRangeAnnotation1Clone,
]);
final RangeAnnotations rangeAnnotations2 = RangeAnnotations(horizontalRangeAnnotations: [
  horizontalRangeAnnotation1Clone,
], verticalRangeAnnotations: [
  verticalRangeAnnotation1,
  verticalRangeAnnotation1Clone,
]);

final FlLine flLine1 = FlLine(color: Colors.green, strokeWidth: 1, dashArray: [1, 2, 3]);
final FlLine flLine1Clone = FlLine(color: Colors.green, strokeWidth: 1, dashArray: [1, 2, 3]);

final Function(double) checkToShowLine = (value) => true;
final Function(double) getDrawingLine = (value) => FlLine();

final FlSpot flSpot1 = FlSpot(1, 1);
final FlSpot flSpot1Clone = flSpot1.copyWith();

final FlSpot flSpot2 = FlSpot(4, 2);
final FlSpot flSpot2Clone = flSpot2.copyWith();

final Function(double value) getTitles = (value) => 'sallam';
final Function(double value) getTextStyles = (value) => const TextStyle(color: Colors.green);

final SideTitles sideTitles1 = SideTitles(
  margin: 1,
  reservedSize: 10,
  getTextStyles: getTextStyles,
  showTitles: false,
  getTitles: getTitles,
  interval: 12,
  rotateAngle: 11,
);
final SideTitles sideTitles1Clone = SideTitles(
  margin: 1,
  reservedSize: 10,
  getTextStyles: getTextStyles,
  showTitles: false,
  getTitles: getTitles,
  interval: 12,
  rotateAngle: 11,
);
final SideTitles sideTitles2 = SideTitles(
  margin: 1,
  reservedSize: 10,
  getTextStyles: getTextStyles,
  showTitles: false,
  getTitles: null,
  interval: 12,
  rotateAngle: 11,
);
final SideTitles sideTitles3 = SideTitles(
  margin: 4,
  reservedSize: 10,
  getTextStyles: getTextStyles,
  showTitles: false,
  getTitles: getTitles,
  interval: 12,
  rotateAngle: 11,
);
final SideTitles sideTitles4 = SideTitles(
  margin: 1,
  reservedSize: 11,
  getTextStyles: getTextStyles,
  showTitles: false,
  getTitles: getTitles,
  interval: 12,
  rotateAngle: 11,
);
final SideTitles sideTitles5 = SideTitles(
  margin: 1,
  reservedSize: 10,
  getTextStyles: getTextStyles,
  showTitles: false,
  getTitles: getTitles,
  interval: 12,
  rotateAngle: 101110,
);
final SideTitles sideTitles6 = SideTitles(
  margin: 1,
  reservedSize: 10,
  getTextStyles: getTextStyles,
  showTitles: false,
  getTitles: getTitles,
  interval: 12,
  rotateAngle: 13,
);

final FlTitlesData flTitlesData1 = FlTitlesData(
  show: true,
  bottomTitles: sideTitles1,
  topTitles: sideTitles2,
  rightTitles: sideTitles3,
  leftTitles: sideTitles4,
);
final FlTitlesData flTitlesData1Clone = FlTitlesData(
  show: true,
  bottomTitles: sideTitles1Clone,
  topTitles: sideTitles2,
  rightTitles: sideTitles3,
  leftTitles: sideTitles4,
);
final FlTitlesData flTitlesData2 = FlTitlesData(
  show: true,
  bottomTitles: null,
  topTitles: sideTitles2,
  rightTitles: sideTitles3,
  leftTitles: sideTitles4,
);
final FlTitlesData flTitlesData3 = FlTitlesData(
  show: true,
  bottomTitles: sideTitles1,
  topTitles: null,
  rightTitles: sideTitles3,
  leftTitles: sideTitles4,
);
final FlTitlesData flTitlesData4 = FlTitlesData(
  show: true,
  bottomTitles: sideTitles1,
  topTitles: sideTitles2,
  rightTitles: null,
  leftTitles: sideTitles4,
);
final FlTitlesData flTitlesData5 = FlTitlesData(
  show: true,
  bottomTitles: sideTitles1,
  topTitles: sideTitles2,
  rightTitles: sideTitles3,
  leftTitles: null,
);
final FlTitlesData flTitlesData6 = FlTitlesData(
  show: false,
  bottomTitles: sideTitles1,
  topTitles: sideTitles2,
  rightTitles: sideTitles3,
  leftTitles: sideTitles4,
);

final AxisTitle axisTitle1 = AxisTitle(
  textStyle: const TextStyle(color: Colors.green),
  reservedSize: 12,
  margin: 33,
  showTitle: true,
  titleText: 'sallam',
  textAlign: TextAlign.right,
);
final AxisTitle axisTitle1Clone = AxisTitle(
  textStyle: const TextStyle(color: Colors.green),
  reservedSize: 12,
  margin: 33,
  showTitle: true,
  titleText: 'sallam',
  textAlign: TextAlign.right,
);

final AxisTitle axisTitle2 = AxisTitle(
  textStyle: const TextStyle(color: Colors.green),
  reservedSize: 33,
  margin: 33,
  showTitle: true,
  titleText: 'sallam',
  textAlign: TextAlign.right,
);
final AxisTitle axisTitle3 = AxisTitle(
  textStyle: const TextStyle(color: Colors.red),
  reservedSize: 12,
  margin: 33,
  showTitle: true,
  titleText: 'sallam',
  textAlign: TextAlign.right,
);
final AxisTitle axisTitle4 = AxisTitle(
  textStyle: const TextStyle(color: Colors.green),
  reservedSize: 12,
  margin: 11,
  showTitle: true,
  titleText: 'sallam',
  textAlign: TextAlign.right,
);
final AxisTitle axisTitle5 = AxisTitle(
  textStyle: const TextStyle(color: Colors.green),
  reservedSize: 12,
  margin: 33,
  showTitle: false,
  titleText: 'sallam',
  textAlign: TextAlign.right,
);
final AxisTitle axisTitle6 = AxisTitle(
  textStyle: const TextStyle(color: Colors.green),
  reservedSize: 12,
  margin: 33,
  showTitle: true,
  titleText: 'sallam',
  textAlign: TextAlign.left,
);
final AxisTitle axisTitle7 = AxisTitle(
  textStyle: const TextStyle(color: Colors.green),
  reservedSize: 12,
  margin: 33,
  showTitle: true,
  titleText: 'sallamm',
  textAlign: TextAlign.right,
);
final AxisTitle axisTitle8 = AxisTitle(
  textStyle: null,
  reservedSize: 12,
  margin: 33,
  showTitle: true,
  titleText: 'sallam',
  textAlign: TextAlign.right,
);

final FlAxisTitleData flAxisTitleData1 = FlAxisTitleData(
  show: true,
  topTitle: axisTitle1,
  rightTitle: axisTitle2,
  leftTitle: axisTitle3,
  bottomTitle: axisTitle4,
);
final FlAxisTitleData flAxisTitleData1Clone = FlAxisTitleData(
  show: true,
  topTitle: axisTitle1Clone,
  rightTitle: axisTitle2,
  leftTitle: axisTitle3,
  bottomTitle: axisTitle4,
);
final FlAxisTitleData flAxisTitleData2 = FlAxisTitleData(
  show: true,
  topTitle: null,
  rightTitle: axisTitle2,
  leftTitle: axisTitle3,
  bottomTitle: axisTitle4,
);
final FlAxisTitleData flAxisTitleData3 = FlAxisTitleData(
  show: true,
  topTitle: axisTitle1,
  rightTitle: null,
  leftTitle: axisTitle3,
  bottomTitle: axisTitle4,
);
final FlAxisTitleData flAxisTitleData4 = FlAxisTitleData(
  show: true,
  topTitle: axisTitle1,
  rightTitle: axisTitle2,
  leftTitle: null,
  bottomTitle: axisTitle4,
);
final FlAxisTitleData flAxisTitleData5 = FlAxisTitleData(
  show: true,
  topTitle: axisTitle1,
  rightTitle: axisTitle2,
  leftTitle: axisTitle3,
  bottomTitle: null,
);
final FlAxisTitleData flAxisTitleData6 = FlAxisTitleData(
  show: false,
  topTitle: axisTitle1,
  rightTitle: axisTitle2,
  leftTitle: axisTitle3,
  bottomTitle: axisTitle4,
);
final FlAxisTitleData flAxisTitleData7 = FlAxisTitleData(
  show: true,
  topTitle: axisTitle1,
  rightTitle: axisTitle2,
  leftTitle: axisTitle4,
  bottomTitle: axisTitle3,
);
final FlAxisTitleData flAxisTitleData8 = FlAxisTitleData(
  show: true,
  topTitle: axisTitle4,
  rightTitle: axisTitle2,
  leftTitle: axisTitle3,
  bottomTitle: axisTitle1,
);

final FlGridData flGridData1 = FlGridData(
  show: true,
  verticalInterval: 12,
  horizontalInterval: 22,
  drawVerticalLine: false,
  drawHorizontalLine: true,
  checkToShowVerticalLine: checkToShowLine,
  checkToShowHorizontalLine: null,
  getDrawingHorizontalLine: getDrawingLine,
  getDrawingVerticalLine: null,
);
final FlGridData flGridData1Clone = FlGridData(
  show: true,
  verticalInterval: 12,
  horizontalInterval: 22,
  drawVerticalLine: false,
  drawHorizontalLine: true,
  checkToShowVerticalLine: checkToShowLine,
  checkToShowHorizontalLine: null,
  getDrawingHorizontalLine: getDrawingLine,
  getDrawingVerticalLine: null,
);
final FlGridData flGridData2 = FlGridData(
  show: true,
  verticalInterval: 12,
  horizontalInterval: 22,
  drawVerticalLine: false,
  drawHorizontalLine: true,
  checkToShowVerticalLine: checkToShowLine,
  checkToShowHorizontalLine: null,
  getDrawingHorizontalLine: getDrawingLine,
  getDrawingVerticalLine: (value) => flLine1,
);
final FlGridData flGridData3 = FlGridData(
  show: true,
  verticalInterval: 12,
  horizontalInterval: 43,
  drawVerticalLine: false,
  drawHorizontalLine: true,
  checkToShowVerticalLine: checkToShowLine,
  checkToShowHorizontalLine: null,
  getDrawingHorizontalLine: getDrawingLine,
  getDrawingVerticalLine: null,
);
final FlGridData flGridData4 = FlGridData(
  show: true,
  verticalInterval: 12,
  horizontalInterval: 22,
  drawVerticalLine: false,
  drawHorizontalLine: true,
  checkToShowVerticalLine: null,
  checkToShowHorizontalLine: null,
  getDrawingHorizontalLine: getDrawingLine,
  getDrawingVerticalLine: null,
);
final FlGridData flGridData5 = FlGridData(
  show: true,
  verticalInterval: 12,
  horizontalInterval: 22,
  drawVerticalLine: true,
  drawHorizontalLine: true,
  checkToShowVerticalLine: checkToShowLine,
  checkToShowHorizontalLine: null,
  getDrawingHorizontalLine: getDrawingLine,
  getDrawingVerticalLine: null,
);

final BaseTouchResponse baseTouchResponse1 = BaseTouchResponse(
  FlPanStart(Offset.zero),
);
final BaseTouchResponse baseTouchResponse2 = BaseTouchResponse(
  FlPanStart(Offset.zero),
);

final FlTouchData touchData1 = FlTouchData(
  false,
);
final FlTouchData touchData2 = FlTouchData(
  false,
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

final Function(FlSpot) checkToShowSpotLine = (spot) => true;

final BarAreaSpotsLine barAreaSpotsLine1 =
    BarAreaSpotsLine(show: true, checkToShowSpotLine: checkToShowSpotLine);
final BarAreaSpotsLine barAreaSpotsLine1Clone =
    BarAreaSpotsLine(show: true, checkToShowSpotLine: checkToShowSpotLine);

final BarAreaSpotsLine barAreaSpotsLine2 = BarAreaSpotsLine(
  show: true,
  checkToShowSpotLine: null,
);

final BarAreaData barAreaData1 = BarAreaData(
  colors: [Colors.green, Colors.blue],
  show: true,
  applyCutOffY: false,
  cutOffY: 12,
  gradientColorStops: [0, 0.5],
  gradientFrom: const Offset(0, 0),
  gradientTo: const Offset(1, 1),
  spotsLine: barAreaSpotsLine1,
);
final BarAreaData barAreaData1Clone = BarAreaData(
  colors: [Colors.green, Colors.blue],
  show: true,
  applyCutOffY: false,
  cutOffY: 12,
  gradientColorStops: [0, 0.5],
  gradientFrom: const Offset(0, 0),
  gradientTo: const Offset(1, 1),
  spotsLine: barAreaSpotsLine1,
);

final BarAreaData barAreaData2 = BarAreaData(
  colors: [Colors.green, Colors.blue],
  show: true,
  applyCutOffY: false,
  cutOffY: 12,
  gradientColorStops: [0, 0.5],
  gradientFrom: const Offset(0, 0),
  gradientTo: const Offset(1, 1),
  spotsLine: barAreaSpotsLine2,
);
final BarAreaData barAreaData3 = BarAreaData(
  colors: null,
  show: true,
  applyCutOffY: false,
  cutOffY: 12,
  gradientColorStops: [0, 0.5],
  gradientFrom: const Offset(0, 0),
  gradientTo: const Offset(1, 1),
  spotsLine: barAreaSpotsLine2,
);
final BarAreaData barAreaData4 = BarAreaData(
  colors: [Colors.green, Colors.blue],
  show: true,
  applyCutOffY: false,
  cutOffY: 12,
  gradientColorStops: [0],
  gradientFrom: const Offset(0, 0),
  gradientTo: const Offset(1, 1),
  spotsLine: barAreaSpotsLine2,
);

final Function(FlSpot spot, LineChartBarData barData) checkToShowDot = (spot, barData) => true;
final Function(FlSpot, double, LineChartBarData, int) getDotDrawer =
    (spot, percent, barData, index) =>
        FlDotCirclePainter(radius: 44, color: Colors.green, strokeWidth: 12);
final Function(FlSpot, double, LineChartBarData, int) getDotDrawer5 =
    (spot, percent, barData, index) =>
        FlDotCirclePainter(radius: 44, color: Colors.green, strokeWidth: 14);
final Function(FlSpot, double, LineChartBarData, int) getDotDrawer6 =
    (spot, percent, barData, index) =>
        FlDotCirclePainter(radius: 44.01, color: Colors.green, strokeWidth: 14);
final Function(FlSpot, double, LineChartBarData, int) getDotDrawerTouched =
    (spot, percent, barData, index) => FlDotCirclePainter(radius: 12, color: Colors.red);
final Function(FlSpot, double, LineChartBarData, int) getDotDrawerTouched4 =
    (spot, percent, barData, index) => FlDotCirclePainter(radius: 12, color: Colors.green);
final Function(FlSpot, double, LineChartBarData, int) getDotDrawerTouched6 =
    (spot, percent, barData, index) => FlDotCirclePainter(radius: 12.01, color: Colors.red);

final FlDotData flDotData1 = FlDotData(
  show: true,
  getDotPainter: getDotDrawer,
  checkToShowDot: checkToShowDot,
);
final FlDotData flDotData1Clone = FlDotData(
  show: true,
  getDotPainter: getDotDrawer,
  checkToShowDot: checkToShowDot,
);

final FlDotData flDotData4 = FlDotData(
  show: true,
  getDotPainter: getDotDrawer,
  checkToShowDot: null,
);

final FlDotData flDotData5 = FlDotData(
  show: true,
  getDotPainter: getDotDrawer5,
  checkToShowDot: null,
);

final FlDotData flDotData6 = FlDotData(
  show: true,
  getDotPainter: getDotDrawer6,
  checkToShowDot: null,
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

final LineChartStepData lineChartStepData1 = LineChartStepData(
  stepDirection: LineChartStepData.stepDirectionMiddle,
);

final LineChartStepData lineChartStepData1Clone = LineChartStepData(
  stepDirection: LineChartStepData.stepDirectionMiddle,
);

final LineChartStepData lineChartStepData2 = LineChartStepData(
  stepDirection: LineChartStepData.stepDirectionForward,
);

final LineChartBarData lineChartBarData1 = LineChartBarData(
  show: true,
  dashArray: [0, 1],
  colors: [Colors.red, Colors.green],
  colorStops: [0, 1],
  spots: [
    flSpot1,
    flSpot2,
  ],
  shadow: shadow1,
  isStepLineChart: false,
  aboveBarData: barAreaData1,
  belowBarData: barAreaData2,
  gradientFrom: const Offset(0, 0),
  gradientTo: const Offset(1, 1),
  barWidth: 12,
  curveSmoothness: 12.0,
  dotData: flDotData1,
  isCurved: false,
  isStrokeCapRound: true,
  preventCurveOverShooting: false,
  preventCurveOvershootingThreshold: 1.2,
  showingIndicators: [0, 1],
);
final LineChartBarData lineChartBarData1Clone = LineChartBarData(
  show: true,
  dashArray: [0, 1],
  colors: [Colors.red, Colors.green],
  colorStops: [0, 1],
  spots: [
    flSpot1Clone,
    flSpot2,
  ],
  shadow: shadow1Clone,
  isStepLineChart: false,
  aboveBarData: barAreaData1Clone,
  belowBarData: barAreaData2,
  gradientFrom: const Offset(0, 0),
  gradientTo: const Offset(1, 1),
  barWidth: 12,
  curveSmoothness: 12.0,
  dotData: flDotData1Clone,
  isCurved: false,
  isStrokeCapRound: true,
  preventCurveOverShooting: false,
  preventCurveOvershootingThreshold: 1.2,
  showingIndicators: [0, 1],
);

final LineChartBarData lineChartBarData2 = LineChartBarData(
  show: true,
  dashArray: [0, 1],
  colors: [Colors.red, Colors.green],
  colorStops: [0, 1],
  spots: [
    flSpot1,
    flSpot2,
  ],
  shadow: shadow2,
  isStepLineChart: true,
  lineChartStepData: lineChartStepData1,
  aboveBarData: barAreaData1,
  belowBarData: barAreaData2,
  gradientFrom: const Offset(0, 0),
  gradientTo: const Offset(1, 1),
  barWidth: 12,
  curveSmoothness: 12.0,
  dotData: flDotData1,
  isCurved: false,
  isStrokeCapRound: true,
  preventCurveOverShooting: false,
  preventCurveOvershootingThreshold: 1.2,
  showingIndicators: [0, 4],
);

final LineChartBarData lineChartBarData3 = LineChartBarData(
  show: true,
  dashArray: null,
  colors: [Colors.red, Colors.green],
  colorStops: [0, 1],
  spots: [
    flSpot1,
    flSpot2,
  ],
  shadow: shadow3,
  isStepLineChart: true,
  lineChartStepData: lineChartStepData2,
  aboveBarData: barAreaData1,
  belowBarData: barAreaData2,
  gradientFrom: const Offset(0, 0),
  gradientTo: const Offset(1, 1),
  barWidth: 12,
  curveSmoothness: 12.0,
  dotData: flDotData1,
  isCurved: false,
  isStrokeCapRound: true,
  preventCurveOverShooting: false,
  preventCurveOvershootingThreshold: 1.2,
  showingIndicators: [0, 1],
);

final LineChartBarData lineChartBarData4 = LineChartBarData(
  show: true,
  dashArray: [0, 1],
  colors: [Colors.red, Colors.green],
  colorStops: [0, 1],
  spots: [
    flSpot2,
    flSpot1,
  ],
  shadow: shadow4,
  isStepLineChart: false,
  lineChartStepData: lineChartStepData2,
  aboveBarData: barAreaData1,
  belowBarData: barAreaData2,
  gradientFrom: const Offset(0, 0),
  gradientTo: const Offset(1, 1),
  barWidth: 12,
  curveSmoothness: 12.0,
  dotData: flDotData1,
  isCurved: false,
  isStrokeCapRound: true,
  preventCurveOverShooting: false,
  preventCurveOvershootingThreshold: 1.2,
  showingIndicators: [0, 1],
);

final LineChartBarData lineChartBarData5 = LineChartBarData(
  show: true,
  dashArray: [0, 1],
  colors: [Colors.red, Colors.green],
  colorStops: [0, 1],
  spots: [
    flSpot1,
    flSpot2,
  ],
  aboveBarData: barAreaData2,
  belowBarData: barAreaData1,
  gradientFrom: const Offset(0, 0),
  gradientTo: const Offset(1, 1),
  barWidth: 12,
  curveSmoothness: 12.0,
  dotData: flDotData1,
  isCurved: false,
  isStrokeCapRound: true,
  preventCurveOverShooting: false,
  preventCurveOvershootingThreshold: 1.2,
  showingIndicators: [0, 1],
);

final LineChartBarData lineChartBarData6 = LineChartBarData(
  show: true,
  dashArray: [0, 1],
  colors: [Colors.red, Colors.green],
  colorStops: [0, 1],
  spots: [
    flSpot1,
    flSpot2,
  ],
  aboveBarData: barAreaData1,
  belowBarData: barAreaData2,
  gradientFrom: const Offset(0, 0),
  gradientTo: const Offset(1, 1),
  barWidth: 12,
  curveSmoothness: 12.0,
  dotData: flDotData1,
  isCurved: false,
  isStrokeCapRound: true,
  preventCurveOverShooting: false,
  preventCurveOvershootingThreshold: 1.2,
  showingIndicators: [0, 1],
);

final LineChartBarData lineChartBarData7 = LineChartBarData(
  show: true,
  dashArray: [0, 1],
  colors: [Colors.red, Colors.green.withOpacity(0.4)],
  colorStops: [0, 1],
  spots: [
    flSpot1,
    flSpot2,
  ],
  aboveBarData: barAreaData1,
  belowBarData: barAreaData2,
  gradientFrom: const Offset(0, 0),
  gradientTo: const Offset(1, 1),
  barWidth: 12,
  curveSmoothness: 12.0,
  dotData: flDotData1,
  isCurved: false,
  isStrokeCapRound: true,
  preventCurveOverShooting: false,
  preventCurveOvershootingThreshold: 1.2,
  showingIndicators: [0, 1],
);

final LineChartBarData lineChartBarData8 = LineChartBarData(
  show: true,
  dashArray: [0, 1],
  colors: [Colors.red, Colors.green],
  colorStops: [0, 1],
  spots: [
    flSpot1,
    flSpot2,
  ],
  aboveBarData: barAreaData1,
  belowBarData: barAreaData2,
  gradientFrom: const Offset(0, 0),
  gradientTo: const Offset(1, 1),
  barWidth: 12,
  curveSmoothness: 12.01,
  dotData: flDotData1,
  isCurved: false,
  isStrokeCapRound: true,
  preventCurveOverShooting: false,
  preventCurveOvershootingThreshold: 1.2,
  showingIndicators: [0, 1],
);

final LineChartBarData lineChartBarData9 = LineChartBarData(
  show: true,
  dashArray: [0, 1],
  colors: [Colors.red, Colors.green],
  colorStops: [0, 1],
  spots: [
    flSpot1,
    flSpot2,
  ],
  aboveBarData: barAreaData1,
  belowBarData: barAreaData2,
  gradientFrom: const Offset(0, 0),
  gradientTo: const Offset(1, 1),
  barWidth: 12,
  curveSmoothness: 12.0,
  dotData: flDotData1,
  isCurved: false,
  isStrokeCapRound: true,
  preventCurveOverShooting: true,
  preventCurveOvershootingThreshold: 1.2,
  showingIndicators: [0, 1],
);

final LineBarSpot lineBarSpot1 = LineBarSpot(
  lineChartBarData1,
  0,
  flSpot1,
);
final LineBarSpot lineBarSpot1Clone = LineBarSpot(
  lineChartBarData1Clone,
  0,
  flSpot1Clone,
);

final LineBarSpot lineBarSpot2 = LineBarSpot(
  lineChartBarData1,
  2,
  flSpot1,
);

final LineBarSpot lineBarSpot3 = LineBarSpot(
  lineChartBarData1,
  100,
  flSpot1,
);

final LineTouchResponse lineTouchResponse1 = LineTouchResponse(
  [
    lineBarSpot1,
    lineBarSpot2,
  ],
  FlPanStart(Offset.zero),
);
final LineTouchResponse lineTouchResponse1Clone = LineTouchResponse(
  [
    lineBarSpot1Clone,
    lineBarSpot2,
  ],
  FlPanStart(Offset.zero),
);

final LineTouchResponse lineTouchResponse2 = LineTouchResponse(
  [
    lineBarSpot2,
    lineBarSpot1,
  ],
  FlPanStart(Offset.zero),
);

final LineTouchResponse lineTouchResponse3 = LineTouchResponse(
  null,
  FlPanStart(Offset.zero),
);

final LineTouchResponse lineTouchResponse4 = LineTouchResponse(
  [
    lineBarSpot1,
    lineBarSpot2,
  ],
  null,
);

final LineTouchResponse lineTouchResponse5 = LineTouchResponse(
  [
    lineBarSpot1,
    lineBarSpot2,
  ],
  FlPanStart(const Offset(0, 100)),
);

final TouchedSpotIndicatorData touchedSpotIndicatorData1 = TouchedSpotIndicatorData(
  FlLine(
    color: Colors.red,
    dashArray: [],
  ),
  FlDotData(getDotPainter: getDotDrawerTouched, checkToShowDot: checkToShowDot, show: true),
);
final TouchedSpotIndicatorData touchedSpotIndicatorData1Clone = TouchedSpotIndicatorData(
  FlLine(
    color: Colors.red,
    dashArray: [],
  ),
  FlDotData(getDotPainter: getDotDrawerTouched, checkToShowDot: checkToShowDot, show: true),
);

final TouchedSpotIndicatorData touchedSpotIndicatorData2 = TouchedSpotIndicatorData(
  FlLine(
    color: Colors.red,
    dashArray: [],
  ),
  FlDotData(getDotPainter: getDotDrawerTouched, checkToShowDot: null, show: true),
);
final TouchedSpotIndicatorData touchedSpotIndicatorData3 = TouchedSpotIndicatorData(
  FlLine(
    color: Colors.red,
    dashArray: null,
  ),
  FlDotData(getDotPainter: getDotDrawerTouched, checkToShowDot: checkToShowDot, show: true),
);
final TouchedSpotIndicatorData touchedSpotIndicatorData4 = TouchedSpotIndicatorData(
  FlLine(
    color: Colors.green,
    dashArray: [],
  ),
  FlDotData(getDotPainter: getDotDrawerTouched4, checkToShowDot: checkToShowDot, show: true),
);
final TouchedSpotIndicatorData touchedSpotIndicatorData5 = TouchedSpotIndicatorData(
  FlLine(
    color: Colors.red,
    dashArray: [],
  ),
  FlDotData(getDotPainter: getDotDrawerTouched, checkToShowDot: checkToShowDot, show: false),
);
final TouchedSpotIndicatorData touchedSpotIndicatorData6 = TouchedSpotIndicatorData(
  FlLine(
    color: Colors.red,
    dashArray: [],
  ),
  FlDotData(getDotPainter: getDotDrawerTouched6, checkToShowDot: checkToShowDot, show: true),
);

final LineTooltipItem lineTooltipItem1 = LineTooltipItem('', const TextStyle(color: Colors.green));
final LineTooltipItem lineTooltipItem1Clone =
    LineTooltipItem('', const TextStyle(color: Colors.green));

final LineTooltipItem lineTooltipItem2 =
    LineTooltipItem('ss', const TextStyle(color: Colors.green));
final LineTooltipItem lineTooltipItem3 = LineTooltipItem('', const TextStyle(color: Colors.blue));
final LineTooltipItem lineTooltipItem4 = LineTooltipItem('', null);

final Function(List<LineBarSpot> touchedSpots) lineChartGetTooltipItems = (list) {
  return list.map((s) => lineTooltipItem1).toList();
};

final LineTouchTooltipData lineTouchTooltipData1 = LineTouchTooltipData(
  tooltipPadding: const EdgeInsets.all(0.1),
  tooltipBgColor: Colors.green,
  maxContentWidth: 12,
  getTooltipItems: lineChartGetTooltipItems,
  fitInsideHorizontally: true,
  fitInsideVertically: false,
  tooltipRoundedRadius: 12,
  tooltipBottomMargin: 33,
);
final LineTouchTooltipData lineTouchTooltipData1Clone = LineTouchTooltipData(
  tooltipPadding: const EdgeInsets.all(0.1),
  tooltipBgColor: Colors.green,
  maxContentWidth: 12,
  getTooltipItems: lineChartGetTooltipItems,
  fitInsideHorizontally: true,
  fitInsideVertically: false,
  tooltipRoundedRadius: 12,
  tooltipBottomMargin: 33,
);

final LineTouchTooltipData lineTouchTooltipData2 = LineTouchTooltipData(
  tooltipPadding: const EdgeInsets.all(0.1),
  tooltipBgColor: Colors.red,
  maxContentWidth: 12,
  getTooltipItems: lineChartGetTooltipItems,
  fitInsideHorizontally: true,
  fitInsideVertically: false,
  tooltipRoundedRadius: 12,
  tooltipBottomMargin: 33,
);
final LineTouchTooltipData lineTouchTooltipData3 = LineTouchTooltipData(
  tooltipPadding: const EdgeInsets.all(0.2),
  tooltipBgColor: Colors.green,
  maxContentWidth: 12,
  getTooltipItems: lineChartGetTooltipItems,
  fitInsideHorizontally: true,
  fitInsideVertically: false,
  tooltipRoundedRadius: 12,
  tooltipBottomMargin: 33,
);
final LineTouchTooltipData lineTouchTooltipData4 = LineTouchTooltipData(
  tooltipPadding: const EdgeInsets.all(0.1),
  tooltipBgColor: Colors.green,
  maxContentWidth: 13,
  getTooltipItems: lineChartGetTooltipItems,
  fitInsideHorizontally: true,
  fitInsideVertically: false,
  tooltipRoundedRadius: 12,
  tooltipBottomMargin: 33,
);
final LineTouchTooltipData lineTouchTooltipData5 = LineTouchTooltipData(
  tooltipPadding: const EdgeInsets.all(0.1),
  tooltipBgColor: Colors.green,
  maxContentWidth: 12,
  getTooltipItems: lineChartGetTooltipItems,
  fitInsideHorizontally: true,
  fitInsideVertically: false,
  tooltipRoundedRadius: 12,
  tooltipBottomMargin: 34,
);

final Function(LineTouchResponse) lineTouchCallback = (response) {};

final Function(LineChartBarData barData, List<int> spotIndexes) getTouchedSpotIndicator =
    (barData, indexes) => indexes.map((i) => touchedSpotIndicatorData1).toList();

final LineTouchData lineTouchData1 = LineTouchData(
  enabled: true,
  touchCallback: lineTouchCallback,
  getTouchedSpotIndicator: getTouchedSpotIndicator,
  handleBuiltInTouches: false,
  touchSpotThreshold: 12,
  touchTooltipData: lineTouchTooltipData1,
  fullHeightTouchLine: false,
);
final LineTouchData lineTouchData1Clone = LineTouchData(
  enabled: true,
  touchCallback: lineTouchCallback,
  getTouchedSpotIndicator: getTouchedSpotIndicator,
  handleBuiltInTouches: false,
  touchSpotThreshold: 12,
  touchTooltipData: lineTouchTooltipData1,
  fullHeightTouchLine: false,
);

final LineTouchData lineTouchData2 = LineTouchData(
  enabled: true,
  touchCallback: null,
  getTouchedSpotIndicator: getTouchedSpotIndicator,
  handleBuiltInTouches: false,
  touchSpotThreshold: 12,
  touchTooltipData: lineTouchTooltipData1,
  fullHeightTouchLine: false,
);
final LineTouchData lineTouchData3 = LineTouchData(
  enabled: true,
  touchCallback: lineTouchCallback,
  getTouchedSpotIndicator: null,
  handleBuiltInTouches: false,
  touchSpotThreshold: 12,
  touchTooltipData: lineTouchTooltipData1,
  fullHeightTouchLine: false,
);
final LineTouchData lineTouchData4 = LineTouchData(
  enabled: true,
  touchCallback: lineTouchCallback,
  getTouchedSpotIndicator: getTouchedSpotIndicator,
  handleBuiltInTouches: false,
  touchSpotThreshold: 12,
  touchTooltipData: null,
  fullHeightTouchLine: false,
);
final LineTouchData lineTouchData5 = LineTouchData(
  enabled: true,
  touchCallback: lineTouchCallback,
  getTouchedSpotIndicator: getTouchedSpotIndicator,
  handleBuiltInTouches: false,
  touchSpotThreshold: 12.001,
  touchTooltipData: lineTouchTooltipData1,
  fullHeightTouchLine: false,
);
final LineTouchData lineTouchData6 = LineTouchData(
  enabled: true,
  touchCallback: lineTouchCallback,
  getTouchedSpotIndicator: getTouchedSpotIndicator,
  handleBuiltInTouches: true,
  touchSpotThreshold: 12,
  touchTooltipData: lineTouchTooltipData1,
  fullHeightTouchLine: false,
);
final LineTouchData lineTouchData7 = LineTouchData(
  enabled: true,
  touchCallback: lineTouchCallback,
  getTouchedSpotIndicator: getTouchedSpotIndicator,
  handleBuiltInTouches: false,
  touchSpotThreshold: 12,
  touchTooltipData: lineTouchTooltipData1,
  fullHeightTouchLine: true,
);

final Function(HorizontalLine) horizontalLabelResolver = (horizontalLine) => 'test';
final Function(VerticalLine) verticalLabelResolver = (horizontalLine) => 'test';

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
  show: false,
  style: const TextStyle(color: Colors.green),
  labelResolver: horizontalLabelResolver,
  alignment: Alignment.topCenter,
  padding: const EdgeInsets.all(12),
);
final HorizontalLineLabel horizontalLineLabel3 = HorizontalLineLabel(
  show: true,
  style: null,
  labelResolver: horizontalLabelResolver,
  alignment: Alignment.topCenter,
  padding: const EdgeInsets.all(12),
);
final HorizontalLineLabel horizontalLineLabel4 = HorizontalLineLabel(
  show: true,
  style: const TextStyle(color: Colors.green),
  labelResolver: null,
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
  show: false,
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
  style: null,
  labelResolver: verticalLabelResolver,
  alignment: Alignment.topCenter,
  padding: const EdgeInsets.all(12),
);
final VerticalLineLabel verticalLineLabel4 = VerticalLineLabel(
  show: true,
  style: const TextStyle(color: Colors.green),
  labelResolver: null,
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
  image: null,
  sizedPicture: SizedPicture(null, 14, 14),
);
final HorizontalLine horizontalLine1Clone = HorizontalLine(
  y: 12,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: horizontalLineLabel1,
  image: null,
  sizedPicture: SizedPicture(null, 14, 14),
);
final HorizontalLine horizontalLine2 = HorizontalLine(
  y: 12,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: horizontalLineLabel1,
  image: null,
  sizedPicture: null,
);
final HorizontalLine horizontalLine3 = HorizontalLine(
  y: 12,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 22,
  label: horizontalLineLabel1,
  image: null,
  sizedPicture: SizedPicture(null, 14, 14),
);
final HorizontalLine horizontalLine4 = HorizontalLine(
  y: 12,
  color: Colors.red,
  dashArray: [1, 0],
  strokeWidth: 21,
  label: horizontalLineLabel1,
  image: null,
  sizedPicture: SizedPicture(null, 14, 14),
);
final HorizontalLine horizontalLine5 = HorizontalLine(
  y: 33,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: horizontalLineLabel1,
  image: null,
  sizedPicture: SizedPicture(null, 14, 14),
);
final HorizontalLine horizontalLine6 = HorizontalLine(
  y: 12,
  color: Colors.green,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: horizontalLineLabel1,
  image: null,
  sizedPicture: SizedPicture(null, 14, 14),
);
final HorizontalLine horizontalLine7 = HorizontalLine(
  y: 12,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: horizontalLineLabel2,
  image: null,
  sizedPicture: SizedPicture(null, 14, 14),
);
final HorizontalLine horizontalLine8 = HorizontalLine(
  y: 12,
  color: Colors.red,
  dashArray: null,
  strokeWidth: 21,
  label: horizontalLineLabel1,
  image: null,
  sizedPicture: SizedPicture(null, 14, 14),
);
final HorizontalLine horizontalLine9 = HorizontalLine(
  y: 12,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: horizontalLineLabel1,
  image: null,
  sizedPicture: SizedPicture(null, 15, 15),
);

final VerticalLine verticalLine1 = VerticalLine(
  x: 12,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: verticalLineLabel1,
  image: null,
  sizedPicture: SizedPicture(null, 14, 14),
);
final VerticalLine verticalLine1Clone = VerticalLine(
  x: 12,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: verticalLineLabel1,
  image: null,
  sizedPicture: SizedPicture(null, 14, 14),
);
final VerticalLine verticalLine2 = VerticalLine(
  x: 12,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: verticalLineLabel1,
  image: null,
  sizedPicture: null,
);
final VerticalLine verticalLine3 = VerticalLine(
  x: 12,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 22,
  label: verticalLineLabel1,
  image: null,
  sizedPicture: SizedPicture(null, 14, 14),
);
final VerticalLine verticalLine4 = VerticalLine(
  x: 12,
  color: Colors.red,
  dashArray: [1, 0],
  strokeWidth: 21,
  label: verticalLineLabel1,
  image: null,
  sizedPicture: SizedPicture(null, 14, 14),
);
final VerticalLine verticalLine5 = VerticalLine(
  x: 33,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: verticalLineLabel1,
  image: null,
  sizedPicture: SizedPicture(null, 14, 14),
);
final VerticalLine verticalLine6 = VerticalLine(
  x: 12,
  color: Colors.green,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: verticalLineLabel1,
  image: null,
  sizedPicture: SizedPicture(null, 14, 14),
);
final VerticalLine verticalLine7 = VerticalLine(
  x: 12,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: verticalLineLabel2,
  image: null,
  sizedPicture: SizedPicture(null, 14, 14),
);
final VerticalLine verticalLine8 = VerticalLine(
  x: 12,
  color: Colors.red,
  dashArray: null,
  strokeWidth: 21,
  label: verticalLineLabel1,
  image: null,
  sizedPicture: SizedPicture(null, 14, 14),
);
final VerticalLine verticalLine9 = VerticalLine(
  x: 12,
  color: Colors.red,
  dashArray: [0, 1],
  strokeWidth: 21,
  label: verticalLineLabel1,
  image: null,
  sizedPicture: SizedPicture(null, 15, 15),
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
  verticalLines: null,
  extraLinesOnTop: false,
);
final ExtraLinesData extraLinesData5 = ExtraLinesData(
  horizontalLines: null,
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
  extraLinesOnTop: true,
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
  null,
  30,
);

final BetweenBarsData betweenBarsData1 = BetweenBarsData(
  fromIndex: 1,
  toIndex: 2,
  gradientTo: const Offset(1, 3),
  gradientFrom: const Offset(4, 1),
  gradientColorStops: [1, 2, 3],
  colors: [Colors.green, Colors.blue, Colors.red],
);
final BetweenBarsData betweenBarsData1Clone = BetweenBarsData(
  fromIndex: 1,
  toIndex: 2,
  gradientTo: const Offset(1, 3),
  gradientFrom: const Offset(4, 1),
  gradientColorStops: [1, 2, 3],
  colors: [Colors.green, Colors.blue, Colors.red],
);
final BetweenBarsData betweenBarsData2 = BetweenBarsData(
  fromIndex: 2,
  toIndex: 2,
  gradientTo: const Offset(1, 3),
  gradientFrom: const Offset(4, 1),
  gradientColorStops: [1, 2, 3],
  colors: [Colors.green, Colors.blue, Colors.red],
);
final BetweenBarsData betweenBarsData3 = BetweenBarsData(
  fromIndex: 1,
  toIndex: 1,
  gradientTo: const Offset(1, 4),
  gradientFrom: const Offset(4, 1),
  gradientColorStops: [1, 2, 3],
  colors: [Colors.green, Colors.blue, Colors.red],
);
final BetweenBarsData betweenBarsData4 = BetweenBarsData(
  fromIndex: 1,
  toIndex: 2,
  gradientTo: const Offset(1, 3),
  gradientFrom: const Offset(5, 1),
  gradientColorStops: [1, 2, 3],
  colors: [Colors.green, Colors.blue, Colors.red],
);
final BetweenBarsData betweenBarsData5 = BetweenBarsData(
  fromIndex: 1,
  toIndex: 2,
  gradientTo: const Offset(1, 3),
  gradientFrom: const Offset(4, 1),
  gradientColorStops: null,
  colors: [Colors.green, Colors.blue, Colors.red],
);
final BetweenBarsData betweenBarsData6 = BetweenBarsData(
  fromIndex: 1,
  toIndex: 2,
  gradientTo: const Offset(1, 3),
  gradientFrom: const Offset(4, 1),
  gradientColorStops: [1, 2, 3],
  colors: [Colors.green, Colors.blue],
);
final BetweenBarsData betweenBarsData7 = BetweenBarsData(
  fromIndex: 1,
  toIndex: 2,
  gradientTo: null,
  gradientFrom: const Offset(4, 1),
  gradientColorStops: [1, 2, 3],
  colors: [Colors.green, Colors.blue, Colors.red],
);
final BetweenBarsData betweenBarsData8 = BetweenBarsData(
  fromIndex: 1,
  toIndex: 2,
  gradientTo: const Offset(1, 3),
  gradientFrom: const Offset(4, 1),
  gradientColorStops: [1, 2, 3],
  colors: [],
);

final ShowingTooltipIndicators showingTooltipIndicator1 = ShowingTooltipIndicators(
  1,
  [lineBarSpot1, lineBarSpot2],
);
final ShowingTooltipIndicators showingTooltipIndicator1Clone = ShowingTooltipIndicators(
  1,
  [lineBarSpot1, lineBarSpot2],
);
final ShowingTooltipIndicators showingTooltipIndicator2 = ShowingTooltipIndicators(
  1,
  null,
);
final ShowingTooltipIndicators showingTooltipIndicator3 = ShowingTooltipIndicators(
  1,
  [],
);
final ShowingTooltipIndicators showingTooltipIndicator4 = ShowingTooltipIndicators(
  1,
  [lineBarSpot2, lineBarSpot1],
);
final ShowingTooltipIndicators showingTooltipIndicator5 = ShowingTooltipIndicators(
  2,
  [lineBarSpot1, lineBarSpot2],
);

final LineChartData lineChartData1 = LineChartData(
  borderData: borderData1,
  lineTouchData: lineTouchData1,
  showingTooltipIndicators: [
    showingTooltipIndicator1,
    showingTooltipIndicator2,
  ],
  axisTitleData: flAxisTitleData1,
  clipData: FlClipData.none(),
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: flTitlesData1,
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
  axisTitleData: flAxisTitleData1Clone,
  clipData: FlClipData.none(),
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1Clone,
  titlesData: flTitlesData1Clone,
  lineBarsData: [lineChartBarData1Clone, lineChartBarData2, lineChartBarData3],
  betweenBarsData: [betweenBarsData1Clone, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData1Clone,
  maxX: 23,
  minX: 11,
  minY: 43,
);
final LineChartData lineChartData2 = LineChartData(
  borderData: null,
  lineTouchData: lineTouchData1,
  showingTooltipIndicators: [
    showingTooltipIndicator1,
    showingTooltipIndicator2,
  ],
  axisTitleData: flAxisTitleData1,
  clipData: FlClipData.none(),
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: flTitlesData1,
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
  axisTitleData: flAxisTitleData1,
  clipData: FlClipData.none(),
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: flTitlesData1,
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
  axisTitleData: flAxisTitleData1,
  clipData: FlClipData.none(),
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: flTitlesData1,
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
  axisTitleData: flAxisTitleData1,
  clipData: FlClipData.none(),
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: flTitlesData1,
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
  showingTooltipIndicators: null,
  axisTitleData: flAxisTitleData1,
  clipData: FlClipData.none(),
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: flTitlesData1,
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
  axisTitleData: flAxisTitleData2,
  clipData: FlClipData.none(),
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: flTitlesData1,
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
  axisTitleData: flAxisTitleData1,
  clipData: FlClipData.all(),
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: flTitlesData1,
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
  axisTitleData: flAxisTitleData1,
  clipData: FlClipData.none(),
  backgroundColor: Colors.red.withOpacity(0.2),
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: flTitlesData1,
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
  axisTitleData: flAxisTitleData1,
  clipData: FlClipData.none(),
  backgroundColor: Colors.red,
  maxY: 24,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: flTitlesData1,
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
  axisTitleData: flAxisTitleData1,
  clipData: FlClipData.none(),
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: null,
  gridData: flGridData1,
  titlesData: flTitlesData1,
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
  axisTitleData: flAxisTitleData1,
  clipData: FlClipData.none(),
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData2,
  titlesData: flTitlesData1,
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
  axisTitleData: flAxisTitleData1,
  clipData: FlClipData.none(),
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: flTitlesData3,
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
  axisTitleData: flAxisTitleData1,
  clipData: FlClipData.none(),
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: flTitlesData1,
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
  axisTitleData: flAxisTitleData1,
  clipData: FlClipData.none(),
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: flTitlesData1,
  lineBarsData: null,
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
  axisTitleData: flAxisTitleData1,
  clipData: FlClipData.none(),
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: flTitlesData1,
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
  axisTitleData: flAxisTitleData1,
  clipData: FlClipData.none(),
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: flTitlesData1,
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
  axisTitleData: flAxisTitleData1,
  clipData: FlClipData.none(),
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: flTitlesData1,
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
  axisTitleData: flAxisTitleData1,
  clipData: FlClipData.none(),
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: flTitlesData1,
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
  axisTitleData: flAxisTitleData1,
  clipData: FlClipData.none(),
  backgroundColor: Colors.red,
  maxY: 23,
  rangeAnnotations: rangeAnnotations1,
  gridData: flGridData1,
  titlesData: flTitlesData1,
  lineBarsData: [lineChartBarData1, lineChartBarData2, lineChartBarData3],
  betweenBarsData: [betweenBarsData1, betweenBarsData2, betweenBarsData3],
  extraLinesData: extraLinesData1,
  maxX: 23,
  minX: 11,
  minY: 302,
);

final PieChartData pieChartData1 = PieChartData(
  borderData: FlBorderData(show: false, border: Border.all(color: Colors.black)),
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

final Function(double) gridCheckToShowLine = (value) => true;
final Function(double) gridGetDrawingLine = (value) => FlLine();

final Function(ScatterSpot touchedSpots) scatterChartGetTooltipItems = (list) {
  return ScatterTooltipItem('check', const TextStyle(color: Colors.blue), 23);
};

final ScatterChartData scatterChartData1 = ScatterChartData(
  minY: 0,
  maxY: 12,
  maxX: 22,
  minX: 11,
  axisTitleData: FlAxisTitleData(
    show: true,
    leftTitle: AxisTitle(
      showTitle: true,
      textStyle: const TextStyle(color: Colors.red, fontSize: 33),
      textAlign: TextAlign.left,
      reservedSize: 22,
      margin: 11,
      titleText: 'title 1',
    ),
    bottomTitle: AxisTitle(
      showTitle: false,
      textStyle: const TextStyle(color: Colors.grey, fontSize: 33),
      textAlign: TextAlign.left,
      reservedSize: 11,
      margin: 11,
      titleText: 'title 2',
    ),
    rightTitle: AxisTitle(
      showTitle: false,
      textStyle: const TextStyle(color: Colors.blue, fontSize: 11),
      textAlign: TextAlign.left,
      reservedSize: 2,
      margin: 1324,
      titleText: 'title 3',
    ),
    topTitle: AxisTitle(
      showTitle: true,
      textStyle: const TextStyle(color: Colors.green, fontSize: 33),
      textAlign: TextAlign.left,
      reservedSize: 23,
      margin: 11,
      titleText: 'title 4',
    ),
  ),
  gridData: FlGridData(
    show: false,
    getDrawingHorizontalLine: gridGetDrawingLine,
    getDrawingVerticalLine: gridGetDrawingLine,
    checkToShowHorizontalLine: gridCheckToShowLine,
    checkToShowVerticalLine: gridCheckToShowLine,
    drawHorizontalLine: true,
    drawVerticalLine: false,
    horizontalInterval: 33,
    verticalInterval: 1,
  ),
  backgroundColor: Colors.black,
  clipData: FlClipData.none(),
  borderData: FlBorderData(
      show: true,
      border: Border.all(
        color: Colors.white,
      )),
  scatterSpots: [
    ScatterSpot(0, 0, show: false, radius: 33, color: Colors.yellow),
    ScatterSpot(2, 2, show: false, radius: 11, color: Colors.purple),
    ScatterSpot(1, 2, show: false, radius: 11, color: Colors.white),
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
    touchCallback: (response) {},
    touchSpotThreshold: 12,
  ),
  showingTooltipIndicators: [0, 1, 2],
  titlesData: FlTitlesData(
    show: true,
    leftTitles: SideTitles(showTitles: false),
    rightTitles: SideTitles(reservedSize: 100, margin: 400, showTitles: true),
    topTitles: SideTitles(showTitles: false),
    bottomTitles: SideTitles(showTitles: false),
  ),
);
final ScatterChartData scatterChartData1Clone = ScatterChartData(
  minY: 0,
  maxY: 12,
  maxX: 22,
  minX: 11,
  axisTitleData: FlAxisTitleData(
    show: true,
    leftTitle: AxisTitle(
      showTitle: true,
      textStyle: const TextStyle(color: Colors.red, fontSize: 33),
      textAlign: TextAlign.left,
      reservedSize: 22,
      margin: 11,
      titleText: 'title 1',
    ),
    bottomTitle: AxisTitle(
      showTitle: false,
      textStyle: const TextStyle(color: Colors.grey, fontSize: 33),
      textAlign: TextAlign.left,
      reservedSize: 11,
      margin: 11,
      titleText: 'title 2',
    ),
    rightTitle: AxisTitle(
      showTitle: false,
      textStyle: const TextStyle(color: Colors.blue, fontSize: 11),
      textAlign: TextAlign.left,
      reservedSize: 2,
      margin: 1324,
      titleText: 'title 3',
    ),
    topTitle: AxisTitle(
      showTitle: true,
      textStyle: const TextStyle(color: Colors.green, fontSize: 33),
      textAlign: TextAlign.left,
      reservedSize: 23,
      margin: 11,
      titleText: 'title 4',
    ),
  ),
  gridData: FlGridData(
    show: false,
    getDrawingHorizontalLine: gridGetDrawingLine,
    getDrawingVerticalLine: gridGetDrawingLine,
    checkToShowHorizontalLine: gridCheckToShowLine,
    checkToShowVerticalLine: gridCheckToShowLine,
    drawHorizontalLine: true,
    drawVerticalLine: false,
    horizontalInterval: 33,
    verticalInterval: 1,
  ),
  backgroundColor: Colors.black,
  clipData: FlClipData.none(),
  borderData: FlBorderData(
      show: true,
      border: Border.all(
        color: Colors.white,
      )),
  scatterSpots: [
    ScatterSpot(0, 0, show: false, radius: 33, color: Colors.yellow),
    ScatterSpot(2, 2, show: false, radius: 11, color: Colors.purple),
    ScatterSpot(1, 2, show: false, radius: 11, color: Colors.white),
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
    touchCallback: (response) {},
    touchSpotThreshold: 12,
  ),
  showingTooltipIndicators: [0, 1, 2],
  titlesData: FlTitlesData(
    show: true,
    leftTitles: SideTitles(showTitles: false),
    rightTitles: SideTitles(reservedSize: 100, margin: 400, showTitles: true),
    topTitles: SideTitles(showTitles: false),
    bottomTitles: SideTitles(showTitles: false),
  ),
);

final BarChartRodStackItem barChartRodStackItem1 = BarChartRodStackItem(
  1,
  2,
  Colors.green,
);
final BarChartRodStackItem barChartRodStackItem1Clone = barChartRodStackItem1.copyWith();

final BarChartRodStackItem barChartRodStackItem2 = BarChartRodStackItem(
  2,
  3,
  Colors.green,
);

final BackgroundBarChartRodData backgroundBarChartRodData1 = BackgroundBarChartRodData(
  y: 21,
  colors: [Colors.blue],
  show: true,
);
final BackgroundBarChartRodData backgroundBarChartRodData1Clone = BackgroundBarChartRodData(
  y: 21,
  colors: [Colors.blue],
  show: true,
);
final BackgroundBarChartRodData backgroundBarChartRodData2 = BackgroundBarChartRodData(
  y: 44,
  colors: [Colors.red],
  show: true,
);
final BackgroundBarChartRodData backgroundBarChartRodData3 = BackgroundBarChartRodData(
  y: 44,
  colors: [Colors.green],
  show: true,
);

final BarChartRodData barChartRodData1 = BarChartRodData(
  colors: [Colors.red],
  y: 12,
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
  colors: [Colors.red],
  y: 1132,
  width: 32,
  borderRadius: const BorderRadius.all(Radius.circular(12)),
  rodStackItems: [
    barChartRodStackItem1,
    barChartRodStackItem2,
  ],
  backDrawRodData: backgroundBarChartRodData1,
);
final BarChartRodData barChartRodData3 = BarChartRodData(
  colors: [Colors.green],
  y: 12,
  width: 32,
  borderRadius: const BorderRadius.all(Radius.circular(12)),
  rodStackItems: [
    barChartRodStackItem2,
  ],
  backDrawRodData: backgroundBarChartRodData1,
);
final BarChartRodData barChartRodData4 = BarChartRodData(
  colors: [Colors.red],
  y: 12,
  width: 32,
  borderRadius: const BorderRadius.all(Radius.circular(12)),
  rodStackItems: [
    barChartRodStackItem2,
    barChartRodStackItem1,
  ],
  backDrawRodData: backgroundBarChartRodData1,
);
final BarChartRodData barChartRodData5 = BarChartRodData(
  colors: [Colors.red],
  y: 12,
  width: 55,
  borderRadius: const BorderRadius.all(Radius.circular(12)),
  rodStackItems: [
    barChartRodStackItem1,
    barChartRodStackItem2,
  ],
  backDrawRodData: backgroundBarChartRodData1,
);
final BarChartRodData barChartRodData6 = BarChartRodData(
  colors: [Colors.red],
  y: 12,
  width: 32,
  borderRadius: const BorderRadius.all(Radius.circular(12)),
  rodStackItems: null,
  backDrawRodData: backgroundBarChartRodData1,
);
final BarChartRodData barChartRodData7 = BarChartRodData(
  colors: [Colors.red],
  y: 12,
  width: 32,
  borderRadius: const BorderRadius.all(Radius.circular(12)),
  rodStackItems: [
    barChartRodStackItem1,
    barChartRodStackItem2,
  ],
  backDrawRodData: backgroundBarChartRodData2,
);
final BarChartRodData barChartRodData8 = BarChartRodData(
  colors: [Colors.red],
  y: 12,
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
  barRods: null,
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
  showingTooltipIndicators: null,
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
  FlPanStart(const Offset(0, 1)),
);
final BarTouchResponse barTouchResponse1Clone = BarTouchResponse(
  barTouchedSpot1Clone,
  FlPanStart(const Offset(0, 1)),
);
final BarTouchResponse barTouchResponse2 = BarTouchResponse(
  barTouchedSpot2,
  FlPanStart(const Offset(0, 1)),
);
final BarTouchResponse barTouchResponse3 = BarTouchResponse(
  barTouchedSpot1,
  FlPanStart(const Offset(0.1, 1)),
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
  null,
  const TextStyle(color: Colors.red),
);
final BarTooltipItem barTooltipItem5 = BarTooltipItem(
  'pashmam 1',
  null,
);

BarTooltipItem getTooltipItem(
  BarChartGroupData group,
  int groupIndex,
  BarChartRodData rod,
  int rodIndex,
) {
  const TextStyle textStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  return BarTooltipItem(rod.y.toString(), textStyle);
}

final BarTouchTooltipData barTouchTooltipData1 = BarTouchTooltipData(
  tooltipRoundedRadius: 12,
  fitInsideVertically: false,
  fitInsideHorizontally: true,
  maxContentWidth: 23,
  tooltipBgColor: Colors.green,
  tooltipPadding: const EdgeInsets.all(23),
  getTooltipItem: getTooltipItem,
  tooltipBottomMargin: 12,
);
final BarTouchTooltipData barTouchTooltipData1Clone = BarTouchTooltipData(
  tooltipRoundedRadius: 12,
  fitInsideVertically: false,
  fitInsideHorizontally: true,
  maxContentWidth: 23,
  tooltipBgColor: Colors.green,
  tooltipPadding: const EdgeInsets.all(23),
  getTooltipItem: getTooltipItem,
  tooltipBottomMargin: 12,
);
final BarTouchTooltipData barTouchTooltipData2 = BarTouchTooltipData(
  tooltipRoundedRadius: 13,
  fitInsideVertically: false,
  fitInsideHorizontally: true,
  maxContentWidth: 23,
  tooltipBgColor: Colors.green,
  tooltipPadding: const EdgeInsets.all(23),
  getTooltipItem: getTooltipItem,
  tooltipBottomMargin: 12,
);
final BarTouchTooltipData barTouchTooltipData3 = BarTouchTooltipData(
  tooltipRoundedRadius: 12,
  fitInsideVertically: true,
  fitInsideHorizontally: true,
  maxContentWidth: 23,
  tooltipBgColor: Colors.green,
  tooltipPadding: const EdgeInsets.all(23),
  getTooltipItem: getTooltipItem,
  tooltipBottomMargin: 12,
);
final BarTouchTooltipData barTouchTooltipData4 = BarTouchTooltipData(
  tooltipRoundedRadius: 12,
  fitInsideVertically: false,
  fitInsideHorizontally: false,
  maxContentWidth: 23,
  tooltipBgColor: Colors.green,
  tooltipPadding: const EdgeInsets.all(23),
  getTooltipItem: getTooltipItem,
  tooltipBottomMargin: 12,
);
final BarTouchTooltipData barTouchTooltipData5 = BarTouchTooltipData(
  tooltipRoundedRadius: 12,
  fitInsideVertically: false,
  fitInsideHorizontally: true,
  maxContentWidth: 23.00001,
  tooltipBgColor: Colors.green,
  tooltipPadding: const EdgeInsets.all(23),
  getTooltipItem: getTooltipItem,
  tooltipBottomMargin: 12,
);
final BarTouchTooltipData barTouchTooltipData6 = BarTouchTooltipData(
  tooltipRoundedRadius: 12,
  fitInsideVertically: false,
  fitInsideHorizontally: true,
  maxContentWidth: 23,
  tooltipBgColor: Colors.blue,
  tooltipPadding: const EdgeInsets.all(23),
  getTooltipItem: getTooltipItem,
  tooltipBottomMargin: 12,
);
final BarTouchTooltipData barTouchTooltipData7 = BarTouchTooltipData(
  tooltipRoundedRadius: 12,
  fitInsideVertically: false,
  fitInsideHorizontally: true,
  maxContentWidth: 23,
  tooltipBgColor: Colors.green,
  tooltipPadding: null,
  getTooltipItem: getTooltipItem,
  tooltipBottomMargin: 12,
);
final BarTouchTooltipData barTouchTooltipData8 = BarTouchTooltipData(
  tooltipRoundedRadius: 12,
  fitInsideVertically: false,
  fitInsideHorizontally: true,
  maxContentWidth: 23,
  tooltipBgColor: Colors.green,
  tooltipPadding: const EdgeInsets.all(23),
  getTooltipItem: null,
  tooltipBottomMargin: 12,
);
final BarTouchTooltipData barTouchTooltipData9 = BarTouchTooltipData(
  tooltipRoundedRadius: 12,
  fitInsideVertically: false,
  fitInsideHorizontally: true,
  maxContentWidth: 23,
  tooltipBgColor: Colors.green,
  tooltipPadding: const EdgeInsets.all(23),
  getTooltipItem: getTooltipItem,
  tooltipBottomMargin: 333,
);

final Function(BarTouchResponse) barTouchCallback = (response) {};

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
  touchTooltipData: null,
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
  touchCallback: null,
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
  touchExtraThreshold: null,
);
final BarTouchData barTouchData9 = BarTouchData(
  touchTooltipData: barTouchTooltipData1,
  handleBuiltInTouches: false,
  touchCallback: barTouchCallback,
  enabled: false,
  allowTouchBarBackDraw: true,
  touchExtraThreshold: const EdgeInsets.only(left: 12),
);

final BarChartData barChartData1 = BarChartData(
  minY: 12,
  titlesData: flTitlesData1,
  gridData: flGridData1,
  rangeAnnotations: rangeAnnotations1,
  maxY: 23,
  backgroundColor: Colors.green,
  axisTitleData: flAxisTitleData1,
  borderData: borderData1,
  alignment: BarChartAlignment.spaceAround,
  barGroups: [
    barChartGroupData1,
    barChartGroupData2,
    barChartGroupData3,
  ],
  barTouchData: barTouchData1,
  groupsSpace: 23,
);
final BarChartData barChartData1Clone = barChartData1.copyWith(
    titlesData: flTitlesData1Clone,
    gridData: flGridData1Clone,
    axisTitleData: flAxisTitleData1Clone,
    borderData: borderData1Clone,
    barTouchData: barTouchData1Clone,
    rangeAnnotations: rangeAnnotations1Clone);

final BarChartData barChartData2 = barChartData1.copyWith(
  minY: 11,
);
final BarChartData barChartData3 = barChartData1.copyWith(
  titlesData: flTitlesData2,
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
  axisTitleData: flAxisTitleData3,
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
