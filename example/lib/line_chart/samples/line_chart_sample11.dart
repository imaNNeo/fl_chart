import 'dart:async';
import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';

class LineChartSample11 extends StatefulWidget {
  const LineChartSample11({Key? key}) : super(key: key);

  @override
  _LineChartSample11State createState() => _LineChartSample11State();
}

class _LineChartSample11State extends State<LineChartSample11> {
  List<Color> gradientColors = const [
    Color(0xffEEF3FE),
    Color(0xffEEF3FE),
  ];

  bool showAvg = false;
  List<AnnotationCoordinate>? annotationCoordinates;

  get to => null;
  double get reservedLeftSideSize => 18.0;

  Future<ui.Image> loadImage(String asset) async {
    final data = await rootBundle.load(asset);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final fi = await codec.getNextFrame();
    return fi.image;
  }

  Future<SizedPicture> loadSvg() async {
    const rawSvg =
        '<svg height="14" width="14" xmlns="http://www.w3.org/2000/svg"><g fill="none" fill-rule="evenodd" transform="translate(-.000014)"><circle cx="7" cy="7" fill="#495DFF" r="7"/><path d="m7 10.9999976c1.6562389 0 2.99998569-1.34374678 2.99998569-2.99999283s-1.34374679-4.99998808-2.99998569-4.99998808c-1.6562532 0-3 3.34374203-3 4.99998808s1.3437468 2.99999283 3 2.99999283z" fill="#fff" fill-rule="nonzero"/></g></svg>';

    final svgRoot = await svg.fromSvgString(rawSvg, rawSvg);

    final picture = svgRoot.toPicture();
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
              children: [
                for (final annotationCoordinate in annotationCoordinates ?? [])
                  Positioned(
                    bottom: 2,
                    child: CustomPaint(
                      painter: AnnotationLineIndicatorPainter(
                        from: annotationCoordinate?.from ?? Offset.zero,
                        to: annotationCoordinate?.to ?? Offset.zero,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                AspectRatio(
                  aspectRatio: 1.7,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 18.0, left: 12.0, top: 24, bottom: 12),
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
        });
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.black87, fontSize: 10);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(meta.formattedValue, style: style),
    );
  }

  LineChartData mainData(SizedPicture sizedPicture) {
    return LineChartData(
      rangeAnnotations: RangeAnnotations(
        verticalRangeAnnotations: [
          VerticalRangeAnnotation(
            x1: 2,
            x2: 5,
            color: Colors.blueAccent,
          ),
          VerticalRangeAnnotation(x1: 8, x2: 9, color: Colors.blueAccent),
        ],
      ),
      verticalRangeAnnotationCallback: _verticalRangeCoordinates,
      // uncomment to see ExtraLines with RangeAnnotations
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: false,
        verticalInterval: 3,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 3,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            interval: 2,
            showTitles: true,
            reservedSize: reservedLeftSideSize,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      lineTouchData: LineTouchData(
        getTouchLineEnd: (data, index) => double.infinity,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
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
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xffecf1fe), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 1),
            FlSpot(1, 1),
            FlSpot(2.2, 3),
            FlSpot(3.4, 4),
            FlSpot(4.9, 4.6),
            FlSpot(5.4, 4.8),
            FlSpot(6.8, 5.8),
            FlSpot(7.8, 3),
            FlSpot(8, 2.1),
            FlSpot(9, 2.1),
            FlSpot(10, 2.1),
            FlSpot(10.7, 1.4),
          ],
          dashArray: [2, 4],
          isCurved: true,
          gradient: const LinearGradient(
            colors: [Color(0xff0F2BF6), Color(0xff0F2BF6)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.5))
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }

  void _verticalRangeCoordinates(List<List<Offset>> coordinates) {
    // Applies leftTitles reservedSize padding
    if (annotationCoordinates != null) return;
    List<List<Offset>> paddedCoordinates = [];
    for (final coordinate in coordinates) {
      paddedCoordinates.add([
        Offset(coordinate[0].dx + reservedLeftSideSize + 12, coordinate[0].dy),
        Offset(coordinate[1].dx + reservedLeftSideSize + 12, coordinate[1].dy)
      ]);
    }
    Future.microtask(() => setState(() {
          annotationCoordinates = paddedCoordinates
              .map((coordinate) =>
                  AnnotationCoordinate(from: coordinate[0], to: coordinate[1]))
              .toList();
        }));
  }
}

/// A class describing the coordinates of an annotation range
/// the starting point [from] to the ending point [to]
class AnnotationCoordinate {
  /// Starting [x] position
  final Offset from;

  /// Ending [x] position
  final Offset to;

  ///
  AnnotationCoordinate({required this.from, required this.to});

  /// Copies current [AnnotationCoordinate] with provided values
  AnnotationCoordinate copyWith({
    Offset? from,
    Offset? to,
  }) {
    return AnnotationCoordinate(
      from: from ?? this.to,
      to: to ?? this.to,
    );
  }
}

class AnnotationLineIndicatorPainter extends CustomPainter {
  /// Starting X coordinate Offset
  final Offset from;

  /// Ending X coordinate Offset
  final Offset to;

  /// The color for the line
  final Color color;

  ///
  AnnotationLineIndicatorPainter({
    required this.from,
    required this.to,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    // Line span indicator has to be equal or greater than icon size to be rendered
    canvas
      ..drawLine(from, Offset(to.dx, 0), paint)
      ..drawLine(Offset(from.dx, 1), Offset(from.dx, -12), paint)
      ..drawLine(Offset(to.dx, 1), Offset(to.dx, -12), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
