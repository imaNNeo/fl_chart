import 'package:fl_chart/fl_chart.dart';
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
    titlesData: FlTitlesData(
      show: false,
      leftTitles: AxisTitles(),
      topTitles: AxisTitles(),
      rightTitles: AxisTitles(),
      bottomTitles: AxisTitles(),
    ),
  );

  final lineChartDataWithAllTitles = lineChartDataBase.copyWith(
    titlesData: FlTitlesData(
      show: true,
      leftTitles: AxisTitles(
        axisNameWidget: const Text('Left Titles'),
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text('L-${value.toInt().toString()}');
          },
          interval: 1,
        ),
      ),
      topTitles: AxisTitles(
        axisNameWidget: const Text('Top Titles'),
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text('T-${value.toInt().toString()}');
          },
          interval: 1,
        ),
      ),
      rightTitles: AxisTitles(
        axisNameWidget: const Text('Right Titles'),
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text('R-${value.toInt().toString()}');
          },
          interval: 1,
        ),
      ),
      bottomTitles: AxisTitles(
        axisNameWidget: const Text('Bottom Titles'),
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text('B-${value.toInt().toString()}');
          },
          interval: 1,
        ),
      ),
    ),
  );

  final lineChartDataWithOnlyLeftTitles = lineChartDataBase.copyWith(
    titlesData: FlTitlesData(
      show: true,
      leftTitles: AxisTitles(
        axisNameWidget: const Text('Left Titles'),
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text('L-${value.toInt().toString()}');
          },
          interval: 1,
        ),
      ),
      topTitles: AxisTitles(),
      rightTitles: AxisTitles(),
      bottomTitles: AxisTitles(),
    ),
  );

  final lineChartDataWithOnlyLeftTitlesWithoutAxisName =
      lineChartDataBase.copyWith(
    titlesData: FlTitlesData(
      show: true,
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text('L-${value.toInt().toString()}');
          },
          interval: 1,
        ),
      ),
      topTitles: AxisTitles(),
      rightTitles: AxisTitles(),
      bottomTitles: AxisTitles(),
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
      show: true,
      leftTitles: AxisTitles(),
      topTitles: AxisTitles(),
      rightTitles: AxisTitles(),
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

  final barChartDataWithOnlyRightTitles = BarChartData(
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
      show: true,
      leftTitles: AxisTitles(),
      topTitles: AxisTitles(),
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
      bottomTitles: AxisTitles(),
    ),
  );

  testWidgets(
    'LineChart with no titles',
    (WidgetTester tester) async {
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
    (WidgetTester tester) async {
      Future checkSide(AxisSide side) async {
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

        String axisName;
        switch (side) {
          case AxisSide.left:
            axisName = 'Left';
            break;
          case AxisSide.top:
            axisName = 'Top';
            break;
          case AxisSide.right:
            axisName = 'Right';
            break;
          case AxisSide.bottom:
            axisName = 'Bottom';
            break;
          default:
            throw StateError('Invalid');
        }
        expect(find.text('$axisName Titles'), findsOneWidget);
        for (int i = 0; i <= 10; i++) {
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
    (WidgetTester tester) async {
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
      for (int i = 0; i <= 10; i++) {
        expect(find.text('L-$i'), findsOneWidget);
      }

      expect(find.byType(Text), findsNWidgets(12));
    },
  );

  testWidgets(
    'LineChart with Only left titles without axis name',
    (WidgetTester tester) async {
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
      for (int i = 0; i <= 10; i++) {
        expect(find.text('L-$i'), findsOneWidget);
      }

      expect(find.byType(Text), findsNWidgets(11));
    },
  );

  testWidgets(
    'BarChart with Only bottom titles',
    (WidgetTester tester) async {
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
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: viewSize.width,
                height: viewSize.height,
                child: SideTitlesWidget(
                  side: AxisSide.right,
                  axisChartData: barChartDataWithOnlyRightTitles,
                  parentSize: viewSize,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_right), findsOneWidget);
      for (int i = 0; i <= 10; i++) {
        expect(find.text('$i'), findsOneWidget);
      }
      expect(find.byType(TextButton), findsNWidgets(11));
    },
  );
}
