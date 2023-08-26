import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_colors.dart';
import 'package:flutter/material.dart';

class LineChartSample12 extends StatefulWidget {
  const LineChartSample12({super.key});

  @override
  State<LineChartSample12> createState() => _LineChartSample12State();
}

class _LineChartSample12State extends State<LineChartSample12> {
  List<FlSpot> get spots1 => [
        const FlSpot(1, 3),
        const FlSpot(2, 2),
        const FlSpot(4, 5),
        const FlSpot(6, 4),
      ];
  List<FlSpot> get spots2 => [
        const FlSpot(1, 1),
        const FlSpot(2, 4),
        const FlSpot(3, 6),
        const FlSpot(5, 3),
      ];

  UpdatedDragSpotsData? _lastUpdate;

  void _onUpdated(UpdatedDragSpotsData newUpdate) {
    setState(() {
      _lastUpdate = newUpdate;
    });
  }

  String get _formattedLastSpotValue {
    if (_lastUpdate == null) {
      return 'Updated spot: None';
    }

    final flSpot = _lastUpdate!.newSpots[_lastUpdate!.updatedSpotIndex];

    return 'new X: ${flSpot.x.toStringAsFixed(2)}, new Y: ${flSpot.y.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Text(
          'Last updated bar index: ${_lastUpdate?.updatedBarIndex ?? 'none'}',
          style: const TextStyle(
            color: AppColors.mainTextColor2,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Last updated spot index: ${_lastUpdate?.updatedSpotIndex ?? 'none'}',
          style: const TextStyle(
            color: AppColors.mainTextColor2,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _formattedLastSpotValue,
          style: const TextStyle(
            color: AppColors.mainTextColor2,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        AspectRatio(
          aspectRatio: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 10,
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              return LineChart(
                LineChartData(
                  minY: 0,
                  minX: 0,
                  maxX: 8,
                  maxY: 8,
                  lineTouchData: LineTouchData(
                    enabled: true,
                    handleBuiltInTouches: true,
                    dragSpotUpdateFinishedCallback: _onUpdated,
                    getTouchedSpotIndicator:
                        (LineChartBarData barData, List<int> spotIndexes) {
                      return spotIndexes.map((index) {}).toList();
                    },
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.transparent,
                      getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                        return lineBarsSpot.map((lineBarSpot) {}).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots1,
                      isCurved: true,
                      isDraggable: true,
                    ),
                    LineChartBarData(
                      spots: spots2,
                      isCurved: true,
                      isDraggable: false,
                      color: Colors.red,
                    ),
                  ],
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: AppColors.borderColor,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
