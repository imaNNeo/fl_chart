import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {

  final Color color;
  final String text;
  final bool isSquare;

  const Indicator({
    Key key,
    this.color,
    this.text,
    this.isSquare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff505050)),
        )
      ],
    );
  }

}