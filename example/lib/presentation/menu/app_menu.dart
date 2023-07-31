import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart_app/util/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'fl_chart_banner.dart';
import 'menu_row.dart';

class AppMenu extends StatefulWidget {
  final List<ChartMenuItem> menuItems;
  final int currentSelectedIndex;
  final Function(int, ChartMenuItem) onItemSelected;

  const AppMenu({
    Key? key,
    required this.menuItems,
    required this.currentSelectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  AppMenuState createState() => AppMenuState();
}

class AppMenuState extends State<AppMenu> {
  @override
  Widget build(BuildContext context) {
    const needToUpdateTheApp = 1 == 0;
    return Container(
      color: AppColors.itemsBackground,
      child: Column(
        children: [
          const SafeArea(
            child: AspectRatio(
              aspectRatio: 3,
              child: Center(
                child: FlChartBanner(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, position) {
                final menuItem = widget.menuItems[position];
                return MenuRow(
                  text: menuItem.text,
                  svgPath: menuItem.iconPath,
                  isSelected: widget.currentSelectedIndex == position,
                  onTap: () {
                    widget.onItemSelected(position, menuItem);
                  },
                  onDocumentsTap: () async {
                    final url = Uri.parse(menuItem.chartType.documentationUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                );
              },
              itemCount: widget.menuItems.length,
            ),
          ),
          if (needToUpdateTheApp)
            Container(
              margin: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'FL Chart v 1.00 - update to get the latest features!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Update',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

class ChartMenuItem {
  final ChartType chartType;
  final String text;
  final String iconPath;

  const ChartMenuItem(this.chartType, this.text, this.iconPath);
}
