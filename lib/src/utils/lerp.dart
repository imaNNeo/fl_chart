import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_data.dart';

List<Color> lerpColorList(List<Color> a, List<Color> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return Color.lerp(a[i], b[i], t);
    });
  } else if (a != null && b != null) {
    return List.generate(b.length, (i) {
      return Color.lerp(i >= a.length ? b[i] : a[i], b[i], t);
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
  } else if (a != null && b != null) {
    return List.generate(b.length, (i) {
      return lerpDouble(i >= a.length ? b[i] : a[i], b[i], t);
    });
  } else {
    return b;
  }
}

List<int> lerpIntList(List<int> a, List<int> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return lerpInt(a[i], b[i], t);
    });
  } else if (a != null && b != null) {
    return List.generate(b.length, (i) {
      return lerpInt(i >= a.length ? b[i] : a[i], b[i], t);
    });
  } else {
    return b;
  }
}

int lerpInt(int a, int b, double t) {
  return (a + (b - a) * t).round();
}

List<FlSpot> lerpFlSpotList(List<FlSpot> a, List<FlSpot> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return FlSpot.lerp(a[i], b[i], t);
    });
  } else if (a != null && b != null) {
    return List.generate(b.length, (i) {
      return FlSpot.lerp(i >= a.length ? b[i] : a[i], b[i], t);
    });
  } else {
    return b;
  }
}

List<HorizontalLine> lerpHorizontalLineList(
    List<HorizontalLine> a, List<HorizontalLine> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return HorizontalLine.lerp(a[i], b[i], t);
    });
  } else if (a != null && b != null) {
    return List.generate(b.length, (i) {
      return HorizontalLine.lerp(i >= a.length ? b[i] : a[i], b[i], t);
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
  } else if (a != null && b != null) {
    return List.generate(b.length, (i) {
      return VerticalLine.lerp(i >= a.length ? b[i] : a[i], b[i], t);
    });
  }  else {
    return b;
  }
}

List<HorizontalRangeAnnotation> lerpHorizontalRangeAnnotationList(
    List<HorizontalRangeAnnotation> a, List<HorizontalRangeAnnotation> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return HorizontalRangeAnnotation.lerp(a[i], b[i], t);
    });
  } else if (a != null && b != null) {
    return List.generate(b.length, (i) {
      return HorizontalRangeAnnotation.lerp(i >= a.length ? b[i] : a[i], b[i], t);
    });
  }  else {
    return b;
  }
}

List<VerticalRangeAnnotation> lerpVerticalRangeAnnotationList(
    List<VerticalRangeAnnotation> a, List<VerticalRangeAnnotation> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return VerticalRangeAnnotation.lerp(a[i], b[i], t);
    });
  } else if (a != null && b != null) {
    return List.generate(b.length, (i) {
      return VerticalRangeAnnotation.lerp(i >= a.length ? b[i] : a[i], b[i], t);
    });
  }  else {
    return b;
  }
}

List<LineChartBarData> lerpLineChartBarDataList(
    List<LineChartBarData> a, List<LineChartBarData> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return LineChartBarData.lerp(a[i], b[i], t);
    });
  } else if (a != null && b != null) {
    return List.generate(b.length, (i) {
      return LineChartBarData.lerp(i >= a.length ? b[i] : a[i], b[i], t);
    });
  } else {
    return b;
  }
}

List<BetweenBarsData> lerpBetweenBarsDataList(
    List<BetweenBarsData> a, List<BetweenBarsData> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return BetweenBarsData.lerp(a[i], b[i], t);
    });
  } else if (a != null && b != null) {
    return List.generate(b.length, (i) {
      return BetweenBarsData.lerp(i >= a.length ? b[i] : a[i], b[i], t);
    });
  }  else {
    return b;
  }
}

List<BarChartGroupData> lerpBarChartGroupDataList(
    List<BarChartGroupData> a, List<BarChartGroupData> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return BarChartGroupData.lerp(a[i], b[i], t);
    });
  } else if (a != null && b != null) {
    return List.generate(b.length, (i) {
      return BarChartGroupData.lerp(i >= a.length ? b[i] : a[i], b[i], t);
    });
  }  else {
    return b;
  }
}

List<BarChartRodData> lerpBarChartRodDataList(
    List<BarChartRodData> a, List<BarChartRodData> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return BarChartRodData.lerp(a[i], b[i], t);
    });
  } else if (a != null && b != null) {
    return List.generate(b.length, (i) {
      return BarChartRodData.lerp(i >= a.length ? b[i] : a[i], b[i], t);
    });
  }  else {
    return b;
  }
}

List<PieChartSectionData> lerpPieChartSectionDataList(
    List<PieChartSectionData> a, List<PieChartSectionData> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return PieChartSectionData.lerp(a[i], b[i], t);
    });
  } else if (a != null && b != null) {
    return List.generate(b.length, (i) {
      return PieChartSectionData.lerp(i >= a.length ? b[i] : a[i], b[i], t);
    });
  } else {
    return b;
  }
}

List<ScatterSpot> lerpScatterSpotList(List<ScatterSpot> a, List<ScatterSpot> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return ScatterSpot.lerp(a[i], b[i], t);
    });
  } else if (a != null && b != null) {
    return List.generate(b.length, (i) {
      return ScatterSpot.lerp(i >= a.length ? b[i] : a[i], b[i], t);
    });
  } else {
    return b;
  }
}

List<BarChartRodStackItem> lerpBarChartRodStackList(
    List<BarChartRodStackItem> a, List<BarChartRodStackItem> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return BarChartRodStackItem.lerp(a[i], b[i], t);
    });
  } else if (a != null && b != null) {
    return List.generate(b.length, (i) {
      return BarChartRodStackItem.lerp(i >= a.length ? b[i] : a[i], b[i], t);
    });
  } else {
    return b;
  }
}
