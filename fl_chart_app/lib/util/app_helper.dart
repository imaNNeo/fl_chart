enum ChartType { LINE, BAR, PIE, SCATTER, RADAR }

extension ChartTypeExtension on ChartType {
  String getName() => '${getSimpleName()} Chart';

  String getSimpleName() {
    switch (this) {
      case ChartType.LINE:
        return 'Line';
      case ChartType.BAR:
        return 'Bar';
      case ChartType.PIE:
        return 'Pie';
      case ChartType.SCATTER:
        return 'Scatter';
      case ChartType.RADAR:
        return 'Radar';
    }
  }
}
