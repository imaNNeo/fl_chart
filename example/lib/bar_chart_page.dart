import 'package:flutter/material.dart';

class BarChartPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("BarChart", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }

}