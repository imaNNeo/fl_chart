import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';

class LineChartSample8 extends StatefulWidget {
  @override
  _LineChartSample8State createState() => _LineChartSample8State();
}

class _LineChartSample8State extends State<LineChartSample8> {
  List<Color> gradientColors = const [
    Color(0xffEEF3FE),
    Color(0xffEEF3FE),
  ];

  bool showAvg = false;

  Future<ui.Image> loadImage(String asset) async {
    final ByteData data = await rootBundle.load(asset);
    final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  Future<SizedPicture> loadSvg() async {
    const String rawSvg =
        '<svg height="14" width="14" xmlns="http://www.w3.org/2000/svg"><g fill="none" fill-rule="evenodd" transform="translate(-.000014)"><circle cx="7" cy="7" fill="#495DFF" r="7"/><path d="m7 10.9999976c1.6562389 0 2.99998569-1.34374678 2.99998569-2.99999283s-1.34374679-4.99998808-2.99998569-4.99998808c-1.6562532 0-3 3.34374203-3 4.99998808s1.3437468 2.99999283 3 2.99999283z" fill="#fff" fill-rule="nonzero"/></g></svg>';

    final DrawableRoot svgRoot = await svg.fromSvgString(rawSvg, rawSvg);

    final ui.Picture picture = svgRoot.toPicture();
    final sizedPicture = SizedPicture(picture, 14, 14);
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
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
                      child: LineChart(
                        mainData(imageSnapshot.data),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  LineChartData mainData(SizedPicture sizedPicture) {
    return LineChartData(
      rangeAnnotations: RangeAnnotations(
        verticalRangeAnnotations: [
          VerticalRangeAnnotation(
            x1: 2,
            x2: 5,
            color: const Color(0xffD5DAE5),
          ),
          VerticalRangeAnnotation(
            x1: 8,
            x2: 9,
            color: const Color(0xffD5DAE5),
          ),
        ],
        horizontalRangeAnnotations: [
          HorizontalRangeAnnotation(
            y1: 2,
            y2: 3,
            color: const Color(0xffEEF3FE),
          ),
        ],
      ),
      // uncomment to see ExtraLines with RangeAnnotations
      extraLinesData: ExtraLinesData(
//         extraLinesOnTop: true,
        horizontalLines: [
          HorizontalLine(
            y: 5,
            color: const Color.fromRGBO(197, 210, 214, 1),
            strokeWidth: 2,
            dashArray: [5, 10],
            label: HorizontalLineLabel(
              show: true,
              alignment: Alignment.topRight,
              padding: const EdgeInsets.only(right: 5, bottom: 5),
              style: const TextStyle(color: Colors.black, fontSize: 9),
              labelResolver: (line) => 'H: ${line.y}',
            ),
          ),
        ],
        verticalLines: [
          VerticalLine(
            x: 5.7,
            color: const Color.fromRGBO(197, 210, 214, 1),
            strokeWidth: 2,
            dashArray: [5, 10],
            label: VerticalLineLabel(
              show: true,
              alignment: Alignment.topRight,
              padding: const EdgeInsets.only(left: 10, top: 5),
              style: const TextStyle(color: Colors.black, fontSize: 9),
              labelResolver: (line) => 'V: ${line.x}',
            ),
          ),
          VerticalLine(
            x: 8.5,
            color: Colors.transparent,
            sizedPicture: sizedPicture,
          )
        ],
      ),
      gridData: FlGridData(
          show: true, drawVerticalLine: false, drawHorizontalLine: false, verticalInterval: 1),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(color: Colors.black87, fontSize: 10),
          interval: 4,
          margin: 8,
          checkToShowTitle: (minValue, maxValue, sideTitles, appliedInterval, value) => true,
        ),
        leftTitles: SideTitles(
          interval: 2,
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.black87,
            fontSize: 10,
          ),
          reservedSize: 28,
          margin: 12,
        ),
      ),
      lineTouchData: LineTouchData(
        fullHeightTouchLine: true,
        getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(color: Colors.orange, strokeWidth: 3),
              FlDotData(
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(radius: 8, color: Colors.deepOrange)),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueAccent,
        ),
      ),
      borderData:
          FlBorderData(show: true, border: Border.all(color: const Color(0xffecf1fe), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 1),
            FlSpot(2, 1),
            FlSpot(4.9, 5),
            FlSpot(6.8, 5),
            FlSpot(7.5, 4),
            FlSpot.nullSpot,
            FlSpot(7.5, 2),
            FlSpot(8, 1),
            FlSpot(10, 2),
            FlSpot(11, 2.5),
          ],
          dashArray: [2, 4],
          isCurved: true,
          colors: const [Color(0xff0F2BF6), Color(0xff0F2BF6)],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
            colors: gradientColors.map((color) => color.withOpacity(0.5)).toList(),
          ),
        ),
      ],
    );
  }
}
