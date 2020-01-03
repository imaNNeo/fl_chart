import 'dart:ui';

import 'package:fl_chart/src/chart/bar_chart/bar_chart_data.dart';
import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/utils/lerp.dart';
import 'package:flutter/material.dart';

class HorizontalBarChartData extends BarChartData {
  HorizontalBarChartData({
    List<BarChartGroupData> barGroups = const [],
    double groupsSpace = 16,
    BarChartAlignment alignment = BarChartAlignment.spaceBetween,
    FlTitlesData titlesData = const FlTitlesData(),
    BarTouchData barTouchData = const BarTouchData(),
    FlGridData gridData = const FlGridData(show: false),
    FlBorderData borderData,
    FlAxisTitleData axisTitleData = const FlAxisTitleData(),
    double maxValue,
    Color backgroundColor,
  }) : super(
          barGroups: barGroups,
          groupsSpace: groupsSpace,
          alignment: alignment,
          titlesData: titlesData,
          barTouchData: barTouchData,
          gridData: gridData,
          borderData: borderData,
          axisTitleData: axisTitleData,
          backgroundColor: backgroundColor,
        ) {
    initSuperMinMaxValues(maxValue);
  }

  @override
  double get maxValue => maxX;

  @override
  BarChartData copyWith({
    List<BarChartGroupData> barGroups,
    double groupsSpace,
    BarChartAlignment alignment,
    FlTitlesData titlesData,
    FlAxisTitleData axisTitleData,
    BarTouchData barTouchData,
    FlGridData gridData,
    FlBorderData borderData,
    double maxValue,
    Color backgroundColor,
  }) {
    return HorizontalBarChartData(
      barGroups: barGroups ?? this.barGroups,
      groupsSpace: groupsSpace ?? this.groupsSpace,
      alignment: alignment ?? this.alignment,
      titlesData: titlesData ?? this.titlesData,
      axisTitleData: axisTitleData ?? this.axisTitleData,
      barTouchData: barTouchData ?? this.barTouchData,
      gridData: gridData ?? this.gridData,
      borderData: borderData ?? this.borderData,
      maxValue: maxValue ?? this.maxValue,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  BaseChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is BarChartData && b is BarChartData && t != null) {
      return HorizontalBarChartData(
        barGroups: lerpBarChartGroupDataList(a.barGroups, b.barGroups, t),
        groupsSpace: lerpDouble(a.groupsSpace, b.groupsSpace, t),
        alignment: b.alignment,
        titlesData: FlTitlesData.lerp(a.titlesData, b.titlesData, t),
        axisTitleData:
            FlAxisTitleData.lerp(a.axisTitleData, b.axisTitleData, t),
        barTouchData: b.barTouchData,
        gridData: FlGridData.lerp(a.gridData, b.gridData, t),
        borderData: FlBorderData.lerp(a.borderData, b.borderData, t),
        maxValue: lerpDouble(a.maxValue, b.maxValue, t),
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      );
    } else {
      throw Exception('Illegal State');
    }
  }

  /// we have to tell [AxisChartData] how much is our
  /// minX, maxX, minY, maxY, values.
  /// here we get them in our constructor, but if each of them was null,
  /// we calculate it with the barGroups, and barRods data.
  @override
  void initSuperMinMaxValues(double maxValue) {
    for (int i = 0; i < barGroups.length; i++) {
      final BarChartGroupData barData = barGroups[i];
      if (barData.barRods == null || barData.barRods.isEmpty) {
        throw Exception('barRods could not be null or empty');
      }
    }

    if (barGroups.isNotEmpty) {
      var canModifyMaxValue = false;
      if (maxValue == null) {
        maxValue = barGroups[0].barRods[0].value;
        canModifyMaxValue = true;
      }

      for (int i = 0; i < barGroups.length; i++) {
        final BarChartGroupData barGroup = barGroups[i];
        for (int j = 0; j < barGroup.barRods.length; j++) {
          final BarChartRodData rod = barGroup.barRods[j];
          if (canModifyMaxValue && rod.value > maxValue) {
            maxValue = rod.value;
          }

          if (canModifyMaxValue &&
              rod.backDrawRodData.show &&
              rod.backDrawRodData.value != null &&
              rod.backDrawRodData.value > maxValue) {
            maxValue = rod.backDrawRodData.value;
          }
        }
      }
    }

    super.minX = 0;
    super.maxX = maxValue ?? 1;
    super.minY = 0;
    super.maxY = 1;
  }
}
