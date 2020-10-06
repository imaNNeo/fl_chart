import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data_pool.dart';

void main() {
  group('PieChart data equality check', () {
    test('PieChartData equality test', () {
      expect(pieChartData1 == pieChartData1Clone, true);

      expect(
          pieChartData1 ==
              pieChartData1Clone.copyWith(
                  borderData: FlBorderData(show: false, border: Border.all(color: Colors.black))),
          true);

      expect(
          pieChartData1 ==
              pieChartData1Clone.copyWith(
                  borderData: FlBorderData(show: true, border: Border.all(color: Colors.black))),
          false);

      expect(
          pieChartData1 ==
              pieChartData1Clone.copyWith(
                startDegreeOffset: 33,
              ),
          false);

      expect(
          pieChartData1 ==
              PieChartData(
                borderData: FlBorderData(show: false, border: Border.all(color: Colors.black)),
                startDegreeOffset: 0,
                sections: null,
                centerSpaceColor: Colors.white,
                centerSpaceRadius: 12,
                pieTouchData: PieTouchData(
                  enabled: false,
                ),
                sectionsSpace: 44,
              ),
          false);

      expect(
          pieChartData1 ==
              pieChartData1Clone.copyWith(
                sections: [],
              ),
          false);

      expect(
          pieChartData1 ==
              pieChartData1Clone.copyWith(
                sections: [
                  PieChartSectionData(value: 12, color: Colors.red),
                  PieChartSectionData(value: 22, color: Colors.green),
                ],
              ),
          true);

      expect(
          pieChartData1 ==
              pieChartData1Clone.copyWith(
                sections: [
                  PieChartSectionData(value: 12, color: Colors.red),
                  PieChartSectionData(value: 22, color: Colors.green.withOpacity(0.99)),
                ],
              ),
          false);

      expect(
          pieChartData1 ==
              pieChartData1Clone.copyWith(
                sections: [
                  PieChartSectionData(value: 22, color: Colors.green),
                  PieChartSectionData(value: 12, color: Colors.red),
                ],
              ),
          false);

      expect(
          pieChartData1 ==
              pieChartData1Clone.copyWith(
                centerSpaceColor: Colors.cyan,
              ),
          false);

      expect(
          pieChartData1 ==
              pieChartData1Clone.copyWith(
                centerSpaceRadius: 44,
              ),
          false);

      expect(
          pieChartData1 ==
              pieChartData1Clone.copyWith(
                pieTouchData: PieTouchData(),
              ),
          false);

      expect(
          pieChartData1 ==
              pieChartData1Clone.copyWith(
                sectionsSpace: 44.000001,
              ),
          false);
    });

    test('PieChartSectionData equality test', () {
      final Widget _badge = Container(
        color: Colors.green,
        width: 20,
        height: 20,
      );

      final PieChartSectionData sample1 = PieChartSectionData(
        color: Colors.red,
        radius: 12,
        showTitle: false,
        value: 33,
        title: 'testTitle',
        titlePositionPercentageOffset: 10,
        titleStyle: const TextStyle(color: Colors.green),
        badgeWidget: _badge,
        badgePositionPercentageOffset: 10,
      );

      final PieChartSectionData sample2 = PieChartSectionData(
        color: Colors.red,
        radius: 12,
        showTitle: false,
        value: 33,
        title: 'testTitle',
        titlePositionPercentageOffset: 10,
        titleStyle: const TextStyle(color: Colors.green),
        badgeWidget: _badge,
        badgePositionPercentageOffset: 10,
      );

      expect(sample1 == sample2, true);

      expect(sample1 == sample2.copyWith(color: Colors.white), false);

      expect(sample1 == sample2.copyWith(radius: 12), true);

      expect(sample1 == sample2.copyWith(radius: 11), false);

      expect(sample1 == sample2.copyWith(title: 'testTitle'), true);

      expect(sample1 == sample2.copyWith(title: 'testTitle.'), false);

      expect(sample1 == sample2.copyWith(value: 12), false);

      expect(sample1 == sample2.copyWith(titlePositionPercentageOffset: 4314), false);

      expect(
        sample1 ==
            sample2.copyWith(
              badgeWidget: _badge,
            ),
        true,
      );

      expect(
        sample1 ==
            sample2.copyWith(
              badgeWidget: Container(
                color: Colors.blue,
                width: 25,
                height: 25,
              ),
            ),
        false,
      );

      expect(sample1 == sample2.copyWith(badgePositionPercentageOffset: 4314), false);

      expect(
          sample1 ==
              PieChartSectionData(
                color: Colors.red,
                radius: 12,
                showTitle: false,
                value: 33,
                title: 'testTitle',
                titlePositionPercentageOffset: 10,
                titleStyle: null,
                badgeWidget: Container(
                  color: Colors.green,
                  width: 20,
                  height: 20,
                ),
                badgePositionPercentageOffset: 10,
              ),
          false);

      expect(sample1 == sample2.copyWith(titleStyle: const TextStyle(color: Colors.green)), true);

      expect(
          sample1 == sample2.copyWith(titleStyle: TextStyle(color: Colors.green.withOpacity(0.3))),
          false);
    });

    test('PieTouchData equality test', () {
      final PieTouchData sample1 = PieTouchData(
        touchCallback: (response) {},
        enabled: true,
      );
      final PieTouchData sample2 = PieTouchData(
        touchCallback: null,
        enabled: true,
      );

      expect(sample1 == sample2, true);

      final PieTouchData disabled = PieTouchData(
        touchCallback: null,
        enabled: false,
      );
      expect(sample1 == disabled, false);
    });

    test('PieTouchResponse equality test', () {
      final PieTouchResponse sample1 = PieTouchResponse(
        PieChartSectionData(
          color: Colors.green,
          title: 'test',
          radius: 12,
        ),
        1,
        12.0,
        30,
        FlPanStart(const Offset(0, 1)),
      );
      final PieTouchResponse sample2 = PieTouchResponse(
        PieChartSectionData(
          color: Colors.green,
          title: 'test',
          radius: 12,
        ),
        1,
        12.0,
        30,
        FlPanStart(const Offset(0, 1)),
      );

      expect(sample1 == sample2, true);

      PieTouchResponse changed = PieTouchResponse(
        PieChartSectionData(
          color: Colors.green,
          title: 'asdf',
          radius: 12,
        ),
        1,
        12.0,
        30,
        FlPanStart(const Offset(0, 1)),
      );

      expect(sample1 == changed, false);

      changed = PieTouchResponse(
        PieChartSectionData(
          color: Colors.red,
          title: 'test',
          radius: 12,
        ),
        1,
        12.0,
        30,
        FlPanStart(const Offset(0, 1)),
      );

      expect(sample1 == changed, false);

      changed = PieTouchResponse(
        PieChartSectionData(
          color: Colors.green,
          title: 'test',
          radius: 12,
        ),
        1,
        12.1,
        30,
        FlPanStart(const Offset(0, 1)),
      );

      expect(sample1 == changed, false);

      changed = PieTouchResponse(
        PieChartSectionData(
          color: Colors.green,
          title: 'test',
          radius: 12,
        ),
        1,
        12.0,
        30,
        FlPanStart(const Offset(0, 1.1)),
      );

      expect(sample1 == changed, false);

      changed = PieTouchResponse(
        null,
        1,
        12.0,
        30,
        FlPanStart(const Offset(0, 1)),
      );

      expect(sample1 == changed, false);
    });
  });
}
