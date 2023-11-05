import 'package:fl_chart_app/util/app_helper.dart';

class Urls {
  static const flChartUrl = 'https://flchart.dev';
  static String getChartSourceCodeUrl(ChartType chartType, int sampleNumber) {
    final chartDir = chartType.name.toLowerCase();
    return 'https://github.com/imaNNeo/fl_chart/blob/master/example/lib/presentation/samples/$chartDir/${chartDir}_chart_sample$sampleNumber.dart';
  }

  static String getChartDocumentationUrl(ChartType chartType) {
    final chartDir = chartType.name.toLowerCase();
    return 'https://github.com/imaNNeo/fl_chart/blob/master/repo_files/documentations/${chartDir}_chart.md';
  }
}
