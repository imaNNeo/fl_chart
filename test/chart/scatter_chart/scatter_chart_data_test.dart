import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScatterChart data equality check', () {

    test('ScatterChartData equality test', () {
      final ScatterChartData sample = ScatterChartData(
        minY: 0,
        maxY: 12,
        maxX: 22,
        minX: 11,
        axisTitleData: FlAxisTitleData(
          show: true,
          leftTitle: AxisTitle(
            showTitle: true,
            textStyle: TextStyle(color: Colors.red, fontSize: 33),
            textAlign: TextAlign.left,
            reservedSize: 22,
            margin: 11,
            titleText: 'title 1',
          ),
          bottomTitle: AxisTitle(
            showTitle: false,
            textStyle: TextStyle(color: Colors.grey, fontSize: 33),
            textAlign: TextAlign.left,
            reservedSize: 11,
            margin: 11,
            titleText: 'title 2',
          ),
          rightTitle: AxisTitle(
            showTitle: false,
            textStyle: TextStyle(color: Colors.blue, fontSize: 11),
            textAlign: TextAlign.left,
            reservedSize: 2,
            margin: 1324,
            titleText: 'title 3',
          ),
          topTitle: AxisTitle(
            showTitle: true,
            textStyle: TextStyle(color: Colors.green, fontSize: 33),
            textAlign: TextAlign.left,
            reservedSize: 23,
            margin: 11,
            titleText: 'title 4',
          ),
        ),
        gridData: FlGridData(
          show: false,
          getDrawingHorizontalLine: (value) =>
            FlLine(color: Colors.green, strokeWidth: 12, dashArray: [1, 2]),
          getDrawingVerticalLine: (value) =>
            FlLine(color: Colors.yellow, strokeWidth: 33, dashArray: [0, 1]),
          checkToShowHorizontalLine: (value) => false,
          checkToShowVerticalLine: (value) => true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          horizontalInterval: 33,
          verticalInterval: 1,
        ),
        backgroundColor: Colors.black,
        clipToBorder: false,
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
            getTooltipItems: (touchedSpot) => ScatterTooltipItem(
              'test',
              TextStyle(color: Colors.white),
              23,
            ),
            fitInsideHorizontally: true,
            fitInsideVertically: false,
            maxContentWidth: 33,
            tooltipBgColor: Colors.white,
            tooltipPadding: EdgeInsets.all(23),
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
      final ScatterChartData sampleClone = ScatterChartData(
        minY: 0,
        maxY: 12,
        maxX: 22,
        minX: 11,
        axisTitleData: FlAxisTitleData(
          show: true,
          leftTitle: AxisTitle(
            showTitle: true,
            textStyle: TextStyle(color: Colors.red, fontSize: 33),
            textAlign: TextAlign.left,
            reservedSize: 22,
            margin: 11,
            titleText: 'title 1',
          ),
          bottomTitle: AxisTitle(
            showTitle: false,
            textStyle: TextStyle(color: Colors.grey, fontSize: 33),
            textAlign: TextAlign.left,
            reservedSize: 11,
            margin: 11,
            titleText: 'title 2',
          ),
          rightTitle: AxisTitle(
            showTitle: false,
            textStyle: TextStyle(color: Colors.blue, fontSize: 11),
            textAlign: TextAlign.left,
            reservedSize: 2,
            margin: 1324,
            titleText: 'title 3',
          ),
          topTitle: AxisTitle(
            showTitle: true,
            textStyle: TextStyle(color: Colors.green, fontSize: 33),
            textAlign: TextAlign.left,
            reservedSize: 23,
            margin: 11,
            titleText: 'title 4',
          ),
        ),
        gridData: FlGridData(
          show: false,
          getDrawingHorizontalLine: (value) =>
            FlLine(color: Colors.green, strokeWidth: 12, dashArray: [1, 2]),
          getDrawingVerticalLine: (value) =>
            FlLine(color: Colors.yellow, strokeWidth: 33, dashArray: [0, 1]),
          checkToShowHorizontalLine: (value) => false,
          checkToShowVerticalLine: (value) => true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          horizontalInterval: 33,
          verticalInterval: 1,
        ),
        backgroundColor: Colors.black,
        clipToBorder: false,
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
            getTooltipItems: (touchedSpot) => ScatterTooltipItem(
              'test',
              TextStyle(color: Colors.white),
              23,
            ),
            fitInsideHorizontally: true,
            fitInsideVertically: false,
            maxContentWidth: 33,
            tooltipBgColor: Colors.white,
            tooltipPadding: EdgeInsets.all(23),
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

      expect(sample == sampleClone, true);
      expect(sample == sampleClone.copyWith(showingTooltipIndicators: []), false);
      expect(
        sample ==
          sampleClone.copyWith(
            borderData: FlBorderData(show: true, border: Border.all(color: Colors.green))),
        false);
      expect(
        sample ==
          sampleClone.copyWith(
            borderData: FlBorderData(show: true, border: Border.all(color: Colors.white))),
        true);
      expect(sample == sampleClone.copyWith(maxX: 444), false);
      expect(
        sample ==
          sampleClone.copyWith(scatterSpots: [
            ScatterSpot(0, 0, show: false, radius: 33, color: Colors.yellow),
            ScatterSpot(2, 2, show: false, radius: 11, color: Colors.purple),
            ScatterSpot(1, 2, show: false, radius: 11, color: Colors.white),
          ]),
        true);
      expect(
        sample ==
          sampleClone.copyWith(scatterSpots: [
            ScatterSpot(2, 2, show: false, radius: 11, color: Colors.purple),
            ScatterSpot(0, 0, show: false, radius: 33, color: Colors.yellow),
            ScatterSpot(1, 2, show: false, radius: 11, color: Colors.white),
          ]),
        false);
      expect(sample == sampleClone.copyWith(clipToBorder: true), false);
      expect(
        sample ==
          sampleClone.copyWith(
            gridData: FlGridData(
              show: false,
              getDrawingHorizontalLine: (value) =>
                FlLine(color: Colors.green, strokeWidth: 12, dashArray: [1, 2]),
              getDrawingVerticalLine: (value) =>
                FlLine(color: Colors.yellow, strokeWidth: 33, dashArray: [0, 1]),
              checkToShowHorizontalLine: (value) => false,
              checkToShowVerticalLine: (value) => true,
              drawHorizontalLine: true,
              drawVerticalLine: false,
              horizontalInterval: 33,
              verticalInterval: 1,
            )),
        true);
      expect(
        sample ==
          sampleClone.copyWith(
            gridData: FlGridData(
              show: true,
              getDrawingHorizontalLine: (value) =>
                FlLine(color: Colors.green, strokeWidth: 12, dashArray: [1, 2]),
              getDrawingVerticalLine: (value) =>
                FlLine(color: Colors.yellow, strokeWidth: 33, dashArray: [0, 1]),
              checkToShowHorizontalLine: (value) => false,
              checkToShowVerticalLine: (value) => true,
              drawHorizontalLine: true,
              drawVerticalLine: false,
              horizontalInterval: 33,
              verticalInterval: 1,
            )),
        false);
      expect(
        sample ==
          sampleClone.copyWith(
            gridData: FlGridData(
              show: false,
              getDrawingHorizontalLine: (value) =>
                FlLine(color: Colors.green, strokeWidth: 12, dashArray: [1, 2]),
              getDrawingVerticalLine: (value) =>
                FlLine(color: Colors.yellow, strokeWidth: 33, dashArray: [0, 1]),
              checkToShowHorizontalLine: (value) => false,
              checkToShowVerticalLine: (value) => true,
              drawHorizontalLine: true,
              drawVerticalLine: false,
              horizontalInterval: 32,
              verticalInterval: 1,
            )),
        false);
      expect(
        sample ==
          sampleClone.copyWith(
            axisTitleData: FlAxisTitleData(
              show: true,
              leftTitle: AxisTitle(
                showTitle: true,
                textStyle: TextStyle(color: Colors.red, fontSize: 33),
                textAlign: TextAlign.left,
                reservedSize: 22,
                margin: 11,
                titleText: 'title 1',
              ),
              bottomTitle: AxisTitle(
                showTitle: false,
                textStyle: TextStyle(color: Colors.grey, fontSize: 33),
                textAlign: TextAlign.left,
                reservedSize: 11,
                margin: 11,
                titleText: 'title 2',
              ),
              rightTitle: AxisTitle(
                showTitle: false,
                textStyle: TextStyle(color: Colors.blue, fontSize: 11),
                textAlign: TextAlign.left,
                reservedSize: 2,
                margin: 1324,
                titleText: 'title 3',
              ),
              topTitle: AxisTitle(
                showTitle: true,
                textStyle: TextStyle(color: Colors.green, fontSize: 33),
                textAlign: TextAlign.left,
                reservedSize: 23,
                margin: 11,
                titleText: 'title 4',
              ),
            )),
        true);
      expect(
        sample ==
          sampleClone.copyWith(
            axisTitleData: FlAxisTitleData(
              show: true,
              leftTitle: AxisTitle(
                showTitle: true,
                textStyle: TextStyle(color: Colors.red, fontSize: 33),
                textAlign: TextAlign.left,
                reservedSize: 21,
                margin: 11,
                titleText: 'title 1',
              ),
              bottomTitle: AxisTitle(
                showTitle: false,
                textStyle: TextStyle(color: Colors.grey, fontSize: 33),
                textAlign: TextAlign.left,
                reservedSize: 11,
                margin: 11,
                titleText: 'title 2',
              ),
              rightTitle: AxisTitle(
                showTitle: false,
                textStyle: TextStyle(color: Colors.blue, fontSize: 11),
                textAlign: TextAlign.left,
                reservedSize: 2,
                margin: 1324,
                titleText: 'title 3',
              ),
              topTitle: AxisTitle(
                showTitle: true,
                textStyle: TextStyle(color: Colors.green, fontSize: 33),
                textAlign: TextAlign.left,
                reservedSize: 23,
                margin: 11,
                titleText: 'title 4',
              ),
            )),
        false);
      expect(
        sample ==
          sampleClone.copyWith(
            axisTitleData: FlAxisTitleData(
              show: true,
              leftTitle: AxisTitle(
                showTitle: true,
                textStyle: TextStyle(color: Colors.red, fontSize: 33),
                textAlign: TextAlign.left,
                reservedSize: 22,
                margin: 11,
                titleText: 'title 1',
              ),
              bottomTitle: AxisTitle(
                showTitle: false,
                textStyle: TextStyle(color: Colors.grey, fontSize: 33),
                textAlign: TextAlign.left,
                reservedSize: 11,
                margin: 11,
                titleText: 'title 23',
              ),
              rightTitle: AxisTitle(
                showTitle: false,
                textStyle: TextStyle(color: Colors.blue, fontSize: 11),
                textAlign: TextAlign.left,
                reservedSize: 2,
                margin: 1324,
                titleText: 'title 3',
              ),
              topTitle: AxisTitle(
                showTitle: true,
                textStyle: TextStyle(color: Colors.green, fontSize: 33),
                textAlign: TextAlign.left,
                reservedSize: 23,
                margin: 11,
                titleText: 'title 4',
              ),
            )),
        false);
      expect(
        sample ==
          sampleClone.copyWith(
            axisTitleData: FlAxisTitleData(
              show: true,
              leftTitle: AxisTitle(
                showTitle: true,
                textStyle: TextStyle(color: Colors.red, fontSize: 33),
                textAlign: TextAlign.left,
                reservedSize: 22,
                margin: 11,
                titleText: 'title 1',
              ),
              bottomTitle: AxisTitle(
                showTitle: false,
                textStyle: TextStyle(color: Colors.grey, fontSize: 33),
                textAlign: TextAlign.left,
                reservedSize: 11,
                margin: 11,
                titleText: 'title 2',
              ),
              rightTitle: AxisTitle(
                showTitle: false,
                textStyle: TextStyle(color: Colors.blue, fontSize: 11),
                textAlign: TextAlign.right,
                reservedSize: 2,
                margin: 1324,
                titleText: 'title 3',
              ),
              topTitle: AxisTitle(
                showTitle: true,
                textStyle: TextStyle(color: Colors.green, fontSize: 33),
                textAlign: TextAlign.left,
                reservedSize: 23,
                margin: 11,
                titleText: 'title 4',
              ),
            )),
        false);
      expect(
        sample ==
          sampleClone.copyWith(
            axisTitleData: FlAxisTitleData(
              show: true,
              leftTitle: AxisTitle(
                showTitle: true,
                textStyle: TextStyle(color: Colors.red, fontSize: 33),
                textAlign: TextAlign.left,
                reservedSize: 22,
                margin: 11,
                titleText: 'title 1',
              ),
              bottomTitle: AxisTitle(
                showTitle: false,
                textStyle: TextStyle(color: Colors.grey, fontSize: 33),
                textAlign: TextAlign.left,
                reservedSize: 11,
                margin: 11,
                titleText: 'title 2',
              ),
              rightTitle: AxisTitle(
                showTitle: false,
                textStyle: TextStyle(color: Colors.blue, fontSize: 11),
                textAlign: TextAlign.left,
                reservedSize: 2,
                margin: 1324,
                titleText: 'title 3',
              ),
              topTitle: AxisTitle(
                showTitle: true,
                textStyle: TextStyle(color: Colors.green, fontSize: 33.5),
                textAlign: TextAlign.left,
                reservedSize: 23,
                margin: 11,
                titleText: 'title 4',
              ),
            )),
        false);
    });

    test('ScatterSpot equality test', () {
      ScatterSpot scatterSpot = ScatterSpot(0, 1);
      ScatterSpot scatterSpotClone = ScatterSpot(0, 1);

      expect(scatterSpot == scatterSpotClone.copyWith(), true);
      expect(scatterSpot == scatterSpotClone.copyWith(y: 3), false);
      expect(scatterSpot == scatterSpotClone.copyWith(x: 3), false);
    });

    test('ScatterTouchData equality test', () {
      ScatterTouchData sample = ScatterTouchData(
        touchTooltipData: ScatterTouchTooltipData(
          maxContentWidth: 2,
          tooltipBgColor: Colors.red,
          tooltipPadding: EdgeInsets.all(11),
        ),
        handleBuiltInTouches: false,
        touchCallback: null,
        touchSpotThreshold: 23,
        enabled: false,
      );
      ScatterTouchData sampleClone = ScatterTouchData(
        touchTooltipData: ScatterTouchTooltipData(
          maxContentWidth: 2,
          tooltipBgColor: Colors.red,
          tooltipPadding: EdgeInsets.all(11),
        ),
        handleBuiltInTouches: false,
        touchCallback: null,
        touchSpotThreshold: 23,
        enabled: false,
      );
      expect(sample == sampleClone, true);

      expect(
          sample ==
              sampleClone.copyWith(
                touchCallback: (response) {},
              ),
          true);
      expect(
          sample ==
              sampleClone.copyWith(
                enabled: true,
              ),
          false);
      expect(
          sample ==
              sampleClone.copyWith(
                touchSpotThreshold: 22,
              ),
          false);
      expect(
          sample ==
              sampleClone.copyWith(
                handleBuiltInTouches: true,
              ),
          false);
    });

    test('ScatterTouchResponse equality test', () {
      ScatterTouchResponse sample1 = ScatterTouchResponse(
        new FlPanStart(Offset(0, 0)),
        ScatterSpot(3, 4),
        1,
      );
      ScatterTouchResponse sample2 = ScatterTouchResponse(
        new FlPanStart(Offset(0, 0)),
        ScatterSpot(3, 4),
        1,
      );
      expect(sample1 == sample2, true);

      ScatterTouchResponse sampleChanged = ScatterTouchResponse(
        new FlPanStart(Offset(0, 3)),
        ScatterSpot(3, 4),
        1,
      );
      expect(sample1 == sampleChanged, false);

      sampleChanged = ScatterTouchResponse(
        new FlPanStart(Offset(0, 0)),
        ScatterSpot(0, 4),
        1,
      );
      expect(sample1 == sampleChanged, false);

      sampleChanged = ScatterTouchResponse(
        new FlPanStart(Offset(0, 0)),
        ScatterSpot(3, 4),
        5,
      );
      expect(sample1 == sampleChanged, false);
    });

    test('ScatterTouchTooltipData equality test', () {
      ScatterTouchTooltipData sample1 = ScatterTouchTooltipData(
        tooltipRoundedRadius: 23,
        tooltipPadding: EdgeInsets.all(11),
        tooltipBgColor: Colors.green,
        maxContentWidth: 33,
        fitInsideVertically: true,
        fitInsideHorizontally: false,
        getTooltipItems: (too) => ScatterTooltipItem('', TextStyle(color: Colors.green), 33),
      );
      ScatterTouchTooltipData sample2 = ScatterTouchTooltipData(
        tooltipRoundedRadius: 23,
        tooltipPadding: EdgeInsets.all(11),
        tooltipBgColor: Colors.green,
        maxContentWidth: 33,
        fitInsideVertically: true,
        fitInsideHorizontally: false,
        getTooltipItems: (too) => ScatterTooltipItem('', TextStyle(color: Colors.green), 33),
      );
      expect(sample1 == sample2, true);
    });

    test('ScatterTooltipItem equality test', () {
      ScatterTooltipItem sample1 = ScatterTooltipItem(
        'aa',
        TextStyle(color: Colors.red),
        23,
      );
      ScatterTooltipItem sample2 = ScatterTooltipItem(
        'aa',
        TextStyle(color: Colors.red),
        23,
      );
      expect(sample1 == sample2, true);

      ScatterTooltipItem changed = ScatterTooltipItem(
        'a3a',
        TextStyle(color: Colors.red),
        23,
      );
      expect(sample1 == changed, false);

      changed = ScatterTooltipItem(
        'aa',
        TextStyle(color: Colors.green),
        23,
      );
      expect(sample1 == changed, false);

      changed = ScatterTooltipItem(
        'aa',
        TextStyle(color: Colors.red),
        0,
      );
      expect(sample1 == changed, false);
    });

  });
}
