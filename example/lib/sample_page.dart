import 'package:flutter/material.dart';

class SamplePage extends StatelessWidget {

  final String title;
  final Widget chartWidget;

  const SamplePage(this.title, this.chartWidget, {Key key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 28),),
          chartWidget,
        ],
      ),
    );
  }

}