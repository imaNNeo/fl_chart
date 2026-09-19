<a href="https://www.youtube.com/watch?v=F3wTxTdAFaU&list=PL1-_rCwRcnbNpvodmbt43O81wMUdBv8-a"><img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/line_chart/line_chart_video_thumbnail.png" width=540></a>

### How to use
```dart
LineChart(
  LineChartData(
    // read about it in the LineChartData section
  ),
  duration: Duration(milliseconds: 150), // Optional
  curve: Curves.linear, // Optional
);
```

### Implicit Animations 
When you change the chart's state, it animates to the new state internally (using [implicit animations](https://flutter.dev/docs/development/ui/animations/implicit-animations)). You can control the animation [duration](https://api.flutter.dev/flutter/dart-core/Duration-class.html) and [curve](https://api.flutter.dev/flutter/animation/Curves-class.html) using optional `duration` and `curve` properties, respectively.

### LineChartData
<!-- api:LineChartData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|lineBarsData|`List<LineChartBarData>`|`const []`|List of [`LineChartBarData`](#linechartbardata) to show the chart's lines, they stack and can be drawn on top of each other.|
|betweenBarsData|`List<BetweenBarsData>`|`const []`|Fills area between two [`LineChartBarData`](#linechartbardata) with a color or gradient.|
|titlesData|`FlTitlesData`|`const FlTitlesData()`|Holds data to draw the titles around the chart, see [`FlTitlesData`](base_chart.md#fltitlesdata).|
|extraLinesData|`ExtraLinesData?`|`const ExtraLinesData()`|Extra horizontal or vertical lines to draw on the chart, see [`ExtraLinesData`](base_chart.md#extralinesdata).|
|lineTouchData|`LineTouchData`|`const LineTouchData()`|Handles touch behaviors and responses.|
|showingTooltipIndicators|`List<ShowingTooltipIndicators>`|`const []`|You can show some tooltipIndicators (a popup with an information) on top of each [`LineChartBarData.spots`](#linechartbardata) using `showingTooltipIndicators`, just put line indicator number and spots indices you want to show it on top of them.<br><br>An important point is that you have to disable the default touch behaviour to show the tooltip manually, see [`LineTouchData.handleBuiltInTouches`](#linetouchdata-read-about-touch-handling).|
|gridData|`FlGridData?`|`const FlGridData()`|Holds data to draw the grid lines behind the chart, see [`FlGridData`](base_chart.md#flgriddata).|
|borderData|`FlBorderData?`|`FlBorderData()`|Holds data to draw the border around the chart, see [`FlBorderData`](base_chart.md#flborderdata).|
|rangeAnnotations|`RangeAnnotations?`|`const RangeAnnotations()`|Highlights some horizontal or vertical ranges behind the chart, see [`RangeAnnotations`](base_chart.md#rangeannotations).|
|minX|`double?`|`null`|Minimum x value of the chart. If you don't provide it, it is calculated from the chart's data (providing it is more performant).|
|maxX|`double?`|`null`|Maximum x value of the chart. If you don't provide it, it is calculated from the chart's data (providing it is more performant).|
|baselineX|`double?`|`0`|The x value that the vertical grid lines and the titles are aligned to, they are drawn at every `baselineX + n * interval`.|
|minY|`double?`|`null`|Minimum y value of the chart. If you don't provide it, it is calculated from the chart's data (providing it is more performant).|
|maxY|`double?`|`null`|Maximum y value of the chart. If you don't provide it, it is calculated from the chart's data (providing it is more performant).|
|baselineY|`double?`|`0`|The y value that the horizontal grid lines and the titles are aligned to, they are drawn at every `baselineY + n * interval`.|
|clipData|`FlClipData?`|`const FlClipData.none()`|Clips the chart to its border (prevents drawing outside of the border), see [`FlClipData`](https://pub.dev/documentation/fl_chart/latest/fl_chart/FlClipData-class.html).|
|backgroundColor|`Color?`|`Colors.transparent`|A background color which is drawn behind the chart.|
|rotationQuarterTurns|`int`|`0`|Rotates the chart 90 degrees (clockwise) in every quarter turn. It works like the [`RotatedBox`](https://api.flutter.dev/flutter/widgets/RotatedBox-class.html) widget.|
<!-- /api -->



### LineChartBarData
<!-- api:LineChartBarData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|spots|`List<FlSpot>`|`const []`|This line goes through this spots.<br><br>You can have multiple lines by splitting them, put a [`FlSpot.nullSpot`](base_chart.md#flspot) between each section.|
|show|`bool`|`true`|Determines to show or hide the line.|
|color|`Color?`||If provided, this [`LineChartBarData`](#linechartbardata) draws with this `color`. Otherwise we use `gradient` to draw the line. It throws an exception if you provide both `color` and `gradient`.<br><br>Defaults to [`Colors.cyan`](https://api.flutter.dev/flutter/material/Colors-class.html) if neither `color` nor `gradient` is provided.|
|gradient|`Gradient?`|`null`|If provided, this [`LineChartBarData`](#linechartbardata) draws with this `gradient`. Otherwise we use `color` to draw the line. It throws an exception if you provide both `color` and `gradient`.<br><br>You can use any [`Gradient`](https://api.flutter.dev/flutter/painting/Gradient-class.html) here, such as [`LinearGradient`](https://api.flutter.dev/flutter/painting/LinearGradient-class.html) or [`RadialGradient`](https://api.flutter.dev/flutter/painting/RadialGradient-class.html).|
|gradientArea|`LineChartGradientArea`|`LineChartGradientArea.rectAroundTheLine`|Only effective if `gradient` is provided.<br><br>It will be used to determine the area of the gradient.|
|barWidth|`double`|`2.0`|Determines thickness of drawing line.|
|isCurved|`bool`|`false`|If it's true, [`LineChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/LineChart-class.html) draws the line with curved edges, otherwise it draws line with hard edges.|
|curveSmoothness|`double`|`0.35`|If `isCurved` is true, it determines smoothness of the curved edges.|
|preventCurveOverShooting|`bool`|`false`|Prevents overshooting when drawing a curve line on linear sequence spots, check this [issue](https://github.com/imaNNeo/fl_chart/issues/25).|
|preventCurveOvershootingThreshold|`double`|`10.0`|Applies threshold for `preventCurveOverShooting` algorithm.|
|isStrokeCapRound|`bool`|`false`|If true, the start and end of the line are round ([`StrokeCap.round`](https://api.flutter.dev/flutter/dart-ui/StrokeCap.html)), otherwise they are flat ([`StrokeCap.butt`](https://api.flutter.dev/flutter/dart-ui/StrokeCap.html)).|
|isStrokeJoinRound|`bool`|`false`|If true, the corners of the line are round ([`StrokeJoin.round`](https://api.flutter.dev/flutter/dart-ui/StrokeJoin.html)), otherwise they are sharp ([`StrokeJoin.miter`](https://api.flutter.dev/flutter/dart-ui/StrokeJoin.html)).|
|belowBarData|`BarAreaData?`|`BarAreaData()`|Fills the space below the line, using a color or gradient, see [`BarAreaData`](#barareadata).|
|aboveBarData|`BarAreaData?`|`BarAreaData()`|Fills the space above the line, using a color or gradient, see [`BarAreaData`](#barareadata).|
|dotData|`FlDotData`|`const FlDotData()`|Responsible for showing `spots` on the line as dots, see [`FlDotData`](#fldotdata).|
|errorIndicatorData|`FlErrorIndicatorData<LineChartSpotErrorRangeCallbackInput>`|`const FlErrorIndicatorData<LineChartSpotErrorRangeCallbackInput>()`|Holds data for showing error indicators on the spots in this line (they are shown if you provide [`FlSpot.xError`](base_chart.md#flspot) or [`FlSpot.yError`](base_chart.md#flspot)).|
|showingIndicators|`List<int>`|`const []`|Shows indicators (a thicker line and a larger dot) on the spots at the provided indices.|
|dashArray|`List<int>?`|`null`|Draws the line dashed, it's a circular array of dash lengths and gaps.<br><br>For example, `[5, 10]` results in dashes 5 pixels long followed by gaps 10 pixels long, and `[5, 10, 5]` results in a 5 pixel dash, a 10 pixel gap, a 5 pixel dash, a 5 pixel gap, a 10 pixel dash, etc.|
|shadow|`Shadow`|`const Shadow(color: Colors.transparent)`|Drops a [`Shadow`](https://api.flutter.dev/flutter/dart-ui/Shadow-class.html) behind the line.|
|isStepLineChart|`bool`|`false`|If sets true, it draws the chart in Step Line Chart style, using [`LineChartBarData.lineChartStepData`](#linechartbardata).|
|lineChartStepData|`LineChartStepData`|`const LineChartStepData()`|Holds data for representing a Step Line Chart, and works only if `isStepLineChart` is true.|
<!-- /api -->

### LineChartGradientArea
<!-- api:LineChartGradientArea -->
|Value|Description|
|:----|:----------|
|rectAroundTheLine|The gradient area will be around the line only, meaning the gradient will exactly wrap around the curve.|
|wholeChart|The entire chart area will be used as the gradient area for the curve.|
<!-- /api -->

### LineChartStepData
<!-- api:LineChartStepData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|stepDirection|`double`|`LineChartStepData.stepDirectionMiddle`|Determines the direction of each step, between 0.0 ([`stepDirectionForward`](#linechartstepdata)) and 1.0 ([`stepDirectionBackward`](#linechartstepdata)).|
<!-- /api -->

### BetweenBarsData
<!-- api:BetweenBarsData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|fromIndex|`int`|required|Index of the first [`LineChartBarData`](#linechartbardata) in [`LineChartData.lineBarsData`](#linechartdata) (zero-based), the area is filled from this line.|
|toIndex|`int`|required|Index of the second [`LineChartBarData`](#linechartbardata) in [`LineChartData.lineBarsData`](#linechartdata) (zero-based), the area is filled up to this line.|
|color|`Color?`||If provided, this [`BetweenBarsData`](#betweenbarsdata) fills the area with this `color`. Otherwise we use `gradient` to fill it. It throws an exception if you provide both `color` and `gradient`.<br><br>Defaults to a semi-transparent [`Colors.blueGrey`](https://api.flutter.dev/flutter/material/Colors-class.html) if neither `color` nor `gradient` is provided.|
|gradient|`Gradient?`|`null`|If provided, this [`BetweenBarsData`](#betweenbarsdata) fills the area with this `gradient`. Otherwise we use `color` to fill it. It throws an exception if you provide both `color` and `gradient`.<br><br>You can use any [`Gradient`](https://api.flutter.dev/flutter/painting/Gradient-class.html) here, such as [`LinearGradient`](https://api.flutter.dev/flutter/painting/LinearGradient-class.html) or [`RadialGradient`](https://api.flutter.dev/flutter/painting/RadialGradient-class.html).|
<!-- /api -->

### BarAreaData
<!-- api:BarAreaData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|show|`bool`|`false`|Determines whether to show or hide the below, or above bar area.|
|color|`Color?`||If provided, this [`BarAreaData`](#barareadata) fills the area with this `color`. Otherwise we use `gradient` to fill it. It throws an exception if you provide both `color` and `gradient`.<br><br>Defaults to a semi-transparent [`Colors.blueGrey`](https://api.flutter.dev/flutter/material/Colors-class.html) if neither `color` nor `gradient` is provided.|
|gradient|`Gradient?`|`null`|If provided, this [`BarAreaData`](#barareadata) fills the area with this `gradient`. Otherwise we use `color` to fill it. It throws an exception if you provide both `color` and `gradient`.<br><br>You can use any [`Gradient`](https://api.flutter.dev/flutter/painting/Gradient-class.html) here, such as [`LinearGradient`](https://api.flutter.dev/flutter/painting/LinearGradient-class.html) or [`RadialGradient`](https://api.flutter.dev/flutter/painting/RadialGradient-class.html).|
|spotsLine|`BarAreaSpotsLine`|`const BarAreaSpotsLine()`|Holds data for drawing a line from each spot to the bottom, or top of the chart, see [`BarAreaSpotsLine`](#barareaspotsline).|
|cutOffY|`double`|`0`|Cuts the drawing of the below or above area at this y value (set `applyCutOffY` to true to apply it).|
|applyCutOffY|`bool`|`false`|Determines whether to apply `cutOffY`.|
<!-- /api -->


### BarAreaSpotsLine
<!-- api:BarAreaSpotsLine -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|show|`bool`|`false`|Determines to show or hide all the lines.|
|flLineStyle|`FlLine`|`const FlLine()`|Holds appearance of drawing line on the spots.|
|checkToShowSpotLine|`bool Function(FlSpot)`|`showAllSpotsBelowLine`|Checks to show or hide lines on the spots.|
|applyCutOffY|`bool`|`true`|Determines to inherit the cutOff properties from its parent [`BarAreaData`](#barareadata)|
<!-- /api -->

### FlDotData
<!-- api:FlDotData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|show|`bool`|`true`|Determines show or hide all dots.|
|checkToShowDot|`bool Function(FlSpot, LineChartBarData)`|`showAllDots`|Checks to show or hide an individual dot.|
|getDotPainter|`FlDotPainter Function(FlSpot, double, LineChartBarData, int)`|`_defaultGetDotPainter`|Callback which is called to set the painter of the given [`FlSpot`](base_chart.md#flspot). The [`FlSpot`](base_chart.md#flspot) is provided as parameter to this callback|
<!-- /api -->

### LineTouchData ([read about touch handling](handle_touches.md))
<!-- api:LineTouchData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|enabled|`bool`|`true`|Determines whether to enable or disable touch behaviors.|
|touchCallback|`void Function(FlTouchEvent, LineTouchResponse?)?`|`null`|`touchCallback` notifies you about the happened touch/pointer events. It gives you a [`FlTouchEvent`](base_chart.md#fltouchevent) which is the happened event such as [`FlPointerHoverEvent`](https://pub.dev/documentation/fl_chart/latest/fl_chart/FlPointerHoverEvent-class.html), [`FlTapUpEvent`](https://pub.dev/documentation/fl_chart/latest/fl_chart/FlTapUpEvent-class.html), ... It also gives you a [`BaseTouchResponse`](https://pub.dev/documentation/fl_chart/latest/fl_chart/BaseTouchResponse-class.html) which is the chart specific type and contains information about the elements that has touched.|
|mouseCursorResolver|`MouseCursor Function(FlTouchEvent, LineTouchResponse?)?`|`null`|Using `mouseCursorResolver` you can change the mouse cursor based on the provided [`FlTouchEvent`](base_chart.md#fltouchevent) and [`BaseTouchResponse`](https://pub.dev/documentation/fl_chart/latest/fl_chart/BaseTouchResponse-class.html)|
|longPressDuration|`Duration?`|`null`|This property that allows to customize the duration of the longPress gesture. If null, it uses [kLongPressTimeout](https://api.flutter.dev/flutter/gestures/kLongPressTimeout-constant.html) (500 milliseconds).|
|touchTooltipData|`LineTouchTooltipData`|`const LineTouchTooltipData()`|Determines how the tooltip looks on top of the touched spots, see [`LineTouchTooltipData`](#linetouchtooltipdata).|
|getTouchedSpotIndicator|`List<TouchedSpotIndicatorData?> Function(LineChartBarData, List<int>)`|`defaultTouchedIndicators`|Retrieves a list of [`TouchedSpotIndicatorData`](#touchedspotindicatordata) for the touched spots of a line, to show an indicator on each of them.|
|touchSpotThreshold|`double`|`10`|Distance threshold to handle the touch event.|
|distanceCalculator|`double Function(Offset, Offset)`|`_xDistance`|Calculates the distance between a touch point and a spot, to find the closest spots to the touch. By default, only the horizontal distance is used.|
|handleBuiltInTouches|`bool`|`true`|If true, the chart handles touches by itself: it shows a tooltip bubble and an indicator on the touched spots.|
|getTouchLineStart|`double Function(LineChartBarData, int)`|`defaultGetTouchLineStart`|The starting point on y axis of the touch line. By default, line starts on the bottom of the chart.|
|getTouchLineEnd|`double Function(LineChartBarData, int)`|`defaultGetTouchLineEnd`|The end point on y axis of the touch line. By default, line ends at the touched point. If line end is overlap with the dot, it will be automatically adjusted to the edge of the dot.|
<!-- /api -->


### LineTouchTooltipData
<!-- api:LineTouchTooltipData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|tooltipBorderRadius|`BorderRadius?`|`BorderRadius.circular(4)`|Sets a rounded radius for the tooltip.|
|tooltipPadding|`EdgeInsets`|`const EdgeInsets.symmetric(horizontal: 16, vertical: 8)`|Applies a padding for showing contents inside the tooltip.|
|tooltipMargin|`double`|`16`|Margin between the tooltip and the touched spot.|
|tooltipHorizontalAlignment|`FLHorizontalAlignment`|`FLHorizontalAlignment.center`|Controls showing tooltip on left side, right side or center aligned with spot.|
|tooltipHorizontalOffset|`double`|`0`|Applies horizontal offset for showing tooltip.|
|maxContentWidth|`double`|`120`|Maximum width of the tooltip's content, a text row which is wider than this breaks into a new line.|
|getTooltipItems|`List<LineTooltipItem?> Function(List<LineBarSpot>)`|`defaultLineTooltipItem`|Retrieves a [`LineTooltipItem`](#linetooltipitem) for each touched spot, to show as a row inside the tooltip.|
|getTooltipColor|`Color Function(LineBarSpot)`|`defaultLineTooltipColor`|Retrieves the background color of the tooltip for each touched spot.|
|fitInsideHorizontally|`bool`|`false`|Forces the tooltip to shift horizontally inside the chart, if overflow happens.|
|fitInsideVertically|`bool`|`false`|Forces the tooltip to shift vertically inside the chart, if overflow happens.|
|showOnTopOfTheChartBoxArea|`bool`|`false`|Forces the tooltip container to the top of the chart's box area, instead of on top of the touched spots.|
|rotateAngle|`double`|`0.0`|Controls the rotation of the tooltip.|
|tooltipBorder|`BorderSide`|`BorderSide.none`|Border of the tooltip bubble.|
<!-- /api -->

### LineTooltipItem
<!-- api:LineTooltipItem -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|text|`String`|required|Text of this row in the tooltip bubble.|
|textStyle|`TextStyle`|required|[`TextStyle`](https://api.flutter.dev/flutter/painting/TextStyle-class.html) of the text.|
|textAlign|`TextAlign`|`TextAlign.center`|[`TextAlign`](https://api.flutter.dev/flutter/dart-ui/TextAlign.html) of the text.|
|textDirection|`TextDirection`|`TextDirection.ltr`|[`TextDirection`](https://api.flutter.dev/flutter/dart-ui/TextDirection.html) of the text.|
|children|`List<TextSpan>?`|`null`|Additional [`TextSpan`](https://api.flutter.dev/flutter/painting/TextSpan-class.html)s after `text`, for a more advanced tooltip.|
<!-- /api -->

### TouchedSpotIndicatorData
<!-- api:TouchedSpotIndicatorData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|indicatorBelowLine|`FlLine`|required|The line drawn below the touched spot, see [`FlLine`](base_chart.md#flline).|
|touchedSpotDotData|`FlDotData`|required|The dot drawn on the touched spot, see [`FlDotData`](#fldotdata).|
<!-- /api -->


### LineBarSpot
<!-- api:LineBarSpot fields -->
Also has the properties of [`FlSpot`](base_chart.md#flspot).

|Property|Type|Description|
|:-------|:---|:----------|
|bar|`LineChartBarData`|Is the [`LineChartBarData`](#linechartbardata) that this spot is inside of.|
|barIndex|`int`|Is the index of our `bar`, in the [`LineChartData.lineBarsData`](#linechartdata) list.|
|spotIndex|`int`|Is the index of this spot, in the [`LineChartBarData.spots`](#linechartbardata) list.|
<!-- /api -->


### TouchLineBarSpot
<!-- api:TouchLineBarSpot fields -->
Also has the properties of [`LineBarSpot`](#linebarspot).

|Property|Type|Description|
|:-------|:---|:----------|
|distance|`double`|Distance in pixels from where the user tapped.|
<!-- /api -->


### LineTouchResponse
<!-- api:LineTouchResponse fields -->
|Property|Type|Description|
|:-------|:---|:----------|
|touchLocation|`Offset`|The location of the touch in pixels on the screen.|
|touchChartCoordinate|`Offset`|The axis coordinate of the touch in chart's coordinate system.|
|lineBarSpots|`List<TouchLineBarSpot>?`|touch happened on these spots (if a single line provided on the chart, `lineBarSpots`'s length will be 1 always)|
<!-- /api -->

### ShowingTooltipIndicators
<!-- api:ShowingTooltipIndicators -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|showingSpots|`List<LineBarSpot>`|required|Determines the spots that each tooltip should be shown.|
<!-- /api -->


### some samples
----
##### Sample 1 ([Source Code](/example/lib/presentation/samples/line/line_chart_sample1.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/line_chart/line_chart_sample_1.gif" width="300" >

<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/line_chart/line_chart_sample_1_anim.gif" width="300" >


##### Sample 2 ([Source Code](/example/lib/presentation/samples/line/line_chart_sample2.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/line_chart/line_chart_sample_2.gif" width="300" >

<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/line_chart/line_chart_sample_2_anim.gif" width="300" >


##### Sample 3 ([Source Code](/example/lib/presentation/samples/line/line_chart_sample3.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/line_chart/line_chart_sample_3.gif" width="300" >


##### Sample 4 ([Source Code](/example/lib/presentation/samples/line/line_chart_sample4.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/line_chart/line_chart_sample_4.png" width="300" >


##### Sample 5 ([Source Code](/example/lib/presentation/samples/line/line_chart_sample5.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/line_chart/line_chart_sample_5.png" width="300" >


##### Sample 6 - Reversed ([Source Code](/example/lib/presentation/samples/line/line_chart_sample6.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/line_chart/line_chart_sample_6.png" width="300" >


##### Sample 7 ([Source Code](/example/lib/presentation/samples/line/line_chart_sample7.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/line_chart/line_chart_sample_7.png" width="300" >


##### Sample 8 ([Source Code](/example/lib/presentation/samples/line/line_chart_sample8.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/line_chart/line_chart_sample_8.png" width="300" >

##### Sample 9 ([Source Code](/example/lib/presentation/samples/line/line_chart_sample9.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/line_chart/line_chart_sample_9.gif" width="300" >

##### Sample 10 ([Source Code](/example/lib/presentation/samples/line/line_chart_sample10.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/line_chart/line_chart_sample_10.gif" width="300" >

##### Sample 11 ([Source Code](/example/lib/presentation/samples/line/line_chart_sample11.dart))
https://user-images.githubusercontent.com/7009300/152555425-3b53ac8c-257f-49b0-8d75-1a878c03ccaa.mp4
