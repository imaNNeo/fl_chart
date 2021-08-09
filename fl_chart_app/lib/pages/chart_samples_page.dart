import 'package:fl_chart_app/resources/app_dimens.dart';
import 'package:fl_chart_app/samples/chart_samples_holder.dart';
import 'package:fl_chart_app/util/app_helper.dart';
import 'package:fl_chart_app/widgets/chart_holder.dart';
import 'package:flutter/material.dart';

class ChartSamplesPage extends StatelessWidget {
  final ChartType chartType;

  final samples = ChartSamplesHolder.samples;

  ChartSamplesPage({
    Key? key,
    required this.chartType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GridView.builder(
        key: ValueKey(chartType),
        padding: EdgeInsets.all(AppDimens.chartSamplesSpace),
        itemCount: samples[chartType]!.length,
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
              child: samples[chartType]![index](context),
            ),
          );
        },
      ),
    );
  }
}
