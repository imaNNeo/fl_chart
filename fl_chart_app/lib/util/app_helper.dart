enum ChartType { LINE, BAR, PIE, SCATTER, RADAR }

class AppHelper {
  static String getChartName(ChartType chart) {
    switch (chart) {
      case ChartType.LINE:
        return 'Line Chart';
      case ChartType.BAR:
        return 'Bar Chart';
      case ChartType.PIE:
        return 'Pie Chart';
      case ChartType.SCATTER:
        return 'Scatter Chart';
      case ChartType.RADAR:
        return 'Radar Chart';
      default:
        throw StateError('Invalid chartSlug');
    }
  }
}
