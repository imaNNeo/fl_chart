import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('LineChart data equality check', () {

    FlSpot flSpot1 = FlSpot(1, 1);
    FlSpot flSpot1_clone = flSpot1.copyWith();

    FlSpot flSpot2 = FlSpot(4, 2);
    FlSpot flSpot2_clone = flSpot2.copyWith();

    Function(FlSpot) checkToShowSpotLine = (spot) => true;

    BarAreaSpotsLine barAreaSpotsLine1 = BarAreaSpotsLine(
      show: true,
      checkToShowSpotLine: checkToShowSpotLine
    );
    BarAreaSpotsLine barAreaSpotsLine1_clone = BarAreaSpotsLine(
      show: true,
      checkToShowSpotLine: checkToShowSpotLine
    );

    BarAreaSpotsLine barAreaSpotsLine2 = BarAreaSpotsLine(
      show: true,
      checkToShowSpotLine: null,
    );

    BarAreaData barAreaData1 = BarAreaData(
      colors: [Colors.green, Colors.blue],
      show: true,
      applyCutOffY: false,
      cutOffY: 12,
      gradientColorStops: [0, 0.5],
      gradientFrom: Offset(0,0),
      gradientTo: Offset(1,1),
      spotsLine: barAreaSpotsLine1,
    );
    BarAreaData barAreaData1_clone = BarAreaData(
      colors: [Colors.green, Colors.blue],
      show: true,
      applyCutOffY: false,
      cutOffY: 12,
      gradientColorStops: [0, 0.5],
      gradientFrom: Offset(0,0),
      gradientTo: Offset(1,1),
      spotsLine: barAreaSpotsLine1,
    );

    BarAreaData barAreaData2 = BarAreaData(
      colors: [Colors.green, Colors.blue],
      show: true,
      applyCutOffY: false,
      cutOffY: 12,
      gradientColorStops: [0, 0.5],
      gradientFrom: Offset(0,0),
      gradientTo: Offset(1,1),
      spotsLine: barAreaSpotsLine2,
    );
    BarAreaData barAreaData3 = BarAreaData(
      colors: null,
      show: true,
      applyCutOffY: false,
      cutOffY: 12,
      gradientColorStops: [0, 0.5],
      gradientFrom: Offset(0,0),
      gradientTo: Offset(1,1),
      spotsLine: barAreaSpotsLine2,
    );
    BarAreaData barAreaData4 = BarAreaData(
      colors: [Colors.green, Colors.blue],
      show: true,
      applyCutOffY: false,
      cutOffY: 12,
      gradientColorStops: [0],
      gradientFrom: Offset(0,0),
      gradientTo: Offset(1,1),
      spotsLine: barAreaSpotsLine2,
    );

    Function(FlSpot, double, LineChartBarData) getDotColor = (spot, percent, bar) => Colors.green;
    Function(FlSpot spot) checkToShowDot = (spot) => true;

    FlDotData flDotData1 = FlDotData(
      show: true,
      strokeWidth: 12,
      getDotColor: getDotColor,
      dotSize: 44,
      getStrokeColor: getDotColor,
      checkToShowDot: checkToShowDot,
    );
    FlDotData flDotData1_clone = FlDotData(
      show: true,
      strokeWidth: 12,
      getDotColor: getDotColor,
      dotSize: 44,
      getStrokeColor: getDotColor,
      checkToShowDot: checkToShowDot,
    );

    FlDotData flDotData2 = FlDotData(
      show: true,
      strokeWidth: 12,
      getDotColor: null,
      dotSize: 44,
      getStrokeColor: getDotColor,
      checkToShowDot: checkToShowDot,
    );

    FlDotData flDotData3 = FlDotData(
      show: true,
      strokeWidth: 12,
      getDotColor: getDotColor,
      dotSize: 44,
      getStrokeColor: null,
      checkToShowDot: checkToShowDot,
    );

    FlDotData flDotData4 = FlDotData(
      show: true,
      strokeWidth: 12,
      getDotColor: getDotColor,
      dotSize: 44,
      getStrokeColor: getDotColor,
      checkToShowDot: null,
    );

    FlDotData flDotData5 = FlDotData(
      show: true,
      strokeWidth: 14,
      getDotColor: getDotColor,
      dotSize: 44,
      getStrokeColor: getDotColor,
      checkToShowDot: null,
    );

    FlDotData flDotData6 = FlDotData(
      show: true,
      strokeWidth: 14,
      getDotColor: getDotColor,
      dotSize: 44.01,
      getStrokeColor: getDotColor,
      checkToShowDot: null,
    );

    LineChartBarData lineChartBarData1 = LineChartBarData(
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
      gradientFrom: Offset(0, 0),
      gradientTo: Offset(1, 1),
      barWidth: 12,
      curveSmoothness: 12.0,
      dotData: flDotData1,
      isCurved: false,
      isStrokeCapRound: true,
      preventCurveOverShooting: false,
      preventCurveOvershootingThreshold: 1.2,
      showingIndicators: [0, 1],
    );
    LineChartBarData lineChartBarData1_clone = LineChartBarData(
      show: true,
      dashArray: [0, 1],
      colors: [Colors.red, Colors.green],
      colorStops: [0, 1],
      spots: [
        flSpot1_clone,
        flSpot2,
      ],
      aboveBarData: barAreaData1_clone,
      belowBarData: barAreaData2,
      gradientFrom: Offset(0, 0),
      gradientTo: Offset(1, 1),
      barWidth: 12,
      curveSmoothness: 12.0,
      dotData: flDotData1_clone,
      isCurved: false,
      isStrokeCapRound: true,
      preventCurveOverShooting: false,
      preventCurveOvershootingThreshold: 1.2,
      showingIndicators: [0, 1],
    );

    LineChartBarData lineChartBarData2 = LineChartBarData(
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
      gradientFrom: Offset(0, 0),
      gradientTo: Offset(1, 1),
      barWidth: 12,
      curveSmoothness: 12.0,
      dotData: flDotData1,
      isCurved: false,
      isStrokeCapRound: true,
      preventCurveOverShooting: false,
      preventCurveOvershootingThreshold: 1.2,
      showingIndicators: [0, 4],
    );

    LineChartBarData lineChartBarData3 = LineChartBarData(
      show: true,
      dashArray: null,
      colors: [Colors.red, Colors.green],
      colorStops: [0, 1],
      spots: [
        flSpot1,
        flSpot2,
      ],
      aboveBarData: barAreaData1,
      belowBarData: barAreaData2,
      gradientFrom: Offset(0, 0),
      gradientTo: Offset(1, 1),
      barWidth: 12,
      curveSmoothness: 12.0,
      dotData: flDotData1,
      isCurved: false,
      isStrokeCapRound: true,
      preventCurveOverShooting: false,
      preventCurveOvershootingThreshold: 1.2,
      showingIndicators: [0, 1],
    );

    LineChartBarData lineChartBarData4 = LineChartBarData(
      show: true,
      dashArray: [0, 1],
      colors: [Colors.red, Colors.green],
      colorStops: [0, 1],
      spots: [
        flSpot2,
        flSpot1,
      ],
      aboveBarData: barAreaData1,
      belowBarData: barAreaData2,
      gradientFrom: Offset(0, 0),
      gradientTo: Offset(1, 1),
      barWidth: 12,
      curveSmoothness: 12.0,
      dotData: flDotData1,
      isCurved: false,
      isStrokeCapRound: true,
      preventCurveOverShooting: false,
      preventCurveOvershootingThreshold: 1.2,
      showingIndicators: [0, 1],
    );

    LineChartBarData lineChartBarData5 = LineChartBarData(
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
      gradientFrom: Offset(0, 0),
      gradientTo: Offset(1, 1),
      barWidth: 12,
      curveSmoothness: 12.0,
      dotData: flDotData1,
      isCurved: false,
      isStrokeCapRound: true,
      preventCurveOverShooting: false,
      preventCurveOvershootingThreshold: 1.2,
      showingIndicators: [0, 1],
    );

    LineChartBarData lineChartBarData6 = LineChartBarData(
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
      gradientFrom: Offset(0, 0),
      gradientTo: Offset(1, 1),
      barWidth: 12,
      curveSmoothness: 12.0,
      dotData: flDotData2,
      isCurved: false,
      isStrokeCapRound: true,
      preventCurveOverShooting: false,
      preventCurveOvershootingThreshold: 1.2,
      showingIndicators: [0, 1],
    );

    LineChartBarData lineChartBarData7 = LineChartBarData(
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
      gradientFrom: Offset(0, 0),
      gradientTo: Offset(1, 1),
      barWidth: 12,
      curveSmoothness: 12.0,
      dotData: flDotData1,
      isCurved: false,
      isStrokeCapRound: true,
      preventCurveOverShooting: false,
      preventCurveOvershootingThreshold: 1.2,
      showingIndicators: [0, 1],
    );

    LineChartBarData lineChartBarData8 = LineChartBarData(
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
      gradientFrom: Offset(0, 0),
      gradientTo: Offset(1, 1),
      barWidth: 12,
      curveSmoothness: 12.01,
      dotData: flDotData1,
      isCurved: false,
      isStrokeCapRound: true,
      preventCurveOverShooting: false,
      preventCurveOvershootingThreshold: 1.2,
      showingIndicators: [0, 1],
    );

    LineChartBarData lineChartBarData9 = LineChartBarData(
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
      gradientFrom: Offset(0, 0),
      gradientTo: Offset(1, 1),
      barWidth: 12,
      curveSmoothness: 12.0,
      dotData: flDotData1,
      isCurved: false,
      isStrokeCapRound: true,
      preventCurveOverShooting: true,
      preventCurveOvershootingThreshold: 1.2,
      showingIndicators: [0, 1],
    );

    LineBarSpot lineBarSpot1 = LineBarSpot(
      lineChartBarData1,
      0,
      flSpot1,
    );
    LineBarSpot lineBarSpot1_clone = LineBarSpot(
      lineChartBarData1_clone,
      0,
      flSpot1_clone,
    );

    LineBarSpot lineBarSpot2 = LineBarSpot(
      lineChartBarData1,
      2,
      flSpot1,
    );

    LineBarSpot lineBarSpot3 = LineBarSpot(
      lineChartBarData1,
      100,
      flSpot1,
    );

    LineTouchResponse lineTouchResponse1 = LineTouchResponse(
      [
        lineBarSpot1,
        lineBarSpot2,
      ],
      FlPanStart(Offset.zero),
    );
    LineTouchResponse lineTouchResponse1_clone = LineTouchResponse(
      [
        lineBarSpot1_clone,
        lineBarSpot2,
      ],
      FlPanStart(Offset.zero),
    );

    LineTouchResponse lineTouchResponse2 = LineTouchResponse(
      [
        lineBarSpot2,
        lineBarSpot1,
      ],
      FlPanStart(Offset.zero),
    );

    LineTouchResponse lineTouchResponse3 = LineTouchResponse(
      null,
      FlPanStart(Offset.zero),
    );

    LineTouchResponse lineTouchResponse4 = LineTouchResponse(
      [
        lineBarSpot1,
        lineBarSpot2,
      ],
      null,
    );

    LineTouchResponse lineTouchResponse5 = LineTouchResponse(
      [
        lineBarSpot1,
        lineBarSpot2,
      ],
      FlPanStart(Offset(0, 100)),
    );

    TouchedSpotIndicatorData touchedSpotIndicatorData1 = TouchedSpotIndicatorData(
      FlLine(color: Colors.red, dashArray: [],),
      FlDotData(dotSize: 12, checkToShowDot: checkToShowDot, show: true),
    );
    TouchedSpotIndicatorData touchedSpotIndicatorData1_clone = TouchedSpotIndicatorData(
      FlLine(color: Colors.red, dashArray: [],),
      FlDotData(dotSize: 12, checkToShowDot: checkToShowDot, show: true),
    );

    TouchedSpotIndicatorData touchedSpotIndicatorData2 = TouchedSpotIndicatorData(
      FlLine(color: Colors.red, dashArray: [],),
      FlDotData(dotSize: 12, checkToShowDot: null, show: true),
    );
    TouchedSpotIndicatorData touchedSpotIndicatorData3 = TouchedSpotIndicatorData(
      FlLine(color: Colors.red, dashArray: null,),
      FlDotData(dotSize: 12, checkToShowDot: checkToShowDot, show: true),
    );
    TouchedSpotIndicatorData touchedSpotIndicatorData4 = TouchedSpotIndicatorData(
      FlLine(color: Colors.green, dashArray: [],),
      FlDotData(dotSize: 12, checkToShowDot: checkToShowDot, show: true),
    );
    TouchedSpotIndicatorData touchedSpotIndicatorData5 = TouchedSpotIndicatorData(
      FlLine(color: Colors.red, dashArray: [],),
      FlDotData(dotSize: 12, checkToShowDot: checkToShowDot, show: false),
    );
    TouchedSpotIndicatorData touchedSpotIndicatorData6 = TouchedSpotIndicatorData(
      FlLine(color: Colors.red, dashArray: [],),
      FlDotData(dotSize: 12.01, checkToShowDot: checkToShowDot, show: true),
    );

    LineTooltipItem lineTooltipItem1 = LineTooltipItem('', TextStyle(color: Colors.green));
    LineTooltipItem lineTooltipItem1_clone = LineTooltipItem('', TextStyle(color: Colors.green));

    LineTooltipItem lineTooltipItem2 = LineTooltipItem('ss', TextStyle(color: Colors.green));
    LineTooltipItem lineTooltipItem3 = LineTooltipItem('', TextStyle(color: Colors.blue));
    LineTooltipItem lineTooltipItem4 = LineTooltipItem('', null);

    Function(List<LineBarSpot> touchedSpots) getTooltipItems = (list) {
      return list.map((s) => lineTooltipItem1).toList();
    };

    LineTouchTooltipData lineTouchTooltipData1 = LineTouchTooltipData(
      tooltipPadding: EdgeInsets.all(0.1),
      tooltipBgColor: Colors.green,
      maxContentWidth: 12,
      getTooltipItems:getTooltipItems,
      fitInsideHorizontally: true,
      fitInsideVertically: false,
      tooltipRoundedRadius: 12,
      tooltipBottomMargin: 33,
    );
    LineTouchTooltipData lineTouchTooltipData1_clone = LineTouchTooltipData(
      tooltipPadding: EdgeInsets.all(0.1),
      tooltipBgColor: Colors.green,
      maxContentWidth: 12,
      getTooltipItems:getTooltipItems,
      fitInsideHorizontally: true,
      fitInsideVertically: false,
      tooltipRoundedRadius: 12,
      tooltipBottomMargin: 33,
    );

    LineTouchTooltipData lineTouchTooltipData2 = LineTouchTooltipData(
      tooltipPadding: EdgeInsets.all(0.1),
      tooltipBgColor: Colors.red,
      maxContentWidth: 12,
      getTooltipItems:getTooltipItems,
      fitInsideHorizontally: true,
      fitInsideVertically: false,
      tooltipRoundedRadius: 12,
      tooltipBottomMargin: 33,
    );
    LineTouchTooltipData lineTouchTooltipData3 = LineTouchTooltipData(
      tooltipPadding: EdgeInsets.all(0.2),
      tooltipBgColor: Colors.green,
      maxContentWidth: 12,
      getTooltipItems:getTooltipItems,
      fitInsideHorizontally: true,
      fitInsideVertically: false,
      tooltipRoundedRadius: 12,
      tooltipBottomMargin: 33,
    );
    LineTouchTooltipData lineTouchTooltipData4 = LineTouchTooltipData(
      tooltipPadding: EdgeInsets.all(0.1),
      tooltipBgColor: Colors.green,
      maxContentWidth: 13,
      getTooltipItems:getTooltipItems,
      fitInsideHorizontally: true,
      fitInsideVertically: false,
      tooltipRoundedRadius: 12,
      tooltipBottomMargin: 33,
    );
    LineTouchTooltipData lineTouchTooltipData5 = LineTouchTooltipData(
      tooltipPadding: EdgeInsets.all(0.1),
      tooltipBgColor: Colors.green,
      maxContentWidth: 12,
      getTooltipItems:getTooltipItems,
      fitInsideHorizontally: true,
      fitInsideVertically: false,
      tooltipRoundedRadius: 12,
      tooltipBottomMargin: 34,
    );

    Function(LineTouchResponse) touchCallback = (response) {};

    Function(LineChartBarData barData, List<int> spotIndexes) getTouchedSpotIndicator =
      (barData, indexes) => indexes.map((i) => touchedSpotIndicatorData1).toList();

    LineTouchData lineTouchData1 = LineTouchData(
      enabled: true,
      touchCallback: touchCallback,
      getTouchedSpotIndicator: getTouchedSpotIndicator,
      handleBuiltInTouches: false,
      touchSpotThreshold: 12,
      touchTooltipData: lineTouchTooltipData1,
      fullHeightTouchLine: false,
    );
    LineTouchData lineTouchData1_clone = LineTouchData(
      enabled: true,
      touchCallback: touchCallback,
      getTouchedSpotIndicator: getTouchedSpotIndicator,
      handleBuiltInTouches: false,
      touchSpotThreshold: 12,
      touchTooltipData: lineTouchTooltipData1,
      fullHeightTouchLine: false,
    );

    LineTouchData lineTouchData2 = LineTouchData(
      enabled: true,
      touchCallback: null,
      getTouchedSpotIndicator: getTouchedSpotIndicator,
      handleBuiltInTouches: false,
      touchSpotThreshold: 12,
      touchTooltipData: lineTouchTooltipData1,
      fullHeightTouchLine: false,
    );
    LineTouchData lineTouchData3 = LineTouchData(
      enabled: true,
      touchCallback: touchCallback,
      getTouchedSpotIndicator: null,
      handleBuiltInTouches: false,
      touchSpotThreshold: 12,
      touchTooltipData: lineTouchTooltipData1,
      fullHeightTouchLine: false,
    );
    LineTouchData lineTouchData4 = LineTouchData(
      enabled: true,
      touchCallback: touchCallback,
      getTouchedSpotIndicator: getTouchedSpotIndicator,
      handleBuiltInTouches: false,
      touchSpotThreshold: 12,
      touchTooltipData: null,
      fullHeightTouchLine: false,
    );
    LineTouchData lineTouchData5 = LineTouchData(
      enabled: true,
      touchCallback: touchCallback,
      getTouchedSpotIndicator: getTouchedSpotIndicator,
      handleBuiltInTouches: false,
      touchSpotThreshold: 12.001,
      touchTooltipData: lineTouchTooltipData1,
      fullHeightTouchLine: false,
    );
    LineTouchData lineTouchData6 = LineTouchData(
      enabled: true,
      touchCallback: touchCallback,
      getTouchedSpotIndicator: getTouchedSpotIndicator,
      handleBuiltInTouches: true,
      touchSpotThreshold: 12,
      touchTooltipData: lineTouchTooltipData1,
      fullHeightTouchLine: false,
    );
    LineTouchData lineTouchData7 = LineTouchData(
      enabled: true,
      touchCallback: touchCallback,
      getTouchedSpotIndicator: getTouchedSpotIndicator,
      handleBuiltInTouches: false,
      touchSpotThreshold: 12,
      touchTooltipData: lineTouchTooltipData1,
      fullHeightTouchLine: true,
    );

    Function(HorizontalLine) horizontalLabelResolver = (horizontalLine) => 'test';
    Function(VerticalLine) verticalLabelResolver = (horizontalLine) => 'test';

    HorizontalLineLabel horizontalLineLabel1 = HorizontalLineLabel(
      show: true,
      style: TextStyle(color: Colors.green),
      labelResolver: horizontalLabelResolver,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(12),
    );
    HorizontalLineLabel horizontalLineLabel1_clone = HorizontalLineLabel(
      show: true,
      style: TextStyle(color: Colors.green),
      labelResolver: horizontalLabelResolver,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(12),
    );
    HorizontalLineLabel horizontalLineLabel2 = HorizontalLineLabel(
      show: false,
      style: TextStyle(color: Colors.green),
      labelResolver: horizontalLabelResolver,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(12),
    );
    HorizontalLineLabel horizontalLineLabel3 = HorizontalLineLabel(
      show: true,
      style: null,
      labelResolver: horizontalLabelResolver,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(12),
    );
    HorizontalLineLabel horizontalLineLabel4 = HorizontalLineLabel(
      show: true,
      style: TextStyle(color: Colors.green),
      labelResolver: null,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(12),
    );
    HorizontalLineLabel horizontalLineLabel5 = HorizontalLineLabel(
      show: true,
      style: TextStyle(color: Colors.green),
      labelResolver: horizontalLabelResolver,
      alignment: Alignment.bottomRight,
      padding: EdgeInsets.all(12),
    );
    HorizontalLineLabel horizontalLineLabel6 = HorizontalLineLabel(
      show: true,
      style: TextStyle(color: Colors.green),
      labelResolver: horizontalLabelResolver,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(44),
    );
    HorizontalLineLabel horizontalLineLabel7 = HorizontalLineLabel(
      show: false,
      style: TextStyle(color: Colors.green),
      labelResolver: horizontalLabelResolver,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(12),
    );

    VerticalLineLabel verticalLineLabel1 = VerticalLineLabel(
      show: true,
      style: TextStyle(color: Colors.green),
      labelResolver: verticalLabelResolver,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(12),
    );
    VerticalLineLabel verticalLineLabel1_clone = VerticalLineLabel(
      show: true,
      style: TextStyle(color: Colors.green),
      labelResolver: verticalLabelResolver,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(12),
    );
    VerticalLineLabel verticalLineLabel2 = VerticalLineLabel(
      show: false,
      style: TextStyle(color: Colors.green),
      labelResolver: verticalLabelResolver,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(12),
    );
    VerticalLineLabel verticalLineLabel3 = VerticalLineLabel(
      show: true,
      style: null,
      labelResolver: verticalLabelResolver,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(12),
    );
    VerticalLineLabel verticalLineLabel4 = VerticalLineLabel(
      show: true,
      style: TextStyle(color: Colors.green),
      labelResolver: null,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(12),
    );
    VerticalLineLabel verticalLineLabel5 = VerticalLineLabel(
      show: true,
      style: TextStyle(color: Colors.green),
      labelResolver: verticalLabelResolver,
      alignment: Alignment.bottomRight,
      padding: EdgeInsets.all(12),
    );
    VerticalLineLabel verticalLineLabel6 = VerticalLineLabel(
      show: true,
      style: TextStyle(color: Colors.green),
      labelResolver: verticalLabelResolver,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(44),
    );
    VerticalLineLabel verticalLineLabel7 = VerticalLineLabel(
      show: false,
      style: TextStyle(color: Colors.green),
      labelResolver: verticalLabelResolver,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(12),
    );

    HorizontalLine horizontalLine1 = HorizontalLine(
      y: 12,
      color: Colors.red,
      dashArray: [0, 1],
      strokeWidth: 21,
      label: horizontalLineLabel1,
      image: null,
      sizedPicture: SizedPicture(null, 14, 14),
    );
    HorizontalLine horizontalLine1_clone = HorizontalLine(
      y: 12,
      color: Colors.red,
      dashArray: [0, 1],
      strokeWidth: 21,
      label: horizontalLineLabel1,
      image: null,
      sizedPicture: SizedPicture(null, 14, 14),
    );
    HorizontalLine horizontalLine2 = HorizontalLine(
      y: 12,
      color: Colors.red,
      dashArray: [0, 1],
      strokeWidth: 21,
      label: horizontalLineLabel1,
      image: null,
      sizedPicture: null,
    );
    HorizontalLine horizontalLine3 = HorizontalLine(
      y: 12,
      color: Colors.red,
      dashArray: [0, 1],
      strokeWidth: 22,
      label: horizontalLineLabel1,
      image: null,
      sizedPicture: SizedPicture(null, 14, 14),
    );
    HorizontalLine horizontalLine4 = HorizontalLine(
      y: 12,
      color: Colors.red,
      dashArray: [1, 0],
      strokeWidth: 21,
      label: horizontalLineLabel1,
      image: null,
      sizedPicture: SizedPicture(null, 14, 14),
    );
    HorizontalLine horizontalLine5 = HorizontalLine(
      y: 33,
      color: Colors.red,
      dashArray: [0, 1],
      strokeWidth: 21,
      label: horizontalLineLabel1,
      image: null,
      sizedPicture: SizedPicture(null, 14, 14),
    );
    HorizontalLine horizontalLine6 = HorizontalLine(
      y: 12,
      color: Colors.green,
      dashArray: [0, 1],
      strokeWidth: 21,
      label: horizontalLineLabel1,
      image: null,
      sizedPicture: SizedPicture(null, 14, 14),
    );
    HorizontalLine horizontalLine7 = HorizontalLine(
      y: 12,
      color: Colors.red,
      dashArray: [0, 1],
      strokeWidth: 21,
      label: horizontalLineLabel2,
      image: null,
      sizedPicture: SizedPicture(null, 14, 14),
    );
    HorizontalLine horizontalLine8 = HorizontalLine(
      y: 12,
      color: Colors.red,
      dashArray: null,
      strokeWidth: 21,
      label: horizontalLineLabel1,
      image: null,
      sizedPicture: SizedPicture(null, 14, 14),
    );
    HorizontalLine horizontalLine9 = HorizontalLine(
      y: 12,
      color: Colors.red,
      dashArray: [0, 1],
      strokeWidth: 21,
      label: horizontalLineLabel1,
      image: null,
      sizedPicture: SizedPicture(null, 15, 15),
    );

    VerticalLine verticalLine1 = VerticalLine(
      x: 12,
      color: Colors.red,
      dashArray: [0, 1],
      strokeWidth: 21,
      label: verticalLineLabel1,
      image: null,
      sizedPicture: SizedPicture(null, 14, 14),
    );
    VerticalLine verticalLine1_clone = VerticalLine(
      x: 12,
      color: Colors.red,
      dashArray: [0, 1],
      strokeWidth: 21,
      label: verticalLineLabel1,
      image: null,
      sizedPicture: SizedPicture(null, 14, 14),
    );
    VerticalLine verticalLine2 = VerticalLine(
      x: 12,
      color: Colors.red,
      dashArray: [0, 1],
      strokeWidth: 21,
      label: verticalLineLabel1,
      image: null,
      sizedPicture: null,
    );
    VerticalLine verticalLine3 = VerticalLine(
      x: 12,
      color: Colors.red,
      dashArray: [0, 1],
      strokeWidth: 22,
      label: verticalLineLabel1,
      image: null,
      sizedPicture: SizedPicture(null, 14, 14),
    );
    VerticalLine verticalLine4 = VerticalLine(
      x: 12,
      color: Colors.red,
      dashArray: [1, 0],
      strokeWidth: 21,
      label: verticalLineLabel1,
      image: null,
      sizedPicture: SizedPicture(null, 14, 14),
    );
    VerticalLine verticalLine5 = VerticalLine(
      x: 33,
      color: Colors.red,
      dashArray: [0, 1],
      strokeWidth: 21,
      label: verticalLineLabel1,
      image: null,
      sizedPicture: SizedPicture(null, 14, 14),
    );
    VerticalLine verticalLine6 = VerticalLine(
      x: 12,
      color: Colors.green,
      dashArray: [0, 1],
      strokeWidth: 21,
      label: verticalLineLabel1,
      image: null,
      sizedPicture: SizedPicture(null, 14, 14),
    );
    VerticalLine verticalLine7 = VerticalLine(
      x: 12,
      color: Colors.red,
      dashArray: [0, 1],
      strokeWidth: 21,
      label: verticalLineLabel2,
      image: null,
      sizedPicture: SizedPicture(null, 14, 14),
    );
    VerticalLine verticalLine8 = VerticalLine(
      x: 12,
      color: Colors.red,
      dashArray: null,
      strokeWidth: 21,
      label: verticalLineLabel1,
      image: null,
      sizedPicture: SizedPicture(null, 14, 14),
    );
    VerticalLine verticalLine9 = VerticalLine(
      x: 12,
      color: Colors.red,
      dashArray: [0, 1],
      strokeWidth: 21,
      label: verticalLineLabel1,
      image: null,
      sizedPicture: SizedPicture(null, 15, 15),
    );

    ExtraLinesData extraLinesData1 = ExtraLinesData(
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
    ExtraLinesData extraLinesData1_clone = ExtraLinesData(
      horizontalLines: [
        horizontalLine1_clone,
        horizontalLine2,
        horizontalLine3,
      ],
      verticalLines: [
        verticalLine1_clone,
        verticalLine2,
        verticalLine3,
      ],
      extraLinesOnTop: false,
    );

    ExtraLinesData extraLinesData2 = ExtraLinesData(
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
    ExtraLinesData extraLinesData3 = ExtraLinesData(
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
    ExtraLinesData extraLinesData4 = ExtraLinesData(
      horizontalLines: [
        horizontalLine1,
        horizontalLine2,
        horizontalLine3,
      ],
      verticalLines: null,
      extraLinesOnTop: false,
    );
    ExtraLinesData extraLinesData5 = ExtraLinesData(
      horizontalLines: null,
      verticalLines: [
        verticalLine1,
        verticalLine2,
        verticalLine3,
      ],
      extraLinesOnTop: false,
    );
    ExtraLinesData extraLinesData6 = ExtraLinesData(
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

    SizedPicture sizedPicture1 = SizedPicture(
      PictureRecorder().endRecording(),
      10,
      30,
    );
    SizedPicture sizedPicture1_clone = SizedPicture(
      PictureRecorder().endRecording(),
      10,
      30,
    );

    SizedPicture sizedPicture2 = SizedPicture(
      PictureRecorder().endRecording(),
      11,
      30,
    );
    SizedPicture sizedPicture3 = SizedPicture(
      PictureRecorder().endRecording(),
      10,
      32,
    );
    SizedPicture sizedPicture4 = SizedPicture(
      PictureRecorder().endRecording(),
      null,
      30,
    );

    BetweenBarsData betweenBarsData1 = BetweenBarsData(
      fromIndex: 1,
      toIndex: 2,
      gradientTo: Offset(1, 3),
      gradientFrom: Offset(4, 1),
      gradientColorStops: [1, 2, 3],
      colors: [Colors.green, Colors.blue, Colors.red],
    );
    BetweenBarsData betweenBarsData1_clone = BetweenBarsData(
      fromIndex: 1,
      toIndex: 2,
      gradientTo: Offset(1, 3),
      gradientFrom: Offset(4, 1),
      gradientColorStops: [1, 2, 3],
      colors: [Colors.green, Colors.blue, Colors.red],
    );
    BetweenBarsData betweenBarsData2 = BetweenBarsData(
      fromIndex: 2,
      toIndex: 2,
      gradientTo: Offset(1, 3),
      gradientFrom: Offset(4, 1),
      gradientColorStops: [1, 2, 3],
      colors: [Colors.green, Colors.blue, Colors.red],
    );
    BetweenBarsData betweenBarsData3 = BetweenBarsData(
      fromIndex: 1,
      toIndex: 1,
      gradientTo: Offset(1, 4),
      gradientFrom: Offset(4, 1),
      gradientColorStops: [1, 2, 3],
      colors: [Colors.green, Colors.blue, Colors.red],
    );
    BetweenBarsData betweenBarsData4 = BetweenBarsData(
      fromIndex: 1,
      toIndex: 2,
      gradientTo: Offset(1, 3),
      gradientFrom: Offset(5, 1),
      gradientColorStops: [1, 2, 3],
      colors: [Colors.green, Colors.blue, Colors.red],
    );
    BetweenBarsData betweenBarsData5 = BetweenBarsData(
      fromIndex: 1,
      toIndex: 2,
      gradientTo: Offset(1, 3),
      gradientFrom: Offset(4, 1),
      gradientColorStops: null,
      colors: [Colors.green, Colors.blue, Colors.red],
    );
    BetweenBarsData betweenBarsData6 = BetweenBarsData(
      fromIndex: 1,
      toIndex: 2,
      gradientTo: Offset(1, 3),
      gradientFrom: Offset(4, 1),
      gradientColorStops: [1, 2, 3],
      colors: [Colors.green, Colors.blue],
    );
    BetweenBarsData betweenBarsData7 = BetweenBarsData(
      fromIndex: 1,
      toIndex: 2,
      gradientTo: null,
      gradientFrom: Offset(4, 1),
      gradientColorStops: [1, 2, 3],
      colors: [Colors.green, Colors.blue, Colors.red],
    );
    BetweenBarsData betweenBarsData8 = BetweenBarsData(
      fromIndex: 1,
      toIndex: 2,
      gradientTo: Offset(1, 3),
      gradientFrom: Offset(4, 1),
      gradientColorStops: [1, 2, 3],
      colors: [],
    );

    FlBorderData flBorderData1 = FlBorderData(
      show: true,
      border: Border.all(color: Colors.green),
    );
    FlBorderData flBorderData1_clone = FlBorderData(
      show: true,
      border: Border.all(color: Colors.green),
    );

    AxisTitle axisTitle1 = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 12,
      margin: 33,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );
    AxisTitle axisTitle1_clone = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 12,
      margin: 33,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );

    AxisTitle axisTitle2 = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 33,
      margin: 33,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );
    AxisTitle axisTitle3 = AxisTitle(
      textStyle: TextStyle(color: Colors.red),
      reservedSize: 12,
      margin: 33,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );
    AxisTitle axisTitle4 = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 12,
      margin: 11,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );

    FlAxisTitleData flAxisTitleData1 = FlAxisTitleData(
      show: true,
      topTitle: axisTitle1,
      rightTitle: axisTitle2,
      leftTitle: axisTitle3,
      bottomTitle: axisTitle4,
    );
    FlAxisTitleData flAxisTitleData1_clone = FlAxisTitleData(
      show: true,
      topTitle: axisTitle1_clone,
      rightTitle: axisTitle2,
      leftTitle: axisTitle3,
      bottomTitle: axisTitle4,
    );
    FlAxisTitleData flAxisTitleData2 = FlAxisTitleData(
      show: true,
      topTitle: null,
      rightTitle: axisTitle2,
      leftTitle: axisTitle3,
      bottomTitle: axisTitle4,
    );

    VerticalRangeAnnotation verticalRangeAnnotation1 = VerticalRangeAnnotation(
      color: Colors.green,
      x2: 12,
      x1: 12.1
    );
    VerticalRangeAnnotation verticalRangeAnnotation2 = VerticalRangeAnnotation(
      color: Colors.green,
      x2: 12,
      x1: 12.1
    );

    HorizontalRangeAnnotation horizontalRangeAnnotation1 = HorizontalRangeAnnotation(
      color: Colors.green,
      y2: 12,
      y1: 12.1
    );
    HorizontalRangeAnnotation horizontalRangeAnnotation2 = HorizontalRangeAnnotation(
      color: Colors.green,
      y2: 12,
      y1: 12.1
    );

    RangeAnnotations rangeAnnotations1 = RangeAnnotations(
      horizontalRangeAnnotations: [
        horizontalRangeAnnotation1,
        horizontalRangeAnnotation2,
      ],
      verticalRangeAnnotations: [
        verticalRangeAnnotation1,
        verticalRangeAnnotation2,
      ]
    );
    RangeAnnotations rangeAnnotations2 = RangeAnnotations(
      horizontalRangeAnnotations: [
        horizontalRangeAnnotation1,
        horizontalRangeAnnotation2,
      ],
      verticalRangeAnnotations: [
        verticalRangeAnnotation1,
        verticalRangeAnnotation2,
      ]
    );

    Function(double) checkToShowLine = (value) => true;
    Function(double) getDrawingLine = (value) => FlLine();

    FlGridData flGridData1 = FlGridData(
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

    FlGridData flGridData1_clone = FlGridData(
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

    FlGridData flGridData2 = FlGridData(
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


    Function(double value) getTitles = (value) => 'sallam';

    SideTitles sideTitles1 = SideTitles(
      margin: 1,
      reservedSize: 10,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: getTitles,
      interval: 12,
      rotateAngle: 11,
    );
    SideTitles sideTitles1_clone = SideTitles(
      margin: 1,
      reservedSize: 10,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: getTitles,
      interval: 12,
      rotateAngle: 11,
    );
    SideTitles sideTitles2 = SideTitles(
      margin: 1,
      reservedSize: 10,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: null,
      interval: 12,
      rotateAngle: 11,
    );
    SideTitles sideTitles3 = SideTitles(
      margin: 4,
      reservedSize: 10,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: getTitles,
      interval: 12,
      rotateAngle: 11,
    );
    SideTitles sideTitles4 = SideTitles(
      margin: 1,
      reservedSize: 11,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: getTitles,
      interval: 12,
      rotateAngle: 11,
    );

    FlTitlesData flTitlesData1 = FlTitlesData(
      show: true,
      bottomTitles: sideTitles1,
      topTitles: sideTitles2,
      rightTitles: sideTitles3,
      leftTitles: sideTitles4,
    );
    FlTitlesData flTitlesData1_clone = FlTitlesData(
      show: true,
      bottomTitles: sideTitles1_clone,
      topTitles: sideTitles2,
      rightTitles: sideTitles3,
      leftTitles: sideTitles4,
    );
    FlTitlesData flTitlesData3 = FlTitlesData(
      show: true,
      bottomTitles: sideTitles1,
      topTitles: null,
      rightTitles: sideTitles3,
      leftTitles: sideTitles4,
    );

    ShowingTooltipIndicators showingTooltipIndicator1 = ShowingTooltipIndicators(
      1, [lineBarSpot1, lineBarSpot2],
    );
    ShowingTooltipIndicators showingTooltipIndicator1_clone = ShowingTooltipIndicators(
      1, [lineBarSpot1, lineBarSpot2],
    );
    ShowingTooltipIndicators showingTooltipIndicator2 = ShowingTooltipIndicators(
      1, null,
    );
    ShowingTooltipIndicators showingTooltipIndicator3 = ShowingTooltipIndicators(
      1, [],
    );
    ShowingTooltipIndicators showingTooltipIndicator4 = ShowingTooltipIndicators(
      1, [lineBarSpot2, lineBarSpot1],
    );
    ShowingTooltipIndicators showingTooltipIndicator5 = ShowingTooltipIndicators(
      2, [lineBarSpot1, lineBarSpot2],
    );

    LineChartData lineChartData1 = LineChartData(
      borderData: flBorderData1,
      lineTouchData: lineTouchData1,
      showingTooltipIndicators: [
        showingTooltipIndicator1,
        showingTooltipIndicator2,
      ],
      axisTitleData: flAxisTitleData1,
      clipToBorder: false,
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
    LineChartData lineChartData1_clone = LineChartData(
      borderData: flBorderData1_clone,
      lineTouchData: lineTouchData1_clone,
      showingTooltipIndicators: [
        showingTooltipIndicator1_clone,
        showingTooltipIndicator2,
      ],
      axisTitleData: flAxisTitleData1_clone,
      clipToBorder: false,
      backgroundColor: Colors.red,
      maxY: 23,
      rangeAnnotations: rangeAnnotations1,
      gridData: flGridData1_clone,
      titlesData: flTitlesData1_clone,
      lineBarsData: [lineChartBarData1_clone, lineChartBarData2, lineChartBarData3],
      betweenBarsData: [betweenBarsData1_clone, betweenBarsData2, betweenBarsData3],
      extraLinesData: extraLinesData1_clone,
      maxX: 23,
      minX: 11,
      minY: 43,
    );
    LineChartData lineChartData2 = LineChartData(
      borderData: null,
      lineTouchData: lineTouchData1,
      showingTooltipIndicators: [
        showingTooltipIndicator1,
        showingTooltipIndicator2,
      ],
      axisTitleData: flAxisTitleData1,
      clipToBorder: false,
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
    LineChartData lineChartData3 = LineChartData(
      borderData: flBorderData1,
      lineTouchData: lineTouchData2,
      showingTooltipIndicators: [
        showingTooltipIndicator1,
        showingTooltipIndicator2,
      ],
      axisTitleData: flAxisTitleData1,
      clipToBorder: false,
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
    LineChartData lineChartData4 = LineChartData(
      borderData: flBorderData1,
      lineTouchData: lineTouchData1,
      showingTooltipIndicators: [],
      axisTitleData: flAxisTitleData1,
      clipToBorder: false,
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
    LineChartData lineChartData5 = LineChartData(
      borderData: flBorderData1,
      lineTouchData: lineTouchData1,
      showingTooltipIndicators: [
        showingTooltipIndicator2,
        showingTooltipIndicator1,
      ],
      axisTitleData: flAxisTitleData1,
      clipToBorder: false,
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
    LineChartData lineChartData6 = LineChartData(
      borderData: flBorderData1,
      lineTouchData: lineTouchData1,
      showingTooltipIndicators: null,
      axisTitleData: flAxisTitleData1,
      clipToBorder: false,
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
    LineChartData lineChartData7 = LineChartData(
      borderData: flBorderData1,
      lineTouchData: lineTouchData1,
      showingTooltipIndicators: [
        showingTooltipIndicator1,
        showingTooltipIndicator2,
      ],
      axisTitleData: flAxisTitleData2,
      clipToBorder: false,
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
    LineChartData lineChartData8 = LineChartData(
      borderData: flBorderData1,
      lineTouchData: lineTouchData1,
      showingTooltipIndicators: [
        showingTooltipIndicator1,
        showingTooltipIndicator2,
      ],
      axisTitleData: flAxisTitleData1,
      clipToBorder: true,
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
    LineChartData lineChartData9 = LineChartData(
      borderData: flBorderData1,
      lineTouchData: lineTouchData1,
      showingTooltipIndicators: [
        showingTooltipIndicator1,
        showingTooltipIndicator2,
      ],
      axisTitleData: flAxisTitleData1,
      clipToBorder: false,
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
    LineChartData lineChartData10 = LineChartData(
      borderData: flBorderData1,
      lineTouchData: lineTouchData1,
      showingTooltipIndicators: [
        showingTooltipIndicator1,
        showingTooltipIndicator2,
      ],
      axisTitleData: flAxisTitleData1,
      clipToBorder: false,
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
    LineChartData lineChartData11 = LineChartData(
      borderData: flBorderData1,
      lineTouchData: lineTouchData1,
      showingTooltipIndicators: [
        showingTooltipIndicator1,
        showingTooltipIndicator2,
      ],
      axisTitleData: flAxisTitleData1,
      clipToBorder: false,
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
    LineChartData lineChartData12 = LineChartData(
      borderData: flBorderData1,
      lineTouchData: lineTouchData1,
      showingTooltipIndicators: [
        showingTooltipIndicator1,
        showingTooltipIndicator2,
      ],
      axisTitleData: flAxisTitleData1,
      clipToBorder: false,
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
    LineChartData lineChartData13 = LineChartData(
      borderData: flBorderData1,
      lineTouchData: lineTouchData1,
      showingTooltipIndicators: [
        showingTooltipIndicator1,
        showingTooltipIndicator2,
      ],
      axisTitleData: flAxisTitleData1,
      clipToBorder: false,
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
    LineChartData lineChartData14 = LineChartData(
      borderData: flBorderData1,
      lineTouchData: lineTouchData1,
      showingTooltipIndicators: [
        showingTooltipIndicator1,
        showingTooltipIndicator2,
      ],
      axisTitleData: flAxisTitleData1,
      clipToBorder: false,
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
    LineChartData lineChartData15 = LineChartData(
      borderData: flBorderData1,
      lineTouchData: lineTouchData1,
      showingTooltipIndicators: [
        showingTooltipIndicator1,
        showingTooltipIndicator2,
      ],
      axisTitleData: flAxisTitleData1,
      clipToBorder: false,
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
    LineChartData lineChartData16 = LineChartData(
      borderData: flBorderData1,
      lineTouchData: lineTouchData1,
      showingTooltipIndicators: [
        showingTooltipIndicator1,
        showingTooltipIndicator2,
      ],
      axisTitleData: flAxisTitleData1,
      clipToBorder: false,
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
    LineChartData lineChartData17 = LineChartData(
      borderData: flBorderData1,
      lineTouchData: lineTouchData1,
      showingTooltipIndicators: [
        showingTooltipIndicator1,
        showingTooltipIndicator2,
      ],
      axisTitleData: flAxisTitleData1,
      clipToBorder: false,
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
    LineChartData lineChartData18 = LineChartData(
      borderData: flBorderData1,
      lineTouchData: lineTouchData1,
      showingTooltipIndicators: [
        showingTooltipIndicator1,
        showingTooltipIndicator2,
      ],
      axisTitleData: flAxisTitleData1,
      clipToBorder: false,
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
    LineChartData lineChartData19 = LineChartData(
      borderData: flBorderData1,
      lineTouchData: lineTouchData1,
      showingTooltipIndicators: [
        showingTooltipIndicator1,
        showingTooltipIndicator2,
      ],
      axisTitleData: flAxisTitleData1,
      clipToBorder: false,
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
    LineChartData lineChartData20 = LineChartData(
      borderData: flBorderData1,
      lineTouchData: lineTouchData1,
      showingTooltipIndicators: [
        showingTooltipIndicator1,
        showingTooltipIndicator2,
      ],
      axisTitleData: flAxisTitleData1,
      clipToBorder: false,
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

    test('LineChartBarData equality test', () {
      expect(lineChartBarData1 == lineChartBarData1_clone, true);
      expect(lineChartBarData1 == lineChartBarData2, false);
      expect(lineChartBarData1 == lineChartBarData3, false);
      expect(lineChartBarData1 == lineChartBarData4, false);
      expect(lineChartBarData1 == lineChartBarData5, false);
      expect(lineChartBarData1 == lineChartBarData6, false);
      expect(lineChartBarData1 == lineChartBarData7, false);
      expect(lineChartBarData1 == lineChartBarData8, false);
      expect(lineChartBarData1 == lineChartBarData9, false);
    });

    test('BarAreaData equality test', () {
      expect(barAreaData1 == barAreaData1_clone, true);

      expect(barAreaData1 == barAreaData2, false);

      expect(barAreaData1 == barAreaData3, false);

      expect(barAreaData1 == barAreaData4, false);
    });

    test('BetweenBarsData equality test', () {
      expect(betweenBarsData1 == betweenBarsData1_clone, true);
      expect(betweenBarsData1 == betweenBarsData2, false);
      expect(betweenBarsData1 == betweenBarsData3, false);
      expect(betweenBarsData1 == betweenBarsData4, false);
      expect(betweenBarsData1 == betweenBarsData5, false);
      expect(betweenBarsData1 == betweenBarsData6, false);
      expect(betweenBarsData1 == betweenBarsData7, false);
      expect(betweenBarsData1 == betweenBarsData8, false);
    });

    test('BarAreaSpotsLine equality test', () {

      expect(barAreaSpotsLine1 == barAreaSpotsLine1_clone, true);

      expect(barAreaSpotsLine1 == barAreaSpotsLine2, false);
    });

    test('FlDotData equality test', () {

      expect(flDotData1 == flDotData1_clone, true);

      expect(flDotData1 == flDotData2, false);

      expect(flDotData1 == flDotData2, false);

      expect(flDotData1 == flDotData3, false);

      expect(flDotData1 == flDotData4, false);

      expect(flDotData1 == flDotData5, false);

      expect(flDotData1 == flDotData6, false);

    });

    test('HorizontalLine equality test', () {
      expect(horizontalLine1 == horizontalLine1_clone, true);
      expect(horizontalLine1 == horizontalLine2, false);
      expect(horizontalLine1 == horizontalLine3, false);
      expect(horizontalLine1 == horizontalLine4, false);
      expect(horizontalLine1 == horizontalLine5, false);
      expect(horizontalLine1 == horizontalLine6, false);
      expect(horizontalLine1 == horizontalLine7, false);
      expect(horizontalLine1 == horizontalLine8, false);
      expect(horizontalLine1 == horizontalLine9, false);
    });

    test('VerticalLine equality test', () {
      expect(verticalLine1 == verticalLine1_clone, true);
      expect(verticalLine1 == verticalLine2, false);
      expect(verticalLine1 == verticalLine3, false);
      expect(verticalLine1 == verticalLine4, false);
      expect(verticalLine1 == verticalLine5, false);
      expect(verticalLine1 == verticalLine6, false);
      expect(verticalLine1 == verticalLine7, false);
      expect(verticalLine1 == verticalLine8, false);
      expect(verticalLine1 == verticalLine9, false);
    });

    test('HorizontalLineLabel equality test', () {
      expect(horizontalLineLabel1 == horizontalLineLabel1_clone, true);
      expect(horizontalLineLabel1 == horizontalLineLabel2, false);
      expect(horizontalLineLabel1 == horizontalLineLabel3, false);
      expect(horizontalLineLabel1 == horizontalLineLabel4, false);
      expect(horizontalLineLabel1 == horizontalLineLabel5, false);
      expect(horizontalLineLabel1 == horizontalLineLabel6, false);
      expect(horizontalLineLabel1 == horizontalLineLabel7, false);
    });

    test('VerticalLineLabel equality test', () {
      expect(verticalLineLabel1 == verticalLineLabel1_clone, true);
      expect(verticalLineLabel1 == verticalLineLabel2, false);
      expect(verticalLineLabel1 == verticalLineLabel3, false);
      expect(verticalLineLabel1 == verticalLineLabel4, false);
      expect(verticalLineLabel1 == verticalLineLabel5, false);
      expect(verticalLineLabel1 == verticalLineLabel6, false);
      expect(verticalLineLabel1 == verticalLineLabel7, false);
    });

    test('SizedPicture equality test', () {
      expect(sizedPicture1 == sizedPicture1_clone, true);
      expect(sizedPicture1 == sizedPicture2, false);
      expect(sizedPicture1 == sizedPicture3, false);
      expect(sizedPicture1 == sizedPicture4, false);
    });

    test('ExtraLinesData equality test', () {
      expect(extraLinesData1 == extraLinesData1_clone, true);
      expect(extraLinesData1 == extraLinesData2, false);
      expect(extraLinesData1 == extraLinesData3, false);
      expect(extraLinesData1 == extraLinesData4, false);
      expect(extraLinesData1 == extraLinesData5, false);
      expect(extraLinesData1 == extraLinesData6, false);
    });

    test('LineTouchData equality test', () {
      expect(lineTouchData1 == lineTouchData1_clone, true);
      expect(lineTouchData1 == lineTouchData2, false);
      expect(lineTouchData1 == lineTouchData3, false);
      expect(lineTouchData1 == lineTouchData4, false);
      expect(lineTouchData1 == lineTouchData5, false);
      expect(lineTouchData1 == lineTouchData6, false);
      expect(lineTouchData1 == lineTouchData7, false);
    });

    test('LineTouchTooltipData equality test', () {
      expect(lineTouchTooltipData1 == lineTouchTooltipData1_clone, true);
      expect(lineTouchTooltipData1 == lineTouchTooltipData2, false);
      expect(lineTouchTooltipData1 == lineTouchTooltipData3, false);
      expect(lineTouchTooltipData1 == lineTouchTooltipData4, false);
      expect(lineTouchTooltipData1 == lineTouchTooltipData5, false);
    });

    test('LineBarSpot equality test', () {
      expect(lineBarSpot1 == lineBarSpot1_clone, true);
      expect(lineBarSpot1 == lineBarSpot2, false);
      expect(lineBarSpot1 == lineBarSpot3, false);
    });

    test('LineTooltipItem equality test', () {
      expect(lineTooltipItem1 == lineTooltipItem1_clone, true);
      expect(lineTooltipItem1 == lineTooltipItem2, false);
      expect(lineTooltipItem1 == lineTooltipItem3, false);
      expect(lineTooltipItem1 == lineTooltipItem4, false);
    });

    test('TouchedSpotIndicatorData equality test', () {
      expect(touchedSpotIndicatorData1 == touchedSpotIndicatorData1_clone, true);
      expect(touchedSpotIndicatorData1 == touchedSpotIndicatorData2, false);
      expect(touchedSpotIndicatorData1 == touchedSpotIndicatorData3, false);
      expect(touchedSpotIndicatorData1 == touchedSpotIndicatorData4, false);
      expect(touchedSpotIndicatorData1 == touchedSpotIndicatorData5, false);
      expect(touchedSpotIndicatorData1 == touchedSpotIndicatorData6, false);
    });

    test('ShowingTooltipIndicator equality test', () {
      expect(showingTooltipIndicator1 == showingTooltipIndicator1_clone, true);
      expect(showingTooltipIndicator1 == showingTooltipIndicator2, false);
      expect(showingTooltipIndicator1 == showingTooltipIndicator3, false);
      expect(showingTooltipIndicator1 == showingTooltipIndicator4, false);
      expect(showingTooltipIndicator1 == showingTooltipIndicator5, false);
    });

    test('LineTouchResponse equality test', () {
      expect(lineTouchResponse1 == lineTouchResponse1_clone, true);
      expect(lineTouchResponse1 == lineTouchResponse2, false);
      expect(lineTouchResponse1 == lineTouchResponse3, false);
      expect(lineTouchResponse1 == lineTouchResponse4, false);
      expect(lineTouchResponse1 == lineTouchResponse5, false);
    });

    test('LineChartData equality test', () {
      expect(lineChartData1 == lineChartData1_clone, true);
      expect(lineChartData1 == lineChartData2, false);
      expect(lineChartData1 == lineChartData3, false);
      expect(lineChartData1 == lineChartData4, false);
      expect(lineChartData1 == lineChartData5, false);
      expect(lineChartData1 == lineChartData6, false);
      expect(lineChartData1 == lineChartData7, false);
      expect(lineChartData1 == lineChartData8, false);
      expect(lineChartData1 == lineChartData9, false);
      expect(lineChartData1 == lineChartData10, false);
      expect(lineChartData1 == lineChartData11, false);
      expect(lineChartData1 == lineChartData12, false);
      expect(lineChartData1 == lineChartData13, false);
      expect(lineChartData1 == lineChartData14, false);
      expect(lineChartData1 == lineChartData15, false);
      expect(lineChartData1 == lineChartData16, false);
      expect(lineChartData1 == lineChartData17, false);
      expect(lineChartData1 == lineChartData18, false);
      expect(lineChartData1 == lineChartData19, false);
      expect(lineChartData1 == lineChartData20, false);
    });

  });

}
