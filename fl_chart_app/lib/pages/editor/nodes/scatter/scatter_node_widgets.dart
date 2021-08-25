

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/pages/widgets/color_indicator.dart';
import 'package:fl_chart_app/resources/app_colors.dart';
import 'package:flutter/material.dart';

class ScatterSpotNodeWidget extends StatelessWidget {
  final ScatterSpot spot;

  const ScatterSpotNodeWidget(this.spot);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ColorIndicator(color: spot.color),
        SizedBox(
          width: 8,
        ),
        Text(
          'x: ${spot.x}, y: ${spot.y}, radius: ${spot.radius}',
          style: TextStyle(color: AppColors.editorItemsColor),
        )
      ],
    );
  }
}
