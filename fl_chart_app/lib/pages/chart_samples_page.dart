import 'package:fl_chart_app/util/app_helper.dart';
import 'package:flutter/material.dart';

class ChartSamplesPage extends StatelessWidget {
  final String chartSlug;
  final bool isStandAlonePage;

  const ChartSamplesPage({
    Key? key,
    required this.chartSlug,
    required this.isStandAlonePage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isStandAlonePage ? AppBar() : null,
      backgroundColor: Colors.blueGrey,
      body: Container(
        child: Center(
          child: Text(
            AppHelper.getChartName(chartSlug),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 38,
            ),
          ),
        ),
      ),
    );
  }
}
