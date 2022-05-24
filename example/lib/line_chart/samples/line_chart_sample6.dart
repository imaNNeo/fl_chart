import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LineChartSample6 extends StatelessWidget {
  final spots = const [
    FlSpot(0, 1),
    FlSpot(2, 5),
    FlSpot(4, 3),
    FlSpot(6, 5),
  ];

  final spots2 = const [
    FlSpot(0, 3),
    FlSpot(2, 1),
    FlSpot(4, 2),
    FlSpot(6, 1),
  ];

  late double minSpotX, maxSpotX;
  late double minSpotY, maxSpotY;

  LineChartSample6({Key? key}) : super(key: key) {
    minSpotX = spots.first.x;
    maxSpotX = spots.first.x;
    minSpotY = spots.first.y;
    maxSpotY = spots.first.y;

    for (var spot in spots) {
      if (spot.x > maxSpotX) {
        maxSpotX = spot.x;
      }

      if (spot.x < minSpotX) {
        minSpotX = spot.x;
      }

      if (spot.y > maxSpotY) {
        maxSpotY = spot.y;
      }

      if (spot.y < minSpotY) {
        minSpotY = spot.y;
      }
    }
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.deepOrange,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );

    final intValue = reverseY(value, minSpotY, maxSpotY).toInt();

    if (intValue == (maxSpotY + minSpotY)) {
      return const Text('', style: style);
    }

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Text(
        intValue.toString(),
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    final intValue = reverseY(value, minSpotY, maxSpotY).toInt();

    if (intValue == (maxSpotY + minSpotY)) {
      return const Text('', style: style);
    }

    return Text(intValue.toString(), style: style, textAlign: TextAlign.right);
  }

  Widget topTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(value.toInt().toString(), style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10,
              spreadRadius: 0,
            )
          ]),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [
            Colors.yellowAccent,
            Colors.yellowAccent.withOpacity(0.1),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 22.0, bottom: 20),
          child: SizedBox(
            width: 300,
            height: 200,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(enabled: false),
                lineBarsData: [
                  LineChartBarData(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.deepOrangeAccent,
                        Colors.orangeAccent,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    spots: reverseSpots(spots, minSpotY, maxSpotY),
                    isCurved: true,
                    isStrokeCapRound: true,
                    barWidth: 10,
                    belowBarData: BarAreaData(
                      show: false,
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                              radius: 12,
                              color: Colors.deepOrange.withOpacity(0.5)),
                    ),
                  ),
                  LineChartBarData(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.lightBlueAccent,
                        Colors.blue,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    spots: reverseSpots(spots2, minSpotY, maxSpotY),
                    isCurved: true,
                    isStrokeCapRound: true,
                    barWidth: 10,
                    belowBarData: BarAreaData(
                      show: false,
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                              radius: 12, color: Colors.blue.withOpacity(0.5)),
                    ),
                  ),
                ],
                minY: 0,
                maxY: maxSpotY + minSpotY,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: leftTitleWidgets,
                      reservedSize: 38,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: rightTitleWidgets,
                        reservedSize: 30),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: topTitleWidgets,
                    ),
                  ),
                ),
                gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    checkToShowHorizontalLine: (value) {
                      final intValue =
                          reverseY(value, minSpotY, maxSpotY).toInt();

                      if (intValue.toInt() == (maxSpotY + minSpotY).toInt()) {
                        return false;
                      }

                      return true;
                    }),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(color: Colors.black),
                    top: BorderSide(color: Colors.black),
                    bottom: BorderSide(color: Colors.transparent),
                    right: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double reverseY(double y, double minX, double maxX) {
    return (maxX + minX) - y;
  }

  List<FlSpot> reverseSpots(List<FlSpot> inputSpots, double minY, double maxY) {
    return inputSpots.map((spot) {
      return spot.copyWith(y: (maxY + minY) - spot.y);
    }).toList();
  }
}
