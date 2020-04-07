import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('LineChart data equality check', () {

    final FlSpot flSpot1 = FlSpot(1, 1);
    final FlSpot flSpot1Clone = flSpot1.copyWith();

    final FlSpot flSpot2 = FlSpot(4, 2);

    final Function(FlSpot) checkToShowSpotLine = (spot) => true;

    final BarAreaSpotsLine barAreaSpotsLine1 = BarAreaSpotsLine(
      show: true,
      checkToShowSpotLine: checkToShowSpotLine
    );
    final BarAreaSpotsLine barAreaSpotsLine1Clone = BarAreaSpotsLine(
      show: true,
      checkToShowSpotLine: checkToShowSpotLine
    );

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
      gradientFrom: const Offset(0,0),
      gradientTo: const Offset(1,1),
      spotsLine: barAreaSpotsLine1,
    );
    final BarAreaData barAreaData1Clone = BarAreaData(
      colors: [Colors.green, Colors.blue],
      show: true,
      applyCutOffY: false,
      cutOffY: 12,
      gradientColorStops: [0, 0.5],
      gradientFrom: const Offset(0,0),
      gradientTo: const Offset(1,1),
      spotsLine: barAreaSpotsLine1,
    );

    final BarAreaData barAreaData2 = BarAreaData(
      colors: [Colors.green, Colors.blue],
      show: true,
      applyCutOffY: false,
      cutOffY: 12,
      gradientColorStops: [0, 0.5],
      gradientFrom: const Offset(0,0),
      gradientTo: const Offset(1,1),
      spotsLine: barAreaSpotsLine2,
    );
    final BarAreaData barAreaData3 = BarAreaData(
      colors: null,
      show: true,
      applyCutOffY: false,
      cutOffY: 12,
      gradientColorStops: [0, 0.5],
      gradientFrom: const Offset(0,0),
      gradientTo: const Offset(1,1),
      spotsLine: barAreaSpotsLine2,
    );
    final BarAreaData barAreaData4 = BarAreaData(
      colors: [Colors.green, Colors.blue],
      show: true,
      applyCutOffY: false,
      cutOffY: 12,
      gradientColorStops: [0],
      gradientFrom: const Offset(0,0),
      gradientTo: const Offset(1,1),
      spotsLine: barAreaSpotsLine2,
    );

    final Function(FlSpot, double, LineChartBarData) getDotColor = (spot, percent, bar) => Colors.green;
    final Function(FlSpot spot) checkToShowDot = (spot) => true;

    final FlDotData flDotData1 = FlDotData(
      show: true,
      strokeWidth: 12,
      getDotColor: getDotColor,
      dotSize: 44,
      getStrokeColor: getDotColor,
      checkToShowDot: checkToShowDot,
    );
    final FlDotData flDotData1Clone = FlDotData(
      show: true,
      strokeWidth: 12,
      getDotColor: getDotColor,
      dotSize: 44,
      getStrokeColor: getDotColor,
      checkToShowDot: checkToShowDot,
    );

    final FlDotData flDotData2 = FlDotData(
      show: true,
      strokeWidth: 12,
      getDotColor: null,
      dotSize: 44,
      getStrokeColor: getDotColor,
      checkToShowDot: checkToShowDot,
    );

    final FlDotData flDotData3 = FlDotData(
      show: true,
      strokeWidth: 12,
      getDotColor: getDotColor,
      dotSize: 44,
      getStrokeColor: null,
      checkToShowDot: checkToShowDot,
    );

    final FlDotData flDotData4 = FlDotData(
      show: true,
      strokeWidth: 12,
      getDotColor: getDotColor,
      dotSize: 44,
      getStrokeColor: getDotColor,
      checkToShowDot: null,
    );

    final FlDotData flDotData5 = FlDotData(
      show: true,
      strokeWidth: 14,
      getDotColor: getDotColor,
      dotSize: 44,
      getStrokeColor: getDotColor,
      checkToShowDot: null,
    );

    final FlDotData flDotData6 = FlDotData(
      show: true,
      strokeWidth: 14,
      getDotColor: getDotColor,
      dotSize: 44.01,
      getStrokeColor: getDotColor,
      checkToShowDot: null,
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
      dotData: flDotData2,
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
      FlLine(color: Colors.red, dashArray: [],),
      FlDotData(dotSize: 12, checkToShowDot: checkToShowDot, show: true),
    );
    final TouchedSpotIndicatorData touchedSpotIndicatorData1Clone = TouchedSpotIndicatorData(
      FlLine(color: Colors.red, dashArray: [],),
      FlDotData(dotSize: 12, checkToShowDot: checkToShowDot, show: true),
    );

    final TouchedSpotIndicatorData touchedSpotIndicatorData2 = TouchedSpotIndicatorData(
      FlLine(color: Colors.red, dashArray: [],),
      FlDotData(dotSize: 12, checkToShowDot: null, show: true),
    );
    final TouchedSpotIndicatorData touchedSpotIndicatorData3 = TouchedSpotIndicatorData(
      FlLine(color: Colors.red, dashArray: null,),
      FlDotData(dotSize: 12, checkToShowDot: checkToShowDot, show: true),
    );
    final TouchedSpotIndicatorData touchedSpotIndicatorData4 = TouchedSpotIndicatorData(
      FlLine(color: Colors.green, dashArray: [],),
      FlDotData(dotSize: 12, checkToShowDot: checkToShowDot, show: true),
    );
    final TouchedSpotIndicatorData touchedSpotIndicatorData5 = TouchedSpotIndicatorData(
      FlLine(color: Colors.red, dashArray: [],),
      FlDotData(dotSize: 12, checkToShowDot: checkToShowDot, show: false),
    );
    final TouchedSpotIndicatorData touchedSpotIndicatorData6 = TouchedSpotIndicatorData(
      FlLine(color: Colors.red, dashArray: [],),
      FlDotData(dotSize: 12.01, checkToShowDot: checkToShowDot, show: true),
    );

    final LineTooltipItem lineTooltipItem1 = LineTooltipItem('', TextStyle(color: Colors.green));
    final LineTooltipItem lineTooltipItem1Clone = LineTooltipItem('', TextStyle(color: Colors.green));

    final LineTooltipItem lineTooltipItem2 = LineTooltipItem('ss', TextStyle(color: Colors.green));
    final LineTooltipItem lineTooltipItem3 = LineTooltipItem('', TextStyle(color: Colors.blue));
    final LineTooltipItem lineTooltipItem4 = LineTooltipItem('', null);

    final Function(List<LineBarSpot> touchedSpots) getTooltipItems = (list) {
      return list.map((s) => lineTooltipItem1).toList();
    };

    final LineTouchTooltipData lineTouchTooltipData1 = LineTouchTooltipData(
      tooltipPadding: const EdgeInsets.all(0.1),
      tooltipBgColor: Colors.green,
      maxContentWidth: 12,
      getTooltipItems:getTooltipItems,
      fitInsideHorizontally: true,
      fitInsideVertically: false,
      tooltipRoundedRadius: 12,
      tooltipBottomMargin: 33,
    );
    final LineTouchTooltipData lineTouchTooltipData1Clone = LineTouchTooltipData(
      tooltipPadding: const EdgeInsets.all(0.1),
      tooltipBgColor: Colors.green,
      maxContentWidth: 12,
      getTooltipItems:getTooltipItems,
      fitInsideHorizontally: true,
      fitInsideVertically: false,
      tooltipRoundedRadius: 12,
      tooltipBottomMargin: 33,
    );

    final LineTouchTooltipData lineTouchTooltipData2 = LineTouchTooltipData(
      tooltipPadding: const EdgeInsets.all(0.1),
      tooltipBgColor: Colors.red,
      maxContentWidth: 12,
      getTooltipItems:getTooltipItems,
      fitInsideHorizontally: true,
      fitInsideVertically: false,
      tooltipRoundedRadius: 12,
      tooltipBottomMargin: 33,
    );
    final LineTouchTooltipData lineTouchTooltipData3 = LineTouchTooltipData(
      tooltipPadding: const EdgeInsets.all(0.2),
      tooltipBgColor: Colors.green,
      maxContentWidth: 12,
      getTooltipItems:getTooltipItems,
      fitInsideHorizontally: true,
      fitInsideVertically: false,
      tooltipRoundedRadius: 12,
      tooltipBottomMargin: 33,
    );
    final LineTouchTooltipData lineTouchTooltipData4 = LineTouchTooltipData(
      tooltipPadding: const EdgeInsets.all(0.1),
      tooltipBgColor: Colors.green,
      maxContentWidth: 13,
      getTooltipItems:getTooltipItems,
      fitInsideHorizontally: true,
      fitInsideVertically: false,
      tooltipRoundedRadius: 12,
      tooltipBottomMargin: 33,
    );
    final LineTouchTooltipData lineTouchTooltipData5 = LineTouchTooltipData(
      tooltipPadding: const EdgeInsets.all(0.1),
      tooltipBgColor: Colors.green,
      maxContentWidth: 12,
      getTooltipItems:getTooltipItems,
      fitInsideHorizontally: true,
      fitInsideVertically: false,
      tooltipRoundedRadius: 12,
      tooltipBottomMargin: 34,
    );

    final Function(LineTouchResponse) touchCallback = (response) {};

    final Function(LineChartBarData barData, List<int> spotIndexes) getTouchedSpotIndicator =
      (barData, indexes) => indexes.map((i) => touchedSpotIndicatorData1).toList();

    final LineTouchData lineTouchData1 = LineTouchData(
      enabled: true,
      touchCallback: touchCallback,
      getTouchedSpotIndicator: getTouchedSpotIndicator,
      handleBuiltInTouches: false,
      touchSpotThreshold: 12,
      touchTooltipData: lineTouchTooltipData1,
      fullHeightTouchLine: false,
    );
    final LineTouchData lineTouchData1Clone = LineTouchData(
      enabled: true,
      touchCallback: touchCallback,
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
      touchCallback: touchCallback,
      getTouchedSpotIndicator: null,
      handleBuiltInTouches: false,
      touchSpotThreshold: 12,
      touchTooltipData: lineTouchTooltipData1,
      fullHeightTouchLine: false,
    );
    final LineTouchData lineTouchData4 = LineTouchData(
      enabled: true,
      touchCallback: touchCallback,
      getTouchedSpotIndicator: getTouchedSpotIndicator,
      handleBuiltInTouches: false,
      touchSpotThreshold: 12,
      touchTooltipData: null,
      fullHeightTouchLine: false,
    );
    final LineTouchData lineTouchData5 = LineTouchData(
      enabled: true,
      touchCallback: touchCallback,
      getTouchedSpotIndicator: getTouchedSpotIndicator,
      handleBuiltInTouches: false,
      touchSpotThreshold: 12.001,
      touchTooltipData: lineTouchTooltipData1,
      fullHeightTouchLine: false,
    );
    final LineTouchData lineTouchData6 = LineTouchData(
      enabled: true,
      touchCallback: touchCallback,
      getTouchedSpotIndicator: getTouchedSpotIndicator,
      handleBuiltInTouches: true,
      touchSpotThreshold: 12,
      touchTooltipData: lineTouchTooltipData1,
      fullHeightTouchLine: false,
    );
    final LineTouchData lineTouchData7 = LineTouchData(
      enabled: true,
      touchCallback: touchCallback,
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
      style: TextStyle(color: Colors.green),
      labelResolver: horizontalLabelResolver,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(12),
    );
    final HorizontalLineLabel horizontalLineLabel1Clone = HorizontalLineLabel(
      show: true,
      style: TextStyle(color: Colors.green),
      labelResolver: horizontalLabelResolver,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(12),
    );
    final HorizontalLineLabel horizontalLineLabel2 = HorizontalLineLabel(
      show: false,
      style: TextStyle(color: Colors.green),
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
      style: TextStyle(color: Colors.green),
      labelResolver: null,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(12),
    );
    final HorizontalLineLabel horizontalLineLabel5 = HorizontalLineLabel(
      show: true,
      style: TextStyle(color: Colors.green),
      labelResolver: horizontalLabelResolver,
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.all(12),
    );
    final HorizontalLineLabel horizontalLineLabel6 = HorizontalLineLabel(
      show: true,
      style: TextStyle(color: Colors.green),
      labelResolver: horizontalLabelResolver,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(44),
    );
    final HorizontalLineLabel horizontalLineLabel7 = HorizontalLineLabel(
      show: false,
      style: TextStyle(color: Colors.green),
      labelResolver: horizontalLabelResolver,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(12),
    );

    final VerticalLineLabel verticalLineLabel1 = VerticalLineLabel(
      show: true,
      style: TextStyle(color: Colors.green),
      labelResolver: verticalLabelResolver,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(12),
    );
    final VerticalLineLabel verticalLineLabel1Clone = VerticalLineLabel(
      show: true,
      style: TextStyle(color: Colors.green),
      labelResolver: verticalLabelResolver,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(12),
    );
    final VerticalLineLabel verticalLineLabel2 = VerticalLineLabel(
      show: false,
      style: TextStyle(color: Colors.green),
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
      style: TextStyle(color: Colors.green),
      labelResolver: null,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(12),
    );
    final VerticalLineLabel verticalLineLabel5 = VerticalLineLabel(
      show: true,
      style: TextStyle(color: Colors.green),
      labelResolver: verticalLabelResolver,
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.all(12),
    );
    final VerticalLineLabel verticalLineLabel6 = VerticalLineLabel(
      show: true,
      style: TextStyle(color: Colors.green),
      labelResolver: verticalLabelResolver,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(44),
    );
    final VerticalLineLabel verticalLineLabel7 = VerticalLineLabel(
      show: false,
      style: TextStyle(color: Colors.green),
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

    final FlBorderData flBorderData1 = FlBorderData(
      show: true,
      border: Border.all(color: Colors.green),
    );
    final FlBorderData flBorderData1Clone = FlBorderData(
      show: true,
      border: Border.all(color: Colors.green),
    );

    final AxisTitle axisTitle1 = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 12,
      margin: 33,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );
    final AxisTitle axisTitle1Clone = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 12,
      margin: 33,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );

    final AxisTitle axisTitle2 = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 33,
      margin: 33,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );
    final AxisTitle axisTitle3 = AxisTitle(
      textStyle: TextStyle(color: Colors.red),
      reservedSize: 12,
      margin: 33,
      showTitle: true,
      titleText: 'sallam',
      textAlign: TextAlign.right,
    );
    final AxisTitle axisTitle4 = AxisTitle(
      textStyle: TextStyle(color: Colors.green),
      reservedSize: 12,
      margin: 11,
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

    final VerticalRangeAnnotation verticalRangeAnnotation1 = VerticalRangeAnnotation(
      color: Colors.green,
      x2: 12,
      x1: 12.1
    );
    final VerticalRangeAnnotation verticalRangeAnnotation2 = VerticalRangeAnnotation(
      color: Colors.green,
      x2: 12,
      x1: 12.1
    );

    final HorizontalRangeAnnotation horizontalRangeAnnotation1 = HorizontalRangeAnnotation(
      color: Colors.green,
      y2: 12,
      y1: 12.1
    );
    final HorizontalRangeAnnotation horizontalRangeAnnotation2 = HorizontalRangeAnnotation(
      color: Colors.green,
      y2: 12,
      y1: 12.1
    );

    final RangeAnnotations rangeAnnotations1 = RangeAnnotations(
      horizontalRangeAnnotations: [
        horizontalRangeAnnotation1,
        horizontalRangeAnnotation2,
      ],
      verticalRangeAnnotations: [
        verticalRangeAnnotation1,
        verticalRangeAnnotation2,
      ]
    );
    final Function(double) checkToShowLine = (value) => true;
    final Function(double) getDrawingLine = (value) => FlLine();

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
      horizontalInterval: 43,
      drawVerticalLine: false,
      drawHorizontalLine: true,
      checkToShowVerticalLine: checkToShowLine,
      checkToShowHorizontalLine: null,
      getDrawingHorizontalLine: getDrawingLine,
      getDrawingVerticalLine: null,
    );


    final Function(double value) getTitles = (value) => 'sallam';

    final SideTitles sideTitles1 = SideTitles(
      margin: 1,
      reservedSize: 10,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: getTitles,
      interval: 12,
      rotateAngle: 11,
    );
    final SideTitles sideTitles1Clone = SideTitles(
      margin: 1,
      reservedSize: 10,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: getTitles,
      interval: 12,
      rotateAngle: 11,
    );
    final SideTitles sideTitles2 = SideTitles(
      margin: 1,
      reservedSize: 10,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: null,
      interval: 12,
      rotateAngle: 11,
    );
    final SideTitles sideTitles3 = SideTitles(
      margin: 4,
      reservedSize: 10,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: getTitles,
      interval: 12,
      rotateAngle: 11,
    );
    final SideTitles sideTitles4 = SideTitles(
      margin: 1,
      reservedSize: 11,
      textStyle: TextStyle(color: Colors.green),
      showTitles: false,
      getTitles: getTitles,
      interval: 12,
      rotateAngle: 11,
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
    final FlTitlesData flTitlesData3 = FlTitlesData(
      show: true,
      bottomTitles: sideTitles1,
      topTitles: null,
      rightTitles: sideTitles3,
      leftTitles: sideTitles4,
    );

    final ShowingTooltipIndicators showingTooltipIndicator1 = ShowingTooltipIndicators(
      1, [lineBarSpot1, lineBarSpot2],
    );
    final ShowingTooltipIndicators showingTooltipIndicator1Clone = ShowingTooltipIndicators(
      1, [lineBarSpot1, lineBarSpot2],
    );
    final ShowingTooltipIndicators showingTooltipIndicator2 = ShowingTooltipIndicators(
      1, null,
    );
    final ShowingTooltipIndicators showingTooltipIndicator3 = ShowingTooltipIndicators(
      1, [],
    );
    final ShowingTooltipIndicators showingTooltipIndicator4 = ShowingTooltipIndicators(
      1, [lineBarSpot2, lineBarSpot1],
    );
    final ShowingTooltipIndicators showingTooltipIndicator5 = ShowingTooltipIndicators(
      2, [lineBarSpot1, lineBarSpot2],
    );

    final LineChartData lineChartData1 = LineChartData(
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
    final LineChartData lineChartData1Clone = LineChartData(
      borderData: flBorderData1Clone,
      lineTouchData: lineTouchData1Clone,
      showingTooltipIndicators: [
        showingTooltipIndicator1Clone,
        showingTooltipIndicator2,
      ],
      axisTitleData: flAxisTitleData1Clone,
      clipToBorder: false,
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
    final LineChartData lineChartData3 = LineChartData(
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
    final LineChartData lineChartData4 = LineChartData(
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
    final LineChartData lineChartData5 = LineChartData(
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
    final LineChartData lineChartData6 = LineChartData(
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
    final LineChartData lineChartData7 = LineChartData(
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
    final LineChartData lineChartData8 = LineChartData(
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
    final LineChartData lineChartData9 = LineChartData(
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
    final LineChartData lineChartData10 = LineChartData(
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
    final LineChartData lineChartData11 = LineChartData(
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
    final LineChartData lineChartData12 = LineChartData(
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
    final LineChartData lineChartData13 = LineChartData(
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
    final LineChartData lineChartData14 = LineChartData(
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
    final LineChartData lineChartData15 = LineChartData(
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
    final LineChartData lineChartData16 = LineChartData(
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
    final LineChartData lineChartData17 = LineChartData(
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
    final LineChartData lineChartData18 = LineChartData(
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
    final LineChartData lineChartData19 = LineChartData(
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
    final LineChartData lineChartData20 = LineChartData(
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
      expect(lineChartBarData1 == lineChartBarData1Clone, true);
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
      expect(barAreaData1 == barAreaData1Clone, true);

      expect(barAreaData1 == barAreaData2, false);

      expect(barAreaData1 == barAreaData3, false);

      expect(barAreaData1 == barAreaData4, false);
    });

    test('BetweenBarsData equality test', () {
      expect(betweenBarsData1 == betweenBarsData1Clone, true);
      expect(betweenBarsData1 == betweenBarsData2, false);
      expect(betweenBarsData1 == betweenBarsData3, false);
      expect(betweenBarsData1 == betweenBarsData4, false);
      expect(betweenBarsData1 == betweenBarsData5, false);
      expect(betweenBarsData1 == betweenBarsData6, false);
      expect(betweenBarsData1 == betweenBarsData7, false);
      expect(betweenBarsData1 == betweenBarsData8, false);
    });

    test('BarAreaSpotsLine equality test', () {

      expect(barAreaSpotsLine1 == barAreaSpotsLine1Clone, true);

      expect(barAreaSpotsLine1 == barAreaSpotsLine2, false);
    });

    test('FlDotData equality test', () {

      expect(flDotData1 == flDotData1Clone, true);

      expect(flDotData1 == flDotData2, false);

      expect(flDotData1 == flDotData2, false);

      expect(flDotData1 == flDotData3, false);

      expect(flDotData1 == flDotData4, false);

      expect(flDotData1 == flDotData5, false);

      expect(flDotData1 == flDotData6, false);

    });

    test('HorizontalLine equality test', () {
      expect(horizontalLine1 == horizontalLine1Clone, true);
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
      expect(verticalLine1 == verticalLine1Clone, true);
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
      expect(horizontalLineLabel1 == horizontalLineLabel1Clone, true);
      expect(horizontalLineLabel1 == horizontalLineLabel2, false);
      expect(horizontalLineLabel1 == horizontalLineLabel3, false);
      expect(horizontalLineLabel1 == horizontalLineLabel4, false);
      expect(horizontalLineLabel1 == horizontalLineLabel5, false);
      expect(horizontalLineLabel1 == horizontalLineLabel6, false);
      expect(horizontalLineLabel1 == horizontalLineLabel7, false);
    });

    test('VerticalLineLabel equality test', () {
      expect(verticalLineLabel1 == verticalLineLabel1Clone, true);
      expect(verticalLineLabel1 == verticalLineLabel2, false);
      expect(verticalLineLabel1 == verticalLineLabel3, false);
      expect(verticalLineLabel1 == verticalLineLabel4, false);
      expect(verticalLineLabel1 == verticalLineLabel5, false);
      expect(verticalLineLabel1 == verticalLineLabel6, false);
      expect(verticalLineLabel1 == verticalLineLabel7, false);
    });

    test('SizedPicture equality test', () {
      expect(sizedPicture1 == sizedPicture1Clone, true);
      expect(sizedPicture1 == sizedPicture2, false);
      expect(sizedPicture1 == sizedPicture3, false);
      expect(sizedPicture1 == sizedPicture4, false);
    });

    test('ExtraLinesData equality test', () {
      expect(extraLinesData1 == extraLinesData1Clone, true);
      expect(extraLinesData1 == extraLinesData2, false);
      expect(extraLinesData1 == extraLinesData3, false);
      expect(extraLinesData1 == extraLinesData4, false);
      expect(extraLinesData1 == extraLinesData5, false);
      expect(extraLinesData1 == extraLinesData6, false);
    });

    test('LineTouchData equality test', () {
      expect(lineTouchData1 == lineTouchData1Clone, true);
      expect(lineTouchData1 == lineTouchData2, false);
      expect(lineTouchData1 == lineTouchData3, false);
      expect(lineTouchData1 == lineTouchData4, false);
      expect(lineTouchData1 == lineTouchData5, false);
      expect(lineTouchData1 == lineTouchData6, false);
      expect(lineTouchData1 == lineTouchData7, false);
    });

    test('LineTouchTooltipData equality test', () {
      expect(lineTouchTooltipData1 == lineTouchTooltipData1Clone, true);
      expect(lineTouchTooltipData1 == lineTouchTooltipData2, false);
      expect(lineTouchTooltipData1 == lineTouchTooltipData3, false);
      expect(lineTouchTooltipData1 == lineTouchTooltipData4, false);
      expect(lineTouchTooltipData1 == lineTouchTooltipData5, false);
    });

    test('LineBarSpot equality test', () {
      expect(lineBarSpot1 == lineBarSpot1Clone, true);
      expect(lineBarSpot1 == lineBarSpot2, false);
      expect(lineBarSpot1 == lineBarSpot3, false);
    });

    test('LineTooltipItem equality test', () {
      expect(lineTooltipItem1 == lineTooltipItem1Clone, true);
      expect(lineTooltipItem1 == lineTooltipItem2, false);
      expect(lineTooltipItem1 == lineTooltipItem3, false);
      expect(lineTooltipItem1 == lineTooltipItem4, false);
    });

    test('TouchedSpotIndicatorData equality test', () {
      expect(touchedSpotIndicatorData1 == touchedSpotIndicatorData1Clone, true);
      expect(touchedSpotIndicatorData1 == touchedSpotIndicatorData2, false);
      expect(touchedSpotIndicatorData1 == touchedSpotIndicatorData3, false);
      expect(touchedSpotIndicatorData1 == touchedSpotIndicatorData4, false);
      expect(touchedSpotIndicatorData1 == touchedSpotIndicatorData5, false);
      expect(touchedSpotIndicatorData1 == touchedSpotIndicatorData6, false);
    });

    test('ShowingTooltipIndicator equality test', () {
      expect(showingTooltipIndicator1 == showingTooltipIndicator1Clone, true);
      expect(showingTooltipIndicator1 == showingTooltipIndicator2, false);
      expect(showingTooltipIndicator1 == showingTooltipIndicator3, false);
      expect(showingTooltipIndicator1 == showingTooltipIndicator4, false);
      expect(showingTooltipIndicator1 == showingTooltipIndicator5, false);
    });

    test('LineTouchResponse equality test', () {
      expect(lineTouchResponse1 == lineTouchResponse1Clone, true);
      expect(lineTouchResponse1 == lineTouchResponse2, false);
      expect(lineTouchResponse1 == lineTouchResponse3, false);
      expect(lineTouchResponse1 == lineTouchResponse4, false);
      expect(lineTouchResponse1 == lineTouchResponse5, false);
    });

    test('LineChartData equality test', () {
      expect(lineChartData1 == lineChartData1Clone, true);
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
