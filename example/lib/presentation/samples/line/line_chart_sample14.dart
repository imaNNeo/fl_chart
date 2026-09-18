import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LineChartSample14 extends StatefulWidget {
  const LineChartSample14({super.key});

  @override
  State<LineChartSample14> createState() => _LineChartSample14State();
}

class _LineChartSample14State extends State<LineChartSample14> {
  FlDotImagePainter? _dotPainter;

  @override
  void initState() {
    _loadDotPainter();
    super.initState();
  }

  // FlDotImagePainter.draw() is synchronous, so the image has to be decoded
  // before we build the chart.
  void _loadDotPainter() async {
    final data = await rootBundle.load('assets/icons/image_annotation.png');
    final buffer = await ui.ImmutableBuffer.fromUint8List(
      data.buffer.asUint8List(),
    );
    final codec =
        await PaintingBinding.instance.instantiateImageCodecWithSize(buffer);
    final frame = await codec.getNextFrame();
    if (!mounted) {
      return;
    }
    setState(() {
      _dotPainter = FlDotImagePainter(
        image: frame.image,
        size: 20,
        mainColor: AppColors.contentColorBlue,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final dotPainter = _dotPainter;
    return AspectRatio(
      aspectRatio: 1.5,
      child: Stack(
        children: [
          if (dotPainter == null)
            const Center(child: CircularProgressIndicator()),
          if (dotPainter != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 6,
                  titlesData: const FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 1,
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 3),
                        FlSpot(1, 1),
                        FlSpot(2, 4),
                        FlSpot(3, 2),
                        FlSpot(4, 5),
                        FlSpot(5, 3),
                        FlSpot(6, 4),
                      ],
                      isCurved: true,
                      color: AppColors.contentColorBlue,
                      barWidth: 3,
                      dotData: FlDotData(
                        getDotPainter: (spot, percent, barData, index) =>
                            dotPainter,
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.contentColorBlue.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
