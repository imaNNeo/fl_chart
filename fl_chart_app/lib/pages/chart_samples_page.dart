import 'package:fl_chart_app/resources/app_dimens.dart';
import 'package:fl_chart_app/samples/bar/bar_sample_1.dart';
import 'package:fl_chart_app/samples/line/line_sample_1.dart';
import 'package:fl_chart_app/samples/pie/pie_sample_1.dart';
import 'package:fl_chart_app/samples/radar/radar_sample_1.dart';
import 'package:fl_chart_app/samples/scatter/scatter_sample_1.dart';
import 'package:fl_chart_app/util/app_helper.dart';
import 'package:fl_chart_app/widgets/chart_holder.dart';
import 'package:flutter/material.dart';

class ChartSamplesPage extends StatelessWidget {
  final ChartType chartSlug;
  final Map<ChartType, List<WidgetBuilder>> samples = {
    ChartType.LINE: [
      (context) => LineSample1(),
      (context) => LineSample1(),
      (context) => LineSample1(),
      (context) => LineSample1(),
    ],
    ChartType.BAR: [
      (context) => BarSample1(),
      (context) => BarSample1(),
      (context) => BarSample1(),
      (context) => BarSample1(),
    ],
    ChartType.PIE: [
      (context) => PieSample1(),
      (context) => PieSample1(),
      (context) => PieSample1(),
      (context) => PieSample1(),
    ],
    ChartType.SCATTER: [
      (context) => ScatterSample1(),
      (context) => ScatterSample1(),
      (context) => ScatterSample1(),
      (context) => ScatterSample1(),
    ],
    ChartType.RADAR: [
      (context) => RadarSample1(),
      (context) => RadarSample1(),
      (context) => RadarSample1(),
      (context) => RadarSample1(),
      (context) => RadarSample1(),
    ],
  };

  ChartSamplesPage({
    Key? key,
    required this.chartSlug,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GridView.builder(
        padding: EdgeInsets.all(AppDimens.chartSamplesSpace),
        itemCount: samples[chartSlug]!.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 600.0,
          childAspectRatio: 1.0,
          crossAxisSpacing: AppDimens.chartSamplesSpace,
          mainAxisSpacing: AppDimens.chartSamplesSpace,
        ),
        itemBuilder: (context, index) {
          return ChartHolder(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: samples[chartSlug]![index](context),
            ),
          );
        },
      ),
    );
  }
}
