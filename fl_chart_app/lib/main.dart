import 'package:fl_chart_app/resources/app_colors.dart';
import 'package:fl_chart_app/menu_row.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'resources/app_resources.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.assistantTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        child: Center(
          child: Column(
            children: [
              MenuRow(text: 'Line', svgPath: AppAssets.icLineChart, isSelected: true,),
              MenuRow(text: 'Bar', svgPath: AppAssets.icBarChart, isSelected: false,),
              MenuRow(text: 'Pie', svgPath: AppAssets.icPieChart, isSelected: false,),
              MenuRow(text: 'Scatter', svgPath: AppAssets.icScatterChart, isSelected: false,),
              MenuRow(text: 'Radar', svgPath: AppAssets.icRadarChart, isSelected: false,),
            ],
          ),
        ),
      ),
    );
  }
}
