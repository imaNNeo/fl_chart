import 'package:flutter/material.dart';
import 'package:flutter_smooth_chart/entity/bar.dart';
import 'package:flutter_smooth_chart/entity/spot.dart';
import 'package:flutter_smooth_chart/flutter_smooth_chart.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smooth Chart Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'smooth_chart'),
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
      body: Center(
        child: SizedBox(child: SmoothChart(
          [
            Bar(
              spots: [
                Spot(0, 1),
                Spot(1, 4),
                Spot(2, 1),
                Spot(3, 5),
                Spot(4, 3),
                Spot(5, 8),
                Spot(6, 4),
                Spot(7, 2),
                Spot(8, 8.5),
              ],
              barColor: Colors.red,
              dotColor: Colors.blue,
              showDots: true,
            ),
          ],
          padding: EdgeInsets.all(20),
        ), width: 300, height: 150,),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
