import 'package:fl_chart_app/util/app_helper.dart';

class AppAssets {
  static String getChartIcon(ChartType type) {
    switch (type) {
      case ChartType.line:
        return 'assets/icons/ic_line_chart.svg';
      case ChartType.bar:
        return 'assets/icons/ic_bar_chart.svg';
      case ChartType.pie:
        return 'assets/icons/ic_pie_chart.svg';
      case ChartType.scatter:
        return 'assets/icons/ic_scatter_chart.svg';
      case ChartType.radar:
        return 'assets/icons/ic_radar_chart.svg';
    }
  }

  static const flChartLogoIcon = 'assets/icons/fl_chart_logo_icon.png';
  static const flChartLogoText = 'assets/icons/fl_chart_logo_text.svg';
}
