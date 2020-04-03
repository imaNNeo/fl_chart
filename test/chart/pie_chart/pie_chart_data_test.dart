import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('PieChart data equality check',() {
    test('PieChartData equality test', () {
      PieChartData sample1 = PieChartData(
        borderData: FlBorderData(show: false,border: Border.all(color: Colors.black)),
        startDegreeOffset: 0,
        sections: [
          PieChartSectionData(value: 12, color: Colors.red),
          PieChartSectionData(value: 22, color: Colors.green),
        ],
        centerSpaceColor: Colors.white,
        centerSpaceRadius: 12,
        pieTouchData: PieTouchData(enabled: false,),
        sectionsSpace: 44,
      );

      PieChartData sample2 = PieChartData(
        borderData: FlBorderData(show: false, border: Border.all(color: Colors.black)),
        startDegreeOffset: 0,
        sections: [
          PieChartSectionData(value: 12, color: Colors.red),
          PieChartSectionData(value: 22, color: Colors.green),
        ],
        centerSpaceColor: Colors.white,
        centerSpaceRadius: 12,
        pieTouchData: PieTouchData(enabled: false,),
        sectionsSpace: 44,
      );

      expect(sample1 == sample2, true);

      expect(sample1 == sample2.copyWith(), true);

      expect(sample1 == sample2.copyWith(
        borderData: FlBorderData(show: false, border: Border.all(color: Colors.black))
      ), true);

      expect(sample1 == sample2.copyWith(
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.black))
      ), false);

      expect(sample1 == sample2.copyWith(
        startDegreeOffset: 33,
      ), false);

      expect(sample1 == PieChartData(
        borderData: FlBorderData(show: false, border: Border.all(color: Colors.black)),
        startDegreeOffset: 0,
        sections: null,
        centerSpaceColor: Colors.white,
        centerSpaceRadius: 12,
        pieTouchData: PieTouchData(enabled: false,),
        sectionsSpace: 44,
      ), false);

      expect(sample1 == sample2.copyWith(
        sections: [],
      ), false);

      expect(sample1 == sample2.copyWith(
        sections: [
          PieChartSectionData(value: 12, color: Colors.red),
          PieChartSectionData(value: 22, color: Colors.green),
        ],
      ), true);

      expect(sample1 == sample2.copyWith(
        sections: [
          PieChartSectionData(value: 12, color: Colors.red),
          PieChartSectionData(value: 22, color: Colors.green.withOpacity(0.99)),
        ],
      ), false);

      expect(sample1 == sample2.copyWith(
        sections: [
          PieChartSectionData(value: 22, color: Colors.green),
          PieChartSectionData(value: 12, color: Colors.red),
        ],
      ), false);

      expect(sample1 == sample2.copyWith(
        centerSpaceColor: Colors.cyan,
      ), false);

      expect(sample1 == sample2.copyWith(
        centerSpaceRadius: 44,
      ), false);

      expect(sample1 == sample2.copyWith(
        pieTouchData: PieTouchData(),
      ), false);

      expect(sample1 == sample2.copyWith(
        sectionsSpace: 44.000001,
      ), false);

    });

    test('PieChartSectionData equality test', () {
      PieChartSectionData sample1 = PieChartSectionData(
        color: Colors.red,
        radius: 12,
        showTitle: false,
        value: 33,
        title: 'testTitle',
        titlePositionPercentageOffset: 10,
        titleStyle: TextStyle(color: Colors.green),
      );

      PieChartSectionData sample2 = PieChartSectionData(
        color: Colors.red,
        radius: 12,
        showTitle: false,
        value: 33,
        title: 'testTitle',
        titlePositionPercentageOffset: 10,
        titleStyle: TextStyle(color: Colors.green),
      );

      expect(sample1 == sample2, true);

      expect(sample1 == sample2.copyWith(color: Colors.white), false);

      expect(sample1 == sample2.copyWith(radius: 12), true);

      expect(sample1 == sample2.copyWith(radius: 11), false);

      expect(sample1 == sample2.copyWith(title: 'testTitle'), true);

      expect(sample1 == sample2.copyWith(title: 'testTitle.'), false);

      expect(sample1 == sample2.copyWith(value: 12), false);

      expect(sample1 == sample2.copyWith(titlePositionPercentageOffset: 4314), false);

      expect(sample1 == PieChartSectionData(
        color: Colors.red,
        radius: 12,
        showTitle: false,
        value: 33,
        title: 'testTitle',
        titlePositionPercentageOffset: 10,
        titleStyle: null,
      ), false);

      expect(sample1 == sample2.copyWith(titleStyle: TextStyle(color: Colors.green)), true);

      expect(sample1 == sample2.copyWith(titleStyle: TextStyle(color: Colors.green.withOpacity(0.3))), false);

    });

    test('PieTouchData equality test', () {
      PieTouchData sample1 = PieTouchData(
        touchCallback: (response) {},
        enabled: true,
      );
      PieTouchData sample2 = PieTouchData(
        touchCallback: null,
        enabled: true,
      );

      expect(sample1 == sample2, true);

      PieTouchData disabled = PieTouchData(
        touchCallback: null,
        enabled: false,
      );
      expect(sample1 == disabled, false);
    });

    test('PieTouchResponse equality test', () {
      PieTouchResponse sample1 = PieTouchResponse(
        PieChartSectionData(
          color: Colors.green,
          title: 'test',
          radius: 12,
        ),
        1,
        12.0,
        30,
        FlPanStart(Offset(0, 1)),
      );
      PieTouchResponse sample2 = PieTouchResponse(
        PieChartSectionData(
          color: Colors.green,
          title: 'test',
          radius: 12,
        ),
        1,
        12.0,
        30,
        FlPanStart(Offset(0, 1)),
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
        FlPanStart(Offset(0, 1)),
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
        FlPanStart(Offset(0, 1)),
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
        FlPanStart(Offset(0, 1)),
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
        FlPanStart(Offset(0, 1.1)),
      );

      expect(sample1 == changed, false);

      changed = PieTouchResponse(
        null,
        1,
        12.0,
        30,
        FlPanStart(Offset(0, 1)),
      );

      expect(sample1 == changed, false);

    });
  });

}
