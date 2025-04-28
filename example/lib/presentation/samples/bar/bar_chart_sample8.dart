import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart_app/util/extensions/color_extensions.dart';
import 'package:flutter/material.dart';

class BarChartSample8 extends StatefulWidget {
  BarChartSample8({super.key});

  final Color barBackgroundColor =
      AppColors.contentColorWhite.darken().withValues(alpha: 0.3);
  final Color barColor = AppColors.contentColorWhite;

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample8> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.graphic_eq),
                const SizedBox(
                  width: 32,
                ),
                Text(
                  'Sales forecasting chart',
                  style: TextStyle(
                    color: widget.barColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Expanded(
              child: BarChart(
                randomData(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y,
    FlErrorRange errorRange,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          toYErrorRange: errorRange,
          color: x >= 4 ? Colors.transparent : widget.barColor,
          borderRadius: BorderRadius.zero,
          borderDashArray: x >= 4 ? [4, 4] : null,
          width: 22,
          borderSide: BorderSide(color: widget.barColor, width: 2.0),
        ),
      ],
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    Widget text = Text(
      days[value.toInt()],
      style: style,
    );

    return SideTitleWidget(
      meta: meta,
      space: 16,
      child: text,
    );
  }

  BarChartData randomData() {
    return BarChartData(
      maxY: 300.0,
      barTouchData: const BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 30,
            showTitles: true,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(
        7,
        (i) {
          final y = Random().nextInt(290).toDouble() + 10;
          final lowerBy = y < 50
              ? Random().nextDouble() * 10
              : Random().nextDouble() * 30 + 5;
          final upperBy = y > 290
              ? Random().nextDouble() * 10
              : Random().nextDouble() * 30 + 5;
          return makeGroupData(
            i,
            y,
            FlErrorRange(
              lowerBy: lowerBy,
              upperBy: upperBy,
            ),
          );
        },
      ),
      gridData: const FlGridData(show: false),
      errorIndicatorData: FlErrorIndicatorData(
        painter: _errorPainter,
      ),
    );
  }

  FlSpotErrorRangePainter _errorPainter(
    BarChartSpotErrorRangeCallbackInput input,
  ) =>
      FlSimpleErrorPainter(
        lineWidth: 2.0,
        capLength: 14,
        lineColor: input.groupIndex < 4
            ? AppColors.contentColorOrange
            : AppColors.primary.withValues(alpha: 0.5),
      );
}
