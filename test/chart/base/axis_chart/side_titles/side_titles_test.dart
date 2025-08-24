import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final data = [
    const FlSpot(0, 0.5),
    const FlSpot(1, 1.3),
    const FlSpot(2, 1.9),
  ];

  const viewSize = Size(400, 400);

  testWidgets(
    'Test the effect of minIncluded and maxIncluded in sideTitles',
    (WidgetTester tester) async {
      // Minimum/maximum included
      final mima = [
        [true, true],
        [true, false],
        [false, true],
        [false, false],
      ];

      for (final e in mima) {
        final titlesData = FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              minIncluded: e[0],
              maxIncluded: e[1],
              reservedSize: 50,
              interval: 1,
            ),
          ),
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          bottomTitles: const AxisTitles(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: viewSize.width,
                  height: viewSize.height,
                  child: LineChart(
                    LineChartData(
                      titlesData: titlesData,
                      lineBarsData: [
                        LineChartBarData(
                          spots: data,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        // Number of expected text widgets (titles) on the y-axis
        expect(
          find.byType(Text),
          findsNWidgets((e[0] ? 1 : 0) + (e[1] ? 1 : 0) + 1),
        );
        // Always there
        expect(find.text('1'), findsOneWidget);
        if (e[0]) {
          // Minimum included
          expect(find.text('0.5'), findsOneWidget);
        }
        if (e[1]) {
          // Maximum included
          expect(find.text('1.9'), findsOneWidget);
        }
      }
    },
  );

  testWidgets('LineChart with only left titles overlayed on chart area',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: viewSize.width,
              height: viewSize.height,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitleAlignment: SideTitleAlignment.inside,
                      axisNameWidget: const Text('Left Titles'),
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text('L-${value.toInt()}');
                        },
                        interval: 1,
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final leftTitleFinder = find.text('L-0');
    expect(leftTitleFinder, findsOneWidget);

    final leftTitleRect = tester.getRect(leftTitleFinder);

    final chartFinder = find.byType(LineChart);
    final chartRect = tester.getRect(chartFinder);

    expect(leftTitleRect.left >= chartRect.left, true);
  });

  testWidgets('LineChart with only left titles overlayed on chart border',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: viewSize.width,
              height: viewSize.height,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitleAlignment: SideTitleAlignment.border,
                      axisNameWidget: const Text('Left Titles'),
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text('L-${value.toInt()}');
                        },
                        interval: 1,
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final leftTitleFinder = find.text('L-0');
    expect(leftTitleFinder, findsOneWidget);

    final leftTitleRect = tester.getRect(leftTitleFinder);

    final chartFinder = find.byType(LineChart);
    final chartRect = tester.getRect(chartFinder);

    expect(leftTitleRect.left >= chartRect.left, true);
  });
}
