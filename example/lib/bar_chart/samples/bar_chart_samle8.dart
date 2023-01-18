import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _BarChart extends StatelessWidget {
  const _BarChart();

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
        extraLinesData: _extraLinesData,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white70,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'User 1';
        break;
      case 1:
        text = 'User 2';
        break;
      case 2:
        text = 'User 3';
        break;
      case 3:
        text = 'User 4';
        break;
      case 4:
        text = 'User 5';
        break;
      case 5:
        text = 'User 6';
        break;
      case 6:
        text = 'User 7';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Colors.pink,
          Colors.lightBlue,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: 8,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: 10,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: 14,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: 15,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: 13,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: 10,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
              toY: 16,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
      ];

  ExtraLinesData get _extraLinesData => ExtraLinesData(
        horizontalLines: [
          HorizontalLine(
            y: 11.6,
            label: HorizontalLineLabel(
              show: true,
              labelResolver: (p0) => 'μ: ${p0.y}',
              style: const TextStyle(color: Colors.white70),
            ),
            color: Colors.pink,
          ),
          HorizontalLine(
            y: 14.15,
            label: HorizontalLineLabel(
              show: true,
              labelResolver: (p0) => '1σ: ${p0.y}',
              style: const TextStyle(color: Colors.white70),
            ),
            color: Colors.lightBlueAccent,
          ),
          HorizontalLine(
            y: 16.64,
            label: HorizontalLineLabel(
              show: true,
              labelResolver: (p0) => '2σ: ${p0.y}',
              style: const TextStyle(color: Colors.white70),
            ),
            color: Colors.blueAccent,
          ),
          HorizontalLine(
            y: 9.1,
            label: HorizontalLineLabel(
              show: true,
              labelResolver: (p0) => '-1σ: ${p0.y}',
              style: const TextStyle(color: Colors.white70),
            ),
            color: Colors.lightBlueAccent,
          ),
          HorizontalLine(
            y: 6.61,
            label: HorizontalLineLabel(
              show: true,
              labelResolver: (p0) => '-2σ: ${p0.y}',
              style: const TextStyle(color: Colors.white70),
            ),
            color: Colors.blueAccent,
          ),
        ],
      );
}

class BarChartSample8 extends StatefulWidget {
  const BarChartSample8({super.key});

  @override
  State<StatefulWidget> createState() => BarChartSample8State();
}

class BarChartSample8State extends State<BarChartSample8> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: Colors.blueGrey,
        child: const _BarChart(),
      ),
    );
  }
}
