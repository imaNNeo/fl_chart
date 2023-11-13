import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

List<BarChartGroupData> get barGroups => [
      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8)]),
      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10)]),
      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 14)]),
      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 15)]),
      BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 13)]),
      BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 10)]),
      BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 16)]),
      BarChartGroupData(x: 7, barRods: [BarChartRodData(toY: 8)]),
      BarChartGroupData(x: 8, barRods: [BarChartRodData(toY: 10)]),
      BarChartGroupData(x: 9, barRods: [BarChartRodData(toY: 14)]),
      BarChartGroupData(x: 10, barRods: [BarChartRodData(toY: 15)]),
      BarChartGroupData(x: 11, barRods: [BarChartRodData(toY: 13)]),
      BarChartGroupData(x: 12, barRods: [BarChartRodData(toY: 10)]),
      BarChartGroupData(x: 13, barRods: [BarChartRodData(toY: 16)]),
      BarChartGroupData(x: 14, barRods: [BarChartRodData(toY: 8)]),
      BarChartGroupData(x: 15, barRods: [BarChartRodData(toY: 10)]),
      BarChartGroupData(x: 16, barRods: [BarChartRodData(toY: 14)]),
      BarChartGroupData(x: 17, barRods: [BarChartRodData(toY: 15)]),
      BarChartGroupData(x: 18, barRods: [BarChartRodData(toY: 13)]),
      BarChartGroupData(x: 19, barRods: [BarChartRodData(toY: 10)]),
      BarChartGroupData(x: 20, barRods: [BarChartRodData(toY: 16)]),
    ];

void main() {
  const viewSize = Size(400, 400);

  testWidgets(
    'Barchart alignment overflow test',
    (WidgetTester tester) async {
      for (final groupsSpace in [4.0, 20.0]) {
        for (final barChartAlignment in [
          BarChartAlignment.start,
          BarChartAlignment.center,
          BarChartAlignment.end,
        ]) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: viewSize.width,
                    height: viewSize.height,
                    child: BarChart(
                      BarChartData(
                        barGroups: barGroups,
                        gridData: const FlGridData(show: false),
                        alignment: barChartAlignment,
                        groupsSpace: groupsSpace,
                        maxY: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();
          final fname = '${barChartAlignment}_$groupsSpace';

          await expectLater(
            find.byType(BarChart),
            matchesGoldenFile('golden/$fname.png'),
          );
        }
      }
    },
  );
}
