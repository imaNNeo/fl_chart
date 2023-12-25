# Migrate to 0.50.0

## Widgets as titles (instead of boring strings) [#183](https://github.com/imaNNeo/fl_chart/issues/183)
We did a lot of hard-work to bring widgets to our titles around the axis-based charts.
It means that you can now put a widget as a title instead of a string.
Look at the below samples:

**LineChartSample 8** ([Source Code](https://github.com/imaNNeo/fl_chart/blob/main/example/lib/presentation/samples/line/line_chart_sample8.dart))

<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/line_chart/line_chart_sample_8.png" width="300" >

**BarChartSample 7** ([Source Code](https://github.com/imaNNeo/fl_chart/blob/main/example/lib/presentation/samples/bar/bar_chart_sample7.dart))

<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/bar_chart/bar_chart_sample_7.gif" width="300" >

**Breaking:**
Previously in [FlTitlesData](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/base_chart.md#FlTitlesData), there were four [SideTitles](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/base_chart.md#sidetitles). Now we have four [AxisTitle](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/base_chart.md#axistitle) instead and [SideTitles](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/base_chart.md#sidetitles) can be placed inside [AxisTitle](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/base_chart.md#AxisTitle).
In fact, we removed `AxisTitlesData` class (which used to hold four `AxisTitle`). Now you can put them in [FlTitlesData](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/base_chart.md#fltitlesdata).

    bool? showTitle,
    String? titleText,
    double? reservedSize,
    TextStyle? textStyle,
    TextDirection? textDirection,
    TextAlign? textAlign,

Look at the below sample.

Previously:
```dart
AxisBasedChartData( // Line, Bar and Scatter
  axisTitleData: FlAxisTitleData(
    bottomTitle: AxisTitle(
      showTitle: true,
      margin: 0,
      titleText: '2019',
      reservedSize: 80,
      textStyle: TextStyle(color: Colors.green),
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
    ),
  ),
  titlesData: FlTitlesData(
    bottomTitles: SideTitles(
      showTitles: true,
      getTitles: (value) {
        return 'My Text'
      },
      reservedSize: 14,
      interval: 1,
      margin: 8,
      getTextStyles: (context, value) => TextStyle(color: Colors.red),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
    ),
  )
)
```

Now in `0.50.0`:
```dart
AxisBasedChartData( // Line, Bar and Scatter
  titlesData: FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      axisNameWidget: Text( // You can use any widget here
        '2019',
        style: TextStyle(color: Colors.green),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
      axisNameSize: 80,
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, titleMeta) {
          return Padding( // You can use any widget here
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'My Text',
              style: TextStyle(color: Colors.red),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
            ),
          );
        },
        reservedSize: 14,
        interval: 1,
      ),
    ),
  )
)
```

* Instead of setting `rotateAngle` property, now you can wrap your widget with [RotatedBox](https://api.flutter.dev/flutter/widgets/RotatedBox-class.html) to rotate it.
* Instead of setting `checkToShowTitle` property, you can pass an empty [SizedBox](https://api.flutter.dev/flutter/widgets/SizedBox-class.html) wherever you want to skip drawing a title.

-----

## Gradient and solid color #948
We made some changes on our approach for handling `solid` color and `gradient` colors.

Previously, we had these properties to handle gradient or solid color:
```dart
List<Color> colors,
List<double> stops,
Offset gradientFrom,
Offset gradientTo,
```
It was supposed to work on both solid color and gradient color. 
If you pass just one color in the `colors` property, it was a solid color. 
On the other hand, if you provide more than one color, it was a linear gradient.

Now we are using a new approach with the properties below:
```dart
Color? color,
Gradient? gradient,
```

* If you fill `color` property, it will be a solid color.
* If you fill `gradient` property, it would be any [Gradient](https://api.flutter.dev/flutter/dart-ui/Gradient-class.html) you want. Such as [LinearGradient](https://api.flutter.dev/flutter/painting/LinearGradient-class.html) and [RadialGradient](https://api.flutter.dev/flutter/painting/RadialGradient-class.html).
* You need to fill one of them.

These are the affected classes:
* [BarChartRodData](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/bar_chart.md#barchartroddata)
* [BackgroundBarChartRodData](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/bar_chart.md#backgroundbarchartroddata)
* [BarAreaData](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/line_chart.md#BarAreaData)
* [BetweenBarsData](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/line_chart.md#betweenbarsdata)
* [LineChartBarData](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/line_chart.md#linechartbardata)

Check the below sample:

Previously:
```dart
LineChartBarData(
  colors: [Colors.red]
)
```

Now in `0.50.0`:
```dart
LineChartBarData(
  color: Colors.red
)
```
-----
Previously:
```dart
LineChartBarData(
  colors: [Colors.green, Colors.blue],
)
```

Now in `0.50.0`:
```dart
LineChartBarData(
  gradient: LinearGradient(
    colors: [Colors.green, Colors.blue],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  )
)
```
-----
Previously:
```dart
LineChartBarData(
  colors: [Colors.green, Colors.blue],
  colorStops: [0.1, 0.10],
  gradientFrom: Offset(0, 0), // topLeft
  gradientTo: Offset(1, 1), // bottomRight
)
```

Now in `0.50.0`:
```dart
LineChartBarData(
  gradient: LinearGradient(
    colors: [Colors.green, Colors.blue],
    stops: [0.1, 0.10],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  )
)
```