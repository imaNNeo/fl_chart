import 'dart:async';
import 'dart:ui' as ui;

import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';

class LineChartSample8 extends StatefulWidget {
  const LineChartSample8({super.key});

  @override
  State<LineChartSample8> createState() => _LineChartSample8State();
}

class _LineChartSample8State extends State<LineChartSample8> {
  List<Color> gradientColors = const [
    Color(0xffEEF3FE),
    Color(0xffEEF3FE),
  ];

  bool showAvg = false;

  Future<ui.Image> loadImage(String asset) async {
    final data = await rootBundle.load(asset);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final fi = await codec.getNextFrame();
    return fi.image;
  }

  Future<SizedPicture> loadSvg() async {
    const rawSvg =
        '<svg height="14" width="14" xmlns="http://www.w3.org/2000/svg"><g fill="none" fill-rule="evenodd" transform="translate(-.000014)"><circle cx="7" cy="7" fill="#495DFF" r="7"/><path d="m7 10.9999976c1.6562389 0 2.99998569-1.34374678 2.99998569-2.99999283s-1.34374679-4.99998808-2.99998569-4.99998808c-1.6562532 0-3 3.34374203-3 4.99998808s1.3437468 2.99999283 3 2.99999283z" fill="#fff" fill-rule="nonzero"/></g></svg>';

    final pictureInfo =
        await vg.loadPicture(const SvgStringLoader(rawSvg), null);

    final sizedPicture = SizedPicture(pictureInfo.picture, 14, 14);
    return sizedPicture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SizedPicture>(
      future: loadSvg(),
      builder: (BuildContext context, imageSnapshot) {
        if (imageSnapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.70,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 18,
                    left: 12,
                    top: 24,
                    bottom: 12,
                  ),
                  child: LineChart(
                    mainData(imageSnapshot.data!),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 10,
      color: AppColors.mainTextColor1,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(meta.formattedValue, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    IconData icon;
    Color color;
    switch (value.toInt()) {
      case 0:
        icon = Icons.wb_sunny;
        color = AppColors.contentColorYellow;
        break;
      case 2:
        icon = Icons.wine_bar_sharp;
        color = AppColors.contentColorRed;
        break;
      case 4:
        icon = Icons.watch_later;
        color = AppColors.contentColorGreen;
        break;
      case 6:
        icon = Icons.whatshot;
        color = AppColors.contentColorOrange;
        break;
      default:
        throw StateError('Invalid');
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Icon(
        icon,
        color: color,
        size: 32,
      ),
    );
  }

  LineChartData mainData(SizedPicture sizedPicture) {
    return LineChartData(
      rangeAnnotations: RangeAnnotations(
        verticalRangeAnnotations: [
          VerticalRangeAnnotation(
            x1: 2,
            x2: 5,
            color: AppColors.contentColorBlue.withOpacity(0.2),
          ),
          VerticalRangeAnnotation(
            x1: 8,
            x2: 9,
            color: AppColors.contentColorBlue.withOpacity(0.2),
          ),
        ],
        horizontalRangeAnnotations: [
          HorizontalRangeAnnotation(
            y1: 2,
            y2: 3,
            color: AppColors.contentColorGreen.withOpacity(0.3),
          ),
        ],
      ),
      // uncomment to see ExtraLines with RangeAnnotations
      extraLinesData: ExtraLinesData(
//         extraLinesOnTop: true,
        horizontalLines: [
          HorizontalLine(
            y: 5,
            color: AppColors.contentColorGreen,
            strokeWidth: 2,
            dashArray: [5, 10],
            label: HorizontalLineLabel(
              show: true,
              alignment: Alignment.topRight,
              padding: const EdgeInsets.only(right: 5, bottom: 5),
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
              labelResolver: (line) => 'H: ${line.y}',
            ),
          ),
        ],
        verticalLines: [
          VerticalLine(
            x: 5.7,
            color: AppColors.contentColorBlue,
            strokeWidth: 2,
            dashArray: [5, 10],
            label: VerticalLineLabel(
              show: true,
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only(left: 5, bottom: 5),
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
              direction: LabelDirection.vertical,
              labelResolver: (line) => 'V: ${line.x}',
            ),
          ),
          VerticalLine(
            x: 8.5,
            color: Colors.transparent,
            sizedPicture: sizedPicture,
          ),
          VerticalLine(
            x: 3.5,
            color: Colors.transparent,
            sizedPicture: sizedPicture,
          )
        ],
      ),
      gridData: const FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: false,
        verticalInterval: 1,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 4,
          ),
        ),
        leftTitles: AxisTitles(
          drawBelowEverything: true,
          sideTitles: SideTitles(
            interval: 2,
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 40,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      lineTouchData: LineTouchData(
        getTouchLineEnd: (data, index) => double.infinity,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              const FlLine(color: AppColors.contentColorOrange, strokeWidth: 3),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 8,
                  color: AppColors.contentColorOrange,
                ),
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => AppColors.contentColorBlue,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: AppColors.borderColor,
        ),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 1),
            FlSpot(2, 1),
            FlSpot(4.9, 5),
            FlSpot(6.8, 5),
            FlSpot(7.5, 3.5),
            FlSpot.nullSpot,
            FlSpot(7.5, 2),
            FlSpot(8, 1),
            FlSpot(10, 2),
            FlSpot(11, 2.5),
          ],
          dashArray: [10, 6],
          isCurved: true,
          color: AppColors.contentColorRed,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
        ),
      ],
    );
  }
}
