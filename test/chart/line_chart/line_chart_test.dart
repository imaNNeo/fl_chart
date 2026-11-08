import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_scaffold_widget.dart';
import 'package:fl_chart/src/chart/base/axis_chart/scale_axis.dart';
import 'package:fl_chart/src/chart/base/axis_chart/transformation_config.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_data.dart';
import 'package:fl_chart/src/chart/line_chart/line_chart_renderer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    testWidgets('has correct default values', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          chart: LineChart(
            LineChartData(),
          ),
        ),
      );

      final lineChart = tester.widget<LineChart>(find.byType(LineChart));
      expect(lineChart.transformationConfig, const FlTransformationConfig());
    });

    testWidgets('passes interaction parameters to AxisChartScaffoldWidget',
        (tester) async {
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

      expect(
        axisChartScaffoldWidget.transformationConfig,
        const FlTransformationConfig(),
      );

      await tester.pumpAndSettle();

      final transformationController = TransformationController();
      addTearDown(transformationController.dispose);
      final transformationConfig = FlTransformationConfig(
        scaleAxis: FlScaleAxis.free,
        trackpadScrollCausesScale: true,
        maxScale: 10,
        minScale: 1.5,
        transformationController: transformationController,
      );
      await tester.pumpWidget(
        createTestWidget(
          chart: LineChart(
            LineChartData(),
            transformationConfig: transformationConfig,
          ),
        ),
      );

      final axisChartScaffoldWidget1 = tester.widget<AxisChartScaffoldWidget>(
        find.byType(AxisChartScaffoldWidget),
      );

      expect(
        axisChartScaffoldWidget1.transformationConfig,
        transformationConfig,
      );
    });

    for (final scaleAxis in FlScaleAxis.scalingEnabledAxis) {
      testWidgets('passes canBeScaled true for $scaleAxis', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: LineChart(
              LineChartData(),
              transformationConfig: FlTransformationConfig(
                scaleAxis: scaleAxis,
              ),
            ),
          ),
        );

        final lineChartLeaf = tester.widget<LineChartLeaf>(
          find.byType(LineChartLeaf),
        );
        expect(lineChartLeaf.canBeScaled, true);
      });
    }

    testWidgets('passes canBeScaled false for FlScaleAxis.none',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          chart: LineChart(
            LineChartData(),
            // This is for test
            // ignore: avoid_redundant_argument_values
            transformationConfig: const FlTransformationConfig(
              // This is for test
              // ignore: avoid_redundant_argument_values
              scaleAxis: FlScaleAxis.none,
            ),
          ),
        ),
      );

      final lineChartLeaf = tester.widget<LineChartLeaf>(
        find.byType(LineChartLeaf),
      );
      expect(lineChartLeaf.canBeScaled, false);
    });

    group('touch gesture', () {
      testWidgets('does not scale with FlScaleAxis.none', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: LineChart(
              LineChartData(),
            ),
          ),
        );

        final lineChartCenterOffset = tester.getCenter(
          find.byType(LineChartLeaf),
        );
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

        expect(lineChartLeaf.chartVirtualRect, isNull);
      });

      testWidgets('scales freely with FlScaleAxis.free', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: LineChart(
              LineChartData(),
              transformationConfig: const FlTransformationConfig(
                scaleAxis: FlScaleAxis.free,
              ),
            ),
          ),
        );

        final lineChartCenterOffset = tester.getCenter(
          find.byType(LineChartLeaf),
        );
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
        final chartVirtualRect = lineChartLeaf.chartVirtualRect!;

        expect(chartVirtualRect.size, greaterThan(renderBox.size));
        expect(chartVirtualRect.left, isNegative);
        expect(chartVirtualRect.top, isNegative);
      });

      testWidgets('scales horizontally with FlScaleAxis.horizontal',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: LineChart(
              LineChartData(),
              transformationConfig: const FlTransformationConfig(
                scaleAxis: FlScaleAxis.horizontal,
              ),
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
        final chartVirtualRect = lineChartLeaf.chartVirtualRect!;

        expect(chartVirtualRect.size.height, renderBox.size.height);
        expect(chartVirtualRect.size.width, greaterThan(renderBox.size.width));
        expect(chartVirtualRect.left, isNegative);
        expect(chartVirtualRect.top, 0);
      });

      testWidgets('scales vertically with FlScaleAxis.vertical',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: LineChart(
              LineChartData(),
              transformationConfig: const FlTransformationConfig(
                scaleAxis: FlScaleAxis.vertical,
              ),
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
        final chartVirtualRect = lineChartLeaf.chartVirtualRect!;

        expect(
          chartVirtualRect.size.height,
          greaterThan(renderBox.size.height),
        );
        expect(chartVirtualRect.size.width, renderBox.size.width);
        expect(chartVirtualRect.left, 0);
        expect(chartVirtualRect.top, isNegative);
      });

      group('pans', () {
        testWidgets('only horizontally with FlScaleAxis.horizontal',
            (tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: LineChart(
                LineChartData(),
                transformationConfig: const FlTransformationConfig(
                  scaleAxis: FlScaleAxis.horizontal,
                ),
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
          final chartVirtualRectBeforePan =
              lineChartLeafBeforePan.chartVirtualRect!;
          expect(chartVirtualRectBeforePan.top, 0);

          const panOffset = Offset(100, 100);
          await tester.dragFrom(chartCenterOffset, panOffset);
          await tester.pumpAndSettle();

          final lineChartLeafAfterPan = tester.widget<LineChartLeaf>(
            find.byType(LineChartLeaf),
          );
          final chartVirtualRectAfterPan =
              lineChartLeafAfterPan.chartVirtualRect!;

          expect(chartVirtualRectBeforePan.size, chartVirtualRectAfterPan.size);
          expect(
            chartVirtualRectAfterPan.left,
            greaterThan(chartVirtualRectBeforePan.left),
          );
          expect(chartVirtualRectAfterPan.top, 0);
        });

        testWidgets('only vertically with FlScaleAxis.vertical',
            (tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: LineChart(
                LineChartData(),
                transformationConfig: const FlTransformationConfig(
                  scaleAxis: FlScaleAxis.vertical,
                ),
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
          final chartVirtualRectBeforePan =
              lineChartLeafBeforePan.chartVirtualRect!;
          expect(chartVirtualRectBeforePan.left, 0);

          const panOffset = Offset(100, 100);
          await tester.dragFrom(chartCenterOffset, panOffset);
          await tester.pumpAndSettle();

          final lineChartLeafAfterPan = tester.widget<LineChartLeaf>(
            find.byType(LineChartLeaf),
          );
          final chartVirtualRectAfterPan =
              lineChartLeafAfterPan.chartVirtualRect!;

          expect(chartVirtualRectAfterPan.left, 0);
          expect(
            chartVirtualRectAfterPan.top,
            greaterThan(chartVirtualRectBeforePan.top),
          );
        });

        testWidgets('freely with FlScaleAxis.free', (tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: LineChart(
                LineChartData(),
                transformationConfig: const FlTransformationConfig(
                  scaleAxis: FlScaleAxis.free,
                ),
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
          final chartVirtualRectBeforePan =
              lineChartLeafBeforePan.chartVirtualRect!;
          expect(chartVirtualRectBeforePan.left, isNegative);
          expect(chartVirtualRectBeforePan.top, isNegative);

          const panOffset = Offset(100, 100);
          await tester.dragFrom(chartCenterOffset, panOffset);
          await tester.pumpAndSettle();

          final lineChartLeafAfterPan = tester.widget<LineChartLeaf>(
            find.byType(LineChartLeaf),
          );
          final chartVirtualRectAfterPan =
              lineChartLeafAfterPan.chartVirtualRect!;

          expect(
            chartVirtualRectAfterPan.left,
            greaterThan(chartVirtualRectBeforePan.left),
          );
          expect(
            chartVirtualRectAfterPan.top,
            greaterThan(chartVirtualRectBeforePan.top),
          );
        });
      });
    });

    group('trackpad scroll', () {
      group('pans', () {
        testWidgets('only horizontally with FlScaleAxis.horizontal',
            (tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: LineChart(
                LineChartData(),
                transformationConfig: const FlTransformationConfig(
                  scaleAxis: FlScaleAxis.horizontal,
                ),
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

          final chartVirtualRectBeforePan =
              lineChartLeafBeforePan.chartVirtualRect!;
          expect(chartVirtualRectBeforePan.top, 0);

          final pointer = TestPointer(1, PointerDeviceKind.trackpad);
          const leftAndUp = Offset(-100, -100);
          await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
          await tester.pump();
          await tester.sendEventToBinding(pointer.scroll(leftAndUp));
          await tester.pump();

          final lineChartLeafAfterPan = tester.widget<LineChartLeaf>(
            find.byType(LineChartLeaf),
          );
          final chartVirtualRectAfterPan =
              lineChartLeafAfterPan.chartVirtualRect!;

          expect(
            chartVirtualRectAfterPan.left,
            greaterThan(chartVirtualRectBeforePan.left),
          );
          expect(chartVirtualRectAfterPan.top, 0);
        });

        testWidgets('vertically with FlScaleAxis.vertical', (tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: LineChart(
                LineChartData(),
                transformationConfig: const FlTransformationConfig(
                  scaleAxis: FlScaleAxis.vertical,
                ),
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

          final chartVirtualRectBeforePan =
              lineChartLeafBeforePan.chartVirtualRect!;
          expect(chartVirtualRectBeforePan.left, 0);

          final pointer = TestPointer(1, PointerDeviceKind.trackpad);
          const leftAndUp = Offset(-100, -100);
          await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
          await tester.pump();
          await tester.sendEventToBinding(pointer.scroll(leftAndUp));
          await tester.pump();

          final lineChartLeafAfterPan = tester.widget<LineChartLeaf>(
            find.byType(LineChartLeaf),
          );
          final chartVirtualRectAfterPan =
              lineChartLeafAfterPan.chartVirtualRect!;

          expect(chartVirtualRectAfterPan.left, 0);
          expect(
            chartVirtualRectAfterPan.top,
            greaterThan(chartVirtualRectBeforePan.top),
          );
        });

        testWidgets('freely with FlScaleAxis.free', (tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: LineChart(
                LineChartData(),
                transformationConfig: const FlTransformationConfig(
                  scaleAxis: FlScaleAxis.free,
                ),
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

          final chartVirtualRectBeforePan =
              lineChartLeafBeforePan.chartVirtualRect!;

          final pointer = TestPointer(1, PointerDeviceKind.trackpad);
          const leftAndUp = Offset(-100, -100);
          await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
          await tester.pump();
          await tester.sendEventToBinding(pointer.scroll(leftAndUp));
          await tester.pump();

          final lineChartLeafAfterPan = tester.widget<LineChartLeaf>(
            find.byType(LineChartLeaf),
          );
          final chartVirtualRectAfterPan =
              lineChartLeafAfterPan.chartVirtualRect!;

          expect(
            chartVirtualRectAfterPan.left,
            greaterThan(chartVirtualRectBeforePan.left),
          );
          expect(
            chartVirtualRectAfterPan.top,
            greaterThan(chartVirtualRectBeforePan.top),
          );
        });
      });

      testWidgets(
        'does not scale with FlScaleAxis.none when '
        'trackpadScrollCausesScale is true',
        (tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: LineChart(
                LineChartData(),
                transformationConfig: const FlTransformationConfig(
                  // This is for test
                  // ignore: avoid_redundant_argument_values
                  scaleAxis: FlScaleAxis.none,
                  trackpadScrollCausesScale: true,
                ),
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
          expect(lineChartLeaf.chartVirtualRect, null);
        },
      );

      for (final scaleAxis in FlScaleAxis.scalingEnabledAxis) {
        testWidgets(
          'does not scale when trackpadScrollCausesScale is false '
          'for $scaleAxis',
          (tester) async {
            await tester.pumpWidget(
              createTestWidget(
                chart: LineChart(
                  LineChartData(),
                  transformationConfig: FlTransformationConfig(
                    scaleAxis: scaleAxis,
                    // This is for test
                    // ignore: avoid_redundant_argument_values
                    trackpadScrollCausesScale: false,
                  ),
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
            expect(lineChartLeaf.chartVirtualRect, null);
          },
        );
      }

      testWidgets('scales horizontally with FlScaleAxis.horizontal',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: LineChart(
              LineChartData(),
              transformationConfig: const FlTransformationConfig(
                scaleAxis: FlScaleAxis.horizontal,
                trackpadScrollCausesScale: true,
              ),
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
        final chartVirtualRect = lineChartLeaf.chartVirtualRect!;

        expect(chartVirtualRect.size.height, renderBox.size.height);
        expect(chartVirtualRect.size.width, greaterThan(renderBox.size.width));
        expect(chartVirtualRect.left, isNegative);
        expect(chartVirtualRect.top, 0);
      });

      testWidgets('scales vertically with FlScaleAxis.vertical',
          (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: LineChart(
              LineChartData(),
              transformationConfig: const FlTransformationConfig(
                scaleAxis: FlScaleAxis.vertical,
                trackpadScrollCausesScale: true,
              ),
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
        final chartVirtualRect = lineChartLeaf.chartVirtualRect!;

        expect(
          chartVirtualRect.size.height,
          greaterThan(renderBox.size.height),
        );
        expect(chartVirtualRect.size.width, renderBox.size.width);
        expect(chartVirtualRect.left, 0);
        expect(chartVirtualRect.top, isNegative);
      });

      testWidgets('scales freely with FlScaleAxis.free', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: LineChart(
              LineChartData(),
              transformationConfig: const FlTransformationConfig(
                scaleAxis: FlScaleAxis.free,
                trackpadScrollCausesScale: true,
              ),
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
        final chartVirtualRect = lineChartLeaf.chartVirtualRect!;

        expect(chartVirtualRect.size, greaterThan(renderBox.size));
        expect(chartVirtualRect.left, isNegative);
        expect(chartVirtualRect.top, isNegative);
      });
    });

    group('built-in touch', () {
      testWidgets('rebuilds only when the touched spots change',
          (tester) async {
        var touchCallbacks = 0;
        await tester.pumpWidget(
          createTestWidget(
            chart: LineChart(
              LineChartData(
                minX: 0,
                maxX: 10,
                minY: 0,
                maxY: 10,
                titlesData: const FlTitlesData(show: false),
                lineTouchData: LineTouchData(
                  touchSpotThreshold: 5,
                  touchCallback: (_, __) => touchCallbacks++,
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      11,
                      (i) => FlSpot(i.toDouble(), i.toDouble()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final rect = tester.getRect(find.byType(LineChartLeaf));
        Offset spotPosition(int index) =>
            Offset(rect.left + rect.width * index / 10, rect.center.dy);
        LineChartLeaf leaf() =>
            tester.widget<LineChartLeaf>(find.byType(LineChartLeaf));

        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        addTearDown(mouse.removePointer);
        await mouse.addPointer(location: rect.topLeft - const Offset(10, 10));
        await mouse.moveTo(spotPosition(3));
        await tester.pump();
        final touchedLeaf = leaf();
        expect(touchedLeaf.data.lineBarsData.first.showingIndicators, [3]);

        // Still on spot 3: no rebuild, but the callback is still called.
        final callbacksBefore = touchCallbacks;
        await mouse.moveTo(spotPosition(3) + const Offset(1, 0));
        await tester.pump();
        expect(leaf(), same(touchedLeaf));
        expect(touchCallbacks, callbacksBefore + 1);

        await mouse.moveTo(spotPosition(6));
        await tester.pump();
        expect(leaf(), isNot(same(touchedLeaf)));
        expect(leaf().data.lineBarsData.first.showingIndicators, [6]);

        // Between two spots, further than touchSpotThreshold: cleared once.
        final between = (spotPosition(6) + spotPosition(7)) / 2;
        await mouse.moveTo(between);
        await tester.pump();
        final clearedLeaf = leaf();
        expect(clearedLeaf.data.lineBarsData.first.showingIndicators, isEmpty);

        await mouse.moveTo(between + const Offset(1, 0));
        await tester.pump();
        expect(leaf(), same(clearedLeaf));
      });
    });

    group('range annotations with clipData', () {
      // The chart takes (50..250) of a 300x300 white box; counts the amber
      // pixels strictly above the chart rect.
      Future<int> amberAboveChart(
        WidgetTester tester,
        LineChartData data,
      ) async {
        final key = GlobalKey();
        await tester.pumpWidget(
          MaterialApp(
            home: Center(
              child: RepaintBoundary(
                key: key,
                child: Container(
                  color: Colors.white,
                  width: 300,
                  height: 300,
                  padding: const EdgeInsets.all(50),
                  child: LineChart(data, duration: Duration.zero),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        var amberAbove = 0;
        await tester.runAsync(() async {
          final b =
              key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          final img = await b.toImage();
          final d = (await img.toByteData())!;
          for (var y = 0; y < 48; y++) {
            for (var x = 60; x < 240; x++) {
              final i = (y * img.width + x) * 4;
              if (d.getUint8(i) > 200 &&
                  d.getUint8(i + 1) > 150 &&
                  d.getUint8(i + 2) < 120) {
                amberAbove++;
              }
            }
          }
        });
        return amberAbove;
      }

      final data1944 = LineChartData(
        clipData: const FlClipData.all(),
        titlesData: const FlTitlesData(show: false),
        gridData: const FlGridData(show: false),
        minX: 0,
        maxX: 100,
        minY: 0,
        maxY: 100,
        rangeAnnotations: RangeAnnotations(
          horizontalRangeAnnotations: [
            HorizontalRangeAnnotation(
              y1: 150,
              y2: 0,
              color: const Color(0xFFFFC107),
            ),
          ],
        ),
        lineBarsData: [
          LineChartBarData(spots: const [FlSpot.zero, FlSpot(100, 200)]),
        ],
      );

      testWidgets(
          'horizontal range annotation beyond maxY stays inside chart with clipData.all (#1944)',
          (tester) async {
        expect(await amberAboveChart(tester, data1944), 0);
      });

      testWidgets(
          'horizontal range annotation beyond maxY stays inside chart with clipData.all and no lines',
          (tester) async {
        expect(
          await amberAboveChart(tester, data1944.copyWith(lineBarsData: [])),
          0,
        );
      });

      testWidgets(
          'horizontal range annotation beyond maxY is not clipped with clipData.none',
          (tester) async {
        expect(
          await amberAboveChart(
            tester,
            data1944.copyWith(clipData: const FlClipData.none()),
          ),
          greaterThan(0),
        );
      });

      testWidgets(
          'vertical range annotation does not cover the axis names with clipData.all (#1763)',
          (t) async {
        final key = GlobalKey();
        await t.pumpWidget(
          MaterialApp(
            home: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: RepaintBoundary(
                  key: key,
                  child: ColoredBox(
                    color: Colors.white,
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: 5,
                          minY: 0,
                          maxY: 5,
                          clipData: const FlClipData.all(),
                          titlesData: const FlTitlesData(
                            leftTitles: AxisTitles(
                              axisNameSize: 48,
                              axisNameWidget: SizedBox(),
                            ),
                            rightTitles: AxisTitles(
                              axisNameSize: 48,
                              axisNameWidget: SizedBox(),
                            ),
                          ),
                          rangeAnnotations: RangeAnnotations(
                            verticalRangeAnnotations: [
                              VerticalRangeAnnotation(
                                x1: -3,
                                x2: 8,
                                color: Colors.red,
                              ),
                            ],
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [FlSpot(0, 1), FlSpot(5, 2)],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await t.runAsync(() async {
          final b =
              key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          final img = await b.toImage();
          final data = (await img.toByteData())!;
          // x=10 is inside the 48px left axis-name area, outside the plot
          int px(int x, int y) {
            final o = (y * img.width + x) * 4;
            return data.getUint8(o) << 16 |
                data.getUint8(o + 1) << 8 |
                data.getUint8(o + 2);
          }

          expect(
            px(10, 150),
            0xffffff,
            reason: 'annotation leaked into axis area',
          );
        });
      });
    });
  });
}
