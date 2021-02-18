# LineChart

<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart.jpg" width="300" >

### How to use
```dart
LineChart(
  LineChartData(
    // read about it in the below section
  ),
);
```

### LineChartData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|lineBarsData| list of [LineChartBarData ](#LineChartBarData ) to show the chart's lines, they stack and be drawn on top of each other|[]|
|betweenBarsData| list of [BetweenBarsData](#BetweenBarsData ) to fill the area between 2 chart lines|[]|
|titlesData| check the [FlTitlesData](base_chart.md#FlTitlesData)| FlTitlesData()|
|axisTitleData| check the [FlAxisTitleData](base_chart.md#FlAxisTitleData)| FlAxisTitleData()|
|extraLinesData| [ExtraLinesData](#ExtraLinesData) object to hold drawing details of extra horizontal and vertical lines.|
|lineTouchData| [LineTouchData](#linetouchdata-read-about-touch-handling) holds the touch interactivity details| LineTouchData()|
|rangeAnnotations| show range annotations behind the chart, check [RangeAnnotations](base_chart.md#RangeAnnotations) | RangeAnnotations()|
|showingTooltipIndicators| show the tooltip based on provided position(x), and list of [LineBarSpot](#LineBarSpot)| [] |
|gridData| check the [FlGridData](base_chart.md#FlGridData)|FlGridData()|
|borderData| check the [FlBorderData](base_chart.md#FlBorderData)|FlBorderData()|
|minX| gets minimum x of x axis, if null, value will read from the input lineBars |null|
|maxX| gets maximum x of x axis, if null, value will read from the input lineBars | null|
|minY| gets minimum y of y axis, if null, value will read from the input lineBars | null|
|maxY| gets maximum y of y axis, if null, value will read from the input lineBars | null|
|clipData| clip the chart to the border (prevent drawing outside the border) | FlClipData.none()|
|backgroundColor| a background color which is drawn behind th chart| null |


### LineChartBarData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|show| determines to show or hide the bar line|true|
|spots| list of [FlSpot](base_chart.md#FlSpot)'s x and y coordinates that the line go through it| []
|colors| colors the line, if multiple colors provided it will be gradient|[Colors.redAccent]|
|colorStops| gets the stop positions of the gradient color, [Read More](https://api.flutter.dev/flutter/dart-ui/Gradient/Gradient.linear.html)|null|
|gradientFrom|determines start of the gradient, each number should be between 0 and 1, [Read More](https://api.flutter.dev/flutter/dart-ui/Gradient/Gradient.linear.html)|Offset(0, 0)|
|gradientTo|determines end of the gradient, each number should be between 0 and 1, [Read More](https://api.flutter.dev/flutter/dart-ui/Gradient/Gradient.linear.html)|Offset(1, 0)|
|barWidth| gets the stroke width of the line bar|2.0|
|isCurved| curves the corners of the line on the spot's positions| false|
|curveSmoothness| smoothness radius of the curve corners (works when isCurved is true) | 0.35|
|preventCurveOverShooting|prevent overshooting when draw curve line on linear sequence spots, check this [issue](https://github.com/imaNNeoFighT/fl_chart/issues/25)| false|
|preventCurveOvershootingThreshold|threshold for applying prevent overshooting algorithm | 10.0|
|isStrokeCapRound| determines whether start and end of the bar line is Qubic or Round | false|
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
|colors|colors the area, if multiple colors provided it will be gradient|[Colors.blueGrey]|
|gradientFrom|determines start of the gradient, each number should be between 0 and 1, [Read More](https://api.flutter.dev/flutter/dart-ui/Gradient/Gradient.linear.html)|Offset(0, 0)|
|gradientTo|determines end of the gradient, each number should be between 0 and 1, [Read More](https://api.flutter.dev/flutter/dart-ui/Gradient/Gradient.linear.html)|Offset(1, 0)|
|gradientColorStops|gets the stop positions of the gradient color, [Read More](https://api.flutter.dev/flutter/dart-ui/Gradient/Gradient.linear.html)|null|

### BarAreaData
|PropName|Description|default value|
|:-------|:----------|:------------|
|show|determines to show or hide the below, or above bar area|false|
|colors|colors the below, or above bar area, if multiple colors provided it will be gradient|[Colors.blueGrey]|
|gradientFrom|determines start of the gradient, each number should be between 0 and 1, [Read More](https://api.flutter.dev/flutter/dart-ui/Gradient/Gradient.linear.html)|Offset(0, 0)|
|gradientTo|determines end of the gradient, each number should be between 0 and 1, [Read More](https://api.flutter.dev/flutter/dart-ui/Gradient/Gradient.linear.html)|Offset(1, 0)|
|gradientColorStops|gets the stop positions of the gradient color, [Read More](https://api.flutter.dev/flutter/dart-ui/Gradient/Gradient.linear.html)|null|
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


### HorizontalLine
|PropName|Description|default value|
|:-------|:----------|:------------|
|y|draw straight line from left to right of the chart with dynamic y value|null|
|color|color of the line|Colors.black|
|strokeWidth|strokeWidth of the line|2|
|image|image to annotate the line. the Future must be complete at the time this is received by the chart|null|
|sizedPicture|uses an svg to annotate the line with a picture. the Future must be complete at the time this is received by the chart|null|
|label|a [HorizontalLineLabel](#HorizontalLineLabel) object with label parameters|null


### VerticalLine
|PropName|Description|default value|
|:-------|:----------|:------------|
|x|draw straight line from bottom to top of the chart with dynamic x value|null|
|color|color of the line|Colors.black|
|strokeWidth|strokeWidth of the line|2|
|image|image to annotate the line. the Future must be complete at the time this is received by the chart|null|
|sizedPicture|uses an svg to annotate the line with a picture. the Future must be complete at the time this is received by the chart|null|
|label|a [VerticalLineLabel](#VerticalLineLabel) object with label parameters|null

### SizedPicture
|PropName|Description|default value|
|:-------|:----------|:------------|
|Picture|a Dart UI Picture which should be derived from the svg. see example for how to get a Picture from an svg.|null|
|width|the width of the picture|null|
|height|the height of the picture|null|

### HorizontalLineLabel
|PropName|Description|default value|
|:-------|:----------|:------------|
|show| Determines showing or not showing label|false|
|padding|[EdgeInsets](https://api.flutter.dev/flutter/painting/EdgeInsets-class.html) object with label padding configuration|EdgeInsets.zero|
|style|[TextStyle](https://api.flutter.dev/flutter/dart-ui/TextStyle-class.html) which determines label text style|TextStyle(fontSize: 11, color: line.color)|
|alignment|[Alignment](https://api.flutter.dev/flutter/painting/Alignment-class.html) with label position relative to line|Alignment.topLeft|
|labelResolver|Getter function returning label title|defaultLineLabelResolver|

### VerticalLineLabel
|PropName|Description|default value|
|:-------|:----------|:------------|
|show| Determines showing or not showing label|false|
|padding|[EdgeInsets](https://api.flutter.dev/flutter/painting/EdgeInsets-class.html) object with label padding configuration|EdgeInsets.zero|
|style|[TextStyle](https://api.flutter.dev/flutter/dart-ui/TextStyle-class.html) which determines label text style|TextStyle(fontSize: 11, color: line.color)|
|alignment|[Alignment](https://api.flutter.dev/flutter/painting/Alignment-class.html) with label position relative to line|Alignment.topLeft|
|labelResolver|Getter function returning label title|defaultLineLabelResolver|



### ExtraLinesData
|PropName|Description|default value|
|:-------|:----------|:------------|
|extraLinesOnTop|determines to paint the extraLines over the trendline or below it|true|
|horizontalLines|list of [HorizontalLine](#HorizontalLine) to draw on the chart|[]|
|verticalLines|list of [VerticalLine](#VerticalLine) to draw on the chart|[]|


### LineTouchData ([read about touch handling](handle_touches.md))
|PropName|Description|default value|
|:-------|:----------|:------------|
|enabled|determines to enable or disable touch behaviors|true|
|touchTooltipData|a [LineTouchTooltipData](#LineTouchTooltipData), that determines how show the tooltip on top of touched spots (appearance of the showing tooltip bubble)|LineTouchTooltipData|
|getTouchedSpotIndicator| a callback that retrieves list of [TouchedSpotIndicatorData](#TouchedSpotIndicatorData) by the given list of [LineBarSpot](#LineBarSpot) for showing the indicators on touched spots|defaultTouchedIndicators|
|touchSpotThreshold|the threshold of the touch accuracy|10|
|handleBuiltInTouches| set this true if you want the built in touch handling (show a tooltip bubble and an indicator on touched spots) | true|
|fullHeightTouchLine| set `true` to show the line in full height mode | false|
|touchCallback| listen to this callback to retrieve touch events, it gives you a [LineTouchResponse](#LineTouchResponse)| null|


### LineTouchTooltipData
 |PropName|Description|default value|
 |:-------|:----------|:------------|
 |tooltipBgColor|background color of the tooltip bubble|Colors.white|
 |tooltipRoundedRadius|background corner radius of the tooltip bubble|4|
 |tooltipPadding|padding of the tooltip|EdgeInsets.symmetric(horizontal: 16, vertical: 8)|
 |tooltipBottomMargin|bottom margin of the tooltip (to the top of most top spot)|16|
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
|spotIndex|index of the target [FlSpot](#FlSpot) inside [LineChartBarData](#LineChartBarData)|null|


### LineTouchResponse
###### you can listen to touch behaviors stream and retrieve this object when any touch action happend.
|PropName|Description|default value|
|:-------|:----------|:------------|
|lineBarSpots|a list of [LineBarSpot](#LineBarSpot)|null|
|touchInput|a [FlTouchInput](base_chart.md#FlTouchInput) that is the touch behaviour|null|

### ShowingTooltipIndicators
|PropName|Description|default value|
|:-------|:----------|:------------|
|lineIndex|Determines in which line these tooltips should be shown.|null|
|showingSpots|Determines the spots that each tooltip should be shown.|null|


### some samples
----
##### Sample 1 ([Source Code](/example/lib/line_chart/samples/line_chart_sample1.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_1.gif" width="300" >

<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_1_anim.gif" width="300" >


##### Sample 2 ([Source Code](/example/lib/line_chart/samples/line_chart_sample2.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_2.gif" width="300" >

<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_2_anim.gif" width="300" >


##### Sample 3 ([Source Code](/example/lib/line_chart/samples/line_chart_sample3.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_3.gif" width="300" >


##### Sample 4 ([Source Code](/example/lib/line_chart/samples/line_chart_sample4.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_4.png" width="300" >


##### Sample 5 ([Source Code](/example/lib/line_chart/samples/line_chart_sample5.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_5.png" width="300" >


##### Sample 6 - Reversed ([Source Code](/example/lib/line_chart/samples/line_chart_sample6.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_6.png" width="300" >


##### Sample 7 ([Source Code](/example/lib/line_chart/samples/line_chart_sample7.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_7.png" width="300" >


##### Sample 8 ([Source Code](/example/lib/line_chart/samples/line_chart_sample8.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_8.png" width="300" >
