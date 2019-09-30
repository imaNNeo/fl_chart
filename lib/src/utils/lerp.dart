
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';

List<Color> lerpColorList(List<Color> a, List<Color> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return Color.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

List<double> lerpDoubleList(List<double> a, List<double> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return lerpDouble(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

List<FlSpot> lerpFlSpotList(List<FlSpot> a, List<FlSpot> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return FlSpot.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

List<HorizontalLine> lerpHorizontalLineList(List<HorizontalLine> a, List<HorizontalLine> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return HorizontalLine.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

List<VerticalLine> lerpVerticalLineList(List<VerticalLine> a, List<VerticalLine> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return VerticalLine.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

List<LineChartBarData> lerpLineChartBarDataList(List<LineChartBarData> a, List<LineChartBarData> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return LineChartBarData.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

List<BarChartGroupData> lerpBarChartGroupDataList(List<BarChartGroupData> a, List<BarChartGroupData> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return BarChartGroupData.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

List<BarChartRodData> lerpBarChartRodDataList(List<BarChartRodData> a, List<BarChartRodData> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return BarChartRodData.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

List<PieChartSectionData> lerpPieChartSectionDataList(List<PieChartSectionData> a, List<PieChartSectionData> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return PieChartSectionData.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}