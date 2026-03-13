import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_helper.dart';
import 'package:fl_chart/src/chart/base/axis_chart/side_titles/side_titles_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const viewSize = Size(400, 400);

  final lineChartDataBase = LineChartData(
    minX: 0,
    maxX: 10,
    minY: 0,
    maxY: 10,
  );

  final lineChartDataWithNoTitles = lineChartDataBase.copyWith(
    titlesData: const FlTitlesData(
      show: false,
      leftTitles: AxisTitles(),
      topTitles: AxisTitles(),
      rightTitles: AxisTitles(),
      bottomTitles: AxisTitles(),
    ),
  );

  final lineChartDataWithAllTitles = lineChartDataBase.copyWith(
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        axisNameWidget: const Text('Left Titles'),
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Text('L-${value.toInt()}');
          },
          interval: 1,
        ),
      ),
      topTitles: AxisTitles(
        axisNameWidget: const Text('Top Titles'),
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Text('T-${value.toInt()}');
          },
          interval: 1,
        ),
      ),
      rightTitles: AxisTitles(
        axisNameWidget: const Text('Right Titles'),
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Text('R-${value.toInt()}');
          },
          interval: 1,
        ),
      ),
      bottomTitles: AxisTitles(
        axisNameWidget: const Text('Bottom Titles'),
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Text('B-${value.toInt()}');
          },
          interval: 1,
        ),
      ),
    ),
  );

  final lineChartDataWithOnlyLeftTitles = lineChartDataBase.copyWith(
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        axisNameWidget: const Text('Left Titles'),
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Text('L-${value.toInt()}');
          },
          interval: 1,
        ),
      ),
      topTitles: const AxisTitles(),
      rightTitles: const AxisTitles(),
      bottomTitles: const AxisTitles(),
    ),
  );

  final lineChartDataWithOnlyLeftTitlesWithoutAxisName =
      lineChartDataBase.copyWith(
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Text('L-${value.toInt()}');
          },
          interval: 1,
        ),
      ),
      topTitles: const AxisTitles(),
      rightTitles: const AxisTitles(),
      bottomTitles: const AxisTitles(),
    ),
  );

  final barChartDataWithOnlyBottomTitles = BarChartData(
    barGroups: [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(toY: 10),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(toY: 10),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(toY: 10),
        ],
      ),
    ],
    titlesData: FlTitlesData(
      leftTitles: const AxisTitles(),
      topTitles: const AxisTitles(),
      rightTitles: const AxisTitles(),
      bottomTitles: AxisTitles(
        axisNameWidget: const Icon(Icons.check),
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return TextButton(
              onPressed: () {},
              child: Text(
                value.toInt().toString(),
              ),
            );
          },
        ),
      ),
    ),
  );

  BarChartData createBarChartDataWithOnlyRightTitles() {
    final barGroups = <BarChartGroupData>[
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(toY: 10),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(toY: 10),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(toY: 10),
        ],
      ),
    ];

    final (minY, maxY) = BarChartHelper().calculateMaxAxisValues(barGroups);

    return BarChartData(
      barGroups: barGroups,
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(),
        topTitles: const AxisTitles(),
        rightTitles: AxisTitles(
          axisNameWidget: const Icon(Icons.arrow_right),
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              return TextButton(
                onPressed: () {},
                child: Text(
                  value.toInt().toString(),
                ),
              );
            },
          ),
        ),
        bottomTitles: const AxisTitles(),
      ),
      minY: minY,
      maxY: maxY,
    );
  }

  BarChartData createBarChartDataWithEmptyGroups() {
    final barGroups = <BarChartGroupData>[];
    final (minY, maxY) = BarChartHelper().calculateMaxAxisValues(barGroups);

    return BarChartData(
      barGroups: [],
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(),
        topTitles: const AxisTitles(),
        rightTitles: AxisTitles(
          axisNameWidget: const Icon(Icons.arrow_right),
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              return TextButton(
                onPressed: () {},
                child: Text(
                  value.toInt().toString(),
                ),
              );
            },
          ),
        ),
        bottomTitles: const AxisTitles(),
      ),
      minY: minY,
      maxY: maxY,
    );
  }

  testWidgets(
    'LineChart with no titles',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: viewSize.width,
                height: viewSize.height,
                child: SideTitlesWidget(
                  side: AxisSide.left,
                  axisChartData: lineChartDataWithNoTitles,
                  parentSize: viewSize,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Text), findsNothing);
    },
  );

  testWidgets(
    'LineChart with all titles',
    (tester) async {
      Future<void> checkSide(AxisSide side) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: viewSize.width,
                  height: viewSize.height,
                  child: SideTitlesWidget(
                    side: side,
                    axisChartData: lineChartDataWithAllTitles,
                    parentSize: viewSize,
                  ),
                ),
              ),
            ),
          ),
        );

        final axisName = switch (side) {
          AxisSide.left => 'Left',
          AxisSide.top => 'Top',
          AxisSide.right => 'Right',
          AxisSide.bottom => 'Bottom',
        };
        expect(find.text('$axisName Titles'), findsOneWidget);
        for (var i = 0; i <= 10; i++) {
          expect(find.text('${axisName.characters.first}-$i'), findsOneWidget);
        }
      }

      await checkSide(AxisSide.left);
      await checkSide(AxisSide.top);
      await checkSide(AxisSide.right);
      await checkSide(AxisSide.bottom);
    },
  );

  testWidgets(
    'LineChart with Only left titles',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: viewSize.width,
                height: viewSize.height,
                child: SideTitlesWidget(
                  side: AxisSide.left,
                  axisChartData: lineChartDataWithOnlyLeftTitles,
                  parentSize: viewSize,
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Left Titles'), findsOneWidget);
      for (var i = 0; i <= 10; i++) {
        expect(find.text('L-$i'), findsOneWidget);
      }

      expect(find.byType(Text), findsNWidgets(12));
    },
  );

  testWidgets(
    'LineChart with Only left titles without axis name',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: viewSize.width,
                height: viewSize.height,
                child: SideTitlesWidget(
                  side: AxisSide.left,
                  axisChartData: lineChartDataWithOnlyLeftTitlesWithoutAxisName,
                  parentSize: viewSize,
                ),
              ),
            ),
          ),
        ),
      );
      for (var i = 0; i <= 10; i++) {
        expect(find.text('L-$i'), findsOneWidget);
      }

      expect(find.byType(Text), findsNWidgets(11));
    },
  );

  testWidgets(
    'BarChart with Only bottom titles',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: viewSize.width,
                height: viewSize.height,
                child: SideTitlesWidget(
                  side: AxisSide.bottom,
                  axisChartData: barChartDataWithOnlyBottomTitles,
                  parentSize: viewSize,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.byType(TextButton), findsNWidgets(3));
    },
  );

  testWidgets(
    'BarChart with Only right titles',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: viewSize.width,
                height: viewSize.height,
                child: SideTitlesWidget(
                  side: AxisSide.right,
                  axisChartData: createBarChartDataWithOnlyRightTitles(),
                  parentSize: viewSize,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_right), findsOneWidget);
      for (var i = 0; i <= 10; i++) {
        expect(find.text('$i'), findsOneWidget);
      }
      expect(find.byType(TextButton), findsNWidgets(11));
    },
  );

  testWidgets(
    'BarChart with empty bars',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: viewSize.width,
                height: viewSize.height,
                child: SideTitlesWidget(
                  side: AxisSide.right,
                  axisChartData: createBarChartDataWithEmptyGroups(),
                  parentSize: viewSize,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_right), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    },
  );

  testWidgets(
    'Rotated BarChart labels render with large reservedSize',
    (tester) async {
      // Regression test for https://github.com/imaNNeo/fl_chart/issues/1963
      // With rotationQuarterTurns=1 and a large bottomTitles reservedSize,
      // labels would disappear because the chart size calculation subtracted
      // the wrong padding dimension, making it negative.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 350,
                height: 120,
                child: BarChart(
                  BarChartData(
                    rotationQuarterTurns: 1,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 25,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 115,
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    barGroups: [
                      BarChartGroupData(
                        x: 1,
                        barRods: [BarChartRodData(toY: 5, color: Colors.blue)],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [BarChartRodData(toY: 10, color: Colors.red)],
                      ),
                      BarChartGroupData(
                        x: 3,
                        barRods: [
                          BarChartRodData(toY: 7, color: Colors.orange),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Labels should be visible, not filtered out.
      // Before the fix, no Text widgets would appear because
      // _getPositionsWithinChartRange incorrectly created a negative-size
      // chart rect, filtering out all label positions.
      expect(find.byType(Text), findsWidgets);
    },
  );
}
