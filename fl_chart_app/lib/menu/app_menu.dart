import 'package:fl_chart_app/menu/fl_chart_banner.dart';
import 'package:fl_chart_app/resources/app_resources.dart';
import 'package:flutter/material.dart';

import 'menu_row.dart';

class AppMenu extends StatefulWidget {
  final List<ChartMenuItem> menuItems;
  final bool isStandAlonePage;
  final int currentSelectedIndex;
  final Function(int, ChartMenuItem) onItemSelected;

  const AppMenu({
    Key? key,
    required this.menuItems,
    required this.isStandAlonePage,
    required this.currentSelectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  _AppMenuState createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 3,
          child: Center(
            child: FlChartBanner(),
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
                isSelectable: !widget.isStandAlonePage,
                onTap: () {
                  widget.onItemSelected(position, menuItem);
                },
              );
            },
            itemCount: widget.menuItems.length,
          ),
        ),
        Container(
          margin: EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
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
                child: Text(
                  'Update',
                  style: TextStyle(
                    color: AppColors.flCyan,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ChartMenuItem {
  final String slug;
  final String text;
  final String iconPath;

  const ChartMenuItem(this.slug, this.text, this.iconPath);
}
