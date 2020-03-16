import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/scatter_chart/scatter_chart_data.dart';
import 'package:flutter/animation.dart';

/// Lerps [Color] list based on [t] value, check [Tween.lerp].
List<Color> lerpColorList(List<Color> a, List<Color> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return Color.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

/// Lerps [double] list based on [t] value, check [Tween.lerp].
List<double> lerpDoubleList(List<double> a, List<double> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return lerpDouble(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

/// Lerps [int] list based on [t] value, check [Tween.lerp].
List<int> lerpIntList(List<int> a, List<int> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return lerpInt(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

/// Lerps [int] list based on [t] value, check [Tween.lerp].
int lerpInt(int a, int b, double t) {
  return (a + (b - a) * t).round();
}

/// Lerps [FlSpot] list based on [t] value, check [Tween.lerp].
List<FlSpot> lerpFlSpotList(List<FlSpot> a, List<FlSpot> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return FlSpot.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

/// Lerps [HorizontalLine] list based on [t] value, check [Tween.lerp].
List<HorizontalLine> lerpHorizontalLineList(
    List<HorizontalLine> a, List<HorizontalLine> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return HorizontalLine.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

/// Lerps [VerticalLine] list based on [t] value, check [Tween.lerp].
List<VerticalLine> lerpVerticalLineList(List<VerticalLine> a, List<VerticalLine> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return VerticalLine.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

/// Lerps [HorizontalRangeAnnotation] list based on [t] value, check [Tween.lerp].
List<HorizontalRangeAnnotation> lerpHorizontalRangeAnnotationList(
    List<HorizontalRangeAnnotation> a, List<HorizontalRangeAnnotation> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return HorizontalRangeAnnotation.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

/// Lerps [VerticalRangeAnnotation] list based on [t] value, check [Tween.lerp].
List<VerticalRangeAnnotation> lerpVerticalRangeAnnotationList(
    List<VerticalRangeAnnotation> a, List<VerticalRangeAnnotation> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return VerticalRangeAnnotation.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

/// Lerps [LineChartBarData] list based on [t] value, check [Tween.lerp].
List<LineChartBarData> lerpLineChartBarDataList(
    List<LineChartBarData> a, List<LineChartBarData> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return LineChartBarData.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

/// Lerps [BetweenBarsData] list based on [t] value, check [Tween.lerp].
List<BetweenBarsData> lerpBetweenBarsDataList(
    List<BetweenBarsData> a, List<BetweenBarsData> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return BetweenBarsData.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

/// Lerps [BarChartGroupData] list based on [t] value, check [Tween.lerp].
List<BarChartGroupData> lerpBarChartGroupDataList(
    List<BarChartGroupData> a, List<BarChartGroupData> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return BarChartGroupData.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

/// Lerps [BarChartRodData] list based on [t] value, check [Tween.lerp].
List<BarChartRodData> lerpBarChartRodDataList(
    List<BarChartRodData> a, List<BarChartRodData> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return BarChartRodData.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

/// Lerps [PieChartSectionData] list based on [t] value, check [Tween.lerp].
List<PieChartSectionData> lerpPieChartSectionDataList(
    List<PieChartSectionData> a, List<PieChartSectionData> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return PieChartSectionData.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

/// Lerps [ScatterSpot] list based on [t] value, check [Tween.lerp].
List<ScatterSpot> lerpScatterSpotList(List<ScatterSpot> a, List<ScatterSpot> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return ScatterSpot.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}

/// Lerps [BarChartRodStackItem] list based on [t] value, check [Tween.lerp].
List<BarChartRodStackItem> lerpBarChartRodStackList(
    List<BarChartRodStackItem> a, List<BarChartRodStackItem> b, double t) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return BarChartRodStackItem.lerp(a[i], b[i], t);
    });
  } else {
    return b;
  }
}
