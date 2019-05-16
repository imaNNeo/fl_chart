import 'package:example/sample_page.dart';
import 'package:fl_chart/chart/line_chart/line_chart_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart_widget.dart';
import 'package:fl_chart/chart/line_chart/line_chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlChart Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'fl_chart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          SamplePage("Sample 1", sample1()),
          SamplePage("Sample 2", sample2()),
          SamplePage("Sample 3", sample3()),
        ],
      ),
    );
  }

  Widget sample3() {
    return SizedBox(child: FlChartWidget(
      flChart: LineChart(
        LineChartData(
          spots: [
            LineChartSpot(0, 1),
            LineChartSpot(1, 2),
            LineChartSpot(2, 1.5),
            LineChartSpot(3, 3),
            LineChartSpot(4, 3.5),
            LineChartSpot(5, 5),
          ],
          barData: LineChartBarData(
            isCurved: true,
            barWidth: 4,
          ),
          showDots: false,
          showGridLines: true,
          gridData: LineChartGridData(
            drawHorizontalGrid: false,
          ),
        ),
      ),
    ), width: 300, height: 140,);
  }

  Widget sample2() {
    return SizedBox(child: FlChartWidget(
      flChart: LineChart(
        LineChartData(
          spots: [
            LineChartSpot(0, 4),
            LineChartSpot(1, 3.5),
            LineChartSpot(2, 4.5),
            LineChartSpot(3, 1),
            LineChartSpot(4, 4),
            LineChartSpot(5, 6),
            LineChartSpot(6, 6),
            LineChartSpot(7, 6),
            LineChartSpot(8, 7),
          ],
          barData: LineChartBarData(
            isCurved: true,
            barWidth: 8,
            barColor: Colors.purpleAccent,
          ),
          showDots: false,
          showGridLines: true,
          gridData: LineChartGridData(
            checkToShowVerticalGrid: (double value) {
              return value == 1 || value == 6 || value == 4 || value == 5;
            }
          )
        ),
      ),
    ), width: 300, height: 140,);
  }

  Widget sample1() {
    return SizedBox(child: FlChartWidget(
      flChart: LineChart(
        LineChartData(
          spots: [
            LineChartSpot(0, 1.3),
            LineChartSpot(1, 1),
            LineChartSpot(2, 1.8),
            LineChartSpot(3, 1.5),
            LineChartSpot(4, 2.2),
            LineChartSpot(5, 1.8),
            LineChartSpot(6, 3),
          ],
          barData: LineChartBarData(
            isCurved: false,
            barWidth: 4,
            barColor: Colors.orange,
          ),
          showDots: true,
          dotData: LineChartDotData(
            dotColor: Colors.deepOrange,
            dotSize: 6,
            checkToShowDot: (spot) {
              return spot.x != 0 && spot.x != 6;
            }
          ),
          showGridLines: true,
          gridData: LineChartGridData(
            drawHorizontalGrid: true,
            drawVerticalGrid: true,
          ),
          titlesData: LineChartTitlesData(
            getHorizontalTitle: (value) {
              switch (value.toInt()) {
                case 0:
                  return 'Sat';

                case 1:
                  return 'Sun';

                case 2:
                  return 'Mon';

                case 3:
                  return 'Tue';

                case 4:
                  return 'Wed';

                case 5:
                  return 'Thu';

                case 6:
                  return 'Fri';
              }

              return '';
            },
            getVerticalTitle: (value) {
              switch (value.toInt()) {
                case 0:
                  return "";
                case 1:
                  return "1k colories";
                case 2:
                  return "2k colories";
                case 3:
                  return "3k colories";
              }

              return "";
            },
            horizontalTitlesTextStyle: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
            verticalTitlesTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 10
            )
          )
        ),
      ),
    ), width: 300, height: 140,);
  }

  @override
  void dispose() {
    super.dispose();
  }

}
