import 'package:fl_chart/chart/bar_chart/bar_chart.dart';
import 'package:fl_chart/chart/bar_chart/bar_chart_data.dart';
import 'package:fl_chart/chart/base/fl_axis_chart/fl_axis_chart_data.dart';
import 'package:fl_chart/fl_chart_widget.dart';
import 'package:flutter/material.dart';

class BarChartPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("BarChart", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
          SizedBox(child: sample1(), width: 300, height: 140,),
        ],
      ),
    );
  }


  Widget sample1() {
    return FlChartWidget(
      flChart: BarChart(
        BarChartData(
          gridData: FlGridData(
            show: true,
          ),
          titlesData: FlTitlesData(
            show: true,
            showVerticalTitles: true,
          ),
          alignment: BarChartAlignment.spaceEvenly,
          barSpots: [
            BarChartRodData(
              isRound: false,
              color: Colors.red,
              width: 14,
              x: 0,
              y: 2,
            ),
            BarChartRodData(
              color: Colors.purpleAccent,
              width: 14,
              x: 1,
              y: 6,
            ),
            BarChartRodData(
              color: Colors.blue,
              width: 14,
              x: 2,
              y: 3,
            ),
            BarChartRodData(
              color: Colors.green,
              width: 14,
              x: 3,
              y: 5,
            ),
          ],
        )
      ),
    );
  }

}