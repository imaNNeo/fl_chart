import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart_app/presentation/widgets/indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartSample4 extends StatefulWidget {
  const PieChartSample4({super.key});

  @override
  State<StatefulWidget> createState() => PieChartSample4State();
}

class PieChartSample4State extends State {
  Offset? hoveredOffset;
  int innerTouchedIndex = -1;
  int outerTouchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 28,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Indicator(
                color: AppColors.contentColorBlue,
                text: 'One',
                isSquare: false,
                size:
                    innerTouchedIndex == 0 || outerTouchedIndex == 0 ? 18 : 16,
                textColor: innerTouchedIndex == 0 || outerTouchedIndex == 0
                    ? AppColors.mainTextColor1
                    : AppColors.mainTextColor3,
              ),
              Indicator(
                color: AppColors.contentColorYellow,
                text: 'Two',
                isSquare: false,
                size:
                    innerTouchedIndex == 1 || outerTouchedIndex == 1 ? 18 : 16,
                textColor: innerTouchedIndex == 1 || outerTouchedIndex == 1
                    ? AppColors.mainTextColor1
                    : AppColors.mainTextColor3,
              ),
              Indicator(
                color: AppColors.contentColorPink,
                text: 'Three',
                isSquare: false,
                size:
                    innerTouchedIndex == 2 || outerTouchedIndex == 2 ? 18 : 16,
                textColor: innerTouchedIndex == 2 || outerTouchedIndex == 2
                    ? AppColors.mainTextColor1
                    : AppColors.mainTextColor3,
              ),
              Indicator(
                color: AppColors.contentColorGreen,
                text: 'Four',
                isSquare: false,
                size:
                    innerTouchedIndex == 3 || outerTouchedIndex == 3 ? 18 : 16,
                textColor: innerTouchedIndex == 3 || outerTouchedIndex == 3
                    ? AppColors.mainTextColor1
                    : AppColors.mainTextColor3,
              ),
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
                aspectRatio: 1,
                child: MouseRegion(
                  onHover: (event) {
                    setState(() {
                      hoveredOffset = event.localPosition;
                    });
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              externalTouchPosition: hoveredOffset,
                              externalTouchCallback: (pieTouchResponse) {
                                int? newTouchedIndex = pieTouchResponse
                                    ?.touchedSection?.touchedSectionIndex;
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  if (mounted &&
                                      newTouchedIndex != innerTouchedIndex) {
                                    setState(() {
                                      innerTouchedIndex = newTouchedIndex ?? -1;
                                    });
                                  }
                                });
                              },
                            ),
                            startDegreeOffset: 180,
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 1,
                            centerSpaceRadius: 0,
                            sections: showingInnerSections(),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              externalTouchPosition: hoveredOffset,
                              externalTouchCallback: (pieTouchResponse) {
                                int? newTouchedIndex = pieTouchResponse
                                    ?.touchedSection?.touchedSectionIndex;
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  if (mounted &&
                                      newTouchedIndex != outerTouchedIndex) {
                                    setState(() {
                                      outerTouchedIndex = newTouchedIndex ?? -1;
                                    });
                                  }
                                });
                              },
                            ),
                            startDegreeOffset: 180,
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 1,
                            centerSpaceRadius: 50,
                            sections: showingOuterSections(),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingInnerSections() {
    return List.generate(
      4,
      (i) {
        final isTouched = i == innerTouchedIndex;
        const color0 = AppColors.contentColorBlue;
        const color1 = AppColors.contentColorYellow;
        const color2 = AppColors.contentColorPink;
        const color3 = AppColors.contentColorGreen;

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color0,
              value: 25,
              title: '',
              radius: 45,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(
                      color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(
                      color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 1:
            return PieChartSectionData(
              color: color1,
              value: 30,
              title: '',
              radius: 45,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(
                      color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(
                      color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 2:
            return PieChartSectionData(
              color: color2,
              value: 25,
              title: '',
              radius: 45,
              titlePositionPercentageOffset: 0.6,
              borderSide: isTouched
                  ? const BorderSide(
                      color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(
                      color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 3:
            return PieChartSectionData(
              color: color3,
              value: 40,
              title: '',
              radius: 45,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(
                      color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(
                      color: AppColors.contentColorWhite.withOpacity(0)),
            );
          default:
            throw Error();
        }
      },
    );
  }

  List<PieChartSectionData> showingOuterSections() {
    return List.generate(
      4,
      (i) {
        final isTouched = i == outerTouchedIndex;
        const color0 = AppColors.contentColorBlue;
        const color1 = AppColors.contentColorYellow;
        const color2 = AppColors.contentColorPink;
        const color3 = AppColors.contentColorGreen;

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color0,
              value: 25,
              title: '',
              radius: 30,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(
                      color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(
                      color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 1:
            return PieChartSectionData(
              color: color1,
              value: 25,
              title: '',
              radius: 15,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(
                      color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(
                      color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 2:
            return PieChartSectionData(
              color: color2,
              value: 25,
              title: '',
              radius: 10,
              titlePositionPercentageOffset: 0.6,
              borderSide: isTouched
                  ? const BorderSide(
                      color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(
                      color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 3:
            return PieChartSectionData(
              color: color3,
              value: 25,
              title: '',
              radius: 20,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(
                      color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(
                      color: AppColors.contentColorWhite.withOpacity(0)),
            );
          default:
            throw Error();
        }
      },
    );
  }
}
