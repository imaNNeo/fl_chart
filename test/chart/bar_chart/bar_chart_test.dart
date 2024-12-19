import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_renderer.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_scaffold_widget.dart';
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
    group('allows passing', () {
      for (final alignment in BarChartAlignment.values) {
        testWidgets('FlScaleAxis.none with $alignment',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: BarChart(
                BarChartData(
                  alignment: alignment,
                  scaleData: const FlScaleData(
                    // ignore: avoid_redundant_argument_values
                    scaleAxis: FlScaleAxis.none,
                  ),
                ),
              ),
            ),
          );
        });
      }

      for (final alignment in BarChartAlignment.values) {
        testWidgets('FlScaleAxis.vertical with $alignment',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: BarChart(
                BarChartData(
                  alignment: alignment,
                  scaleData: const FlScaleData(
                    scaleAxis: FlScaleAxis.vertical,
                  ),
                ),
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
        testWidgets('FlScaleAxis.free with $alignment',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: BarChart(
                BarChartData(
                  alignment: alignment,
                  scaleData: const FlScaleData(
                    scaleAxis: FlScaleAxis.free,
                  ),
                ),
              ),
            ),
          );
        });
      }

      for (final alignment in scalableAlignments) {
        testWidgets('FlScaleAxis.horizontal with $alignment',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: BarChart(
                BarChartData(
                  alignment: alignment,
                  scaleData: const FlScaleData(
                    scaleAxis: FlScaleAxis.horizontal,
                  ),
                ),
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
      final scaleData = barChart.data.scaleData;
      expect(scaleData.scaleAxis, FlScaleAxis.none);
      expect(scaleData.maxScale, 2.5);
      expect(scaleData.minScale, 1);
      expect(scaleData.trackpadScrollCausesScale, false);
      expect(scaleData.transformationController, isNull);
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

      final scaleData = axisChartScaffoldWidget.data.scaleData;
      expect(scaleData.maxScale, 2.5);
      expect(scaleData.minScale, 1);
      expect(scaleData.scaleAxis, FlScaleAxis.none);
      expect(scaleData.trackpadScrollCausesScale, false);
      expect(scaleData.transformationController, isNull);

      await tester.pumpAndSettle();

      final transformationController = TransformationController();
      await tester.pumpWidget(
        createTestWidget(
          chart: BarChart(
            BarChartData().copyWith(
              scaleData: FlScaleData(
                scaleAxis: FlScaleAxis.free,
                trackpadScrollCausesScale: true,
                maxScale: 10,
                minScale: 1.5,
                transformationController: transformationController,
              ),
            ),
          ),
        ),
      );

      final axisChartScaffoldWidget1 = tester.widget<AxisChartScaffoldWidget>(
        find.byType(AxisChartScaffoldWidget),
      );

      final scaleData1 = axisChartScaffoldWidget1.data.scaleData;
      expect(scaleData1.maxScale, 10);
      expect(scaleData1.minScale, 1.5);
      expect(scaleData1.scaleAxis, FlScaleAxis.free);
      expect(scaleData1.trackpadScrollCausesScale, true);
      expect(
        scaleData1.transformationController,
        transformationController,
      );
    });

    for (final scaleAxis in FlScaleAxis.scalingEnabledAxis) {
      testWidgets('passes canBeScaled true for $scaleAxis',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: BarChart(
              BarChartData().copyWith(
                scaleData: FlScaleData(
                  scaleAxis: scaleAxis,
                ),
              ),
            ),
          ),
        );

        final barChartLeaf = tester.widget<BarChartLeaf>(
          find.byType(BarChartLeaf),
        );
        expect(barChartLeaf.canBeScaled, true);
      });
    }

    testWidgets('passes canBeScaled false for FlScaleAxis.none',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          chart: BarChart(
            BarChartData().copyWith(
              scaleData: const FlScaleData(
                // ignore: avoid_redundant_argument_values
                scaleAxis: FlScaleAxis.none,
              ),
            ),
          ),
        ),
      );

      final barChartLeaf = tester.widget<BarChartLeaf>(
        find.byType(BarChartLeaf),
      );
      expect(barChartLeaf.canBeScaled, false);
    });

    group('touch gesture', () {
      testWidgets('does not scale with FlScaleAxis.none',
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

        expect(barChartLeaf.chartVirtualRect, isNull);
      });

      testWidgets('scales freely with FlScaleAxis.free',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceEvenly,
                scaleData: const FlScaleData(
                  scaleAxis: FlScaleAxis.free,
                ),
              ),
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
        final chartVirtualRect = barChartLeaf.chartVirtualRect!;

        expect(chartVirtualRect.size, greaterThan(renderBox.size));
        expect(chartVirtualRect.left, isNegative);
        expect(chartVirtualRect.top, isNegative);
      });

      testWidgets('scales horizontally with FlScaleAxis.horizontal',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: BarChart(
              BarChartData(
                scaleData: const FlScaleData(
                  scaleAxis: FlScaleAxis.horizontal,
                ),
              ),
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
        final chartVirtualRect = barChartLeaf.chartVirtualRect!;

        expect(chartVirtualRect.size.height, renderBox.size.height);
        expect(chartVirtualRect.size.width, greaterThan(renderBox.size.width));
        expect(chartVirtualRect.left, isNegative);
        expect(chartVirtualRect.top, 0);
      });

      testWidgets('scales vertically with FlScaleAxis.vertical',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: BarChart(
              BarChartData(
                scaleData: const FlScaleData(
                  scaleAxis: FlScaleAxis.vertical,
                ),
              ),
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
        final chartVirtualRect = barChartLeaf.chartVirtualRect!;

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
            (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: BarChart(
                BarChartData(
                  scaleData: const FlScaleData(
                    scaleAxis: FlScaleAxis.horizontal,
                  ),
                ),
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
          final chartVirtualRectBeforePan =
              barChartLeafBeforePan.chartVirtualRect!;
          expect(chartVirtualRectBeforePan.top, 0);

          const panOffset = Offset(100, 100);
          await tester.dragFrom(chartCenterOffset, panOffset);
          await tester.pumpAndSettle();

          final barChartLeafAfterPan = tester.widget<BarChartLeaf>(
            find.byType(BarChartLeaf),
          );
          final chartVirtualRectAfterPan =
              barChartLeafAfterPan.chartVirtualRect!;

          expect(chartVirtualRectBeforePan.size, chartVirtualRectAfterPan.size);
          expect(
            chartVirtualRectAfterPan.left,
            greaterThan(chartVirtualRectBeforePan.left),
          );
          expect(chartVirtualRectAfterPan.top, 0);
        });

        testWidgets('only vertically with FlScaleAxis.vertical',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: BarChart(
                BarChartData(
                  scaleData: const FlScaleData(
                    scaleAxis: FlScaleAxis.vertical,
                  ),
                ),
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
          final chartVirtualRectBeforePan =
              barChartLeafBeforePan.chartVirtualRect!;
          expect(chartVirtualRectBeforePan.left, 0);

          const panOffset = Offset(100, 100);
          await tester.dragFrom(chartCenterOffset, panOffset);
          await tester.pumpAndSettle();

          final barChartLeafAfterPan = tester.widget<BarChartLeaf>(
            find.byType(BarChartLeaf),
          );
          final chartVirtualRectAfterPan =
              barChartLeafAfterPan.chartVirtualRect!;

          expect(chartVirtualRectAfterPan.left, 0);
          expect(
            chartVirtualRectAfterPan.top,
            greaterThan(chartVirtualRectBeforePan.top),
          );
        });

        testWidgets('freely with FlScaleAxis.free',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: BarChart(
                BarChartData(
                  scaleData: const FlScaleData(
                    scaleAxis: FlScaleAxis.free,
                  ),
                ),
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
          final chartVirtualRectBeforePan =
              barChartLeafBeforePan.chartVirtualRect!;
          expect(chartVirtualRectBeforePan.top, isNegative);
          expect(chartVirtualRectBeforePan.left, isNegative);

          const panOffset = Offset(100, 100);
          await tester.dragFrom(chartCenterOffset, panOffset);
          await tester.pumpAndSettle();

          final barChartLeafAfterPan = tester.widget<BarChartLeaf>(
            find.byType(BarChartLeaf),
          );
          final chartVirtualRectAfterPan =
              barChartLeafAfterPan.chartVirtualRect!;

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
            (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: BarChart(
                BarChartData(
                  scaleData: const FlScaleData(
                    scaleAxis: FlScaleAxis.horizontal,
                  ),
                ),
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

          final chartVirtualRectBeforePan =
              barChartLeafBeforePan.chartVirtualRect!;
          expect(chartVirtualRectBeforePan.top, 0);

          final pointer = TestPointer(1, PointerDeviceKind.trackpad);
          const leftAndUp = Offset(-100, -100);
          await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
          await tester.pump();
          await tester.sendEventToBinding(pointer.scroll(leftAndUp));
          await tester.pump();

          final barChartLeafAfterPan = tester.widget<BarChartLeaf>(
            find.byType(BarChartLeaf),
          );
          final chartVirtualRectAfterPan =
              barChartLeafAfterPan.chartVirtualRect!;

          expect(
            chartVirtualRectAfterPan.left,
            greaterThan(chartVirtualRectBeforePan.left),
          );
          expect(chartVirtualRectAfterPan.top, 0);
        });

        testWidgets('vertically with FlScaleAxis.vertical',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: BarChart(
                BarChartData(
                  scaleData: const FlScaleData(
                    scaleAxis: FlScaleAxis.vertical,
                  ),
                ),
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

          final chartVirtualRectBeforePan =
              barChartLeafBeforePan.chartVirtualRect!;
          expect(chartVirtualRectBeforePan.left, 0);

          final pointer = TestPointer(1, PointerDeviceKind.trackpad);
          const leftAndUp = Offset(-100, -100);
          await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
          await tester.pump();
          await tester.sendEventToBinding(pointer.scroll(leftAndUp));
          await tester.pump();

          final barChartLeafAfterPan = tester.widget<BarChartLeaf>(
            find.byType(BarChartLeaf),
          );
          final chartVirtualRectAfterPan =
              barChartLeafAfterPan.chartVirtualRect!;

          expect(chartVirtualRectAfterPan.left, 0);
          expect(
            chartVirtualRectAfterPan.top,
            greaterThan(chartVirtualRectBeforePan.top),
          );
        });

        testWidgets('freely with FlScaleAxis.free',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: BarChart(
                BarChartData(
                  scaleData: const FlScaleData(
                    scaleAxis: FlScaleAxis.free,
                  ),
                ),
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

          final chartVirtualRectBeforePan =
              barChartLeafBeforePan.chartVirtualRect!;

          final pointer = TestPointer(1, PointerDeviceKind.trackpad);
          const leftAndUp = Offset(-100, -100);
          await tester.sendEventToBinding(pointer.hover(chartCenterOffset));
          await tester.pump();
          await tester.sendEventToBinding(pointer.scroll(leftAndUp));
          await tester.pump();

          final barChartLeafAfterPan = tester.widget<BarChartLeaf>(
            find.byType(BarChartLeaf),
          );
          final chartVirtualRectAfterPan =
              barChartLeafAfterPan.chartVirtualRect!;

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
        (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(
              chart: BarChart(
                BarChartData(
                  scaleData: const FlScaleData(
                    // ignore: avoid_redundant_argument_values
                    scaleAxis: FlScaleAxis.none,
                    trackpadScrollCausesScale: true,
                  ),
                ),
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
          expect(barChartLeaf.chartVirtualRect, null);
        },
      );

      for (final scaleAxis in FlScaleAxis.scalingEnabledAxis) {
        testWidgets(
          'does not scale when trackpadScrollCausesScale is false '
          'for $scaleAxis',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              createTestWidget(
                chart: BarChart(
                  BarChartData(
                    scaleData: FlScaleData(
                      scaleAxis: scaleAxis,
                      // ignore: avoid_redundant_argument_values
                      trackpadScrollCausesScale: false,
                    ),
                  ),
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
            expect(barChartLeaf.chartVirtualRect, null);
          },
        );
      }

      testWidgets('scales horizontally with FlScaleAxis.horizontal',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: BarChart(
              BarChartData(
                scaleData: const FlScaleData(
                  scaleAxis: FlScaleAxis.horizontal,
                  trackpadScrollCausesScale: true,
                ),
              ),
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
        final chartVirtualRect = barChartLeaf.chartVirtualRect!;

        expect(chartVirtualRect.size.height, renderBox.size.height);
        expect(chartVirtualRect.size.width, greaterThan(renderBox.size.width));
        expect(chartVirtualRect.left, isNegative);
        expect(chartVirtualRect.top, 0);
      });

      testWidgets('scales vertically with FlScaleAxis.vertical',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: BarChart(
              BarChartData(
                scaleData: const FlScaleData(
                  scaleAxis: FlScaleAxis.vertical,
                  trackpadScrollCausesScale: true,
                ),
              ),
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
        final chartVirtualRect = barChartLeaf.chartVirtualRect!;

        expect(
          chartVirtualRect.size.height,
          greaterThan(renderBox.size.height),
        );
        expect(chartVirtualRect.size.width, renderBox.size.width);
        expect(chartVirtualRect.left, 0);
        expect(chartVirtualRect.top, isNegative);
      });

      testWidgets('scales freely with FlScaleAxis.free',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            chart: BarChart(
              BarChartData(
                scaleData: const FlScaleData(
                  scaleAxis: FlScaleAxis.free,
                  trackpadScrollCausesScale: true,
                ),
              ),
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
        final chartVirtualRect = barChartLeaf.chartVirtualRect!;

        expect(chartVirtualRect.size, greaterThan(renderBox.size));
        expect(chartVirtualRect.left, isNegative);
        expect(chartVirtualRect.top, isNegative);
      });
    });
  });
}
