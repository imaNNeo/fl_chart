import 'package:fl_chart/src/chart/bar_chart/bar_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_data.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_renderer.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_scaffold_widget.dart';
import 'package:fl_chart/src/chart/base/axis_chart/scale_axis.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget({
    required BarChart chart,
  }) {
    return MaterialApp(
      home: chart,
    );
  }

  group('BarChart', () {
    group('throws AssertionError for', () {
      final verticallyScalableAlignments = [
        BarChartAlignment.start,
        BarChartAlignment.center,
        BarChartAlignment.end,
      ];
      for (final alignment in verticallyScalableAlignments) {
        testWidgets('ScaleAxis.horizontal with $alignment',
            (WidgetTester tester) async {
          expect(
            () => tester.pumpWidget(
              createTestWidget(
                chart: BarChart(
                  BarChartData(
                    alignment: alignment,
                  ),
                  scaleAxis: ScaleAxis.horizontal,
                ),
              ),
            ),
            throwsAssertionError,
          );
        });
      }

      for (final alignment in verticallyScalableAlignments) {
        testWidgets('ScaleAxis.free with $alignment',
            (WidgetTester tester) async {
          expect(
            () => tester.pumpWidget(
              createTestWidget(
                chart: BarChart(
                  BarChartData(
                    alignment: alignment,
                  ),
                  scaleAxis: ScaleAxis.free,
                ),
              ),
            ),
            throwsAssertionError,
          );
        });
      }
    });

    group('allows passing', () {
      for (final alignment in BarChartAlignment.values) {
        testWidgets('ScaleAxis.none with $alignment',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: BarChart(
                BarChartData(alignment: alignment),
                // ignore: avoid_redundant_argument_values
                scaleAxis: ScaleAxis.none,
              ),
            ),
          );
        });
      }

      for (final alignment in BarChartAlignment.values) {
        testWidgets('ScaleAxis.vertical with $alignment',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: BarChart(
                BarChartData(alignment: alignment),
                scaleAxis: ScaleAxis.vertical,
              ),
            ),
          );
        });
      }

      final scalableAlignments = [
        BarChartAlignment.spaceAround,
        BarChartAlignment.spaceBetween,
        BarChartAlignment.spaceEvenly,
      ];

      for (final alignment in scalableAlignments) {
        testWidgets('ScaleAxis.free with $alignment',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: BarChart(
                BarChartData(alignment: alignment),
                scaleAxis: ScaleAxis.free,
              ),
            ),
          );
        });
      }

      for (final alignment in scalableAlignments) {
        testWidgets('ScaleAxis.horizontal with $alignment',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: BarChart(
                BarChartData(alignment: alignment),
                scaleAxis: ScaleAxis.horizontal,
              ),
            ),
          );
        });
      }
    });

    testWidgets('has correct default values', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          chart: BarChart(
            BarChartData(),
          ),
        ),
      );

      final barChart = tester.widget<BarChart>(find.byType(BarChart));
      expect(barChart.scaleAxis, ScaleAxis.none);
      expect(barChart.maxScale, 2.5);
      expect(barChart.trackpadScrollCausesScale, false);
    });

    testWidgets('passes interaction parameters to AxisChartScaffoldWidget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          chart: BarChart(
            BarChartData(),
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
          chart: BarChart(
            BarChartData(),
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
            chart: BarChart(
              BarChartData(),
              scaleAxis: scaleAxis,
            ),
          ),
        );

        final barChartLeaf = tester.widget<BarChartLeaf>(
          find.byType(BarChartLeaf),
        );
        expect(barChartLeaf.canBeScaled, true);
      });
    }

    testWidgets('passes canBeScaled false for ScaleAxis.none',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          chart: BarChart(
            BarChartData(),
            // ignore: avoid_redundant_argument_values
            scaleAxis: ScaleAxis.none,
          ),
        ),
      );

      final barChartLeaf = tester.widget<BarChartLeaf>(
        find.byType(BarChartLeaf),
      );
      expect(barChartLeaf.canBeScaled, false);
    });

    group('touch gesture', () {
      testWidgets('does not scale with ScaleAxis.none',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: BarChart(
              BarChartData(),
            ),
          ),
        );

        final barChartCenterOffset =
            tester.getCenter(find.byType(BarChartLeaf));
        final scaleStart1 = barChartCenterOffset;
        final scaleStart2 = barChartCenterOffset;
        final scaleEnd1 = barChartCenterOffset + const Offset(100, 100);
        final scaleEnd2 = barChartCenterOffset - const Offset(100, 100);

        final gesture1 = await tester.startGesture(scaleStart1);
        final gesture2 = await tester.startGesture(scaleStart2);
        await tester.pump();
        await gesture1.moveTo(scaleEnd1);
        await gesture2.moveTo(scaleEnd2);
        await tester.pump();
        await gesture1.up();
        await gesture2.up();
        await tester.pumpAndSettle();

        final barChartLeaf = tester.widget<BarChartLeaf>(
          find.byType(BarChartLeaf),
        );

        expect(barChartLeaf.boundingBox, isNull);
      });

      testWidgets('scales freely with ScaleAxis.free',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: BarChart(
              BarChartData(alignment: BarChartAlignment.spaceEvenly),
              scaleAxis: ScaleAxis.free,
            ),
          ),
        );

        final barChartCenterOffset =
            tester.getCenter(find.byType(BarChartLeaf));
        final scaleStart1 = barChartCenterOffset;
        final scaleStart2 = barChartCenterOffset;
        final scaleEnd1 = barChartCenterOffset + const Offset(100, 100);
        final scaleEnd2 = barChartCenterOffset - const Offset(100, 100);

        final gesture1 = await tester.startGesture(scaleStart1);
        final gesture2 = await tester.startGesture(scaleStart2);
        await tester.pump();
        await gesture1.moveTo(scaleEnd1);
        await gesture2.moveTo(scaleEnd2);
        await tester.pump();
        await gesture1.up();
        await gesture2.up();
        await tester.pumpAndSettle();

        final barChartLeaf = tester.widget<BarChartLeaf>(
          find.byType(BarChartLeaf),
        );
        final renderBox = tester.renderObject<RenderBox>(
          find.byType(BarChartLeaf),
        );
        final boundingBox = barChartLeaf.boundingBox!;

        expect(boundingBox.size, greaterThan(renderBox.size));
        expect(boundingBox.left, isNegative);
        expect(boundingBox.top, isNegative);
      });

      testWidgets('scales horizontally with ScaleAxis.horizontal',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: BarChart(
              BarChartData(),
              scaleAxis: ScaleAxis.horizontal,
            ),
          ),
        );

        final chartCenterOffset = tester.getCenter(find.byType(BarChartLeaf));
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

        final barChartLeaf = tester.widget<BarChartLeaf>(
          find.byType(BarChartLeaf),
        );
        final renderBox = tester.renderObject<RenderBox>(
          find.byType(BarChartLeaf),
        );
        final boundingBox = barChartLeaf.boundingBox!;

        expect(boundingBox.size.height, renderBox.size.height);
        expect(boundingBox.size.width, greaterThan(renderBox.size.width));
        expect(boundingBox.left, isNegative);
        expect(boundingBox.top, 0);
      });

      testWidgets('scales vertically with ScaleAxis.vertical',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: BarChart(
              BarChartData(),
              scaleAxis: ScaleAxis.vertical,
            ),
          ),
        );

        final chartCenterOffset = tester.getCenter(find.byType(BarChartLeaf));
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

        final barChartLeaf = tester.widget<BarChartLeaf>(
          find.byType(BarChartLeaf),
        );
        final renderBox = tester.renderObject<RenderBox>(
          find.byType(BarChartLeaf),
        );
        final boundingBox = barChartLeaf.boundingBox!;

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
              chart: BarChart(
                BarChartData(),
                scaleAxis: ScaleAxis.horizontal,
              ),
            ),
          );

          final chartCenterOffset = tester.getCenter(find.byType(BarChartLeaf));
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

          final barChartLeafBeforePan = tester.widget<BarChartLeaf>(
            find.byType(BarChartLeaf),
          );
          final boundingBoxBeforePan = barChartLeafBeforePan.boundingBox!;
          expect(boundingBoxBeforePan.top, 0);

          const panOffset = Offset(100, 100);
          await tester.dragFrom(chartCenterOffset, panOffset);
          await tester.pumpAndSettle();

          final barChartLeafAfterPan = tester.widget<BarChartLeaf>(
            find.byType(BarChartLeaf),
          );
          final boundingBoxAfterPan = barChartLeafAfterPan.boundingBox!;

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
              chart: BarChart(
                BarChartData(),
                scaleAxis: ScaleAxis.vertical,
              ),
            ),
          );

          final chartCenterOffset = tester.getCenter(find.byType(BarChartLeaf));
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

          final barChartLeafBeforePan = tester.widget<BarChartLeaf>(
            find.byType(BarChartLeaf),
          );
          final boundingBoxBeforePan = barChartLeafBeforePan.boundingBox!;
          expect(boundingBoxBeforePan.left, 0);

          const panOffset = Offset(100, 100);
          await tester.dragFrom(chartCenterOffset, panOffset);
          await tester.pumpAndSettle();

          final barChartLeafAfterPan = tester.widget<BarChartLeaf>(
            find.byType(BarChartLeaf),
          );
          final boundingBoxAfterPan = barChartLeafAfterPan.boundingBox!;

          expect(boundingBoxAfterPan.left, 0);
          expect(
            boundingBoxAfterPan.top,
            greaterThan(boundingBoxBeforePan.top),
          );
        });

        testWidgets('freely with ScaleAxis.free', (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: BarChart(
                BarChartData(),
                scaleAxis: ScaleAxis.free,
              ),
            ),
          );

          final chartCenterOffset = tester.getCenter(find.byType(BarChartLeaf));
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

          final barChartLeafBeforePan = tester.widget<BarChartLeaf>(
            find.byType(BarChartLeaf),
          );
          final boundingBoxBeforePan = barChartLeafBeforePan.boundingBox!;
          expect(boundingBoxBeforePan.top, isNegative);
          expect(boundingBoxBeforePan.left, isNegative);

          const panOffset = Offset(100, 100);
          await tester.dragFrom(chartCenterOffset, panOffset);
          await tester.pumpAndSettle();

          final barChartLeafAfterPan = tester.widget<BarChartLeaf>(
            find.byType(BarChartLeaf),
          );
          final boundingBoxAfterPan = barChartLeafAfterPan.boundingBox!;

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
              chart: BarChart(
                BarChartData(),
                scaleAxis: ScaleAxis.horizontal,
              ),
            ),
          );

          final chartCenterOffset = tester.getCenter(find.byType(BarChartLeaf));
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

          final barChartLeafBeforePan = tester.widget<BarChartLeaf>(
            find.byType(BarChartLeaf),
          );

          final boundingBoxBeforePan = barChartLeafBeforePan.boundingBox!;
          expect(boundingBoxBeforePan.top, 0);

          final pointer = TestPointer(1, PointerDeviceKind.trackpad);
          const leftAndUp = Offset(-100, -100);
          await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
          await tester.pump();
          await tester.sendEventToBinding(pointer.scroll(leftAndUp));
          await tester.pump();

          final barChartLeafAfterPan = tester.widget<BarChartLeaf>(
            find.byType(BarChartLeaf),
          );
          final boundingBoxAfterPan = barChartLeafAfterPan.boundingBox!;

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
              chart: BarChart(
                BarChartData(),
                scaleAxis: ScaleAxis.vertical,
              ),
            ),
          );

          final chartCenterOffset = tester.getCenter(find.byType(BarChartLeaf));
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

          final barChartLeafBeforePan = tester.widget<BarChartLeaf>(
            find.byType(BarChartLeaf),
          );

          final boundingBoxBeforePan = barChartLeafBeforePan.boundingBox!;
          expect(boundingBoxBeforePan.left, 0);

          final pointer = TestPointer(1, PointerDeviceKind.trackpad);
          const leftAndUp = Offset(-100, -100);
          await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
          await tester.pump();
          await tester.sendEventToBinding(pointer.scroll(leftAndUp));
          await tester.pump();

          final barChartLeafAfterPan = tester.widget<BarChartLeaf>(
            find.byType(BarChartLeaf),
          );
          final boundingBoxAfterPan = barChartLeafAfterPan.boundingBox!;

          expect(boundingBoxAfterPan.left, 0);
          expect(
            boundingBoxAfterPan.top,
            greaterThan(boundingBoxBeforePan.top),
          );
        });

        testWidgets('freely with ScaleAxis.free', (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: BarChart(
                BarChartData(),
                scaleAxis: ScaleAxis.free,
              ),
            ),
          );

          final chartCenterOffset = tester.getCenter(find.byType(BarChartLeaf));
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

          final barChartLeafBeforePan = tester.widget<BarChartLeaf>(
            find.byType(BarChartLeaf),
          );

          final boundingBoxBeforePan = barChartLeafBeforePan.boundingBox!;

          final pointer = TestPointer(1, PointerDeviceKind.trackpad);
          const leftAndUp = Offset(-100, -100);
          await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
          await tester.pump();
          await tester.sendEventToBinding(pointer.scroll(leftAndUp));
          await tester.pump();

          final barChartLeafAfterPan = tester.widget<BarChartLeaf>(
            find.byType(BarChartLeaf),
          );
          final boundingBoxAfterPan = barChartLeafAfterPan.boundingBox!;

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
              chart: BarChart(
                BarChartData(),
                // ignore: avoid_redundant_argument_values
                scaleAxis: ScaleAxis.none,
                trackpadScrollCausesScale: true,
              ),
            ),
          );

          final pointer = TestPointer(1, PointerDeviceKind.trackpad);
          final chartCenterOffset = tester.getCenter(find.byType(BarChartLeaf));
          const scrollAmount = Offset(0, -100);

          await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
          await tester.pump();
          await tester.sendEventToBinding(pointer.scroll(scrollAmount));
          await tester.pump();

          final barChartLeaf = tester.widget<BarChartLeaf>(
            find.byType(BarChartLeaf),
          );
          expect(barChartLeaf.boundingBox, null);
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
                chart: BarChart(
                  BarChartData(),
                  scaleAxis: scaleAxis,
                  // ignore: avoid_redundant_argument_values
                  trackpadScrollCausesScale: false,
                ),
              ),
            );

            final pointer = TestPointer(1, PointerDeviceKind.trackpad);
            final chartCenterOffset = tester.getCenter(
              find.byType(BarChartLeaf),
            );
            const scrollAmount = Offset(0, -100);

            await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
            await tester.pump();
            await tester.sendEventToBinding(pointer.scroll(scrollAmount));
            await tester.pump();

            final barChartLeaf = tester.widget<BarChartLeaf>(
              find.byType(BarChartLeaf),
            );
            expect(barChartLeaf.boundingBox, null);
          },
        );
      }

      testWidgets('scales horizontally with ScaleAxis.horizontal',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: BarChart(
              BarChartData(),
              scaleAxis: ScaleAxis.horizontal,
              trackpadScrollCausesScale: true,
            ),
          ),
        );

        final pointer = TestPointer(1, PointerDeviceKind.trackpad);
        final chartCenterOffset = tester.getCenter(find.byType(BarChartLeaf));
        const scrollAmount = Offset(0, -100);

        await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
        await tester.pump();
        await tester.sendEventToBinding(pointer.scroll(scrollAmount));
        await tester.pump();

        final barChartLeaf = tester.widget<BarChartLeaf>(
          find.byType(BarChartLeaf),
        );
        final renderBox = tester.renderObject<RenderBox>(
          find.byType(BarChartLeaf),
        );
        final boundingBox = barChartLeaf.boundingBox!;

        expect(boundingBox.size.height, renderBox.size.height);
        expect(boundingBox.size.width, greaterThan(renderBox.size.width));
        expect(boundingBox.left, isNegative);
        expect(boundingBox.top, 0);
      });

      testWidgets('scales vertically with ScaleAxis.vertical',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: BarChart(
              BarChartData(),
              scaleAxis: ScaleAxis.vertical,
              trackpadScrollCausesScale: true,
            ),
          ),
        );

        final pointer = TestPointer(1, PointerDeviceKind.trackpad);
        final chartCenterOffset = tester.getCenter(find.byType(BarChartLeaf));
        const scrollAmount = Offset(0, -100);

        await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
        await tester.pump();
        await tester.sendEventToBinding(pointer.scroll(scrollAmount));
        await tester.pump();

        final barChartLeaf = tester.widget<BarChartLeaf>(
          find.byType(BarChartLeaf),
        );
        final renderBox = tester.renderObject<RenderBox>(
          find.byType(BarChartLeaf),
        );
        final boundingBox = barChartLeaf.boundingBox!;

        expect(boundingBox.size.height, greaterThan(renderBox.size.height));
        expect(boundingBox.size.width, renderBox.size.width);
        expect(boundingBox.left, 0);
        expect(boundingBox.top, isNegative);
      });

      testWidgets('scales freely with ScaleAxis.free',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: BarChart(
              BarChartData(),
              scaleAxis: ScaleAxis.free,
              trackpadScrollCausesScale: true,
            ),
          ),
        );

        final pointer = TestPointer(1, PointerDeviceKind.trackpad);
        final chartCenterOffset = tester.getCenter(find.byType(BarChartLeaf));
        const scrollAmount = Offset(0, -100);

        await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
        await tester.pump();
        await tester.sendEventToBinding(pointer.scroll(scrollAmount));
        await tester.pump();

        final barChartLeaf =
            tester.widget<BarChartLeaf>(find.byType(BarChartLeaf));
        final renderBox = tester.renderObject<RenderBox>(
          find.byType(BarChartLeaf),
        );
        final boundingBox = barChartLeaf.boundingBox!;

        expect(boundingBox.size, greaterThan(renderBox.size));
        expect(boundingBox.left, isNegative);
        expect(boundingBox.top, isNegative);
      });
    });
  });
}
