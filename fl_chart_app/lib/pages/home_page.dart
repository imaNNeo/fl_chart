import 'package:fl_chart_app/menu/app_menu.dart';
import 'package:fl_chart_app/pages/chart_samples_page.dart';
import 'package:fl_chart_app/resources/app_dimens.dart';
import 'package:fl_chart_app/resources/app_resources.dart';
import 'package:fl_chart_app/util/app_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int selectedMenuIndex;

  final menuItems = const [
    ChartMenuItem(AppHelper.LINE_CHART_SLUG, 'Line', AppAssets.icLineChart),
    ChartMenuItem(AppHelper.BAR_CHART_SLUG, 'Bar', AppAssets.icBarChart),
    ChartMenuItem(AppHelper.PIE_CHART_SLUG, 'Pie', AppAssets.icPieChart),
    ChartMenuItem(AppHelper.SCATTER_CHART_SLUG, 'Scatter', AppAssets.icScatterChart),
    ChartMenuItem(AppHelper.RADAR_CHART_SLUG, 'Radar', AppAssets.icRadarChart),
  ];

  @override
  void initState() {
    selectedMenuIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > AppDimens.menuMaxNeededWidth + AppDimens.chartBoxMinWidth) {
          return Row(
            children: [
              SizedBox(
                width: AppDimens.menuMaxNeededWidth,
                child: AppMenu(
                  menuItems: menuItems,
                  isStandAlonePage: false,
                  currentSelectedIndex: selectedMenuIndex,
                  onItemSelected: (newIndex, chartMenuItem) {
                    setState(() {
                      selectedMenuIndex = newIndex;
                    });
                  },
                ),
              ),
              Expanded(
                child: IndexedStack(
                  index: selectedMenuIndex,
                  children: menuItems
                      .map(
                        (e) => ChartSamplesPage(
                          chartSlug: e.slug,
                          isStandAlonePage: false,
                        ),
                      )
                      .toList(),
                ),
              )
            ],
          );
        } else {
          return AppMenu(
            menuItems: menuItems,
            isStandAlonePage: true,
            currentSelectedIndex: selectedMenuIndex,
            onItemSelected: (newIndex, chartMenuItem) {
              Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => ChartSamplesPage(
                    chartSlug: chartMenuItem.slug,
                    isStandAlonePage: true,
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
