import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class PieChartSample1 extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => PieChartSample1State();

}

class PieChartSample1State extends State {

  List<PieChartSectionData> pieChartRawSections;
  List<PieChartSectionData> showingSections;


  StreamController<PieTouchResponse> pieTouchedResultStreamController;

  @override
  void initState() {
    super.initState();

    final section1 = PieChartSectionData(
      color: Color(0xff0293ee),
      value: 25,
      title: "",
      radius: 80,
      titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff044d7c)),
      titlePositionPercentageOffset: 0.55,
    );

    final section2 = PieChartSectionData(
      color: Color(0xfff8b250),
      value: 25,
      title: "",
      radius: 65,
      titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff90672d)),
      titlePositionPercentageOffset: 0.55,
    );

    final section3 = PieChartSectionData(
      color: Color(0xff845bef),
      value: 25,
      title: "",
      radius: 60,
      titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff4c3788)),
      titlePositionPercentageOffset: 0.6,
    );

    final section4 = PieChartSectionData(
      color: Color(0xff13d38e),
      value: 25,
      title: "",
      radius: 70,
      titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff0c7f55)),
      titlePositionPercentageOffset: 0.55,
    );

    final items =  [
      section1,
      section2,
      section3,
      section4,
    ];

    pieChartRawSections = List.unmodifiable(items);

    showingSections = List.of(pieChartRawSections);

    pieTouchedResultStreamController = StreamController();
    pieTouchedResultStreamController.stream.distinct().listen((details) {
      if (details == null) {
        return;
      }

      int index = -1;
      if (details.sectionData != null) {
        index = showingSections.indexOf(details.sectionData);
      }

      setState(() {
        if (details.touchInput is FlLongPressEnd) {
          showingSections = List.of(pieChartRawSections);
        } else {
          showingSections = List.of(pieChartRawSections);
          if (index != -1) {
            showingSections[index] = showingSections[index].copyWith(
              color: showingSections[index].color.withOpacity(0.8),
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
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 28,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Indicator(color: Color(0xff0293ee), text: "One", isSquare: false),
                Indicator(color: Color(0xfff8b250), text: "Two", isSquare: false),
                Indicator(color: Color(0xff845bef), text: "Three", isSquare: false),
                Indicator(color: Color(0xff13d38e), text: "Four", isSquare: false),
              ],
            ),
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
                        touchResponseStreamSink: pieTouchedResultStreamController.sink,
                      ),
                      startDegreeOffset: 180,
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 12,
                      centerSpaceRadius: 0,
                      sections: showingSections),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    pieTouchedResultStreamController.close();
  }

}