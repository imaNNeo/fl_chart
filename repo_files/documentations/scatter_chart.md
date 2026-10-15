# ScatterChart

<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/scatter_chart/scatter_chart.png" width="300" >

### How to use
```dart
ScatterChart(
  ScatterChartData(
    // read about it in the ScatterChartData section
  ),
  duration: Duration(milliseconds: 150), // Optional
  curve: Curves.linear, // Optional
);
```

### Implicit Animations
When you change the chart's state, it animates to the new state internally (using [implicit animations](https://flutter.dev/docs/development/ui/animations/implicit-animations)). You can control the animation [duration](https://api.flutter.dev/flutter/dart-core/Duration-class.html) and [curve](https://api.flutter.dev/flutter/animation/Curves-class.html) using optional `duration` and `curve` properties, respectively.

### ScatterChartData
<!-- api:ScatterChartData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|scatterSpots|`List<ScatterSpot>?`|`const []`|The spots to draw on the chart, see [`ScatterSpot`](#scatterspot).|
|titlesData|`FlTitlesData?`|`const FlTitlesData()`|Holds data to draw the titles around the chart, see [`FlTitlesData`](base_chart.md#fltitlesdata).|
|scatterTouchData|`ScatterTouchData?`|`ScatterTouchData()`|Handles touch behaviors and responses, see [`ScatterTouchData`](#scattertouchdata-read-about-touch-handling).|
|showingTooltipIndicators|`List<int>?`|`const []`|you can show some tooltipIndicators (a popup with an information) on top of each [`ScatterSpot`](#scatterspot) using `showingTooltipIndicators`, just put indices you want to show it on top of them.<br><br>An important point is that you have to disable the default touch behaviour to show the tooltip manually, see [`ScatterTouchData.handleBuiltInTouches`](#scattertouchdata-read-about-touch-handling).|
|gridData|`FlGridData?`|`const FlGridData()`|Holds data to draw the grid lines behind the chart, see [`FlGridData`](base_chart.md#flgriddata).|
|borderData|`FlBorderData?`|`FlBorderData()`|Holds data to draw the border around the chart, see [`FlBorderData`](base_chart.md#flborderdata).|
|minX|`double?`||Minimum x value of the chart. If you don't provide it, it is calculated from the chart's data (providing it is more performant).|
|maxX|`double?`||Maximum x value of the chart. If you don't provide it, it is calculated from the chart's data (providing it is more performant).|
|baselineX|`double?`|`0`|The x value that the vertical grid lines and the titles are aligned to, they are drawn at every `baselineX + n * interval`.|
|minY|`double?`||Minimum y value of the chart. If you don't provide it, it is calculated from the chart's data (providing it is more performant).|
|maxY|`double?`||Maximum y value of the chart. If you don't provide it, it is calculated from the chart's data (providing it is more performant).|
|baselineY|`double?`|`0`|The y value that the horizontal grid lines and the titles are aligned to, they are drawn at every `baselineY + n * interval`.|
|clipData|`FlClipData?`|`const FlClipData.none()`|Clips the chart to its border (prevents drawing outside of the border), see [`FlClipData`](https://pub.dev/documentation/fl_chart/latest/fl_chart/FlClipData-class.html).|
|backgroundColor|`Color?`|`Colors.transparent`|A background color which is drawn behind the chart.|
|scatterLabelSettings|`ScatterLabelSettings?`|`ScatterLabelSettings()`|Shows a label on each spot, see [`ScatterLabelSettings`](#scatterlabelsettings).|
|rotationQuarterTurns|`int`|`0`|Rotates the chart 90 degrees (clockwise) in every quarter turn. It works like the [`RotatedBox`](https://api.flutter.dev/flutter/widgets/RotatedBox-class.html) widget.|
|errorIndicatorData|`FlErrorIndicatorData<ScatterChartSpotErrorRangeCallbackInput>`|`const FlErrorIndicatorData<ScatterChartSpotErrorRangeCallbackInput>()`|Holds data for showing error indicators on the `scatterSpots`|
<!-- /api -->

### ScatterSpot
<!-- api:ScatterSpot -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|x|`double`|required|The x value of the spot, on the horizontal axis (from left to right).|
|y|`double`|required|The y value of the spot, on the vertical axis (from bottom to top).|
|show|`bool?`|`true`|Determines show or hide the spot.|
|renderPriority|`int?`|`0`|Meant to determine which spots are drawn on top when they overlap.<br><br>Note that the chart doesn't use it yet: the spots are drawn in the order of [`ScatterChartData.scatterSpots`](#scatterchartdata) (the last one on top).|
|dotPainter|`FlDotPainter?`||Draws the spot, like a [`FlDotCirclePainter`](https://pub.dev/documentation/fl_chart/latest/fl_chart/FlDotCirclePainter-class.html) (the shape, size and color).<br><br>Defaults to a circle with a radius of 6, and a color of [`Colors.primaries`](https://api.flutter.dev/flutter/material/Colors-class.html) picked from the `x` and `y` of the spot.|
|xError|`FlErrorRange?`|`null`|The error range of the spot on the x axis, drawn by the `errorIndicatorData` of the chart, see [`FlErrorRange`](base_chart.md#flerrorrange).|
|yError|`FlErrorRange?`|`null`|The error range of the spot on the y axis, drawn by the `errorIndicatorData` of the chart, see [`FlErrorRange`](base_chart.md#flerrorrange).|
<!-- /api -->


### ScatterTouchData ([read about touch handling](handle_touches.md))
<!-- api:ScatterTouchData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|enabled|`bool?`|`true`|Determines whether to enable or disable touch behaviors.|
|touchCallback|`void Function(FlTouchEvent, ScatterTouchResponse?)?`|`null`|`touchCallback` notifies you about the happened touch/pointer events. It gives you a [`FlTouchEvent`](base_chart.md#fltouchevent) which is the happened event such as [`FlPointerHoverEvent`](https://pub.dev/documentation/fl_chart/latest/fl_chart/FlPointerHoverEvent-class.html), [`FlTapUpEvent`](https://pub.dev/documentation/fl_chart/latest/fl_chart/FlTapUpEvent-class.html), ... It also gives you a [`BaseTouchResponse`](https://pub.dev/documentation/fl_chart/latest/fl_chart/BaseTouchResponse-class.html) which is the chart specific type and contains information about the elements that has touched.|
|mouseCursorResolver|`MouseCursor Function(FlTouchEvent, ScatterTouchResponse?)?`|`null`|Using `mouseCursorResolver` you can change the mouse cursor based on the provided [`FlTouchEvent`](base_chart.md#fltouchevent) and [`BaseTouchResponse`](https://pub.dev/documentation/fl_chart/latest/fl_chart/BaseTouchResponse-class.html)|
|longPressDuration|`Duration?`|`null`|This property that allows to customize the duration of the longPress gesture. If null, it uses [kLongPressTimeout](https://api.flutter.dev/flutter/gestures/kLongPressTimeout-constant.html) (500 milliseconds).|
|touchTooltipData|`ScatterTouchTooltipData?`|`const ScatterTouchTooltipData()`|Determines how the tooltip looks on top of the touched spot, see [`ScatterTouchTooltipData`](#scattertouchtooltipdata).|
|touchSpotThreshold|`double?`|`0`|Extends the touchable area of each spot by this distance (in pixels).|
|handleBuiltInTouches|`bool?`|`true`|If true, the chart handles touches by itself: it shows a tooltip bubble on top of the touched spot.|
<!-- /api -->

### ScatterTouchTooltipData
<!-- api:ScatterTouchTooltipData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|tooltipBorderRadius|`BorderRadius?`|`BorderRadius.circular(4)`|Sets a rounded radius for the tooltip.|
|tooltipPadding|`EdgeInsets?`|`const EdgeInsets.symmetric(horizontal: 16, vertical: 8)`|Applies a padding for showing contents inside the tooltip.|
|tooltipHorizontalAlignment|`FLHorizontalAlignment?`|`FLHorizontalAlignment.center`|Controls showing tooltip on left side, right side or center aligned with spot.|
|tooltipHorizontalOffset|`double?`|`0`|Applies horizontal offset for showing tooltip.|
|maxContentWidth|`double?`|`120`|Maximum width of the tooltip's content, a text row which is wider than this breaks into a new line.|
|getTooltipItems|`ScatterTooltipItem? Function(ScatterSpot)?`|`defaultScatterTooltipItem`|Retrieves data for showing content inside the tooltip.|
|fitInsideHorizontally|`bool?`|`false`|Forces the tooltip to shift horizontally inside the chart, if overflow happens.|
|fitInsideVertically|`bool?`|`false`|Forces the tooltip to shift vertically inside the chart, if overflow happens.|
|rotateAngle|`double?`|`0.0`|Controls the rotation of the tooltip.|
|tooltipBorder|`BorderSide?`|`BorderSide.none`|Border of the tooltip bubble.|
|getTooltipColor|`Color Function(ScatterSpot)?`|`defaultScatterTooltipColor`|Retrieves the background color of the tooltip for each touched spot.|
<!-- /api -->

### ScatterTooltipItem
<!-- api:ScatterTooltipItem -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|text|`String`|required|Text of the tooltip.|
|textStyle|`TextStyle?`|`null`|[`TextStyle`](https://api.flutter.dev/flutter/painting/TextStyle-class.html) of the `text`.|
|bottomMargin|`double?`|`8`|The space between the tooltip and the top of the spot.|
|textAlign|`TextAlign?`|`TextAlign.center`|TextAlign of the showing content.|
|textDirection|`TextDirection?`|`TextDirection.ltr`|Direction of showing text.|
|children|`List<TextSpan>?`|`null`|Add further style and format to the text of the tooltip|
<!-- /api -->


### ScatterTouchResponse
###### You can listen to touch behaviors callback and retrieve this object when any touch action happens.
<!-- api:ScatterTouchResponse fields -->
|Property|Type|Description|
|:-------|:---|:----------|
|touchLocation|`Offset`|The location of the touch in pixels on the screen.|
|touchChartCoordinate|`Offset`|The axis coordinate of the touch in chart's coordinate system.|
|touchedSpot|`ScatterTouchedSpot?`|The touched spot, null if no spot is touched.|
<!-- /api -->

### ScatterTouchedSpot
<!-- api:ScatterTouchedSpot fields -->
|Property|Type|Description|
|:-------|:---|:----------|
|spot|`ScatterSpot`|Touch happened on this spot|
|spotIndex|`int`|Touch happened on this spot index|
<!-- /api -->

### ScatterLabelSettings
<!-- api:ScatterLabelSettings -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|showLabel|`bool?`|`false`|Determines whether to show or hide the labels.|
|getLabelTextStyleFunction|`TextStyle? Function(int, ScatterSpot)?`|`getDefaultLabelTextStyleFunction`|This function gives you the index value of the spot in the list and returns the text style.|
|getLabelFunction|`String Function(int, ScatterSpot)?`|`getDefaultLabelFunction`|This function gives you the index value of the spot in the list and returns the label.|
|textDirection|`TextDirection?`|`TextDirection.ltr`|Determines the direction of the text for the labels.|
<!-- /api -->

### some samples
----
##### Sample 1 ([Source Code](/example/lib/presentation/samples/scatter/scatter_chart_sample1.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/scatter_chart/scatter_chart_sample_1.gif" width="300" >


##### Sample 2 ([Source Code](/example/lib/presentation/samples/scatter/scatter_chart_sample2.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/scatter_chart/scatter_chart_sample_2.gif" width="300" >
