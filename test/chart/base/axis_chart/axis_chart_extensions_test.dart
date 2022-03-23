import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../data_pool.dart';

void main() {
  group('splitByNullSpots()', () {
    test('test 1 - null spots start', () {
      List<FlSpot> spots = [
        FlSpot.nullSpot,
        FlSpot.nullSpot,
        FlSpot.nullSpot,
        FlSpot.nullSpot,
        FlSpot.nullSpot,
        MockData.flSpot1,
        MockData.flSpot2,
        MockData.flSpot3,
      ];
      final result = spots.splitByNullSpots();
      expect(
        result,
        [
          [
            MockData.flSpot1,
            MockData.flSpot2,
            MockData.flSpot3,
          ]
        ],
      );
    });
    test('test 2 - null spots end', () {
      List<FlSpot> spots = [
        MockData.flSpot1,
        MockData.flSpot2,
        MockData.flSpot3,
        FlSpot.nullSpot,
        FlSpot.nullSpot,
        FlSpot.nullSpot,
      ];
      final result = spots.splitByNullSpots();
      expect(
        result,
        [
          [
            MockData.flSpot1,
            MockData.flSpot2,
            MockData.flSpot3,
          ]
        ],
      );
    });
    test('test 3 - null spots around', () {
      List<FlSpot> spots = [
        FlSpot.nullSpot,
        FlSpot.nullSpot,
        FlSpot.nullSpot,
        FlSpot.nullSpot,
        FlSpot.nullSpot,
        MockData.flSpot1,
        MockData.flSpot2,
        MockData.flSpot3,
        FlSpot.nullSpot,
        FlSpot.nullSpot,
        FlSpot.nullSpot,
      ];
      final result = spots.splitByNullSpots();
      expect(
        result,
        [
          [
            MockData.flSpot1,
            MockData.flSpot2,
            MockData.flSpot3,
          ]
        ],
      );
    });
    test('test 4 - null spots between', () {
      List<FlSpot> spots = [
        MockData.flSpot1,
        MockData.flSpot2,
        FlSpot.nullSpot,
        MockData.flSpot3,
        FlSpot.nullSpot,
        MockData.flSpot4,
        MockData.flSpot5,
        FlSpot.nullSpot,
        MockData.flSpot1,
      ];
      final result = spots.splitByNullSpots();
      expect(
        result,
        [
          [
            MockData.flSpot1,
            MockData.flSpot2,
          ],
          [
            MockData.flSpot3,
          ],
          [
            MockData.flSpot4,
            MockData.flSpot5,
          ],
          [
            MockData.flSpot1,
          ]
        ],
      );
    });
  });
}
