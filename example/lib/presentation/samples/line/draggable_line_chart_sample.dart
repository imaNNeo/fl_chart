import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Example demonstrating drag-to-edit functionality with DraggableLineChart
/// Launches a fullscreen demo to avoid scrollable context issues
class DraggableLineChartSample extends StatelessWidget {
  const DraggableLineChartSample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'Interactive Draggable Chart',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Point dragging unsupported in scrollable context - Tap the button to try the draggable chart in fullscreen mode.',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const _DraggableLineChartDemo(),
                ),
              );
            },
            icon: const Icon(Icons.touch_app),
            label: const Text('Launch Interactive Demo'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

/// Fullscreen demo of the draggable chart
class _DraggableLineChartDemo extends StatefulWidget {
  const _DraggableLineChartDemo();

  @override
  State<_DraggableLineChartDemo> createState() =>
      _DraggableLineChartDemoState();
}

class _DraggableLineChartDemoState extends State<_DraggableLineChartDemo> {
  // Mutable data that can be edited by dragging
  List<FlSpot> dataPoints = [
    const FlSpot(0, 3),
    const FlSpot(2, 5),
    const FlSpot(4, 2),
    const FlSpot(6, 7),
    const FlSpot(8, 5),
    const FlSpot(10, 8),
  ];

  int? selectedPointIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draggable Line Chart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                // Reset to initial data
                dataPoints = [
                  const FlSpot(0, 3),
                  const FlSpot(2, 5),
                  const FlSpot(4, 2),
                  const FlSpot(6, 7),
                  const FlSpot(8, 5),
                  const FlSpot(10, 8),
                ];
                selectedPointIndex = null;
              });
            },
            tooltip: 'Reset Data',
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Try it out!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Tap any point to select it (turns red)\n'
                      '• Drag points to move them around\n'
                      '• Use the refresh button to reset',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DraggableLineChart(
                dragTolerance: 10.0,
                // Add constraints to keep points in order and within bounds
                constrainDrag: (barIndex, spotIndex, oldSpot, proposedSpot) {
                  // Get the previous and next points to constrain X movement
                  // Add padding to prevent points from getting too close
                  const minSpacing = 0.8;
                  final prevX = spotIndex > 0 
                      ? dataPoints[spotIndex - 1].x + minSpacing 
                      : 0.0;
                  final nextX = spotIndex < dataPoints.length - 1 
                      ? dataPoints[spotIndex + 1].x - minSpacing
                      : 10.0;
                  
                  // Constrain X to stay between neighbors with spacing
                  final constrainedX = proposedSpot.x.clamp(prevX, nextX);
                  // Constrain Y within chart bounds
                  final constrainedY = proposedSpot.y.clamp(0.0, 10.0);
                  
                  return FlSpot(constrainedX, constrainedY);
                },
                data: LineChartData(
                  minX: 0,
                  maxX: 10,
                  minY: 0,
                  maxY: 10,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: true,
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: dataPoints,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          final isSelected = index == selectedPointIndex;
                          return FlDotCirclePainter(
                            radius: isSelected ? 10 : 6,
                            color: isSelected ? Colors.red : Colors.blue,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                onSpotTap: (barIndex, spotIndex, spot) {
                  setState(() {
                    selectedPointIndex = spotIndex;
                  });
                },
                onDragStart: (barIndex, spotIndex, spot) {
                  setState(() {
                    selectedPointIndex = spotIndex;
                  });
                },
                onDragUpdate: (barIndex, spotIndex, oldSpot, newSpot) {
                  setState(() {
                    dataPoints[spotIndex] = FlSpot(
                      newSpot.x.clamp(0.0, 10.0),
                      newSpot.y.clamp(0.0, 10.0),
                    );
                  });
                },
                onDragEnd: () {
                  // Drag complete
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
