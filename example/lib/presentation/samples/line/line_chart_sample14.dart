import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:flutter/material.dart';

class LineChartSample14 extends StatefulWidget {
  const LineChartSample14({super.key});

  @override
  State<LineChartSample14> createState() => _LineChartSample14State();
}

class _LineChartSample14State extends State<LineChartSample14> {
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];

  LineChartEntryAnimation entryAnimation = LineChartEntryAnimation.original;
  bool useSecondDataSet = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 60,
              bottom: 12,
            ),
            child: LineChart(
              mainData(),
              duration: const Duration(
                  milliseconds: 1500), // Slower animation to see the effect
              animationType: entryAnimation,
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          height: 40,
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      entryAnimation = LineChartEntryAnimation.values[
                          (entryAnimation.index + 1) %
                              LineChartEntryAnimation.values.length];
                    });
                  },
                  child: Text(
                    "Animation: ${entryAnimation.name}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    useSecondDataSet = !useSecondDataSet;
                  });
                },
                child: const Text(
                  'Toggle DataSet',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('FEB', style: style);
        break;
      case 5:
        text = const Text('MAY', style: style);
        break;
      case 8:
        text = const Text('AUG', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      meta: meta,
      child: text,
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          HorizontalLine(
            y: 3,
            color: AppColors.contentColorRed,
            strokeWidth: 2,
            dashArray: [5, 5],
            label: HorizontalLineLabel(
              show: true,
              alignment: Alignment.topRight,
              style: const TextStyle(
                color: AppColors.contentColorRed,
                fontWeight: FontWeight.bold,
              ),
              labelResolver: (line) => 'Target',
            ),
          ),
        ],
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) => Text(value.toString()),
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: useSecondDataSet ? 18 : 11,
      minY: 0,
      maxY: useSecondDataSet ? 12 : 6,
      lineBarsData: [
        LineChartBarData(
          spots: useSecondDataSet
              ? const [
                  FlSpot(0, 1),
                  FlSpot(1.5, 4),
                  FlSpot(3.2, 2.5),
                  FlSpot(5.1, 5.5),
                  FlSpot(7.3, 4.8),
                  FlSpot(9.2, 9.2),
                  FlSpot(18, 11.8),
                ]
              : const [
                  FlSpot(0, 3),
                  FlSpot(2.6, 2),
                  FlSpot(4.9, 5),
                  FlSpot(6.8, 3.1),
                  FlSpot(8, 4),
                  FlSpot(9.5, 3),
                  FlSpot(11, 4),
                ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            checkToShowDot: (spot, barData) => spot.y > 1.5,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withValues(alpha: 0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
