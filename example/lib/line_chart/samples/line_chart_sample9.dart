import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample9 extends StatefulWidget {
  final int lastDays;
  final bool useRawMilliSeconds; // set this value to TRUE for crashing

  const LineChartSample9(
      {Key key, this.lastDays, this.useRawMilliSeconds = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

const int _kMilliSecondsMultiplier = 100000;

// This is a dummy class which represents real-world values
class _TrackedTemperature {
  // typically dates are represented in milliseconds within charts
  final int dateTimeInMilliseconds;

  final double temperature;

  _TrackedTemperature(this.dateTimeInMilliseconds, this.temperature);
}

class LineChartSample1State extends State<LineChartSample9> {
  List<_TrackedTemperature> realWorldData = [];

  @override
  void initState() {
    super.initState();

    // create one temperature object per day
    for (int i = 0; i < widget.lastDays; i++) {
      final DateTime date = DateTime.now().subtract(Duration(days: i));

      // just any temperature between 18.0 and 19.0
      final double temperature = Random.secure().nextDouble() + 18.0;

      realWorldData
          .add(_TrackedTemperature(date.millisecondsSinceEpoch, temperature));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: [Colors.amber, Colors.amberAccent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 37,
                ),
                Text(
                  'Last ${widget.lastDays} Days',
                  style: TextStyle(
                    color: Colors.amber.shade900,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Temperature Tracker',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 37,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: LineChart(
                      sampleData1(),
                      swapAnimationDuration: const Duration(milliseconds: 250),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartData sampleData1() {
    double interval;

    if (widget.lastDays <= 7) {
      interval = 1000;
    } else if (widget.lastDays <= 30) {
      interval = 10000;
    } else {
      interval = 100000;
    }
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
            getTooltipItems: (spots) {
              return spots
                  .map((e) => LineTooltipItem('${e.y.toStringAsFixed(3)} °C',
                      const TextStyle(color: Colors.orange)))
                  .toList(growable: false);
            }),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          interval: interval,
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            int time;
            if (widget.useRawMilliSeconds) {
              time = value.toInt();
            } else {
              time = value.toInt() * _kMilliSecondsMultiplier;
            }

            final dateTime = DateTime.fromMillisecondsSinceEpoch(time);

            return "${dateTime.day}.${dateTime.month}";
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            return "${value.toStringAsFixed(2)} C°";
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    List<FlSpot> spots;

    if (widget.useRawMilliSeconds) {
      // we don't divide through 100000 so the whole app becomes unresponsive
      spots = List<FlSpot>.unmodifiable(realWorldData.map<FlSpot>(
          (e) => FlSpot((e.dateTimeInMilliseconds).toDouble(), e.temperature)));
    } else {
      spots = List<FlSpot>.unmodifiable(realWorldData.map<FlSpot>((e) => FlSpot(
          (e.dateTimeInMilliseconds / _kMilliSecondsMultiplier).toDouble(),
          e.temperature)));
    }

    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: spots,
      isCurved: true,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [lineChartBarData1];
  }
}
