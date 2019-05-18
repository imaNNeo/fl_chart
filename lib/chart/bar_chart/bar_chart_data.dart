//
//import 'dart:ui';
//
//import 'package:fl_chart/chart/base/fl_chart/fl_chart_data.dart';
//import 'package:flutter/material.dart';
//
//class BarChartData extends FlChartData {
//  final List<BarChartGroupData> groups;
//
//  BarChartData({
//    this.groups,
//    FlGridData gridData,
//    FlTitlesData titlesData,
//    FlBorderData borderData,
//  }) : super(
//    gridData: gridData,
//    titlesData: titlesData,
//    borderData: borderData,
//  );
//}
//
//class BarChartGroupData {
//  final double spotX;
//  final List<BarChartRod> rods;
//
//  BarChartGroupData({
//    this.spotX,
//    this.rods,
//  });
//}
//
//class BarChartRod {
//  final double spotY;
//  final Color color;
//
//  BarChartRod({
//    this.spotY,
//    this.color = Colors.green,
//  });
//}