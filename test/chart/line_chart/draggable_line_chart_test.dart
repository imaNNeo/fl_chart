import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget({
    required DraggableLineChart chart,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 400,
          height: 400,
          child: chart,
        ),
      ),
    );
  }

  group('DraggableLineChart', () {
    testWidgets('builds correctly with basic data', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          chart: DraggableLineChart(
            data: LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    const FlSpot(0, 1),
                    const FlSpot(1, 2),
                    const FlSpot(2, 1.5),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(DraggableLineChart), findsOneWidget);
      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('disables touch on underlying LineChart', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          chart: DraggableLineChart(
            data: LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: [const FlSpot(0, 1), const FlSpot(1, 2)],
                ),
              ],
            ),
          ),
        ),
      );

      final lineChart = tester.widget<LineChart>(find.byType(LineChart));
      expect(lineChart.data.lineTouchData?.enabled, false);
    });

    testWidgets('calls onSpotTap when spot is tapped', (WidgetTester tester) async {
      int? tappedBarIndex;
      int? tappedSpotIndex;
      FlSpot? tappedSpot;

      await tester.pumpWidget(
        createTestWidget(
          chart: DraggableLineChart(
            data: LineChartData(
              minX: 0,
              maxX: 10,
              minY: 0,
              maxY: 10,
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    const FlSpot(5, 5),
                  ],
                ),
              ],
            ),
            onSpotTap: (barIndex, spotIndex, spot) {
              tappedBarIndex = barIndex;
              tappedSpotIndex = spotIndex;
              tappedSpot = spot;
            },
          ),
        ),
      );

      // Tap the center of the chart where the spot should be
      await tester.tapAt(tester.getCenter(find.byType(DraggableLineChart)));
      await tester.pump();

      expect(tappedBarIndex, 0);
      expect(tappedSpotIndex, 0);
      expect(tappedSpot, const FlSpot(5, 5));
    });

    testWidgets('calls onDragStart when drag begins', (WidgetTester tester) async {
      int? draggedBarIndex;
      int? draggedSpotIndex;
      FlSpot? draggedSpot;

      await tester.pumpWidget(
        createTestWidget(
          chart: DraggableLineChart(
            data: LineChartData(
              minX: 0,
              maxX: 10,
              minY: 0,
              maxY: 10,
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    const FlSpot(5, 5),
                  ],
                ),
              ],
            ),
            onDragStart: (barIndex, spotIndex, spot) {
              draggedBarIndex = barIndex;
              draggedSpotIndex = spotIndex;
              draggedSpot = spot;
            },
          ),
        ),
      );

      final center = tester.getCenter(find.byType(DraggableLineChart));
      await tester.startGesture(center);
      await tester.pump();

      expect(draggedBarIndex, 0);
      expect(draggedSpotIndex, 0);
      expect(draggedSpot, const FlSpot(5, 5));
    });

    testWidgets('calls onDragUpdate during drag', (WidgetTester tester) async {
      final List<FlSpot> updatedSpots = [];

      await tester.pumpWidget(
        createTestWidget(
          chart: DraggableLineChart(
            dragTolerance: 50.0, // High tolerance to ensure we hit the spot
            data: LineChartData(
              minX: 0,
              maxX: 10,
              minY: 0,
              maxY: 10,
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    const FlSpot(5, 5),
                  ],
                ),
              ],
            ),
            onDragStart: (barIndex, spotIndex, spot) {}, // Required for drag to work
            onDragUpdate: (barIndex, spotIndex, oldSpot, newSpot) {
              updatedSpots.add(newSpot);
            },
          ),
        ),
      );

      final center = tester.getCenter(find.byType(DraggableLineChart));
      final gesture = await tester.startGesture(center);
      await tester.pump();
      await gesture.moveTo(center + const Offset(50, 50));
      await tester.pumpAndSettle();
      await gesture.up();
      await tester.pump();

      expect(updatedSpots.isNotEmpty, true);
    });

    testWidgets('calls onDragEnd when drag ends', (WidgetTester tester) async {
      bool dragEnded = false;

      await tester.pumpWidget(
        createTestWidget(
          chart: DraggableLineChart(
            data: LineChartData(
              minX: 0,
              maxX: 10,
              minY: 0,
              maxY: 10,
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    const FlSpot(5, 5),
                  ],
                ),
              ],
            ),
            onDragStart: (barIndex, spotIndex, spot) {},
            onDragEnd: () {
              dragEnded = true;
            },
          ),
        ),
      );

      final center = tester.getCenter(find.byType(DraggableLineChart));
      final gesture = await tester.startGesture(center);
      await tester.pump();
      await gesture.moveTo(center + const Offset(50, 50));
      await tester.pump();
      await gesture.up();
      await tester.pump();

      expect(dragEnded, true);
    });

    testWidgets('applies constrainDrag callback', (WidgetTester tester) async {
      FlSpot? constrainedSpot;

      await tester.pumpWidget(
        createTestWidget(
          chart: DraggableLineChart(
            dragTolerance: 50.0,
            data: LineChartData(
              minX: 0,
              maxX: 10,
              minY: 0,
              maxY: 10,
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    const FlSpot(5, 5),
                  ],
                ),
              ],
            ),
            onDragStart: (barIndex, spotIndex, spot) {}, // Required for drag to work
            constrainDrag: (barIndex, spotIndex, oldSpot, proposedSpot) {
              // Constrain to only horizontal movement
              return FlSpot(proposedSpot.x, oldSpot.y);
            },
            onDragUpdate: (barIndex, spotIndex, oldSpot, newSpot) {
              constrainedSpot = newSpot;
            },
          ),
        ),
      );

      final center = tester.getCenter(find.byType(DraggableLineChart));
      final gesture = await tester.startGesture(center);
      await tester.pump();
      await gesture.moveTo(center + const Offset(50, 50));
      await tester.pumpAndSettle();
      await gesture.up();
      await tester.pump();

      // Y should remain at 5 due to constraint
      expect(constrainedSpot?.y, 5);
    });

    testWidgets('respects canDragSpot callback', (WidgetTester tester) async {
      bool dragStarted = false;

      await tester.pumpWidget(
        createTestWidget(
          chart: DraggableLineChart(
            data: LineChartData(
              minX: 0,
              maxX: 10,
              minY: 0,
              maxY: 10,
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    const FlSpot(5, 5),
                  ],
                ),
              ],
            ),
            canDragSpot: (barIndex, spotIndex) => false, // Disable dragging
            onDragStart: (barIndex, spotIndex, spot) {
              dragStarted = true;
            },
          ),
        ),
      );

      await tester.drag(find.byType(DraggableLineChart), const Offset(50, 50));
      await tester.pump();

      expect(dragStarted, false);
    });

    testWidgets('does not trigger onSpotTap during drag', (WidgetTester tester) async {
      bool tapped = false;
      bool dragged = false;

      await tester.pumpWidget(
        createTestWidget(
          chart: DraggableLineChart(
            data: LineChartData(
              minX: 0,
              maxX: 10,
              minY: 0,
              maxY: 10,
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    const FlSpot(5, 5),
                  ],
                ),
              ],
            ),
            onSpotTap: (barIndex, spotIndex, spot) {
              tapped = true;
            },
            onDragStart: (barIndex, spotIndex, spot) {
              dragged = true;
            },
          ),
        ),
      );

      // Perform a drag (not a tap)
      await tester.drag(find.byType(DraggableLineChart), const Offset(50, 0));
      await tester.pump();

      expect(dragged, true);
      expect(tapped, false);
    });

    testWidgets('handles multiple bars correctly', (WidgetTester tester) async {
      int? draggedBarIndex;

      await tester.pumpWidget(
        createTestWidget(
          chart: DraggableLineChart(
            dragTolerance: 50.0,
            data: LineChartData(
              minX: 0,
              maxX: 10,
              minY: 0,
              maxY: 10,
              lineBarsData: [
                LineChartBarData(
                  spots: [const FlSpot(5, 5)],
                ),
                LineChartBarData(
                  spots: [const FlSpot(8, 8)],
                ),
              ],
            ),
            onDragStart: (barIndex, spotIndex, spot) {
              draggedBarIndex = barIndex;
            },
          ),
        ),
      );

      // Should find the nearest spot
      final center = tester.getCenter(find.byType(DraggableLineChart));
      await tester.startGesture(center);
      await tester.pump();

      expect(draggedBarIndex, isNotNull);
    });

    testWidgets('respects dragTolerance parameter', (WidgetTester tester) async {
      bool dragStartedWithHighTolerance = false;

      // Test with high tolerance (easier to hit)
      await tester.pumpWidget(
        createTestWidget(
          chart: DraggableLineChart(
            dragTolerance: 50.0, // Very high tolerance
            data: LineChartData(
              minX: 0,
              maxX: 10,
              minY: 0,
              maxY: 10,
              lineBarsData: [
                LineChartBarData(
                  spots: [const FlSpot(5, 5)],
                ),
              ],
            ),
            onDragStart: (barIndex, spotIndex, spot) {
              dragStartedWithHighTolerance = true;
            },
          ),
        ),
      );

      final center = tester.getCenter(find.byType(DraggableLineChart));
      await tester.startGesture(center + const Offset(50, 50));
      await tester.pump();

      // With high tolerance, should still detect the spot
      expect(dragStartedWithHighTolerance, true);
    });
  });
}
