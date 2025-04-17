import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart_app/urls.dart';

enum ChartType { line, bar, pie, scatter, radar, candlestick }

extension ChartTypeExtension on ChartType {
  String get displayName => '$simpleName Chart';

  String get simpleName => switch (this) {
        ChartType.line => 'Line',
        ChartType.bar => 'Bar',
        ChartType.pie => 'Pie',
        ChartType.scatter => 'Scatter',
        ChartType.radar => 'Radar',
        ChartType.candlestick => 'Candlestick',
      };

  String get documentationUrl => Urls.getChartDocumentationUrl(this);

  String get assetIcon => AppAssets.getChartIcon(this);
}
