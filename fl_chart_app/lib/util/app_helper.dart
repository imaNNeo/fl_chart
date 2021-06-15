class AppHelper {
  static const String LINE_CHART_SLUG = 'line_chart';
  static const String BAR_CHART_SLUG = 'bar_chart';
  static const String PIE_CHART_SLUG = 'pie_chart';
  static const String SCATTER_CHART_SLUG = 'scatter_chart';
  static const String RADAR_CHART_SLUG = 'radar_chart';

  static String getChartName(String chartSlug) {
    switch(chartSlug) {
      case LINE_CHART_SLUG: return 'Line Chart';
      case BAR_CHART_SLUG: return 'Bar Chart';
      case PIE_CHART_SLUG: return 'Pie Chart';
      case SCATTER_CHART_SLUG: return 'Scatter Chart';
      case RADAR_CHART_SLUG: return 'Radar Chart';
      default: throw StateError('Invalid chartSlug');
    }
  }
}