import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data_pool.dart';

void main() {
  group('RadarChart Data equality check', () {
    test('RadarChartData equality test', () {
      /// object equality test
      expect(radarChartData1 == radarChartData1Clone, true);

      expect(
          radarChartData1 ==
              radarChartData1Clone.copyWith(dataSets: [radarDataSet2]),
          false);

      expect(
          radarChartData1 ==
              radarChartData1Clone.copyWith(radarBackgroundColor: Colors.black),
          false);

      expect(
          radarChartData1 ==
              radarChartData1Clone.copyWith(
                  borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.green),
              )),
          true);

      expect(
          radarChartData1 ==
              radarChartData1Clone.copyWith(
                  borderData: FlBorderData(
                      show: false, border: Border.all(color: Colors.black))),
          false);

      expect(
          radarChartData1 ==
              radarChartData1Clone.copyWith(
                  radarBorderData: const BorderSide(
                width: 200,
                color: Colors.red,
              )),
          false);

      expect(
          radarChartData1 ==
              radarChartData1Clone.copyWith(
                radarShape: RadarShape.polygon,
              ),
          false);

      expect(
          radarChartData1 ==
              radarChartData1Clone.copyWith(radarTouchData: radarTouchData2),
          false);

      expect(
          radarChartData1 ==
              radarChartData1Clone.copyWith(
                  gridBorderData: const BorderSide(
                color: Colors.black54,
                width: 2.1,
              )),
          false);

      expect(radarChartData1 == radarChartData1Clone.copyWith(tickCount: 8),
          false);

      expect(
          radarChartData1 ==
              radarChartData1Clone.copyWith(ticksTextStyle: const TextStyle()),
          false);

      expect(
          radarChartData1 ==
              radarChartData1Clone.copyWith(
                  ticksTextStyle: radarChartData2.ticksTextStyle),
          false);

      expect(
          radarChartData1 ==
              radarChartData1Clone.copyWith(
                  tickBorderData: radarChartData2.tickBorderData),
          false);

      expect(
          radarChartData1 ==
              radarChartData1Clone.copyWith(titlePositionPercentageOffset: 0.2),
          true);

      expect(
          radarChartData1 ==
              radarChartData1Clone.copyWith(
                  titlePositionPercentageOffset:
                      radarChartData2.titlePositionPercentageOffset),
          false);

      expect(
          radarChartData1 ==
              radarChartData1Clone.copyWith(titleTextStyle: const TextStyle()),
          false);

      expect(
          radarChartData1 ==
              radarChartData1Clone.copyWith(
                  titleTextStyle: radarChartData2.titleTextStyle),
          false);

      expect(
          radarChartData1 ==
              radarChartData1Clone.copyWith(
                  titleTextStyle: radarChartData2.titleTextStyle),
          false);
    });

    test('RadarDataSet equality test', () {
      expect(radarDataSet1 == radarDataSet1Clone, true);

      expect(radarDataSet1 == radarDataSet2, false);

      expect(
        radarDataSet1 ==
            radarDataSet1Clone.copyWith(
              dataEntries: const [
                RadarEntry(value: 5),
                RadarEntry(value: 5),
                RadarEntry(value: 5),
              ],
            ),
        false,
      );

      expect(
          radarDataSet1 == radarDataSet1Clone.copyWith(fillColor: Colors.grey),
          true);

      expect(
          radarDataSet1 == radarDataSet1Clone.copyWith(fillColor: Colors.pink),
          false);

      expect(
          radarDataSet1 ==
              radarDataSet1Clone.copyWith(borderColor: Colors.blue),
          true);

      expect(
          radarDataSet1 ==
              radarDataSet1Clone.copyWith(borderColor: Colors.pink),
          false);

      expect(
          radarDataSet1 == radarDataSet1Clone.copyWith(borderWidth: 3), true);

      expect(radarDataSet1 == radarDataSet1Clone.copyWith(borderWidth: 3.2),
          false);

      expect(radarDataSet1 == radarDataSet1Clone.copyWith(borderWidth: 3.00002),
          false);

      expect(
          radarDataSet1 == radarDataSet1Clone.copyWith(entryRadius: 3), true);

      expect(radarDataSet1 == radarDataSet1Clone.copyWith(entryRadius: 3.2),
          false);

      expect(radarDataSet1 == radarDataSet1Clone.copyWith(entryRadius: 3.002),
          false);
    });

    test('RadarTouchData equality test', () {
      expect(radarTouchData1 == radarTouchData1Clone, true);

      expect(radarTouchData1 == radarTouchData2, false);

      expect(
          radarTouchData1 ==
              RadarTouchData(
                enabled: false,
                touchCallback: radarTouchCallback,
                touchSpotThreshold: 12,
              ),
          false);

      expect(
          radarTouchData1 ==
              RadarTouchData(
                enabled: true,
                touchCallback: radarTouchCallback,
                touchSpotThreshold: 2,
              ),
          false);

      expect(
          radarTouchData1 ==
              RadarTouchData(
                enabled: true,
                touchCallback: (event, value) {},
                touchSpotThreshold: 12,
              ),
          false);
    });

    test('RadarTouchedSpot equality test', () {
      expect(radarTouchedSpot1 == radarTouchedSpotClone1, true);
      expect(radarTouchedSpot1 == radarTouchedSpot2, false);
      expect(radarTouchedSpot1 == radarTouchedSpot3, false);
      expect(radarTouchedSpot1 == radarTouchedSpot4, false);
      expect(radarTouchedSpot1 == radarTouchedSpot5, false);
      expect(radarTouchedSpot1 == radarTouchedSpot6, false);
      expect(radarTouchedSpot1 == radarTouchedSpot7, false);
    });
  });
}
