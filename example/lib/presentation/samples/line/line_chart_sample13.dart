import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart_app/util/app_utils.dart';
import 'package:fl_chart_app/util/csv_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LineChartSample13 extends StatefulWidget {
  const LineChartSample13({super.key});

  @override
  State<LineChartSample13> createState() => _LineChartSample13State();
}

class _LineChartSample13State extends State<LineChartSample13> {
  List<List<_WeatherData>>? monthlyWeatherData;
  int _currentMonthIndex = 0;
  late final List<String> monthsNames;

  final int minDays = 1;
  final int maxDays = 31;
  late final double overallMinTemp;
  late final double overallMaxTemp;

  int _interactedSpotIndex = -1;

  @override
  void initState() {
    monthsNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    _loadWeatherData();
    super.initState();
  }

  void _loadWeatherData() async {
    final data =
        await rootBundle.loadString('assets/data/amsterdam_2024_weather.csv');
    final rows = CsvParser.parse(data);
    if (!mounted) {
      return;
    }
    setState(() {
      final allWeatherData =
          rows.skip(1).map((row) => _WeatherData.fromCsv(row)).toList();
      monthlyWeatherData = List.generate(12, (index) {
        final month = index + 1;
        return allWeatherData
            .where((element) => element.datetime.month == month)
            .toList();
      });
      overallMinTemp = allWeatherData
          .map((e) => e.temp)
          .reduce((value, element) => value < element ? value : element);
      overallMaxTemp = allWeatherData
          .map((e) => e.temp)
          .reduce((value, element) => value > element ? value : element);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 18),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Amsterdam Weather 2024',
              style: TextStyle(
                color: AppColors.contentColorOrange,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Tooltip(
              message: 'Source: visualcrossing.com',
              child: IconButton(
                  onPressed: () {
                    AppUtils().tryToLaunchUrl(
                      'https://www.visualcrossing.com/weather-history/Amsterdam,Netherlands/metric/2024-01-01/2024-12-31',
                    );
                  },
                  icon: const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.contentColorOrange,
                    size: 18,
                  )),
            )
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: _canGoPrevious ? _previousMonth : null,
                  icon: const Icon(Icons.navigate_before_rounded),
                ),
              ),
            ),
            SizedBox(
              width: 92,
              child: Text(
                monthsNames[_currentMonthIndex],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.contentColorBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: _canGoNext ? _nextMonth : null,
                  icon: const Icon(Icons.navigate_next_rounded),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        AspectRatio(
          aspectRatio: 1.4,
          child: Stack(
            children: [
              if (monthlyWeatherData != null)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0.0,
                    right: 18.0,
                  ),
                  child: LineChart(
                    LineChartData(
                      minY: overallMinTemp - 5,
                      maxY: overallMaxTemp + 5,
                      minX: 0,
                      maxX: 31,
                      lineBarsData: [
                        LineChartBarData(
                          spots: monthlyWeatherData![_currentMonthIndex]
                              .asMap()
                              .entries
                              .map((e) {
                            final index = e.key;
                            final item = e.value;
                            final value = item.temp;
                            return FlSpot(
                              index.toDouble(),
                              value,
                              yError: FlErrorRange(
                                lowerBy: (item.tempmin - value).abs(),
                                upperBy: item.tempmax - value,
                              ),
                            );
                          }).toList(),
                          isCurved: false,
                          dotData: const FlDotData(show: false),
                          color: AppColors.contentColorBlue,
                          barWidth: 1,
                          errorIndicatorData: FlErrorIndicatorData(
                            show: true,
                            painter: _errorPainter,
                          ),
                        ),
                      ],
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        drawVerticalLine: false,
                        horizontalInterval: 5,
                        getDrawingHorizontalLine: _horizontalGridLines,
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          drawBelowEverything: true,
                          sideTitles: SideTitles(
                            showTitles: true,
                            maxIncluded: false,
                            minIncluded: false,
                            reservedSize: 40,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(
                                  '${meta.formattedValue}°',
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          axisNameWidget: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: const Text(
                              'Day of month',
                              style: TextStyle(
                                color: AppColors.contentColorGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          axisNameSize: 40,
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 38,
                            maxIncluded: false,
                            interval: 1,
                            getTitlesWidget: _bottomTitles,
                          ),
                        ),
                      ),
                      lineTouchData: LineTouchData(
                        enabled: true,
                        handleBuiltInTouches: false,
                        touchCallback: _touchCallback,
                      ),
                    ),
                  ),
                ),
              if (monthlyWeatherData == null)
                const Center(
                  child: CircularProgressIndicator(),
                )
            ],
          ),
        ),
      ],
    );
  }

  bool get _canGoNext => _currentMonthIndex < 11;

  bool get _canGoPrevious => _currentMonthIndex > 0;

  void _previousMonth() {
    if (!_canGoPrevious) {
      return;
    }

    setState(() {
      _currentMonthIndex--;
    });
  }

  void _nextMonth() {
    if (!_canGoNext) {
      return;
    }
    setState(() {
      _currentMonthIndex++;
    });
  }

  FlSpotErrorRangePainter _errorPainter(
    LineChartSpotErrorRangeCallbackInput input,
  ) =>
      FlSimpleErrorPainter(
        lineWidth: 1.0,
        lineColor: _interactedSpotIndex == input.spotIndex
            ? Colors.white
            : Colors.white38,
        showErrorTexts: _interactedSpotIndex == input.spotIndex,
      );

  FlLine _horizontalGridLines(double value) {
    final isZero = value == 0.0;
    return FlLine(
      color: isZero ? Colors.white38 : Colors.blueGrey,
      strokeWidth: isZero ? 0.8 : 0.4,
      dashArray: isZero ? null : [8, 4],
    );
  }

  Widget _bottomTitles(double value, TitleMeta meta) {
    final day = value.toInt() + 1;

    final isDayHovered = _interactedSpotIndex == day - 1;

    final isImportantToShow = day % 5 == 0 || day == 1;

    if (!isImportantToShow && !isDayHovered) {
      return const SizedBox();
    }

    return SideTitleWidget(
      meta: meta,
      child: Text(
        day.toString(),
        style: TextStyle(
          color: isDayHovered
              ? AppColors.contentColorWhite
              : AppColors.contentColorGreen,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _touchCallback(FlTouchEvent event, LineTouchResponse? touchResponse) {
    if (!event.isInterestedForInteractions ||
        touchResponse?.lineBarSpots == null ||
        touchResponse!.lineBarSpots!.isEmpty) {
      setState(() {
        _interactedSpotIndex = -1;
      });
      return;
    }

    setState(() {
      _interactedSpotIndex = touchResponse.lineBarSpots!.first.spotIndex;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _WeatherData with EquatableMixin {
  final String name;
  final DateTime datetime;
  final double tempmax;
  final double tempmin;
  final double temp;
  final double feelslikemax;
  final double feelslikemin;
  final double feelslike;
  final double dew;
  final double humidity;
  final double precip;
  final double precipprob;
  final double precipcover;
  final String preciptype;
  final double snow;
  final double snowdepth;
  final double windgust;
  final double windspeed;
  final double winddir;
  final double sealevelpressure;
  final double cloudcover;
  final double visibility;
  final double solarradiation;
  final double solarenergy;
  final double uvindex;
  final double severerisk;
  final DateTime sunrise;
  final DateTime sunset;
  final double moonphase;
  final String conditions;
  final String description;
  final String icon;
  final String stations;

  const _WeatherData({
    required this.name,
    required this.datetime,
    required this.tempmax,
    required this.tempmin,
    required this.temp,
    required this.feelslikemax,
    required this.feelslikemin,
    required this.feelslike,
    required this.dew,
    required this.humidity,
    required this.precip,
    required this.precipprob,
    required this.precipcover,
    required this.preciptype,
    required this.snow,
    required this.snowdepth,
    required this.windgust,
    required this.windspeed,
    required this.winddir,
    required this.sealevelpressure,
    required this.cloudcover,
    required this.visibility,
    required this.solarradiation,
    required this.solarenergy,
    required this.uvindex,
    required this.severerisk,
    required this.sunrise,
    required this.sunset,
    required this.moonphase,
    required this.conditions,
    required this.description,
    required this.icon,
    required this.stations,
  });

  // parse from csv row
  // name,datetime,tempmax,tempmin,temp,feelslikemax,feelslikemin,feelslike,dew,humidity,precip,precipprob,precipcover,preciptype,snow,snowdepth,windgust,windspeed,winddir,sealevelpressure,cloudcover,visibility,solarradiation,solarenergy,uvindex,severerisk,sunrise,sunset,moonphase,conditions,description,icon,stations
  // "Amsterdam,Netherlands",2024-01-01,9.1,6.4,8,5.3,2.5,4.1,5.1,82.4,14.26,100,37.5,rain,0,0,53.9,40.2,225.9,1000.1,88.7,20.5,20.6,1.8,2,,2024-01-01T08:50:34,2024-01-01T16:37:06,0.68,"Rain, Partially cloudy",Partly cloudy throughout the day with a chance of rain throughout the day.,rain,"06260099999,D3248,06348099999,06249099999,C0449,06240099999,06269099999,06257099999,06344099999"
  factory _WeatherData.fromCsv(List<String> row) => _WeatherData(
        name: row[0],
        datetime: DateTime.parse(row[1]),
        tempmax: double.parse(row[2]),
        tempmin: double.parse(row[3]),
        temp: double.parse(row[4]),
        feelslikemax: double.parse(row[5]),
        feelslikemin: double.parse(row[6]),
        feelslike: double.parse(row[7]),
        dew: double.parse(row[8]),
        humidity: double.parse(row[9]),
        precip: double.parse(row[10]),
        precipprob: double.parse(row[11]),
        precipcover: double.parse(row[12]),
        preciptype: row[13],
        snow: double.parse(row[14]),
        snowdepth: double.parse(row[15]),
        windgust: double.parse(row[16]),
        windspeed: double.parse(row[17]),
        winddir: double.parse(row[18]),
        sealevelpressure: double.parse(row[19]),
        cloudcover: double.parse(row[20]),
        visibility: double.parse(row[21]),
        solarradiation: double.parse(row[22]),
        solarenergy: double.parse(row[23]),
        uvindex: double.parse(row[24]),
        severerisk: row[25].isEmpty ? 0 : double.parse(row[25]),
        sunrise: DateTime.parse(row[26]),
        sunset: DateTime.parse(row[27]),
        moonphase: double.parse(row[28]),
        conditions: row[29],
        description: row[30],
        icon: row[31],
        stations: row[32],
      );

  @override
  List<Object?> get props => [
        name,
        datetime,
        tempmax,
        tempmin,
        temp,
        feelslikemax,
        feelslikemin,
        feelslike,
        dew,
        humidity,
        precip,
        precipprob,
        precipcover,
        preciptype,
        snow,
        snowdepth,
        windgust,
        windspeed,
        winddir,
        sealevelpressure,
        cloudcover,
        visibility,
        solarradiation,
        solarenergy,
        uvindex,
        severerisk,
        sunrise,
        sunset,
        moonphase,
        conditions,
        description,
        icon,
        stations,
      ];
}
