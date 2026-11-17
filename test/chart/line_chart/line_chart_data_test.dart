import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../data_pool.dart';

void main() {
  group('LineChart data equality check', () {
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

    test('LineChartBarData late init values test', () {
      final bar = LineChartBarData(
        spots: const [
          FlSpot(1, 1),
          FlSpot(2, 4),
          FlSpot(-3, 8),
          FlSpot(2, -5),
          FlSpot(9, 0),
        ],
      );
      expect(bar.mostLeftSpot, const FlSpot(-3, 8));
      expect(bar.mostTopSpot, const FlSpot(-3, 8));
      expect(bar.mostRightSpot, const FlSpot(9, 0));
      expect(bar.mostBottomSpot, const FlSpot(2, -5));
    });

    test('LineChartBarData borderSide equality test', () {
      final bar1 = LineChartBarData(
        borderSide: const BorderSide(color: Color(0xFF112233), width: 3),
      );
      final bar1Clone = LineChartBarData(
        borderSide: const BorderSide(color: Color(0xFF112233), width: 3),
      );
      final barDefault = LineChartBarData();
      final bar2 = LineChartBarData(
        borderSide: const BorderSide(color: Color(0xFF112233), width: 4),
      );

      expect(bar1 == bar1Clone, true);
      expect(bar1 == barDefault, false);
      expect(bar1 == bar2, false);
    });

    test('LineChartBarData borderSide copyWith test', () {
      final bar = LineChartBarData(
        borderSide: const BorderSide(color: Color(0xFF112233), width: 3),
      );
      final copyWithNewBorder = bar.copyWith(
        borderSide: const BorderSide(color: Color(0xFFAABBCC), width: 5),
      );
      expect(
        copyWithNewBorder.borderSide,
        const BorderSide(color: Color(0xFFAABBCC), width: 5),
      );

      final copyNoChange = bar.copyWith();
      expect(copyNoChange.borderSide, bar.borderSide);
    });

    test('LineChartBarData borderSide lerp test', () {
      final barA = LineChartBarData(
        borderSide: const BorderSide(color: Color(0xFF000000), width: 2),
      );
      final barB = LineChartBarData(
        borderSide: const BorderSide(color: Color(0xFFFFFFFF), width: 6),
      );

      final lerped = LineChartBarData.lerp(barA, barB, 0.5);
      expect(lerped.borderSide.width, 4.0);
      expect(
        lerped.borderSide.color,
        Color.lerp(const Color(0xFF000000), const Color(0xFFFFFFFF), 0.5),
      );
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
      expect(lineTouchData1 == lineTouchData8, false);
    });

    test('LineTouchTooltipData equality test', () {
      expect(lineTouchTooltipData1 == lineTouchTooltipData1Clone, true);
      expect(lineTouchTooltipData1 == lineTouchTooltipData2, false);
      expect(lineTouchTooltipData1 == lineTouchTooltipData3, false);
      expect(lineTouchTooltipData1 == lineTouchTooltipData4, false);
      expect(lineTouchTooltipData1 == lineTouchTooltipData5, false);
      expect(lineTouchTooltipData1 == lineTouchTooltipData6, false);
      expect(lineTouchTooltipData1 == lineTouchTooltipData7, false);
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
      expect(lineTouchResponse1 == lineTouchResponse1Clone, false);
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
      expect(lineChartData1 == lineChartData21, false);
      expect(
        lineChartData21 ==
            lineChartData21.copyWith(
              rotationQuarterTurns: 2,
            ),
        false,
      );
      expect(
        lineChartData21 ==
            lineChartData21.copyWith(
              rotationQuarterTurns: 1,
            ),
        true,
      );
    });
  });
}
