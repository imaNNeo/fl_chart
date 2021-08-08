import 'package:fl_chart_app/resources/app_dimens.dart';
import 'package:flutter/material.dart';

class ChartHolder extends StatelessWidget {
  final Widget? child;

  const ChartHolder({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFF282E45),
            borderRadius: BorderRadius.all(Radius.circular(AppDimens.defaultRadius)),
          ),
          child: child,
        );
      },
    );
  }
}
