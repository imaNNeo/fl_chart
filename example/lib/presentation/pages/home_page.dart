import 'package:dartx/dartx.dart';
import 'package:fl_chart_app/presentation/menu/app_menu.dart';
import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart_app/urls.dart';
import 'package:fl_chart_app/util/app_helper.dart';
import 'package:fl_chart_app/util/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'chart_samples_page.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key? key,
    required this.showingChartType,
  }) : super(key: key) {
    _initMenuItems();
  }

  void _initMenuItems() {
    _menuItemsIndices = {};
    _menuItems = ChartType.values.mapIndexed(
      (int index, ChartType type) {
        _menuItemsIndices[type] = index;
        return ChartMenuItem(
          type,
          type.displayName,
          type.assetIcon,
        );
      },
    ).toList();
  }

  final ChartType showingChartType;
  late final Map<ChartType, int> _menuItemsIndices;
  late final List<ChartMenuItem> _menuItems;

  @override
  Widget build(BuildContext context) {
    final selectedMenuIndex = _menuItemsIndices[showingChartType]!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final needsDrawer = constraints.maxWidth <=
            AppDimens.menuMaxNeededWidth + AppDimens.chartBoxMinWidth;
        final appMenuWidget = AppMenu(
          menuItems: _menuItems,
          currentSelectedIndex: selectedMenuIndex,
          onItemSelected: (newIndex, chartMenuItem) {
            context.go('/${chartMenuItem.chartType.name}');
            if (needsDrawer) {
              /// to close the drawer
              Navigator.of(context).pop();
            }
          },
          onBannerClicked: () => AppUtils().tryToLaunchUrl(Urls.flChartUrl),
        );
        final samplesSectionWidget =
            ChartSamplesPage(chartType: showingChartType);
        final body = needsDrawer
            ? samplesSectionWidget
            : Row(
                children: [
                  SizedBox(
                    width: AppDimens.menuMaxNeededWidth,
                    child: appMenuWidget,
                  ),
                  Expanded(
                    child: samplesSectionWidget,
                  )
                ],
              );

        return Scaffold(
          body: body,
          drawer: needsDrawer
              ? Drawer(
                  child: appMenuWidget,
                )
              : null,
          appBar: needsDrawer
              ? AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  title: Text(showingChartType.displayName),
                )
              : null,
        );
      },
    );
  }
}
