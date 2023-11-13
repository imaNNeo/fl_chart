import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart_app/presentation/samples/chart_sample.dart';
import 'package:fl_chart_app/util/app_utils.dart';
import 'package:flutter/material.dart';

class ChartHolder extends StatelessWidget {
  final ChartSample chartSample;

  const ChartHolder({
    Key? key,
    required this.chartSample,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const SizedBox(width: 6),
            Text(
              chartSample.name,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(child: Container()),
            IconButton(
              onPressed: () => AppUtils().tryToLaunchUrl(chartSample.url),
              icon: const Icon(
                Icons.code,
                color: AppColors.primary,
              ),
              tooltip: 'Source code',
            ),
          ],
        ),
        const SizedBox(height: 2),
        Container(
          decoration: const BoxDecoration(
            color: AppColors.itemsBackground,
            borderRadius:
                BorderRadius.all(Radius.circular(AppDimens.defaultRadius)),
          ),
          child: chartSample.builder(context),
        ),
      ],
    );
  }
}
