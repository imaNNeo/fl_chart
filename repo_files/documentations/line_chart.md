# LineChart

<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/line_chart/line_chart.jpg" width="300" >

### How to use
```dart
LineChart(
  LineChartData(
    // read about it in the LineChartData section
  ),
  swapAnimationDuration: Duration(milliseconds: 150), // Optional
  swapAnimationCurve: Curves.linear, // Optional
);
```

### Implicit Animations 
When you change the chart's state, it animates to the new state internally (using [implicit animations](https://flutter.dev/docs/development/ui/animations/implicit-animations)). You can control the animation [duration](https://api.flutter.dev/flutter/dart-core/Duration-class.html) and [curve](https://api.flutter.dev/flutter/animation/Curves-class.html) using optional `swapAnimationDuration` and `swapAnimationCurve` properties, respectively.

### LineChartData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|lineBarsData| list of [LineChartBarData ](#LineChartBarData ) to show the chart's lines, they stack and can be drawn on top of each other|[]|
|betweenBarsData| list of [BetweenBarsData](#BetweenBarsData ) to fill the area between 2 chart lines|[]|
|titlesData| check the [FlTitlesData](base_chart.md#FlTitlesData)| FlTitlesData()|
|axisTitleData| check the [FlAxisTitleData](base_chart.md#FlAxisTitleData)| FlAxisTitleData()|
|extraLinesData| [ExtraLinesData](base_chart.md#ExtraLinesData) object to hold drawing details of extra horizontal and vertical lines. Check [ExtraLinesData](base_chart.md#ExtraLinesData)|ExtraLinesData()|
|lineTouchData| [LineTouchData](#linetouchdata-read-about-touch-handling) holds the touch interactivity details| LineTouchData()|
|rangeAnnotations| show range annotations behind the chart, check [RangeAnnotations](base_chart.md#RangeAnnotations) | RangeAnnotations()|
|showingTooltipIndicators| show the tooltip based on provided list of [LineBarSpot](#LineBarSpot)| [] |
|gridData| check the [FlGridData](base_chart.md#FlGridData)|FlGridData()|
|borderData| check the [FlBorderData](base_chart.md#FlBorderData)|FlBorderData()|
|minX| gets minimum x of x axis, if null, value will read from the input lineBars |null|
|maxX| gets maximum x of x axis, if null, value will read from the input lineBars | null|
|baselineX| defines the baseline of x-axis | 0|
|minY| gets minimum y of y axis, if null, value will read from the input lineBars | null|
|maxY| gets maximum y of y axis, if null, value will read from the input lineBars | null|
|baselineY| defines the baseline of y-axis | 0|
|clipData| clip the chart to the border (prevent drawing outside the border) | FlClipData.none()|
|backgroundColor| a background color which is drawn behind th chart| null |


### LineChartBarData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|show| determines to show or hide the bar line|true|
|spots| list of [FlSpot](base_chart.md#FlSpot)'s x and y coordinates that the line go through it| []
|color|color of the line|[Colors.redAccent]|
|gradient| You can use any [Gradient](https://api.flutter.dev/flutter/dart-ui/Gradient-class.html) here. such as [LinearGradient](https://api.flutter.dev/flutter/painting/LinearGradient-class.html) or [RadialGradient](https://api.flutter.dev/flutter/painting/RadialGradient-class.html)|null|
|barWidth| gets the stroke width of the line bar|2.0|
|isCurved| curves the corners of the line on the spot's positions| false|
|curveSmoothness| smoothness radius of the curve corners (works when isCurved is true) | 0.35|
|preventCurveOverShooting|prevent overshooting when draw curve line on linear sequence spots, check this [issue](https://github.com/imaNNeo/fl_chart/issues/25)| false|
|preventCurveOvershootingThreshold|threshold for applying prevent overshooting algorithm | 10.0|
|isStrokeCapRound| determines whether start and end of the bar line is Qubic or Round | false|
|isStrokeJoinRound| determines whether stroke joins have a round shape or a sharp edge | false|
|belowBarData| check the [BarAreaData](#BarAreaData) |BarAreaData|
|aboveBarData| check the [BarAreaData](#BarAreaData) |BarAreaData|
|dotData| check the [FlDotData](#FlDotData) | FlDotData()|
|showingIndicators| show indicators based on provided indexes | []|
|dashArray|A circular array of dash offsets and lengths. For example, the array `[5, 10]` would result in dashes 5 pixels long followed by blank spaces 10 pixels long.  The array `[5, 10, 5]` would result in a 5 pixel dash, a 10 pixel gap, a 5 pixel dash, a 5 pixel gap, a 10 pixel dash, etc.|null|
|shadow|It drops a shadow behind your bar, see [Shadow](https://api.flutter.dev/flutter/dart-ui/Shadow-class.html).|Shadow()|
|isStepLineChart|If sets true, it draws the chart in Step Line Chart style, using `lineChartStepData`.|false|
|lineChartStepData|Holds data for representing a Step Line Chart, and works only if [isStepChart] is true.|[LineChartStepData](#LineChartStepData)()|

### LineChartStepData
|PropName|Description|default value|
|:-------|:----------|:------------|
|stepDirection|Determines the direction of each step, could be between 0.0 (forward), and 1.0 (backward)|LineChartStepData.stepDirectionMiddle|

### BetweenBarsData
|PropName|Description|default value|
|:-------|:----------|:------------|
|fromIndex|index of the first LineChartBarData inside LineChartData (zero-based index)|required|
|toIndex|index of the second LineChartBarData inside LineChartData (zero-based index)|required|
|color|color of the area|[Colors.blueGrey]|
|gradient| You can use any [Gradient](https://api.flutter.dev/flutter/dart-ui/Gradient-class.html) here. such as [LinearGradient](https://api.flutter.dev/flutter/painting/LinearGradient-class.html) or [RadialGradient](https://api.flutter.dev/flutter/painting/RadialGradient-class.html)|null|

### BarAreaData
|PropName|Description|default value|
|:-------|:----------|:------------|
|show|determines to show or hide the below, or above bar area|false|
|color|color of the below, or above bar area|[Colors.blueGrey]|
|gradient| You can use any [Gradient](https://api.flutter.dev/flutter/dart-ui/Gradient-class.html) here. such as [LinearGradient](https://api.flutter.dev/flutter/painting/LinearGradient-class.html) or [RadialGradient](https://api.flutter.dev/flutter/painting/RadialGradient-class.html)|null|
|spotsLine| draw a line from each spot the the bottom, or top of the chart|[BarAreaSpotsLine](#BarAreaSpotsLine)()|
|cutOffY| cut the drawing below or above area to this y value (set `applyCutOffY` true if you want to set it)|null|
|applyCutOffY| determines should or shouldn't apply cutOffY (`scutOffY` should be provided)|false|


### BarAreaSpotsLine
|PropName|Description|default value|
|:-------|:----------|:------------|
|show|determines show or hide the below, or above spots line|true|
|flLineStyle|a [FlLine](base_chart.md#FlLine) object that determines style of the line|[Colors.blueGrey]|
|checkToShowSpotLine|a function to determine whether to show or hide the below or above line on the given spot|showAllSpotsBelowLine|
|applyCutOffY|Determines to inherit the cutOff properties from its parent [BarAreaData](#BarAreaData)|true|

### FlDotData
|PropName|Description|default value|
|:-------|:----------|:------------|
|show|determines to show or hide the dots|true|
|checkToShowDot|a function to determine whether to show or hide the dot on the given spot|showAllDots|
|getDotPainter|a function to determine how the dot is drawn on the given spot|_defaultGetDotPainter|

### LineTouchData ([read about touch handling](handle_touches.md))
|PropName|Description|default value|
|:-------|:----------|:------------|
|enabled|determines to enable or disable touch behaviors|true|
|mouseCursorResolver|you can change the mouse cursor based on the provided [FlTouchEvent](https://github.com/imaNNeo/fl_chart/blob/master/repo_files/documentations/base_chart.md#fltouchevent) and [LineTouchResponse](#LineTouchResponse)|MouseCursor.defer|
|touchTooltipData|a [LineTouchTooltipData](#LineTouchTooltipData), that determines how show the tooltip on top of touched spots (appearance of the showing tooltip bubble)|LineTouchTooltipData|
|getTouchedSpotIndicator| a callback that retrieves list of [TouchedSpotIndicatorData](#TouchedSpotIndicatorData) by the given list of [LineBarSpot](#LineBarSpot) for showing the indicators on touched spots|defaultTouchedIndicators|
|touchSpotThreshold|the threshold of the touch accuracy|10|
|distanceCalculator| a function to calculate the distance between a spot and a touch event| _xDistance|
|handleBuiltInTouches| set this true if you want the built in touch handling (show a tooltip bubble and an indicator on touched spots) | true|
|getTouchLineStart| controls where the line starts, default is bottom of the chart| defaultGetTouchLineStart|
|getTouchLineEnd| controls where the line ends, default is the touch point| defaultGetTouchLineEnd|
|touchCallback| listen to this callback to retrieve touch/pointer events and responses, it gives you a [FlTouchEvent](https://github.com/imaNNeo/fl_chart/blob/master/repo_files/documentations/base_chart.md#fltouchevent) and [LineTouchResponse](#LineTouchResponse)| null|
|longPressDuration| allows to customize the duration of the longPress gesture. If null, the duration of the longPressGesture is [kLongPressTimeout](https://api.flutter.dev/flutter/gestures/kLongPressTimeout-constant.html)| null|


### LineTouchTooltipData
 |PropName|Description|default value|
 |:-------|:----------|:------------|
 |tooltipBgColor|background color of the tooltip bubble|Colors.white|
 |tooltipBorder|border of the tooltip bubble|BorderSide.none|
 |tooltipRoundedRadius|background corner radius of the tooltip bubble|4|
 |tooltipPadding|padding of the tooltip|EdgeInsets.symmetric(horizontal: 16, vertical: 8)|
 |tooltipMargin|margin between the tooltip and the touched spot|16|
 |tooltipHorizontalAlignment|horizontal alginment of tooltip relative to the spot|FLHorizontalAlignment.center|
 |tooltipHorizontalOffset|horizontal offset of tooltip|0|
 |maxContentWidth|maximum width of the tooltip (if a text row is wider than this, then the text breaks to a new line|120|
 |getTooltipItems|a callback that retrieve list of [LineTooltipItem](#LineTooltipItem) by the given list of [LineBarSpot](#LineBarSpot) |defaultLineTooltipItem|
 |fitInsideHorizontally| forces tooltip to horizontally shift inside the chart's bounding box| false|
 |fitInsideVertically| forces tooltip to vertically shift inside the chart's bounding box| false|
 |showOnTopOfTheChartBoxArea| forces the tooltip container to top of the line| false|

### LineTooltipItem
|PropName|Description|default value|
|:-------|:----------|:------------|
|text|text string of each row in the tooltip bubble|null|
|textStyle|[TextStyle](https://api.flutter.dev/flutter/dart-ui/TextStyle-class.html) of the showing text row|null|
|textAlign|[TextStyle](https://api.flutter.dev/flutter/dart-ui/TextAlign-class.html) of the showing text row|TextAlign.center|
|textDirection|[TextDirection](https://api.flutter.dev/flutter/dart-ui/TextDirection-class.html) of the showing text row|TextDirection.ltr|
|children|[List<TextSpan>](https://api.flutter.dev/flutter/painting/InlineSpan-class.html) pass additional InlineSpan children for a more advance tooltip|null|

### TouchedSpotIndicatorData
|PropName|Description|default value|
|:-------|:----------|:------------|
|indicatorBelowLine|a [FlLine](base_chart.md#FlLine) to show the below line indicator on the touched spot|null|
|touchedSpotDotData|a [FlDotData](#FlDotData) to show a dot indicator on the touched spot|null|


### LineBarSpot
|PropName|Description|default value|
|:-------|:----------|:------------|
|bar|the [LineChartBarData](#LineChartBarData) that contains a spot|null|
|barIndex|index of the target [LineChartBarData](#LineChartBarData) inside [LineChartData](#LineChartData)|null|
|spotIndex|index of the target [FlSpot](base_chart.md#FlSpot) inside [LineChartBarData](#LineChartBarData)|null|


### TouchLineBarSpot
|PropName|Description|default value|
|:-------|:----------|:------------|
|bar|the [LineChartBarData](#LineChartBarData) that contains a spot|null|
|barIndex|index of the target [LineChartBarData](#LineChartBarData) inside [LineChartData](#LineChartData)|null|
|spotIndex|index of the target [FlSpot](base_chart.md#FlSpot) inside [LineChartBarData](#LineChartBarData)|null|
|distance|distance to the touch event|null|


### LineTouchResponse
|PropName|Description|default value|
|:-------|:----------|:------------|
|lineBarSpots|a list of [TouchLineBarSpot](#TouchLineBarSpot)|null|

### ShowingTooltipIndicators
|PropName|Description|default value|
|:-------|:----------|:------------|
|showingSpots|Determines the spots that each tooltip should be shown.|null|


### some samples
----
##### Sample 1 ([Source Code](/example/lib/presentation/samples/line/line_chart_sample1.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_1.gif" width="300" >

<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_1_anim.gif" width="300" >


##### Sample 2 ([Source Code](/example/lib/presentation/samples/line/line_chart_sample2.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_2.gif" width="300" >

<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_2_anim.gif" width="300" >


##### Sample 3 ([Source Code](/example/lib/presentation/samples/line/line_chart_sample3.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_3.gif" width="300" >


##### Sample 4 ([Source Code](/example/lib/presentation/samples/line/line_chart_sample4.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_4.png" width="300" >


##### Sample 5 ([Source Code](/example/lib/presentation/samples/line/line_chart_sample5.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_5.png" width="300" >


##### Sample 6 - Reversed ([Source Code](/example/lib/presentation/samples/line/line_chart_sample6.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_6.png" width="300" >


##### Sample 7 ([Source Code](/example/lib/presentation/samples/line/line_chart_sample7.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_7.png" width="300" >


##### Sample 8 ([Source Code](/example/lib/presentation/samples/line/line_chart_sample8.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_8.png" width="300" >

##### Sample 9 ([Source Code](/example/lib/presentation/samples/line/line_chart_sample9.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_9.gif" width="300" >

##### Sample 10 ([Source Code](/example/lib/presentation/samples/line/line_chart_sample10.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_10.gif" width="300" >

##### Sample 11 ([Source Code](/example/lib/presentation/samples/line/line_chart_sample11.dart))
https://user-images.githubusercontent.com/7009300/152555425-3b53ac8c-257f-49b0-8d75-1a878c03ccaa.mp4
