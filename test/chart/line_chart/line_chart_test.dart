import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_scaffold_widget.dart';
import 'package:fl_chart/src/chart/base/axis_chart/scale_axis.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_data.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_renderer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget({
    required LineChart chart,
  }) {
    return MaterialApp(
      home: chart,
    );
  }

  group('LineChart', () {
    testWidgets('has correct default values', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          chart: LineChart(
            LineChartData(),
          ),
        ),
      );

      final lineChart = tester.widget<LineChart>(find.byType(LineChart));
      expect(lineChart.scaleAxis, ScaleAxis.none);
      expect(lineChart.trackpadScrollCausesScale, false);
      expect(lineChart.maxScale, 2.5);
    });

    testWidgets('passes interaction parameters to AxisChartScaffoldWidget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          chart: LineChart(
            LineChartData(),
          ),
        ),
      );

      final axisChartScaffoldWidget = tester.widget<AxisChartScaffoldWidget>(
        find.byType(AxisChartScaffoldWidget),
      );

      expect(axisChartScaffoldWidget.maxScale, 2.5);
      expect(axisChartScaffoldWidget.scaleAxis, ScaleAxis.none);
      expect(axisChartScaffoldWidget.trackpadScrollCausesScale, false);

      await tester.pumpAndSettle();

      await tester.pumpWidget(
        createTestWidget(
          chart: LineChart(
            LineChartData(),
            scaleAxis: ScaleAxis.free,
            trackpadScrollCausesScale: true,
            maxScale: 10,
          ),
        ),
      );

      final axisChartScaffoldWidget1 = tester.widget<AxisChartScaffoldWidget>(
        find.byType(AxisChartScaffoldWidget),
      );

      expect(axisChartScaffoldWidget1.maxScale, 10);
      expect(axisChartScaffoldWidget1.scaleAxis, ScaleAxis.free);
      expect(axisChartScaffoldWidget1.trackpadScrollCausesScale, true);
    });

    final scalingEnabledAxis = [
      ScaleAxis.free,
      ScaleAxis.horizontal,
      ScaleAxis.vertical,
    ];
    for (final scaleAxis in scalingEnabledAxis) {
      testWidgets('passes canBeScaled true for $scaleAxis',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: LineChart(
              LineChartData(),
              scaleAxis: scaleAxis,
            ),
          ),
        );

        final lineChartLeaf = tester.widget<LineChartLeaf>(
          find.byType(LineChartLeaf),
        );
        expect(lineChartLeaf.canBeScaled, true);
      });
    }

    testWidgets('passes canBeScaled false for ScaleAxis.none',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          chart: LineChart(
            LineChartData(),
            // ignore: avoid_redundant_argument_values
            scaleAxis: ScaleAxis.none,
          ),
        ),
      );

      final lineChartLeaf = tester.widget<LineChartLeaf>(
        find.byType(LineChartLeaf),
      );
      expect(lineChartLeaf.canBeScaled, false);
    });

    group('touch gesture', () {
      testWidgets('does not scale with ScaleAxis.none',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: LineChart(
              LineChartData(),
            ),
          ),
        );

        final lineChartCenterOffset =
            tester.getCenter(find.byType(LineChartLeaf));
        final scaleStart1 = lineChartCenterOffset;
        final scaleStart2 = lineChartCenterOffset;
        final scaleEnd1 = lineChartCenterOffset + const Offset(100, 100);
        final scaleEnd2 = lineChartCenterOffset - const Offset(100, 100);

        final gesture1 = await tester.startGesture(scaleStart1);
        final gesture2 = await tester.startGesture(scaleStart2);
        await tester.pump();
        await gesture1.moveTo(scaleEnd1);
        await gesture2.moveTo(scaleEnd2);
        await tester.pump();
        await gesture1.up();
        await gesture2.up();
        await tester.pumpAndSettle();

        final lineChartLeaf = tester.widget<LineChartLeaf>(
          find.byType(LineChartLeaf),
        );

        expect(lineChartLeaf.boundingBox, isNull);
      });

      testWidgets('scales freely with ScaleAxis.free',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: LineChart(
              LineChartData(),
              scaleAxis: ScaleAxis.free,
            ),
          ),
        );

        final lineChartCenterOffset =
            tester.getCenter(find.byType(LineChartLeaf));
        final scaleStart1 = lineChartCenterOffset;
        final scaleStart2 = lineChartCenterOffset;
        final scaleEnd1 = lineChartCenterOffset + const Offset(100, 100);
        final scaleEnd2 = lineChartCenterOffset - const Offset(100, 100);

        final gesture1 = await tester.startGesture(scaleStart1);
        final gesture2 = await tester.startGesture(scaleStart2);
        await tester.pump();
        await gesture1.moveTo(scaleEnd1);
        await gesture2.moveTo(scaleEnd2);
        await tester.pump();
        await gesture1.up();
        await gesture2.up();
        await tester.pumpAndSettle();

        final lineChartLeaf = tester.widget<LineChartLeaf>(
          find.byType(LineChartLeaf),
        );
        final renderBox = tester.renderObject<RenderBox>(
          find.byType(LineChartLeaf),
        );
        final boundingBox = lineChartLeaf.boundingBox!;

        expect(boundingBox.size, greaterThan(renderBox.size));
        expect(boundingBox.left, isNegative);
        expect(boundingBox.top, isNegative);
      });

      testWidgets('scales horizontally with ScaleAxis.horizontal',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: LineChart(
              LineChartData(),
              scaleAxis: ScaleAxis.horizontal,
            ),
          ),
        );

        final chartCenterOffset = tester.getCenter(find.byType(LineChartLeaf));
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

        final lineChartLeaf = tester.widget<LineChartLeaf>(
          find.byType(LineChartLeaf),
        );
        final renderBox = tester.renderObject<RenderBox>(
          find.byType(LineChartLeaf),
        );
        final boundingBox = lineChartLeaf.boundingBox!;

        expect(boundingBox.size.height, renderBox.size.height);
        expect(boundingBox.size.width, greaterThan(renderBox.size.width));
        expect(boundingBox.left, isNegative);
        expect(boundingBox.top, 0);
      });

      testWidgets('scales vertically with ScaleAxis.vertical',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: LineChart(
              LineChartData(),
              scaleAxis: ScaleAxis.vertical,
            ),
          ),
        );

        final chartCenterOffset = tester.getCenter(find.byType(LineChartLeaf));
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

        final lineChartLeaf = tester.widget<LineChartLeaf>(
          find.byType(LineChartLeaf),
        );
        final renderBox = tester.renderObject<RenderBox>(
          find.byType(LineChartLeaf),
        );
        final boundingBox = lineChartLeaf.boundingBox!;

        expect(boundingBox.size.height, greaterThan(renderBox.size.height));
        expect(boundingBox.size.width, renderBox.size.width);
        expect(boundingBox.left, 0);
        expect(boundingBox.top, isNegative);
      });

      group('pans', () {
        testWidgets('only horizontally with ScaleAxis.horizontal',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: LineChart(
                LineChartData(),
                scaleAxis: ScaleAxis.horizontal,
              ),
            ),
          );

          final chartCenterOffset = tester.getCenter(
            find.byType(LineChartLeaf),
          );
          final scaleStart1 = chartCenterOffset;
          final scaleStart2 = chartCenterOffset;
          final scaleEnd1 = chartCenterOffset + const Offset(100, 100);
          final scaleEnd2 = chartCenterOffset - const Offset(100, 100);

          final gesture1 = await tester.startGesture(scaleStart1);
          final gesture2 = await tester.startGesture(scaleStart2);
          await gesture1.moveTo(scaleEnd1);
          await gesture2.moveTo(scaleEnd2);
          await gesture1.up();
          await gesture2.up();
          await tester.pumpAndSettle();

          final lineChartLeafBeforePan = tester.widget<LineChartLeaf>(
            find.byType(LineChartLeaf),
          );
          final boundingBoxBeforePan = lineChartLeafBeforePan.boundingBox!;
          expect(boundingBoxBeforePan.top, 0);

          const panOffset = Offset(100, 100);
          await tester.dragFrom(chartCenterOffset, panOffset);
          await tester.pumpAndSettle();

          final lineChartLeafAfterPan = tester.widget<LineChartLeaf>(
            find.byType(LineChartLeaf),
          );
          final boundingBoxAfterPan = lineChartLeafAfterPan.boundingBox!;

          expect(boundingBoxBeforePan.size, boundingBoxAfterPan.size);
          expect(
            boundingBoxAfterPan.left,
            greaterThan(boundingBoxBeforePan.left),
          );
          expect(boundingBoxAfterPan.top, 0);
        });

        testWidgets('only vertically with ScaleAxis.vertical',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: LineChart(
                LineChartData(),
                scaleAxis: ScaleAxis.vertical,
              ),
            ),
          );

          final chartCenterOffset = tester.getCenter(
            find.byType(LineChartLeaf),
          );
          final scaleStart1 = chartCenterOffset;
          final scaleStart2 = chartCenterOffset;
          final scaleEnd1 = chartCenterOffset + const Offset(100, 100);
          final scaleEnd2 = chartCenterOffset - const Offset(100, 100);

          final gesture1 = await tester.startGesture(scaleStart1);
          final gesture2 = await tester.startGesture(scaleStart2);
          await gesture1.moveTo(scaleEnd1);
          await gesture2.moveTo(scaleEnd2);
          await gesture1.up();
          await gesture2.up();
          await tester.pumpAndSettle();

          final lineChartLeafBeforePan = tester.widget<LineChartLeaf>(
            find.byType(LineChartLeaf),
          );
          final boundingBoxBeforePan = lineChartLeafBeforePan.boundingBox!;
          expect(boundingBoxBeforePan.left, 0);

          const panOffset = Offset(100, 100);
          await tester.dragFrom(chartCenterOffset, panOffset);
          await tester.pumpAndSettle();

          final lineChartLeafAfterPan = tester.widget<LineChartLeaf>(
            find.byType(LineChartLeaf),
          );
          final boundingBoxAfterPan = lineChartLeafAfterPan.boundingBox!;

          expect(boundingBoxAfterPan.left, 0);
          expect(
            boundingBoxAfterPan.top,
            greaterThan(boundingBoxBeforePan.top),
          );
        });

        testWidgets('freely with ScaleAxis.free', (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: LineChart(
                LineChartData(),
                scaleAxis: ScaleAxis.free,
              ),
            ),
          );

          final chartCenterOffset = tester.getCenter(
            find.byType(LineChartLeaf),
          );
          final scaleStart1 = chartCenterOffset;
          final scaleStart2 = chartCenterOffset;
          final scaleEnd1 = chartCenterOffset + const Offset(100, 100);
          final scaleEnd2 = chartCenterOffset - const Offset(100, 100);

          final gesture1 = await tester.startGesture(scaleStart1);
          final gesture2 = await tester.startGesture(scaleStart2);
          await gesture1.moveTo(scaleEnd1);
          await gesture2.moveTo(scaleEnd2);
          await gesture1.up();
          await gesture2.up();
          await tester.pumpAndSettle();

          final lineChartLeafBeforePan = tester.widget<LineChartLeaf>(
            find.byType(LineChartLeaf),
          );
          final boundingBoxBeforePan = lineChartLeafBeforePan.boundingBox!;
          expect(boundingBoxBeforePan.left, isNegative);
          expect(boundingBoxBeforePan.top, isNegative);

          const panOffset = Offset(100, 100);
          await tester.dragFrom(chartCenterOffset, panOffset);
          await tester.pumpAndSettle();

          final lineChartLeafAfterPan = tester.widget<LineChartLeaf>(
            find.byType(LineChartLeaf),
          );
          final boundingBoxAfterPan = lineChartLeafAfterPan.boundingBox!;

          expect(
            boundingBoxAfterPan.left,
            greaterThan(boundingBoxBeforePan.left),
          );
          expect(
            boundingBoxAfterPan.top,
            greaterThan(boundingBoxBeforePan.top),
          );
        });
      });
    });

    group('trackpad scroll', () {
      group('pans', () {
        testWidgets('only horizontally with ScaleAxis.horizontal',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: LineChart(
                LineChartData(),
                scaleAxis: ScaleAxis.horizontal,
              ),
            ),
          );

          final chartCenterOffset =
              tester.getCenter(find.byType(LineChartLeaf));
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

          final lineChartLeafBeforePan = tester.widget<LineChartLeaf>(
            find.byType(LineChartLeaf),
          );

          final boundingBoxBeforePan = lineChartLeafBeforePan.boundingBox!;
          expect(boundingBoxBeforePan.top, 0);

          final pointer = TestPointer(1, PointerDeviceKind.trackpad);
          const leftAndUp = Offset(-100, -100);
          await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
          await tester.pump();
          await tester.sendEventToBinding(pointer.scroll(leftAndUp));
          await tester.pump();

          final lineChartLeafAfterPan = tester.widget<LineChartLeaf>(
            find.byType(LineChartLeaf),
          );
          final boundingBoxAfterPan = lineChartLeafAfterPan.boundingBox!;

          expect(
            boundingBoxAfterPan.left,
            greaterThan(boundingBoxBeforePan.left),
          );
          expect(boundingBoxAfterPan.top, 0);
        });

        testWidgets('vertically with ScaleAxis.vertical',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: LineChart(
                LineChartData(),
                scaleAxis: ScaleAxis.vertical,
              ),
            ),
          );

          final chartCenterOffset = tester.getCenter(
            find.byType(LineChartLeaf),
          );
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

          final lineChartLeafBeforePan = tester.widget<LineChartLeaf>(
            find.byType(LineChartLeaf),
          );

          final boundingBoxBeforePan = lineChartLeafBeforePan.boundingBox!;
          expect(boundingBoxBeforePan.left, 0);

          final pointer = TestPointer(1, PointerDeviceKind.trackpad);
          const leftAndUp = Offset(-100, -100);
          await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
          await tester.pump();
          await tester.sendEventToBinding(pointer.scroll(leftAndUp));
          await tester.pump();

          final lineChartLeafAfterPan = tester.widget<LineChartLeaf>(
            find.byType(LineChartLeaf),
          );
          final boundingBoxAfterPan = lineChartLeafAfterPan.boundingBox!;

          expect(boundingBoxAfterPan.left, 0);
          expect(
            boundingBoxAfterPan.top,
            greaterThan(boundingBoxBeforePan.top),
          );
        });

        testWidgets('freely with ScaleAxis.free', (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: LineChart(
                LineChartData(),
                scaleAxis: ScaleAxis.free,
              ),
            ),
          );

          final chartCenterOffset = tester.getCenter(
            find.byType(LineChartLeaf),
          );
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

          final lineChartLeafBeforePan = tester.widget<LineChartLeaf>(
            find.byType(LineChartLeaf),
          );

          final boundingBoxBeforePan = lineChartLeafBeforePan.boundingBox!;

          final pointer = TestPointer(1, PointerDeviceKind.trackpad);
          const leftAndUp = Offset(-100, -100);
          await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
          await tester.pump();
          await tester.sendEventToBinding(pointer.scroll(leftAndUp));
          await tester.pump();

          final lineChartLeafAfterPan = tester.widget<LineChartLeaf>(
            find.byType(LineChartLeaf),
          );
          final boundingBoxAfterPan = lineChartLeafAfterPan.boundingBox!;

          expect(
            boundingBoxAfterPan.left,
            greaterThan(boundingBoxBeforePan.left),
          );
          expect(
            boundingBoxAfterPan.top,
            greaterThan(boundingBoxBeforePan.top),
          );
        });
      });

      testWidgets(
        'does not scale with ScaleAxis.none when '
        'trackpadScrollCausesScale is true',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: LineChart(
                LineChartData(),
                // ignore: avoid_redundant_argument_values
                scaleAxis: ScaleAxis.none,
                trackpadScrollCausesScale: true,
              ),
            ),
          );

          final pointer = TestPointer(1, PointerDeviceKind.trackpad);
          final chartCenterOffset = tester.getCenter(
            find.byType(LineChartLeaf),
          );
          const scrollAmount = Offset(0, -100);

          await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
          await tester.pump();
          await tester.sendEventToBinding(pointer.scroll(scrollAmount));
          await tester.pump();

          final lineChartLeaf = tester.widget<LineChartLeaf>(
            find.byType(LineChartLeaf),
          );
          expect(lineChartLeaf.boundingBox, null);
        },
      );

      final scalingAxis = [
        ScaleAxis.free,
        ScaleAxis.horizontal,
        ScaleAxis.vertical,
      ];
      for (final scaleAxis in scalingAxis) {
        testWidgets(
          'does not scale when trackpadScrollCausesScale is false '
          'for $scaleAxis',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              createTestWidget(
                chart: LineChart(
                  LineChartData(),
                  scaleAxis: scaleAxis,
                  // ignore: avoid_redundant_argument_values
                  trackpadScrollCausesScale: false,
                ),
              ),
            );

            final pointer = TestPointer(1, PointerDeviceKind.trackpad);
            final chartCenterOffset = tester.getCenter(
              find.byType(LineChartLeaf),
            );
            const scrollAmount = Offset(0, -100);

            await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
            await tester.pump();
            await tester.sendEventToBinding(pointer.scroll(scrollAmount));
            await tester.pump();

            final lineChartLeaf = tester.widget<LineChartLeaf>(
              find.byType(LineChartLeaf),
            );
            expect(lineChartLeaf.boundingBox, null);
          },
        );
      }

      testWidgets('scales horizontally with ScaleAxis.horizontal',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: LineChart(
              LineChartData(),
              scaleAxis: ScaleAxis.horizontal,
              trackpadScrollCausesScale: true,
            ),
          ),
        );

        final pointer = TestPointer(1, PointerDeviceKind.trackpad);
        final chartCenterOffset = tester.getCenter(find.byType(LineChartLeaf));
        const scrollAmount = Offset(0, -100);

        await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
        await tester.pump();
        await tester.sendEventToBinding(pointer.scroll(scrollAmount));
        await tester.pump();

        final lineChartLeaf = tester.widget<LineChartLeaf>(
          find.byType(LineChartLeaf),
        );
        final renderBox = tester.renderObject<RenderBox>(
          find.byType(LineChartLeaf),
        );
        final boundingBox = lineChartLeaf.boundingBox!;

        expect(boundingBox.size.height, renderBox.size.height);
        expect(boundingBox.size.width, greaterThan(renderBox.size.width));
        expect(boundingBox.left, isNegative);
        expect(boundingBox.top, 0);
      });

      testWidgets('scales vertically with ScaleAxis.vertical',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: LineChart(
              LineChartData(),
              scaleAxis: ScaleAxis.vertical,
              trackpadScrollCausesScale: true,
            ),
          ),
        );

        final pointer = TestPointer(1, PointerDeviceKind.trackpad);
        final chartCenterOffset = tester.getCenter(find.byType(LineChartLeaf));
        const scrollAmount = Offset(0, -100);

        await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
        await tester.pump();
        await tester.sendEventToBinding(pointer.scroll(scrollAmount));
        await tester.pump();

        final lineChartLeaf = tester.widget<LineChartLeaf>(
          find.byType(LineChartLeaf),
        );
        final renderBox = tester.renderObject<RenderBox>(
          find.byType(LineChartLeaf),
        );
        final boundingBox = lineChartLeaf.boundingBox!;

        expect(boundingBox.size.height, greaterThan(renderBox.size.height));
        expect(boundingBox.size.width, renderBox.size.width);
        expect(boundingBox.left, 0);
        expect(boundingBox.top, isNegative);
      });

      testWidgets('scales freely with ScaleAxis.free',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: LineChart(
              LineChartData(),
              scaleAxis: ScaleAxis.free,
              trackpadScrollCausesScale: true,
            ),
          ),
        );

        final pointer = TestPointer(1, PointerDeviceKind.trackpad);
        final chartCenterOffset = tester.getCenter(find.byType(LineChartLeaf));
        const scrollAmount = Offset(0, -100);

        await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
        await tester.pump();
        await tester.sendEventToBinding(pointer.scroll(scrollAmount));
        await tester.pump();

        final lineChartLeaf =
            tester.widget<LineChartLeaf>(find.byType(LineChartLeaf));
        final renderBox = tester.renderObject<RenderBox>(
          find.byType(LineChartLeaf),
        );
        final boundingBox = lineChartLeaf.boundingBox!;

        expect(boundingBox.size, greaterThan(renderBox.size));
        expect(boundingBox.left, isNegative);
        expect(boundingBox.top, isNegative);
      });
    });
  });
}
