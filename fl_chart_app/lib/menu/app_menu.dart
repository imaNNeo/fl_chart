import 'package:fl_chart_app/menu/fl_chart_banner.dart';
import 'package:fl_chart_app/resources/app_resources.dart';
import 'package:flutter/material.dart';

import 'menu_row.dart';

class AppMenu extends StatefulWidget {
  final items = const [
    _MenuItem('Line', AppAssets.icLineChart),
    _MenuItem('Bar', AppAssets.icBarChart),
    _MenuItem('Pie', AppAssets.icPieChart),
    _MenuItem('Scatter', AppAssets.icScatterChart),
    _MenuItem('Radar', AppAssets.icRadarChart),
  ];

  const AppMenu({Key? key}) : super(key: key);

  @override
  _AppMenuState createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
  late int selectedIndex;

  @override
  void initState() {
    selectedIndex = 0;
    super.initState();
  }

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
              final menuItem = widget.items[position];
              return MenuRow(
                text: menuItem.text,
                svgPath: menuItem.iconPath,
                isSelected: selectedIndex == position,
                onTap: () {
                  _onListItemTap(position);
                },
              );
            },
            itemCount: widget.items.length,
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

  void _onListItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

class _MenuItem {
  final String text;
  final String iconPath;

  const _MenuItem(this.text, this.iconPath);
}
