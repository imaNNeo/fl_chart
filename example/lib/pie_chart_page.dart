import 'package:fl_chart/chart/bar_chart/bar_chart_data.dart';
import 'package:fl_chart/chart/pie_chart/pie_chart.dart';
import 'package:fl_chart/chart/pie_chart/pie_chart_data.dart';
import 'package:fl_chart/fl_chart_widget.dart';
import 'package:flutter/material.dart';

class PieChartPage extends StatelessWidget {

  final Color barColor = Colors.white;
  final Color barBackgroundColor = Color(0xff72d8bf);
  final double width = 22;

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Color(0xff232040),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: AspectRatio(
            aspectRatio: 1,
            child: FlChartWidget(
              flChart: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 25,
                      color: Colors.green,
                      widthRadius: 40,
                      title: "25%"
                    ),
                    PieChartSectionData(
                      value: 45,
                      color: Colors.red,
                      widthRadius: 40,
                      title: "45%"
                    ),
                    PieChartSectionData(
                      value: 20,
                      color: Colors.purpleAccent,
                      widthRadius: 40,
                      title: "20%"
                    ),
                    PieChartSectionData(
                      value: 10,
                      color: Colors.blue,
                      widthRadius: 40,
                      title: "10%"
                    ),
                  ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          color: barColor,
          width: width,
          isRound: true,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            color: barBackgroundColor,
          ),
        ),
      ]
    );
  }

}