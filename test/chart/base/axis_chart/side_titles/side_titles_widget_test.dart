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

  LineChartData createLineChartDataWithLargeBottomReservedSize({
    required int rotationQuarterTurns,
  }) {
    return lineChartDataBase.copyWith(
      rotationQuarterTurns: rotationQuarterTurns,
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              return Text('L-${value.toInt()}');
            },
          ),
        ),
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 190,
            interval: 1,
            getTitlesWidget: (value, meta) {
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
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
    'LineChart left titles remain visible with large cross-axis reserved size (unrotated and rotated)',
    (tester) async {
      Future<void> pumpChart({
        required Size parentSize,
        required int rotationQuarterTurns,
      }) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: parentSize.width,
                  height: parentSize.height,
                  child: SideTitlesWidget(
                    side: AxisSide.left,
                    axisChartData:
                        createLineChartDataWithLargeBottomReservedSize(
                      rotationQuarterTurns: rotationQuarterTurns,
                    ),
                    parentSize: parentSize,
                  ),
                ),
              ),
            ),
          ),
        );
      }

      await pumpChart(
        parentSize: const Size(180, 400),
        rotationQuarterTurns: 0,
      );
      for (var i = 0; i <= 10; i++) {
        expect(find.text('L-$i'), findsOneWidget);
      }

      await pumpChart(
        parentSize: const Size(400, 180),
        rotationQuarterTurns: 1,
      );
      for (var i = 0; i <= 10; i++) {
        expect(find.text('L-$i'), findsOneWidget);
      }
    },
  );

  testWidgets(
    'LineChart default left titles stay distinct on a tall narrow-range axis (#1584)',
    (tester) async {
      const parentSize = Size(400, 1000);
      tester.view.physicalSize = parentSize;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: parentSize.width,
              height: parentSize.height,
              child: SideTitlesWidget(
                side: AxisSide.left,
                axisChartData: LineChartData(
                  minX: 0,
                  maxX: 10,
                  minY: 976405.27,
                  maxY: 1135594.31,
                  titlesData: const FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles: AxisTitles(),
                    rightTitles: AxisTitles(),
                    bottomTitles: AxisTitles(),
                  ),
                ),
                parentSize: parentSize,
              ),
            ),
          ),
        ),
      );

      final labels = tester
          .widgetList<Text>(find.byType(Text))
          .map((t) => t.data)
          .toList();
      expect(labels.length, greaterThan(20));
      expect(labels.toSet().length, labels.length);
      expect(labels, contains('1.005M'));
    },
  );

  // Pumps the titles of [side] alone and records what getTitlesWidget gets.
  Future<Map<double, TitleMeta>> pumpTitles(
    WidgetTester tester,
    AxisSide side,
    AxisChartData Function(FlTitlesData titlesData) buildData,
  ) async {
    final titles = <double, TitleMeta>{};
    final axisTitles = AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          titles[value] = meta;
          return Text(meta.formattedValue);
        },
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: viewSize.width,
              height: viewSize.height,
              child: SideTitlesWidget(
                side: side,
                axisChartData: buildData(
                  FlTitlesData(
                    leftTitles:
                        side == AxisSide.left ? axisTitles : const AxisTitles(),
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                    bottomTitles: side == AxisSide.bottom
                        ? axisTitles
                        : const AxisTitles(),
                  ),
                ),
                parentSize: viewSize,
              ),
            ),
          ),
        ),
      ),
    );
    return titles;
  }

  // Pumps the left titles of minY: 10, maxY: 0 and of minY: 0, maxY: 10.
  // Expects the same values, each one at its getPixelY position (minY at the
  // bottom), and no two titles at the same position.
  Future<Map<double, TitleMeta>> expectInvertedLeftTitlesMatchNormal(
    WidgetTester tester,
    AxisChartData Function(double minY, double maxY, FlTitlesData titlesData)
        buildData,
  ) async {
    final normal =
        await pumpTitles(tester, AxisSide.left, (t) => buildData(0, 10, t));
    final inverted =
        await pumpTitles(tester, AxisSide.left, (t) => buildData(10, 0, t));

    expect(inverted.keys.toSet(), normal.keys.toSet());
    for (final MapEntry(key: value, value: meta) in inverted.entries) {
      expect(
        meta.axisPosition,
        closeTo((1 - (value - 10) / (0 - 10)) * meta.parentAxisSize, 0.0001),
        reason: 'title $value',
      );
    }
    final positions = inverted.values.map((meta) => meta.axisPosition);
    expect(positions.toSet(), hasLength(positions.length));
    return inverted;
  }

  testWidgets(
    'inverted Y axis titles match the normal axis for LineChartData (#1769)',
    (tester) async {
      final inverted = await expectInvertedLeftTitlesMatchNormal(
        tester,
        (minY, maxY, titlesData) => LineChartData(
          minX: 0,
          maxX: 10,
          minY: minY,
          maxY: maxY,
          titlesData: titlesData,
        ),
      );
      for (final meta in inverted.values) {
        expect(meta.appliedInterval, greaterThan(0));
        expect(meta.min, 10);
        expect(meta.max, 0);
      }
    },
  );

  testWidgets(
    'inverted Y axis titles match the normal axis for BarChartData (#1769)',
    (tester) async {
      await expectInvertedLeftTitlesMatchNormal(
        tester,
        (minY, maxY, titlesData) => BarChartData(
          minY: minY,
          maxY: maxY,
          titlesData: titlesData,
          barGroups: [
            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 4)]),
          ],
        ),
      );
    },
  );

  testWidgets(
    'inverted Y axis titles match the normal axis for ScatterChartData (#1769)',
    (tester) async {
      await expectInvertedLeftTitlesMatchNormal(
        tester,
        (minY, maxY, titlesData) => ScatterChartData(
          minX: 0,
          maxX: 10,
          minY: minY,
          maxY: maxY,
          titlesData: titlesData,
          scatterSpots: [ScatterSpot(2, 3)],
        ),
      );
    },
  );

  testWidgets(
    'inverted Y axis titles match the normal axis for CandlestickChartData (#1769)',
    (tester) async {
      await expectInvertedLeftTitlesMatchNormal(
        tester,
        (minY, maxY, titlesData) => CandlestickChartData(
          minX: 0,
          maxX: 10,
          minY: minY,
          maxY: maxY,
          titlesData: titlesData,
          candlestickSpots: [
            CandlestickSpot(x: 2, open: 3, high: 6, low: 2, close: 5),
          ],
        ),
      );
    },
  );

  testWidgets(
    'min == max keeps the titles of e60b4c13 (#1769)',
    (tester) async {
      final titles = await pumpTitles(
        tester,
        AxisSide.left,
        (titlesData) => LineChartData(
          minX: 0,
          maxX: 10,
          minY: 3,
          maxY: 3,
          titlesData: titlesData,
        ),
      );

      // Measured on e60b4c13: one title, at the bottom of the axis.
      expect(
        titles.map((value, meta) => MapEntry(value, meta.axisPosition)),
        {3.0: 398.0},
      );
    },
  );

  testWidgets(
    'inverted X axis bottom titles match the normal axis (#1769)',
    (tester) async {
      LineChartData buildData(double minX, double maxX, FlTitlesData t) =>
          LineChartData(
            minX: minX,
            maxX: maxX,
            minY: 0,
            maxY: 10,
            titlesData: t,
          );
      final normal =
          await pumpTitles(tester, AxisSide.bottom, (t) => buildData(1, 18, t));
      final inverted =
          await pumpTitles(tester, AxisSide.bottom, (t) => buildData(18, 1, t));

      expect(inverted.keys.toSet(), normal.keys.toSet());
      for (final MapEntry(key: value, value: meta) in inverted.entries) {
        // getPixelX: minX on the left.
        expect(
          meta.axisPosition,
          closeTo((value - 18) / (1 - 18) * meta.parentAxisSize, 0.0001),
          reason: 'title $value',
        );
      }
      final positions = inverted.values.map((meta) => meta.axisPosition);
      expect(positions.toSet(), hasLength(positions.length));
    },
  );
}
