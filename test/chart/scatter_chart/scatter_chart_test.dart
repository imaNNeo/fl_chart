import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_scaffold_widget.dart';
import 'package:fl_chart/src/chart/base/axis_chart/scale_axis.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_data.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_renderer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget({
    required ScatterChart chart,
  }) {
    return MaterialApp(
      home: chart,
    );
  }

  group('ScatterChart', () {
    testWidgets('has correct default values', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          chart: ScatterChart(
            ScatterChartData(),
          ),
        ),
      );

      final scatterChart = tester.widget<ScatterChart>(
        find.byType(ScatterChart),
      );
      expect(scatterChart.scaleAxis, ScaleAxis.none);
      expect(scatterChart.maxScale, 2.5);
      expect(scatterChart.minScale, 1);
      expect(scatterChart.trackpadScrollCausesScale, false);
      expect(scatterChart.transformationController, isNull);
    });

    testWidgets('passes interaction parameters to AxisChartScaffoldWidget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          chart: ScatterChart(
            ScatterChartData(),
          ),
        ),
      );

      final axisChartScaffoldWidget = tester.widget<AxisChartScaffoldWidget>(
        find.byType(AxisChartScaffoldWidget),
      );

      expect(axisChartScaffoldWidget.maxScale, 2.5);
      expect(axisChartScaffoldWidget.minScale, 1);
      expect(axisChartScaffoldWidget.scaleAxis, ScaleAxis.none);
      expect(axisChartScaffoldWidget.trackpadScrollCausesScale, false);
      expect(axisChartScaffoldWidget.transformationController, isNull);

      await tester.pumpAndSettle();

      final transformationController = TransformationController();
      await tester.pumpWidget(
        createTestWidget(
          chart: ScatterChart(
            ScatterChartData(),
            scaleAxis: ScaleAxis.free,
            trackpadScrollCausesScale: true,
            maxScale: 10,
            minScale: 1.5,
            transformationController: transformationController,
          ),
        ),
      );

      final axisChartScaffoldWidget1 = tester.widget<AxisChartScaffoldWidget>(
        find.byType(AxisChartScaffoldWidget),
      );

      expect(axisChartScaffoldWidget1.maxScale, 10);
      expect(axisChartScaffoldWidget1.minScale, 1.5);
      expect(axisChartScaffoldWidget1.scaleAxis, ScaleAxis.free);
      expect(axisChartScaffoldWidget1.trackpadScrollCausesScale, true);
      expect(
        axisChartScaffoldWidget1.transformationController,
        transformationController,
      );
    });

    for (final scaleAxis in ScaleAxis.scalingEnabledAxis) {
      testWidgets('passes canBeScaled true for $scaleAxis',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: ScatterChart(
              ScatterChartData(),
              scaleAxis: scaleAxis,
            ),
          ),
        );

        final scatterChartLeaf = tester.widget<ScatterChartLeaf>(
          find.byType(ScatterChartLeaf),
        );
        expect(scatterChartLeaf.canBeScaled, true);
      });
    }

    testWidgets('passes canBeScaled false for ScaleAxis.none',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          chart: ScatterChart(
            ScatterChartData(),
            // ignore: avoid_redundant_argument_values
            scaleAxis: ScaleAxis.none,
          ),
        ),
      );

      final scatterChartLeaf = tester.widget<ScatterChartLeaf>(
        find.byType(ScatterChartLeaf),
      );
      expect(scatterChartLeaf.canBeScaled, false);
    });

    group('touch gesture', () {
      testWidgets('does not scale with ScaleAxis.none',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: ScatterChart(
              ScatterChartData(),
            ),
          ),
        );

        final scatterChartCenterOffset =
            tester.getCenter(find.byType(ScatterChartLeaf));
        final scaleStart1 = scatterChartCenterOffset;
        final scaleStart2 = scatterChartCenterOffset;
        final scaleEnd1 = scatterChartCenterOffset + const Offset(100, 100);
        final scaleEnd2 = scatterChartCenterOffset - const Offset(100, 100);

        final gesture1 = await tester.startGesture(scaleStart1);
        final gesture2 = await tester.startGesture(scaleStart2);
        await tester.pump();
        await gesture1.moveTo(scaleEnd1);
        await gesture2.moveTo(scaleEnd2);
        await tester.pump();
        await gesture1.up();
        await gesture2.up();
        await tester.pumpAndSettle();

        final scatterChartLeaf = tester.widget<ScatterChartLeaf>(
          find.byType(ScatterChartLeaf),
        );

        expect(scatterChartLeaf.boundingBox, isNull);
      });

      testWidgets('scales freely with ScaleAxis.free',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: ScatterChart(
              ScatterChartData(),
              scaleAxis: ScaleAxis.free,
            ),
          ),
        );

        final scatterChartCenterOffset =
            tester.getCenter(find.byType(ScatterChartLeaf));
        final scaleStart1 = scatterChartCenterOffset;
        final scaleStart2 = scatterChartCenterOffset;
        final scaleEnd1 = scatterChartCenterOffset + const Offset(100, 100);
        final scaleEnd2 = scatterChartCenterOffset - const Offset(100, 100);

        final gesture1 = await tester.startGesture(scaleStart1);
        final gesture2 = await tester.startGesture(scaleStart2);
        await tester.pump();
        await gesture1.moveTo(scaleEnd1);
        await gesture2.moveTo(scaleEnd2);
        await tester.pump();
        await gesture1.up();
        await gesture2.up();
        await tester.pumpAndSettle();

        final scatterChartLeaf = tester.widget<ScatterChartLeaf>(
          find.byType(ScatterChartLeaf),
        );
        final renderBox = tester.renderObject<RenderBox>(
          find.byType(ScatterChartLeaf),
        );
        final boundingBox = scatterChartLeaf.boundingBox!;

        expect(boundingBox.size, greaterThan(renderBox.size));
        expect(boundingBox.left, isNegative);
        expect(boundingBox.top, isNegative);
      });

      testWidgets('scales horizontally with ScaleAxis.horizontal',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: ScatterChart(
              ScatterChartData(),
              scaleAxis: ScaleAxis.horizontal,
            ),
          ),
        );

        final chartCenterOffset =
            tester.getCenter(find.byType(ScatterChartLeaf));
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

        final scatterChartLeaf = tester.widget<ScatterChartLeaf>(
          find.byType(ScatterChartLeaf),
        );
        final renderBox = tester.renderObject<RenderBox>(
          find.byType(ScatterChartLeaf),
        );
        final boundingBox = scatterChartLeaf.boundingBox!;

        expect(boundingBox.size.height, renderBox.size.height);
        expect(boundingBox.size.width, greaterThan(renderBox.size.width));
        expect(boundingBox.left, isNegative);
        expect(boundingBox.top, 0);
      });

      testWidgets('scales vertically with ScaleAxis.vertical',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: ScatterChart(
              ScatterChartData(),
              scaleAxis: ScaleAxis.vertical,
            ),
          ),
        );

        final chartCenterOffset =
            tester.getCenter(find.byType(ScatterChartLeaf));
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

        final scatterChartLeaf = tester.widget<ScatterChartLeaf>(
          find.byType(ScatterChartLeaf),
        );
        final renderBox = tester.renderObject<RenderBox>(
          find.byType(ScatterChartLeaf),
        );
        final boundingBox = scatterChartLeaf.boundingBox!;

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
              chart: ScatterChart(
                ScatterChartData(),
                scaleAxis: ScaleAxis.horizontal,
              ),
            ),
          );

          final chartCenterOffset =
              tester.getCenter(find.byType(ScatterChartLeaf));
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

          final scatterChartLeafBeforePan = tester.widget<ScatterChartLeaf>(
            find.byType(ScatterChartLeaf),
          );
          final boundingBoxBeforePan = scatterChartLeafBeforePan.boundingBox!;
          expect(boundingBoxBeforePan.top, 0);

          const panOffset = Offset(100, 100);
          await tester.dragFrom(chartCenterOffset, panOffset);
          await tester.pumpAndSettle();

          final scatterChartLeafAfterPan = tester.widget<ScatterChartLeaf>(
            find.byType(ScatterChartLeaf),
          );
          final boundingBoxAfterPan = scatterChartLeafAfterPan.boundingBox!;

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
              chart: ScatterChart(
                ScatterChartData(),
                scaleAxis: ScaleAxis.vertical,
              ),
            ),
          );

          final chartCenterOffset =
              tester.getCenter(find.byType(ScatterChartLeaf));
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

          final scatterChartLeafBeforePan = tester.widget<ScatterChartLeaf>(
            find.byType(ScatterChartLeaf),
          );
          final boundingBoxBeforePan = scatterChartLeafBeforePan.boundingBox!;
          expect(boundingBoxBeforePan.left, 0);

          const panOffset = Offset(100, 100);
          await tester.dragFrom(chartCenterOffset, panOffset);
          await tester.pumpAndSettle();

          final scatterChartLeafAfterPan = tester.widget<ScatterChartLeaf>(
            find.byType(ScatterChartLeaf),
          );
          final boundingBoxAfterPan = scatterChartLeafAfterPan.boundingBox!;

          expect(boundingBoxAfterPan.left, 0);
          expect(
            boundingBoxAfterPan.top,
            greaterThan(boundingBoxBeforePan.top),
          );
        });

        testWidgets('freely with ScaleAxis.free', (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: ScatterChart(
                ScatterChartData(),
                scaleAxis: ScaleAxis.free,
              ),
            ),
          );

          final chartCenterOffset =
              tester.getCenter(find.byType(ScatterChartLeaf));
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

          final scatterChartLeafBeforePan = tester.widget<ScatterChartLeaf>(
            find.byType(ScatterChartLeaf),
          );
          final boundingBoxBeforePan = scatterChartLeafBeforePan.boundingBox!;
          expect(boundingBoxBeforePan.top, isNegative);
          expect(boundingBoxBeforePan.left, isNegative);

          const panOffset = Offset(100, 100);
          await tester.dragFrom(chartCenterOffset, panOffset);
          await tester.pumpAndSettle();

          final scatterChartLeafAfterPan = tester.widget<ScatterChartLeaf>(
            find.byType(ScatterChartLeaf),
          );
          final boundingBoxAfterPan = scatterChartLeafAfterPan.boundingBox!;

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
              chart: ScatterChart(
                ScatterChartData(),
                scaleAxis: ScaleAxis.horizontal,
              ),
            ),
          );

          final chartCenterOffset =
              tester.getCenter(find.byType(ScatterChartLeaf));
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

          final scatterChartLeafBeforePan = tester.widget<ScatterChartLeaf>(
            find.byType(ScatterChartLeaf),
          );

          final boundingBoxBeforePan = scatterChartLeafBeforePan.boundingBox!;
          expect(boundingBoxBeforePan.top, 0);

          final pointer = TestPointer(1, PointerDeviceKind.trackpad);
          const leftAndUp = Offset(-100, -100);
          await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
          await tester.pump();
          await tester.sendEventToBinding(pointer.scroll(leftAndUp));
          await tester.pump();

          final scatterChartLeafAfterPan = tester.widget<ScatterChartLeaf>(
            find.byType(ScatterChartLeaf),
          );
          final boundingBoxAfterPan = scatterChartLeafAfterPan.boundingBox!;

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
              chart: ScatterChart(
                ScatterChartData(),
                scaleAxis: ScaleAxis.vertical,
              ),
            ),
          );

          final chartCenterOffset =
              tester.getCenter(find.byType(ScatterChartLeaf));
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

          final scatterChartLeafBeforePan = tester.widget<ScatterChartLeaf>(
            find.byType(ScatterChartLeaf),
          );

          final boundingBoxBeforePan = scatterChartLeafBeforePan.boundingBox!;
          expect(boundingBoxBeforePan.left, 0);

          final pointer = TestPointer(1, PointerDeviceKind.trackpad);
          const leftAndUp = Offset(-100, -100);
          await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
          await tester.pump();
          await tester.sendEventToBinding(pointer.scroll(leftAndUp));
          await tester.pump();

          final scatterChartLeafAfterPan = tester.widget<ScatterChartLeaf>(
            find.byType(ScatterChartLeaf),
          );
          final boundingBoxAfterPan = scatterChartLeafAfterPan.boundingBox!;

          expect(boundingBoxAfterPan.left, 0);
          expect(
            boundingBoxAfterPan.top,
            greaterThan(boundingBoxBeforePan.top),
          );
        });

        testWidgets('freely with ScaleAxis.free', (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: ScatterChart(
                ScatterChartData(),
                scaleAxis: ScaleAxis.free,
              ),
            ),
          );

          final chartCenterOffset =
              tester.getCenter(find.byType(ScatterChartLeaf));
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

          final scatterChartLeafBeforePan = tester.widget<ScatterChartLeaf>(
            find.byType(ScatterChartLeaf),
          );

          final boundingBoxBeforePan = scatterChartLeafBeforePan.boundingBox!;

          final pointer = TestPointer(1, PointerDeviceKind.trackpad);
          const leftAndUp = Offset(-100, -100);
          await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
          await tester.pump();
          await tester.sendEventToBinding(pointer.scroll(leftAndUp));
          await tester.pump();

          final scatterChartLeafAfterPan = tester.widget<ScatterChartLeaf>(
            find.byType(ScatterChartLeaf),
          );
          final boundingBoxAfterPan = scatterChartLeafAfterPan.boundingBox!;

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
              chart: ScatterChart(
                ScatterChartData(),
                // ignore: avoid_redundant_argument_values
                scaleAxis: ScaleAxis.none,
                trackpadScrollCausesScale: true,
              ),
            ),
          );

          final pointer = TestPointer(1, PointerDeviceKind.trackpad);
          final chartCenterOffset =
              tester.getCenter(find.byType(ScatterChartLeaf));
          const scrollAmount = Offset(0, -100);

          await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
          await tester.pump();
          await tester.sendEventToBinding(pointer.scroll(scrollAmount));
          await tester.pump();

          final scatterChartLeaf = tester.widget<ScatterChartLeaf>(
            find.byType(ScatterChartLeaf),
          );
          expect(scatterChartLeaf.boundingBox, null);
        },
      );

      for (final scaleAxis in ScaleAxis.scalingEnabledAxis) {
        testWidgets(
          'does not scale when trackpadScrollCausesScale is false '
          'for $scaleAxis',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              createTestWidget(
                chart: ScatterChart(
                  ScatterChartData(),
                  scaleAxis: scaleAxis,
                  // ignore: avoid_redundant_argument_values
                  trackpadScrollCausesScale: false,
                ),
              ),
            );

            final pointer = TestPointer(1, PointerDeviceKind.trackpad);
            final chartCenterOffset = tester.getCenter(
              find.byType(ScatterChartLeaf),
            );
            const scrollAmount = Offset(0, -100);

            await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
            await tester.pump();
            await tester.sendEventToBinding(pointer.scroll(scrollAmount));
            await tester.pump();

            final scatterChartLeaf = tester.widget<ScatterChartLeaf>(
              find.byType(ScatterChartLeaf),
            );
            expect(scatterChartLeaf.boundingBox, null);
          },
        );
      }

      testWidgets('scales horizontally with ScaleAxis.horizontal',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: ScatterChart(
              ScatterChartData(),
              scaleAxis: ScaleAxis.horizontal,
              trackpadScrollCausesScale: true,
            ),
          ),
        );

        final pointer = TestPointer(1, PointerDeviceKind.trackpad);
        final chartCenterOffset =
            tester.getCenter(find.byType(ScatterChartLeaf));
        const scrollAmount = Offset(0, -100);

        await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
        await tester.pump();
        await tester.sendEventToBinding(pointer.scroll(scrollAmount));
        await tester.pump();

        final scatterChartLeaf = tester.widget<ScatterChartLeaf>(
          find.byType(ScatterChartLeaf),
        );
        final renderBox = tester.renderObject<RenderBox>(
          find.byType(ScatterChartLeaf),
        );
        final boundingBox = scatterChartLeaf.boundingBox!;

        expect(boundingBox.size.height, renderBox.size.height);
        expect(boundingBox.size.width, greaterThan(renderBox.size.width));
        expect(boundingBox.left, isNegative);
        expect(boundingBox.top, 0);
      });

      testWidgets('scales vertically with ScaleAxis.vertical',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: ScatterChart(
              ScatterChartData(),
              scaleAxis: ScaleAxis.vertical,
              trackpadScrollCausesScale: true,
            ),
          ),
        );

        final pointer = TestPointer(1, PointerDeviceKind.trackpad);
        final chartCenterOffset =
            tester.getCenter(find.byType(ScatterChartLeaf));
        const scrollAmount = Offset(0, -100);

        await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
        await tester.pump();
        await tester.sendEventToBinding(pointer.scroll(scrollAmount));
        await tester.pump();

        final scatterChartLeaf = tester.widget<ScatterChartLeaf>(
          find.byType(ScatterChartLeaf),
        );
        final renderBox = tester.renderObject<RenderBox>(
          find.byType(ScatterChartLeaf),
        );
        final boundingBox = scatterChartLeaf.boundingBox!;

        expect(boundingBox.size.height, greaterThan(renderBox.size.height));
        expect(boundingBox.size.width, renderBox.size.width);
        expect(boundingBox.left, 0);
        expect(boundingBox.top, isNegative);
      });

      testWidgets('scales freely with ScaleAxis.free',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: ScatterChart(
              ScatterChartData(),
              scaleAxis: ScaleAxis.free,
              trackpadScrollCausesScale: true,
            ),
          ),
        );

        final pointer = TestPointer(1, PointerDeviceKind.trackpad);
        final chartCenterOffset =
            tester.getCenter(find.byType(ScatterChartLeaf));
        const scrollAmount = Offset(0, -100);

        await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
        await tester.pump();
        await tester.sendEventToBinding(pointer.scroll(scrollAmount));
        await tester.pump();

        final scatterChartLeaf =
            tester.widget<ScatterChartLeaf>(find.byType(ScatterChartLeaf));
        final renderBox = tester.renderObject<RenderBox>(
          find.byType(ScatterChartLeaf),
        );
        final boundingBox = scatterChartLeaf.boundingBox!;

        expect(boundingBox.size, greaterThan(renderBox.size));
        expect(boundingBox.left, isNegative);
        expect(boundingBox.top, isNegative);
      });
    });
  });
}
