import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_scaffold_widget.dart';
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
    borderData: FlBorderData(show: false),
  );

  final lineChartDataWithAllTitles = lineChartDataBase.copyWith(
    borderData: FlBorderData(
      show: true,
      border: Border.all(
        color: Colors.red,
        width: 10,
      ),
    ),
    titlesData: FlTitlesData(
      show: true,
      leftTitles: AxisTitles(
        axisNameWidget: const Icon(Icons.arrow_left),
        axisNameSize: 10,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 10,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text('L-${value.toInt().toString()}');
          },
          interval: 1,
        ),
      ),
      topTitles: AxisTitles(
        axisNameWidget: const Icon(Icons.arrow_drop_up),
        axisNameSize: 20,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 20,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text('T-${value.toInt().toString()}');
          },
          interval: 1,
        ),
      ),
      rightTitles: AxisTitles(
        axisNameWidget: const Icon(Icons.arrow_right),
        axisNameSize: 30,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text('R-${value.toInt().toString()}');
          },
          interval: 1,
        ),
      ),
      bottomTitles: AxisTitles(
        axisNameWidget: const Icon(Icons.arrow_drop_down),
        axisNameSize: 40,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text('B-${value.toInt().toString()}');
          },
          interval: 1,
        ),
      ),
    ),
  );

  final lineChartDataWithOnlyLeftTitles = lineChartDataBase.copyWith(
    borderData: FlBorderData(
      show: true,
      border: const Border(
        left: BorderSide(
          color: Colors.red,
          width: 6,
        ),
        top: BorderSide.none,
        right: BorderSide.none,
        bottom: BorderSide.none,
      ),
    ),
    titlesData: FlTitlesData(
      show: true,
      leftTitles: AxisTitles(
        axisNameWidget: const Icon(Icons.arrow_left),
        axisNameSize: 10,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 10,
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
    borderData: FlBorderData(show: false),
    titlesData: FlTitlesData(
      show: true,
      leftTitles: AxisTitles(
        axisNameSize: 10,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 10,
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

  final lineChartDataWithOnlyLeftAxisNameWithoutSideTitles =
      lineChartDataBase.copyWith(
    borderData: FlBorderData(show: false),
    titlesData: FlTitlesData(
      show: true,
      leftTitles: AxisTitles(
        axisNameSize: 10,
        axisNameWidget: const Icon(Icons.arrow_left),
        sideTitles: SideTitles(
          showTitles: false,
          reservedSize: 10,
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

  testWidgets(
    'LineChart with no titles',
    (WidgetTester tester) async {
      Size? chartDrawingSize;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: viewSize.width,
                height: viewSize.height,
                child: AxisChartScaffoldWidget(
                  chart: LayoutBuilder(builder: (context, constraints) {
                    chartDrawingSize = constraints.biggest;
                    return Container(
                      color: Colors.red,
                    );
                  }),
                  data: lineChartDataWithNoTitles,
                ),
              ),
            ),
          ),
        ),
      );
      expect(chartDrawingSize, viewSize);
      expect(find.byType(Text), findsNothing);
      expect(find.byType(Icon), findsNothing);
    },
  );

  testWidgets(
    'LineChart with all titles',
    (WidgetTester tester) async {
      Size? chartDrawingSize;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: viewSize.width,
                height: viewSize.height,
                child: AxisChartScaffoldWidget(
                  chart: LayoutBuilder(builder: (context, constraints) {
                    chartDrawingSize = constraints.biggest;
                    return Container(
                      color: Colors.red,
                    );
                  }),
                  data: lineChartDataWithAllTitles,
                ),
              ),
            ),
          ),
        ),
      );

      Future checkSide(AxisSide side) async {
        String axisChar;
        switch (side) {
          case AxisSide.left:
            axisChar = 'L';
            break;
          case AxisSide.top:
            axisChar = 'T';
            break;
          case AxisSide.right:
            axisChar = 'R';
            break;
          case AxisSide.bottom:
            axisChar = 'B';
            break;
          default:
            throw StateError('Invalid');
        }
        for (int i = 0; i <= 10; i++) {
          expect(find.text('$axisChar-$i'), findsOneWidget);
        }
      }

      expect(chartDrawingSize, const Size(300, 260));
      expect(find.byIcon(Icons.arrow_left), findsOneWidget);
      checkSide(AxisSide.left);

      expect(find.byIcon(Icons.arrow_drop_up), findsOneWidget);
      checkSide(AxisSide.top);

      expect(find.byIcon(Icons.arrow_right), findsOneWidget);
      checkSide(AxisSide.right);

      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
      checkSide(AxisSide.bottom);

      expect(find.byType(Text), findsNWidgets(44));
      expect(find.byType(Icon), findsNWidgets(4));
    },
  );

  testWidgets(
    'LineChart with only left titles',
    (WidgetTester tester) async {
      Size? chartDrawingSize;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: viewSize.width,
                height: viewSize.height,
                child: AxisChartScaffoldWidget(
                  chart: LayoutBuilder(builder: (context, constraints) {
                    chartDrawingSize = constraints.biggest;
                    return Container(
                      color: Colors.red,
                    );
                  }),
                  data: lineChartDataWithOnlyLeftTitles,
                ),
              ),
            ),
          ),
        ),
      );

      expect(chartDrawingSize, const Size(374, 400));
      expect(find.byIcon(Icons.arrow_left), findsOneWidget);
      for (int i = 0; i <= 10; i++) {
        expect(find.text('L-$i'), findsOneWidget);
      }

      expect(find.byType(Text), findsNWidgets(11));
      expect(find.byType(Icon), findsNWidgets(1));
    },
  );

  testWidgets(
    'LineChart with only left titles without axis name',
    (WidgetTester tester) async {
      Size? chartDrawingSize;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: viewSize.width,
                height: viewSize.height,
                child: AxisChartScaffoldWidget(
                  chart: LayoutBuilder(builder: (context, constraints) {
                    chartDrawingSize = constraints.biggest;
                    return Container(
                      color: Colors.red,
                    );
                  }),
                  data: lineChartDataWithOnlyLeftTitlesWithoutAxisName,
                ),
              ),
            ),
          ),
        ),
      );

      expect(chartDrawingSize, const Size(390, 400));
      for (int i = 0; i <= 10; i++) {
        expect(find.text('L-$i'), findsOneWidget);
      }

      expect(find.byType(Text), findsNWidgets(11));
      expect(find.byType(Icon), findsNothing);
    },
  );

  testWidgets(
    'LineChart with only left axis name without side titles',
    (WidgetTester tester) async {
      Size? chartDrawingSize;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: viewSize.width,
                height: viewSize.height,
                child: AxisChartScaffoldWidget(
                  chart: LayoutBuilder(builder: (context, constraints) {
                    chartDrawingSize = constraints.biggest;
                    return Container(
                      color: Colors.red,
                    );
                  }),
                  data: lineChartDataWithOnlyLeftAxisNameWithoutSideTitles,
                ),
              ),
            ),
          ),
        ),
      );

      expect(chartDrawingSize, const Size(390, 400));
      expect(find.byType(Text), findsNothing);
      expect(find.byType(Icon), findsOneWidget);
    },
  );
}
