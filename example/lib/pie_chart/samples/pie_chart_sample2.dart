import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class PieChartSample2 extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => PieChart2State();

}

class PieChart2State extends State {

  List<PieChartSectionData> pieChartRawSections;
  List<PieChartSectionData> showingSections;

  StreamController<PieTouchResponse> pieTouchedResultStreamController;

  int touchedIndex;

  @override
  void initState() {
    super.initState();

    final section1 = PieChartSectionData(
      color: Color(0xff0293ee),
      value: 40,
      title: "40%",
      radius: 50,
      titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff)),
    );

    final section2 = PieChartSectionData(
      color: Color(0xfff8b250),
      value: 30,
      title: "30%",
      radius: 50,
      titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff)),
    );

    final section3 = PieChartSectionData(
      color: Color(0xff845bef),
      value: 15,
      title: "15%",
      radius: 50,
      titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff)),
    );

    final section4 = PieChartSectionData(
      color: Color(0xff13d38e),
      value: 15,
      title: "15%",
      radius: 50,
      titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff)),
    );

    final items = [
      section1,
      section2,
      section3,
      section4,
    ];

    pieChartRawSections = items;

    showingSections = pieChartRawSections;

    pieTouchedResultStreamController = StreamController();
    pieTouchedResultStreamController.stream.distinct().listen((details) {
      print(details);
      if (details == null) {
        return;
      }

      touchedIndex = -1;
      if (details.sectionData != null) {
        touchedIndex = showingSections.indexOf(details.sectionData);
      }

      setState(() {
        if (details.touchInput is FlLongPressEnd) {
          touchedIndex = -1;
          showingSections = List.of(pieChartRawSections);
        } else {
          showingSections = List.of(pieChartRawSections);

          if (touchedIndex != -1) {
            TextStyle style = showingSections[touchedIndex].titleStyle;
            showingSections[touchedIndex] = showingSections[touchedIndex].copyWith(
              titleStyle: style.copyWith(
                fontSize: 24,
              ),
              radius: 60,
            );
          }
        }
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: FlChart(
                  chart: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchResponseStreamSink: pieTouchedResultStreamController.sink
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: showingSections),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(color: Color(0xff0293ee), text: "First", isSquare: true,),
                SizedBox(
                  height: 4,
                ),
                Indicator(color: Color(0xfff8b250), text: "Second", isSquare: true,),
                SizedBox(
                  height: 4,
                ),
                Indicator(color: Color(0xff845bef), text: "Third", isSquare: true,),
                SizedBox(
                  height: 4,
                ),
                Indicator(color: Color(0xff13d38e), text: "Fourth", isSquare: true,),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
            SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }

}