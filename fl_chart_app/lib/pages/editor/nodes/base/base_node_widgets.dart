
import 'package:fl_chart_app/resources/app_resources.dart';
import 'package:flutter/material.dart';

class AddNodeWidget extends StatelessWidget {
  final String text;

  const AddNodeWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.add, color: AppColors.editorItemsColor,),
        Text(
          text,
          style: AppStyles.editorPanelTextStyle,
        ),
      ],
    );
  }
}
