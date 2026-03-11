import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// LineChartSample14 demonstrates how to use FlDotImagePainter
/// to display custom images as dot markers on a line chart.
///
/// This sample shows:
/// - Loading images asynchronously before creating the chart
/// - Using FlDotImagePainter with custom image assets
/// - Handling loading states while images are being loaded
class LineChartSample14 extends StatefulWidget {
  const LineChartSample14({super.key});

  @override
  State<LineChartSample14> createState() => _LineChartSample14State();
}

class _LineChartSample14State extends State<LineChartSample14> {
  /// The custom dot painter that will render images at each data point.
  /// Null until the image is loaded asynchronously.
  FlDotImagePainter? _dotPainter;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  /// Loads the image asset and creates a FlDotImagePainter.
  ///
  /// This must be done asynchronously before the chart can be rendered
  /// because the draw() method is synchronous and cannot load images on-demand.
  Future<void> _loadImage() async {
    final image = await FlDotImagePainter.loadImageFromAsset(
      'assets/icons/image_annotation.png',
    );
    setState(() {
      _dotPainter = FlDotImagePainter(image: image, size: 20.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while the image is being loaded
    if (_dotPainter == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            // Define the chart boundaries
            minX: 0,
            maxX: 6,
            minY: 0,
            maxY: 6,
            // Configure axis titles
            titlesData: FlTitlesData(
              show: true,
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
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: const FlGridData(show: true),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey),
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
                color: Colors.blue,
                barWidth: 3,
                // Use FlDotImagePainter to display custom images at each data point
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    // Return the pre-loaded image painter for each dot
                    return _dotPainter!;
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blue.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
