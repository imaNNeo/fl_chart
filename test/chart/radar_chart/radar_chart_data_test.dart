import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data_pool.dart';

void main() {
  group('RadarChart Data equality check', () {
    test('RadarChartData equality test', () {
      /// object equality test
      expect(
        radarChartData1 == radarChartData1Clone,
        true,
      );

      /// [dataSets] parameter test
      expect(
        radarChartData1 == radarChartData1Clone.copyWith(dataSets: [radarDataSet2]),
        false,
      );

      /// [radarBackgroundColor] test
      expect(
        radarChartData1 == radarChartData1Clone.copyWith(radarBackgroundColor: Colors.black),
        false,
      );

      /// [radarBorderData] test
      expect(
        radarChartData1 ==
            radarChartData1Clone.copyWith(
                radarBorderData: BorderSide(
              width: 200,
              color: Colors.red,
            )),
        false,
      );
    });
  });
}
