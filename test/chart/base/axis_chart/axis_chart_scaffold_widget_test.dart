import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_scaffold_widget.dart';
import 'package:fl_chart/src/chart/base/axis_chart/side_titles/side_titles_widget.dart';
import 'package:fl_chart/src/chart/base/custom_interactive_viewer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const viewSize = Size(400, 400);

  const dummyChartKey = Key('chart');
  const dummyChart = SizedBox(key: dummyChartKey);

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
      leftTitles: AxisTitles(
        axisNameWidget: const Icon(Icons.arrow_left),
        axisNameSize: 10,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 10,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text('L-${value.toInt()}');
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
            return Text('T-${value.toInt()}');
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
            return Text('R-${value.toInt()}');
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
            return Text('B-${value.toInt()}');
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
      ),
    ),
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        axisNameWidget: const Icon(Icons.arrow_left),
        axisNameSize: 10,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 10,
          getTitlesWidget: (double value, TitleMeta meta) {
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
    borderData: FlBorderData(show: false),
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        axisNameSize: 10,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 10,
          getTitlesWidget: (double value, TitleMeta meta) {
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

  final lineChartDataWithOnlyLeftAxisNameWithoutSideTitles =
      lineChartDataBase.copyWith(
    borderData: FlBorderData(show: false),
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        axisNameSize: 10,
        axisNameWidget: const Icon(Icons.arrow_left),
        sideTitles: SideTitles(
          reservedSize: 10,
          getTitlesWidget: (double value, TitleMeta meta) {
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
                  chartBuilder: (context, chartRect) => LayoutBuilder(
                    builder: (context, constraints) {
                      chartDrawingSize = constraints.biggest;
                      return const ColoredBox(
                        color: Colors.red,
                      );
                    },
                  ),
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
                  chartBuilder: (context, chartRect) => LayoutBuilder(
                    builder: (context, constraints) {
                      chartDrawingSize = constraints.biggest;
                      return const ColoredBox(
                        color: Colors.red,
                      );
                    },
                  ),
                  data: lineChartDataWithAllTitles,
                ),
              ),
            ),
          ),
        ),
      );

      Future<void> checkSide(AxisSide side) async {
        final axisChar = switch (side) {
          AxisSide.left => 'L',
          AxisSide.top => 'T',
          AxisSide.right => 'R',
          AxisSide.bottom => 'B',
        };
        for (var i = 0; i <= 10; i++) {
          expect(find.text('$axisChar-$i'), findsOneWidget);
        }
      }

      expect(chartDrawingSize, const Size(300, 260));
      expect(find.byIcon(Icons.arrow_left), findsOneWidget);
      await checkSide(AxisSide.left);

      expect(find.byIcon(Icons.arrow_drop_up), findsOneWidget);
      await checkSide(AxisSide.top);

      expect(find.byIcon(Icons.arrow_right), findsOneWidget);
      await checkSide(AxisSide.right);

      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
      await checkSide(AxisSide.bottom);

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
                  chartBuilder: (context, chartRect) => LayoutBuilder(
                    builder: (context, constraints) {
                      chartDrawingSize = constraints.biggest;
                      return const ColoredBox(
                        color: Colors.red,
                      );
                    },
                  ),
                  data: lineChartDataWithOnlyLeftTitles,
                ),
              ),
            ),
          ),
        ),
      );

      expect(chartDrawingSize, const Size(374, 400));
      expect(find.byIcon(Icons.arrow_left), findsOneWidget);
      for (var i = 0; i <= 10; i++) {
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
                  chartBuilder: (context, chartRect) => LayoutBuilder(
                    builder: (context, constraints) {
                      chartDrawingSize = constraints.biggest;
                      return const ColoredBox(
                        color: Colors.red,
                      );
                    },
                  ),
                  data: lineChartDataWithOnlyLeftTitlesWithoutAxisName,
                ),
              ),
            ),
          ),
        ),
      );

      expect(chartDrawingSize, const Size(390, 400));
      for (var i = 0; i <= 10; i++) {
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
                  chartBuilder: (context, chartRect) => LayoutBuilder(
                    builder: (context, constraints) {
                      chartDrawingSize = constraints.biggest;
                      return const ColoredBox(
                        color: Colors.red,
                      );
                    },
                  ),
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

  group('AxisChartScaffoldWidget', () {
    for (final scaleAxis in ScaleAxis.scalingEnabledAxis) {
      testWidgets(
        'wraps chart in interactive viewer when scaling is $scaleAxis',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: viewSize.width,
                    height: viewSize.height,
                    child: AxisChartScaffoldWidget(
                      data: lineChartDataWithAllTitles,
                      scaleAxis: scaleAxis,
                      chartBuilder: (context, chartRect) => dummyChart,
                    ),
                  ),
                ),
              ),
            ),
          );

          final interactiveViewer = find.ancestor(
            of: find.byKey(dummyChartKey),
            matching: find.byType(CustomInteractiveViewer),
          );
          expect(interactiveViewer, findsOneWidget);
        },
      );
    }

    testWidgets(
      'does not wrap chart in interactive viewer when scaling is disabled',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: viewSize.width,
                  height: viewSize.height,
                  child: AxisChartScaffoldWidget(
                    data: lineChartDataWithAllTitles,
                    // ignore: avoid_redundant_argument_values
                    scaleAxis: ScaleAxis.none,
                    chartBuilder: (context, chartRect) => dummyChart,
                  ),
                ),
              ),
            ),
          ),
        );

        final interactiveViewer = find.ancestor(
          of: find.byKey(dummyChartKey),
          matching: find.byType(CustomInteractiveViewer),
        );
        expect(interactiveViewer, findsNothing);
      },
    );

    testWidgets('passes interaction parameters to interactive viewer',
        (WidgetTester tester) async {
      Future<void> pumpTestWidget(AxisChartScaffoldWidget widget) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: viewSize.width,
                  height: viewSize.height,
                  child: widget,
                ),
              ),
            ),
          ),
        );
      }

      await pumpTestWidget(
        AxisChartScaffoldWidget(
          data: lineChartDataWithAllTitles,
          scaleAxis: ScaleAxis.free,
          chartBuilder: (context, chartRect) => dummyChart,
        ),
      );

      final interactiveViewer1 = tester.widget<CustomInteractiveViewer>(
        find.byType(CustomInteractiveViewer),
      );

      expect(interactiveViewer1.trackpadScrollCausesScale, false);
      expect(interactiveViewer1.maxScale, 2.5);
      expect(interactiveViewer1.minScale, 1);
      expect(interactiveViewer1.clipBehavior, Clip.none);

      final transformationController = TransformationController();
      await pumpTestWidget(
        AxisChartScaffoldWidget(
          data: lineChartDataWithAllTitles,
          scaleAxis: ScaleAxis.free,
          trackpadScrollCausesScale: true,
          maxScale: 10,
          minScale: 1.5,
          transformationController: transformationController,
          chartBuilder: (context, chartRect) => dummyChart,
        ),
      );

      final interactiveViewer2 = tester.widget<CustomInteractiveViewer>(
        find.byType(CustomInteractiveViewer),
      );
      expect(interactiveViewer2.trackpadScrollCausesScale, true);
      expect(interactiveViewer2.maxScale, 10);
      expect(interactiveViewer2.minScale, 1.5);
      expect(interactiveViewer2.clipBehavior, Clip.none);
      expect(
        interactiveViewer2.transformationController,
        transformationController,
      );
    });

    testWidgets('asserts minScale is greater than 1',
        (WidgetTester tester) async {
      expect(
        () => AxisChartScaffoldWidget(
          data: lineChartDataWithAllTitles,
          scaleAxis: ScaleAxis.free,
          minScale: 0.5,
          chartBuilder: (context, chartRect) => dummyChart,
        ),
        throwsAssertionError,
      );
    });

    testWidgets('asserts maxScale is greater than or equal to minScale',
        (WidgetTester tester) async {
      expect(
        () => AxisChartScaffoldWidget(
          data: lineChartDataWithAllTitles,
          scaleAxis: ScaleAxis.free,
          maxScale: 0.5,
          chartBuilder: (context, chartRect) => dummyChart,
        ),
        throwsAssertionError,
      );
    });

    group('scaling and panning', () {
      group('touch gesture', () {
        testWidgets('does not scale with ScaleAxis.none',
            (WidgetTester tester) async {
          Rect? chartRect;
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: viewSize.width,
                    height: viewSize.height,
                    child: AxisChartScaffoldWidget(
                      chartBuilder: (context, rect) {
                        chartRect = rect;
                        return dummyChart;
                      },
                      data: lineChartDataWithNoTitles,
                    ),
                  ),
                ),
              ),
            ),
          );

          final chartCenterOffset = tester.getCenter(find.byKey(dummyChartKey));
          final scaleStart1 = chartCenterOffset;
          final scaleStart2 = chartCenterOffset;
          final scaleEnd1 = chartCenterOffset + const Offset(100, 100);
          final scaleEnd2 = chartCenterOffset - const Offset(100, 100);

          final gesture1 = await tester.startGesture(scaleStart1);
          final gesture2 = await tester.startGesture(scaleStart2);
          await tester.pump();
          await gesture1.moveTo(scaleEnd1);
          await gesture2.moveTo(scaleEnd2);
          await tester.pump();
          await gesture1.up();
          await gesture2.up();
          await tester.pumpAndSettle();

          expect(chartRect, isNull);
        });

        testWidgets('scales freely with ScaleAxis.free',
            (WidgetTester tester) async {
          Rect? chartRect;
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: viewSize.width,
                    height: viewSize.height,
                    child: AxisChartScaffoldWidget(
                      scaleAxis: ScaleAxis.free,
                      chartBuilder: (context, rect) {
                        chartRect = rect;
                        return dummyChart;
                      },
                      data: lineChartDataWithNoTitles,
                    ),
                  ),
                ),
              ),
            ),
          );

          final renderBox = tester.renderObject<RenderBox>(
            find.byKey(dummyChartKey),
          );
          final chartCenterOffset = tester.getCenter(find.byKey(dummyChartKey));
          final scaleStart1 = chartCenterOffset + const Offset(10, 10);
          final scaleStart2 = chartCenterOffset - const Offset(10, 10);
          final scaleEnd1 = chartCenterOffset + const Offset(100, 100);
          final scaleEnd2 = chartCenterOffset - const Offset(100, 100);

          final gesture1 = await tester.startGesture(scaleStart1);
          final gesture2 = await tester.startGesture(scaleStart2);
          await tester.pump();
          await gesture1.moveTo(scaleEnd1);
          await gesture2.moveTo(scaleEnd2);
          await tester.pump();
          await gesture1.up();
          await gesture2.up();
          await tester.pumpAndSettle();

          expect(chartRect!.size, greaterThan(renderBox.size));
          expect(chartRect!.left, isNegative);
          expect(chartRect!.top, isNegative);
        });

        testWidgets('scales horizontally with ScaleAxis.horizontal',
            (WidgetTester tester) async {
          Rect? chartRect;
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: viewSize.width,
                    height: viewSize.height,
                    child: AxisChartScaffoldWidget(
                      scaleAxis: ScaleAxis.horizontal,
                      chartBuilder: (context, rect) {
                        chartRect = rect;
                        return dummyChart;
                      },
                      data: lineChartDataWithNoTitles,
                    ),
                  ),
                ),
              ),
            ),
          );

          final renderBox = tester.renderObject<RenderBox>(
            find.byKey(dummyChartKey),
          );
          final chartCenterOffset = tester.getCenter(find.byKey(dummyChartKey));
          final scaleStart1 = chartCenterOffset + const Offset(10, 10);
          final scaleStart2 = chartCenterOffset - const Offset(10, 10);
          final scaleEnd1 = chartCenterOffset + const Offset(100, 100);
          final scaleEnd2 = chartCenterOffset - const Offset(100, 100);

          final gesture1 = await tester.startGesture(scaleStart1);
          final gesture2 = await tester.startGesture(scaleStart2);
          await tester.pump();
          await gesture1.moveTo(scaleEnd1);
          await gesture2.moveTo(scaleEnd2);
          await tester.pump();
          await gesture1.up();
          await gesture2.up();
          await tester.pumpAndSettle();

          expect(chartRect!.size.height, renderBox.size.height);
          expect(chartRect!.size.width, greaterThan(renderBox.size.width));
          expect(chartRect!.left, isNegative);
          expect(chartRect!.top, 0);
        });

        testWidgets('scales vertically with ScaleAxis.vertical',
            (WidgetTester tester) async {
          Rect? chartRect;
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: viewSize.width,
                    height: viewSize.height,
                    child: AxisChartScaffoldWidget(
                      scaleAxis: ScaleAxis.vertical,
                      chartBuilder: (context, rect) {
                        chartRect = rect;
                        return dummyChart;
                      },
                      data: lineChartDataWithNoTitles,
                    ),
                  ),
                ),
              ),
            ),
          );

          final renderBox = tester.renderObject<RenderBox>(
            find.byKey(dummyChartKey),
          );
          final chartCenterOffset = tester.getCenter(find.byKey(dummyChartKey));
          final scaleStart1 = chartCenterOffset + const Offset(10, 10);
          final scaleStart2 = chartCenterOffset - const Offset(10, 10);
          final scaleEnd1 = chartCenterOffset + const Offset(100, 100);
          final scaleEnd2 = chartCenterOffset - const Offset(100, 100);

          final gesture1 = await tester.startGesture(scaleStart1);
          final gesture2 = await tester.startGesture(scaleStart2);
          await tester.pump();
          await gesture1.moveTo(scaleEnd1);
          await gesture2.moveTo(scaleEnd2);
          await tester.pump();
          await gesture1.up();
          await gesture2.up();
          await tester.pumpAndSettle();

          expect(chartRect!.size.height, greaterThan(renderBox.size.height));
          expect(chartRect!.size.width, renderBox.size.width);
          expect(chartRect!.left, 0);
          expect(chartRect!.top, isNegative);
        });
      });

      group('trackpad scroll', () {
        testWidgets(
          'does not scale with ScaleAxis.none when trackpadScrollCausesScale is true',
          (WidgetTester tester) async {
            Rect? chartRect;
            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(
                  body: Center(
                    child: SizedBox(
                      width: viewSize.width,
                      height: viewSize.height,
                      child: AxisChartScaffoldWidget(
                        trackpadScrollCausesScale: true,
                        chartBuilder: (context, rect) {
                          chartRect = rect;
                          return dummyChart;
                        },
                        data: lineChartDataWithNoTitles,
                      ),
                    ),
                  ),
                ),
              ),
            );

            final pointer = TestPointer(1, PointerDeviceKind.trackpad);
            final chartCenterOffset =
                tester.getCenter(find.byKey(dummyChartKey));
            const scrollAmount = Offset(0, -100);

            await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
            await tester.pump();
            await tester.sendEventToBinding(pointer.scroll(scrollAmount));
            await tester.pump();

            expect(chartRect, isNull);
          },
        );

        for (final scaleAxis in ScaleAxis.scalingEnabledAxis) {
          testWidgets(
            'does not scale when trackpadScrollCausesScale is false '
            'for $scaleAxis',
            (WidgetTester tester) async {
              Rect? chartRect;
              await tester.pumpWidget(
                MaterialApp(
                  home: Scaffold(
                    body: Center(
                      child: SizedBox(
                        width: viewSize.width,
                        height: viewSize.height,
                        child: AxisChartScaffoldWidget(
                          scaleAxis: scaleAxis,
                          chartBuilder: (context, rect) {
                            chartRect = rect;
                            return dummyChart;
                          },
                          data: lineChartDataWithNoTitles,
                        ),
                      ),
                    ),
                  ),
                ),
              );

              final pointer = TestPointer(1, PointerDeviceKind.trackpad);
              final chartCenterOffset = tester.getCenter(
                find.byKey(dummyChartKey),
              );
              const scrollAmount = Offset(0, -100);

              await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
              await tester.pump();
              await tester.sendEventToBinding(pointer.scroll(scrollAmount));
              await tester.pump();

              expect(chartRect, isNull);
            },
          );
        }

        testWidgets('scales horizontally with ScaleAxis.horizontal',
            (WidgetTester tester) async {
          Rect? chartRect;
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: viewSize.width,
                    height: viewSize.height,
                    child: AxisChartScaffoldWidget(
                      scaleAxis: ScaleAxis.horizontal,
                      trackpadScrollCausesScale: true,
                      chartBuilder: (context, rect) {
                        chartRect = rect;
                        return dummyChart;
                      },
                      data: lineChartDataWithNoTitles,
                    ),
                  ),
                ),
              ),
            ),
          );

          final renderBox = tester.renderObject<RenderBox>(
            find.byKey(dummyChartKey),
          );
          final pointer = TestPointer(1, PointerDeviceKind.trackpad);
          final chartCenterOffset = tester.getCenter(find.byKey(dummyChartKey));
          const scrollAmount = Offset(0, -100);

          await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
          await tester.pump();
          await tester.sendEventToBinding(pointer.scroll(scrollAmount));
          await tester.pump();

          expect(chartRect!.size.height, renderBox.size.height);
          expect(chartRect!.size.width, greaterThan(renderBox.size.width));
          expect(chartRect!.left, isNegative);
          expect(chartRect!.top, 0);
        });

        testWidgets('scales vertically with ScaleAxis.vertical',
            (WidgetTester tester) async {
          Rect? chartRect;
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: viewSize.width,
                    height: viewSize.height,
                    child: AxisChartScaffoldWidget(
                      scaleAxis: ScaleAxis.vertical,
                      trackpadScrollCausesScale: true,
                      chartBuilder: (context, rect) {
                        chartRect = rect;
                        return dummyChart;
                      },
                      data: lineChartDataWithNoTitles,
                    ),
                  ),
                ),
              ),
            ),
          );

          final renderBox = tester.renderObject<RenderBox>(
            find.byKey(dummyChartKey),
          );
          final pointer = TestPointer(1, PointerDeviceKind.trackpad);
          final chartCenterOffset = tester.getCenter(find.byKey(dummyChartKey));
          const scrollAmount = Offset(0, -100);

          await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
          await tester.pump();
          await tester.sendEventToBinding(pointer.scroll(scrollAmount));
          await tester.pump();

          expect(chartRect!.size.height, greaterThan(renderBox.size.height));
          expect(chartRect!.size.width, renderBox.size.width);
          expect(chartRect!.left, 0);
          expect(chartRect!.top, isNegative);
        });

        testWidgets('scales freely with ScaleAxis.free',
            (WidgetTester tester) async {
          Rect? chartRect;
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: viewSize.width,
                    height: viewSize.height,
                    child: AxisChartScaffoldWidget(
                      scaleAxis: ScaleAxis.free,
                      trackpadScrollCausesScale: true,
                      chartBuilder: (context, rect) {
                        chartRect = rect;
                        return dummyChart;
                      },
                      data: lineChartDataWithNoTitles,
                    ),
                  ),
                ),
              ),
            ),
          );

          final renderBox = tester.renderObject<RenderBox>(
            find.byKey(dummyChartKey),
          );
          final pointer = TestPointer(1, PointerDeviceKind.trackpad);
          final chartCenterOffset = tester.getCenter(find.byKey(dummyChartKey));
          const scrollAmount = Offset(0, -100);

          await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
          await tester.pump();
          await tester.sendEventToBinding(pointer.scroll(scrollAmount));
          await tester.pump();

          expect(chartRect!.size, greaterThan(renderBox.size));
          expect(chartRect!.left, isNegative);
          expect(chartRect!.top, isNegative);
        });
      });

      group('pans', () {
        testWidgets('only horizontally with ScaleAxis.horizontal',
            (WidgetTester tester) async {
          Rect? chartRect;
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: viewSize.width,
                    height: viewSize.height,
                    child: AxisChartScaffoldWidget(
                      scaleAxis: ScaleAxis.horizontal,
                      chartBuilder: (context, rect) {
                        chartRect = rect;
                        return const ColoredBox(
                          color: Colors.red,
                        );
                      },
                      data: lineChartDataWithNoTitles,
                    ),
                  ),
                ),
              ),
            ),
          );

          final chartCenterOffset = tester.getCenter(find.byType(ColoredBox));
          final scaleStart1 = chartCenterOffset + const Offset(10, 10);
          final scaleStart2 = chartCenterOffset - const Offset(10, 10);
          final scaleEnd1 = chartCenterOffset + const Offset(100, 100);
          final scaleEnd2 = chartCenterOffset - const Offset(100, 100);

          final gesture1 = await tester.startGesture(scaleStart1);
          final gesture2 = await tester.startGesture(scaleStart2);
          await gesture1.moveTo(scaleEnd1);
          await gesture2.moveTo(scaleEnd2);
          await gesture1.up();
          await gesture2.up();
          await tester.pumpAndSettle();

          final chartRectBeforePan = chartRect;
          expect(chartRectBeforePan!.top, 0);

          const panOffset = Offset(100, 100);
          await tester.dragFrom(chartCenterOffset, panOffset);
          await tester.pumpAndSettle();

          expect(chartRect!.size, chartRectBeforePan.size);
          expect(chartRect!.left, greaterThan(chartRectBeforePan.left));
          expect(chartRect!.top, 0);
        });

        testWidgets('only vertically with ScaleAxis.vertical',
            (WidgetTester tester) async {
          Rect? chartRect;
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: viewSize.width,
                    height: viewSize.height,
                    child: AxisChartScaffoldWidget(
                      scaleAxis: ScaleAxis.vertical,
                      chartBuilder: (context, rect) {
                        chartRect = rect;
                        return const ColoredBox(
                          color: Colors.red,
                        );
                      },
                      data: lineChartDataWithNoTitles,
                    ),
                  ),
                ),
              ),
            ),
          );

          final chartCenterOffset = tester.getCenter(find.byType(ColoredBox));
          final scaleStart1 = chartCenterOffset + const Offset(10, 10);
          final scaleStart2 = chartCenterOffset - const Offset(10, 10);
          final scaleEnd1 = chartCenterOffset + const Offset(100, 100);
          final scaleEnd2 = chartCenterOffset - const Offset(100, 100);

          final gesture1 = await tester.startGesture(scaleStart1);
          final gesture2 = await tester.startGesture(scaleStart2);
          await gesture1.moveTo(scaleEnd1);
          await gesture2.moveTo(scaleEnd2);
          await gesture1.up();
          await gesture2.up();
          await tester.pumpAndSettle();

          final chartRectBeforePan = chartRect;
          expect(chartRectBeforePan!.left, 0);

          const panOffset = Offset(100, 100);
          await tester.dragFrom(chartCenterOffset, panOffset);
          await tester.pumpAndSettle();

          expect(chartRect!.left, 0);
          expect(chartRect!.top, greaterThan(chartRectBeforePan.top));
        });

        testWidgets('freely with ScaleAxis.free', (WidgetTester tester) async {
          Rect? chartRect;
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: viewSize.width,
                    height: viewSize.height,
                    child: AxisChartScaffoldWidget(
                      scaleAxis: ScaleAxis.free,
                      chartBuilder: (context, rect) {
                        chartRect = rect;
                        return const ColoredBox(
                          color: Colors.red,
                        );
                      },
                      data: lineChartDataWithNoTitles,
                    ),
                  ),
                ),
              ),
            ),
          );

          final chartCenterOffset = tester.getCenter(find.byType(ColoredBox));
          final scaleStart1 = chartCenterOffset + const Offset(10, 10);
          final scaleStart2 = chartCenterOffset - const Offset(10, 10);
          final scaleEnd1 = chartCenterOffset + const Offset(100, 100);
          final scaleEnd2 = chartCenterOffset - const Offset(100, 100);

          final gesture1 = await tester.startGesture(scaleStart1);
          final gesture2 = await tester.startGesture(scaleStart2);
          await gesture1.moveTo(scaleEnd1);
          await gesture2.moveTo(scaleEnd2);
          await gesture1.up();
          await gesture2.up();
          await tester.pumpAndSettle();

          final chartRectBeforePan = chartRect;
          expect(chartRectBeforePan!.left, isNegative);
          expect(chartRectBeforePan.top, isNegative);

          const panOffset = Offset(100, 100);
          await tester.dragFrom(chartCenterOffset, panOffset);
          await tester.pumpAndSettle();

          expect(chartRect!.left, greaterThan(chartRectBeforePan.left));
          expect(chartRect!.top, greaterThan(chartRectBeforePan.top));
        });
      });
    });

    testWidgets('passes chart rect to SideTitlesWidgets',
        (WidgetTester tester) async {
      Rect? chartRect;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: viewSize.width,
                height: viewSize.height,
                child: AxisChartScaffoldWidget(
                  scaleAxis: ScaleAxis.free,
                  chartBuilder: (context, rect) {
                    chartRect = rect;
                    return const ColoredBox(
                      color: Colors.red,
                    );
                  },
                  data: lineChartDataWithAllTitles,
                ),
              ),
            ),
          ),
        ),
      );

      final chartCenterOffset = tester.getCenter(find.byType(ColoredBox));
      final scaleStart1 = chartCenterOffset + const Offset(10, 10);
      final scaleStart2 = chartCenterOffset - const Offset(10, 10);
      final scaleEnd1 = chartCenterOffset + const Offset(100, 100);
      final scaleEnd2 = chartCenterOffset - const Offset(100, 100);

      final gesture1 = await tester.startGesture(scaleStart1);
      final gesture2 = await tester.startGesture(scaleStart2);
      await gesture1.moveTo(scaleEnd1);
      await gesture2.moveTo(scaleEnd2);
      await gesture1.up();
      await gesture2.up();
      await tester.pumpAndSettle();

      final sideTitlesWidgets = tester.allWidgets.whereType<SideTitlesWidget>();
      expect(sideTitlesWidgets.length, 4);
      for (final sideTitlesWidget in sideTitlesWidgets) {
        expect(sideTitlesWidget.boundingBox, chartRect);
      }
    });

    testWidgets(
      'updates chart rect after the first frame when controller scale != 1.0',
      (WidgetTester tester) async {
        final controller = TransformationController(
          Matrix4.identity()..scale(3.0),
        );
        Rect? chartRect;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: AxisChartScaffoldWidget(
                  data: lineChartDataWithNoTitles,
                  transformationController: controller,
                  chartBuilder: (context, rect) {
                    chartRect = rect;
                    return dummyChart;
                  },
                ),
              ),
            ),
          ),
        );

        expect(chartRect, isNull);
        await tester.pump();
        expect(chartRect, isNotNull);
      },
    );

    group('didUpdateWidget', () {
      const chartScaffoldKey = Key('chartScaffold');

      final chartRects = <Rect?>[];

      const Rect? isNotScaled = null;
      final isScaled = isA<Rect>();

      tearDown(chartRects.clear);

      Widget createTestWidget({
        TransformationController? controller,
      }) {
        return MaterialApp(
          home: Scaffold(
            body: Center(
              child: AxisChartScaffoldWidget(
                key: chartScaffoldKey,
                data: lineChartDataWithNoTitles,
                scaleAxis: ScaleAxis.free,
                transformationController: controller,
                chartBuilder: (context, rect) {
                  chartRects.add(rect);
                  return dummyChart;
                },
              ),
            ),
          ),
        );
      }

      TransformationController? getTransformationController(
        WidgetTester tester,
      ) {
        return tester
            .widget<CustomInteractiveViewer>(
              find.byType(CustomInteractiveViewer),
            )
            .transformationController;
      }

      testWidgets(
        'oldWidget.controller is null and widget.controller is null: '
        'keeps old controller',
        (WidgetTester tester) async {
          final actualChartRects = <Object?>[isNotScaled, isNotScaled];
          await tester.pumpWidget(createTestWidget());
          await tester.pump();
          expect(chartRects, actualChartRects);

          final transformationController = getTransformationController(tester);
          transformationController!.value = Matrix4.identity()..scale(2.0);
          await tester.pump();
          expect(chartRects, actualChartRects..add(isScaled));

          await tester.pumpWidget(createTestWidget());
          expect(chartRects, actualChartRects..add(isScaled));
          await tester.pump();
          expect(chartRects, actualChartRects..add(isScaled));

          final transformationController2 = getTransformationController(tester);
          expect(transformationController2, transformationController);
          transformationController2!.value = Matrix4.identity()..scale(3.0);
          await tester.pump();
          expect(chartRects, actualChartRects..add(isScaled));
        },
      );

      testWidgets(
        'oldWidget.controller is null and widget.controller is not null: '
        'disposes old controller and sets up widget.controller with listeners',
        (WidgetTester tester) async {
          final actualChartRects = <Object?>[isNotScaled, isNotScaled];
          await tester.pumpWidget(createTestWidget());
          await tester.pump();
          expect(chartRects, actualChartRects);

          final transformationController = getTransformationController(tester);
          transformationController!.value = Matrix4.identity()..scale(2.0);
          await tester.pump();
          expect(chartRects, actualChartRects..add(isScaled));

          final transformationController2 = TransformationController();

          await tester.pumpWidget(
            createTestWidget(controller: transformationController2),
          );
          expect(chartRects, actualChartRects..add(isScaled));
          await tester.pump();
          expect(chartRects, actualChartRects..add(isNotScaled));

          expect(transformationController2, isNot(transformationController));
          transformationController2.value = Matrix4.identity()..scale(2.0);
          await tester.pump();
          expect(chartRects, actualChartRects..add(isScaled));
        },
      );

      testWidgets(
        'oldWidget.controller is not null and widget.controller is null: '
        'disposes old controller and sets up new controller with listeners',
        (WidgetTester tester) async {
          final actualChartRects = <Object?>[isNotScaled, isNotScaled];
          final transformationController = TransformationController();
          await tester.pumpWidget(
            createTestWidget(controller: transformationController),
          );
          await tester.pump();
          expect(chartRects, actualChartRects);

          transformationController.value = Matrix4.identity()..scale(2.0);
          await tester.pump();
          expect(chartRects, actualChartRects..add(isScaled));

          await tester.pumpWidget(createTestWidget());
          expect(chartRects, actualChartRects..add(isScaled));
          await tester.pump();
          expect(chartRects, actualChartRects..add(isNotScaled));

          final transformationController2 = getTransformationController(tester);
          expect(transformationController2, isNot(transformationController));
          transformationController2!.value = Matrix4.identity()..scale(2.0);
          await tester.pump();
          expect(chartRects, actualChartRects..add(isScaled));
        },
      );

      testWidgets(
        'oldWidget.controller is not null and widget.controller is not null, '
        'controllers are different: '
        'disposes old controller and sets up widget.controller with listeners',
        (WidgetTester tester) async {
          final actualChartRects = <Object?>[isNotScaled, isNotScaled];
          final transformationController = TransformationController();
          await tester.pumpWidget(
            createTestWidget(controller: transformationController),
          );
          await tester.pump();
          expect(chartRects, actualChartRects);

          transformationController.value = Matrix4.identity()..scale(2.0);
          await tester.pump();
          expect(chartRects, actualChartRects..add(isScaled));

          final transformationController2 = TransformationController();

          await tester.pumpWidget(
            createTestWidget(controller: transformationController2),
          );
          expect(chartRects, actualChartRects..add(isScaled));
          await tester.pump();
          expect(chartRects, actualChartRects..add(isNotScaled));

          expect(transformationController2, isNot(transformationController));
          transformationController2.value = Matrix4.identity()..scale(2.0);
          await tester.pump();
          expect(chartRects, actualChartRects..add(isScaled));
        },
      );

      testWidgets(
        'oldWidget.controller is not null and widget.controller is not null, '
        'controllers are the same: keeps old controller',
        (WidgetTester tester) async {
          final actualChartRects = <Object?>[isNotScaled, isNotScaled];
          final transformationController = TransformationController();
          await tester.pumpWidget(
            createTestWidget(
              controller: transformationController,
            ),
          );
          await tester.pump();
          expect(chartRects, actualChartRects);

          transformationController.value = Matrix4.identity()..scale(2.0);
          await tester.pump();
          expect(chartRects, actualChartRects..add(isScaled));

          await tester.pumpWidget(
            createTestWidget(
              controller: transformationController,
            ),
          );
          expect(chartRects, actualChartRects..add(isScaled));
          await tester.pump();
          expect(chartRects, actualChartRects..add(isScaled));

          final transformationController2 = getTransformationController(tester);
          expect(transformationController2, transformationController);
          transformationController.value = Matrix4.identity()..scale(3.0);
          await tester.pump();
          expect(chartRects, actualChartRects..add(isScaled));
        },
      );
    });
  });
}
