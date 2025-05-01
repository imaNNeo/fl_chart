import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/resources/app_colors.dart';
import 'package:fl_chart_app/util/csv_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CandlestickChartSample1 extends StatefulWidget {
  const CandlestickChartSample1({super.key});

  @override
  State<StatefulWidget> createState() => CandlestickChartSample1State();
}

class CandlestickChartSample1State extends State<CandlestickChartSample1> {
  List<List<_BtcCandlestickData>>? _btcMonthlyData;

  int _currentMonthIndex = 0;
  late final List<String> monthsNames;

  final int minDays = 1;
  final int maxDays = 31;
  late final FlLine _gridLine;

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
    _loadData();
    _gridLine = FlLine(
      color: Colors.blueGrey.withValues(alpha: 0.4),
      strokeWidth: 0.4,
      dashArray: [8, 4],
    );
    super.initState();
  }

  void _loadData() async {
    final data = await rootBundle
        .loadString('assets/data/bitcoin_2023-01-01_2023-12-31.csv');
    final rows = CsvParser.parse(data);
    if (!mounted) {
      return;
    }
    setState(() {
      final allData = rows.skip(1).map((row) {
        // 2023-12-31,2024-01-01
        return _BtcCandlestickData(
          datetime: DateTime.parse(row[0]),
          open: double.parse(row[2]),
          high: double.parse(row[3]),
          low: double.parse(row[4]),
          close: double.parse(row[5]),
          volume: double.parse(row[6]),
          marketCap: double.parse(row[7]),
        );
      }).toList();

      _btcMonthlyData = List.generate(12, (index) {
        final month = index + 1;
        final monthData = allData
            .where((element) => element.datetime.month == month)
            .toList();
        monthData.sort((a, b) => a.datetime.compareTo(b.datetime));
        return monthData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 18),
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'BTC Price 2024',
              style: TextStyle(
                color: AppColors.contentColorYellow,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                  color: AppColors.contentColorWhite,
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
          aspectRatio: 1.5,
          child: Stack(
            children: [
              if (_btcMonthlyData != null)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0.0,
                    right: 18.0,
                  ),
                  child: CandlestickChart(
                    CandlestickChartData(
                      candlestickSpots: _btcMonthlyData![_currentMonthIndex]
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final data = entry.value;
                        return CandlestickSpot(
                          x: index.toDouble(),
                          open: data.open,
                          high: data.high,
                          low: data.low,
                          close: data.close,
                        );
                      }).toList(),
                      minX: 0,
                      maxX: 31,
                      gridData: FlGridData(
                        show: true,
                        getDrawingHorizontalLine: (_) => _gridLine,
                        getDrawingVerticalLine: (_) => _gridLine,
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
                            reservedSize: 60,
                            getTitlesWidget: _leftTitles,
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
                      touchedPointIndicator: AxisSpotIndicator(
                        painter: AxisLinesIndicatorPainter(
                          verticalLineProvider: (x) {
                            final data =
                                _btcMonthlyData![_currentMonthIndex][x.toInt()];

                            return VerticalLine(
                              x: x,
                              color: (data.isUp
                                      ? AppColors.contentColorGreen
                                      : AppColors.contentColorRed)
                                  .withValues(alpha: 0.5),
                              strokeWidth: 1,
                            );
                          },
                          horizontalLineProvider: (y) => HorizontalLine(
                            y: y,
                            label: HorizontalLineLabel(
                                show: true,
                                style: const TextStyle(
                                  color: AppColors.contentColorYellow,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                labelResolver: (hLine) =>
                                    hLine.y.toInt().toString(),
                                alignment: Alignment.topLeft),
                            color: AppColors.contentColorYellow.withValues(
                              alpha: 0.8,
                            ),
                            strokeWidth: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (_btcMonthlyData == null)
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

  Widget _bottomTitles(double value, TitleMeta meta) {
    final day = value.toInt() + 1;

    final isImportantToShow = day % 5 == 0 || day == 1;

    if (!isImportantToShow) {
      return const SizedBox();
    }

    return SideTitleWidget(
      meta: meta,
      child: Text(
        day.toString(),
        style: const TextStyle(
          color: AppColors.contentColorGreen,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _leftTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      meta: meta,
      child: Text(
        meta.formattedValue,
        style: const TextStyle(
          color: AppColors.contentColorYellow,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _BtcCandlestickData with EquatableMixin {
  _BtcCandlestickData({
    required this.datetime,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.marketCap,
  });

  final DateTime datetime;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  final double marketCap;

  bool get isUp => open < close;

  @override
  List<Object?> get props => [
        datetime,
        open,
        high,
        low,
        close,
        volume,
        marketCap,
      ];
}
