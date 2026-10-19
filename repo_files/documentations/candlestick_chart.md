# CandlestickChart

<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/candlestick_chart/candlestick_chart_sample_1.gif" width="300" >

### How to use
```dart
CandlestickChart(
	CandlestickChartData(
    // read about it in the CandlestickChartData section
  ),
  duration: Duration(milliseconds: 150), // Optional
  curve: Curves.linear, // Optional
);
```

### Implicit Animations
When you change the chart's state, it animates to the new state internally (using [implicit animations](https://flutter.dev/docs/development/ui/animations/implicit-animations)). You can control the animation [duration](https://api.flutter.dev/flutter/dart-core/Duration-class.html) and [curve](https://api.flutter.dev/flutter/animation/Curves-class.html) using optional `duration` and `curve` properties, respectively.

### CandlestickChartData
<!-- api:CandlestickChartData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|candlestickSpots|`List<CandlestickSpot>?`|`const []`|Contains the data for the candlestick chart.<br><br>Each [`CandlestickSpot`](#candlestickspot) represents a candlestick in the chart that contains [`CandlestickSpot.open`](#candlestickspot), [`CandlestickSpot.high`](#candlestickspot), [`CandlestickSpot.low`](#candlestickspot) and [`CandlestickSpot.close`](#candlestickspot) values.|
|candlestickPainter|`FlCandlestickPainter?`|`DefaultCandlestickPainter()`|The painter used to draw the candlestick. You can use the [`DefaultCandlestickPainter`](https://pub.dev/documentation/fl_chart/latest/fl_chart/DefaultCandlestickPainter-class.html) or implement your own.|
|titlesData|`FlTitlesData?`|`const FlTitlesData()`|Holds data to draw the titles around the chart, see [`FlTitlesData`](base_chart.md#fltitlesdata).|
|candlestickTouchData|`CandlestickTouchData?`|`CandlestickTouchData()`|Handles touch behaviors and responses.|
|showingTooltipIndicators|`List<int>?`|`const []`|you can show some tooltipIndicators (a popup with an information) on top of each [`CandlestickSpot`](#candlestickspot) using `showingTooltipIndicators`, just put indices you want to show it on top of them.<br><br>An important point is that you have to disable the default touch behaviour to show the tooltip manually, see [`CandlestickTouchData.handleBuiltInTouches`](#candlesticktouchdata-read-about-touch-handling).|
|gridData|`FlGridData?`|`const FlGridData()`|Holds data to draw the grid lines behind the chart, see [`FlGridData`](base_chart.md#flgriddata).|
|borderData|`FlBorderData?`|`FlBorderData()`|Holds data to draw the border around the chart, see [`FlBorderData`](base_chart.md#flborderdata).|
|minX|`double?`||Minimum x value of the chart. If you don't provide it, it is calculated from the chart's data (providing it is more performant).|
|maxX|`double?`||Maximum x value of the chart. If you don't provide it, it is calculated from the chart's data (providing it is more performant).|
|baselineX|`double?`|`0`|The x value that the vertical grid lines and the titles are aligned to, they are drawn at every `baselineX + n * interval`.|
|minY|`double?`||Minimum y value of the chart. If you don't provide it, it is calculated from the chart's data (providing it is more performant).|
|maxY|`double?`||Maximum y value of the chart. If you don't provide it, it is calculated from the chart's data (providing it is more performant).|
|baselineY|`double?`|`0`|The y value that the horizontal grid lines and the titles are aligned to, they are drawn at every `baselineY + n * interval`.|
|rangeAnnotations|`RangeAnnotations?`|`const RangeAnnotations()`|Highlights some horizontal or vertical ranges behind the chart, see [`RangeAnnotations`](base_chart.md#rangeannotations).|
|clipData|`FlClipData?`|`const FlClipData.none()`|Clips the chart to its border (prevents drawing outside of the border), see [`FlClipData`](https://pub.dev/documentation/fl_chart/latest/fl_chart/FlClipData-class.html).|
|backgroundColor|`Color?`|`Colors.transparent`|A background color which is drawn behind the chart.|
|rotationQuarterTurns|`int`|`0`|Rotates the chart 90 degrees (clockwise) in every quarter turn. It works like the [`RotatedBox`](https://api.flutter.dev/flutter/widgets/RotatedBox-class.html) widget.|
|touchedPointIndicator|`AxisSpotIndicator?`|`null`|Shows an indicator on the touched / hovered point<br><br>We manage to set it by default when [`CandlestickTouchData.handleBuiltInTouches`](#candlesticktouchdata-read-about-touch-handling) is true, so nothing happens if you change this property as long as the handleBuiltInTouches property is true.<br><br>But you can set [`CandlestickTouchData.handleBuiltInTouches`](#candlesticktouchdata-read-about-touch-handling) to false if you want to have customized `touchedPointIndicator`|
<!-- /api -->

### CandlestickSpot
<!-- api:CandlestickSpot -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|x|`double`|required|The x value of the spot, on the horizontal axis (from left to right).|
|open|`double`|required|The open value of the candlestick, see the [OHLC standard](https://en.wikipedia.org/wiki/Open-high-low-close_chart).|
|high|`double`|required|The highest value of the candlestick (the top of its wick).|
|low|`double`|required|The lowest value of the candlestick (the bottom of its wick).|
|close|`double`|required|The close value of the candlestick, see the [OHLC standard](https://en.wikipedia.org/wiki/Open-high-low-close_chart).|
|show|`bool?`|`true`|Determines show or hide the spot.|
<!-- /api -->


### CandlestickTouchData ([read about touch handling](handle_touches.md))
<!-- api:CandlestickTouchData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|enabled|`bool?`|`true`|Determines whether to enable or disable touch behaviors.|
|touchCallback|`void Function(FlTouchEvent, CandlestickTouchResponse?)?`|`null`|`touchCallback` notifies you about the happened touch/pointer events. It gives you a [`FlTouchEvent`](base_chart.md#fltouchevent) which is the happened event such as [`FlPointerHoverEvent`](https://pub.dev/documentation/fl_chart/latest/fl_chart/FlPointerHoverEvent-class.html), [`FlTapUpEvent`](https://pub.dev/documentation/fl_chart/latest/fl_chart/FlTapUpEvent-class.html), ... It also gives you a [`BaseTouchResponse`](https://pub.dev/documentation/fl_chart/latest/fl_chart/BaseTouchResponse-class.html) which is the chart specific type and contains information about the elements that has touched.|
|mouseCursorResolver|`MouseCursor Function(FlTouchEvent, CandlestickTouchResponse?)?`|`null`|Using `mouseCursorResolver` you can change the mouse cursor based on the provided [`FlTouchEvent`](base_chart.md#fltouchevent) and [`BaseTouchResponse`](https://pub.dev/documentation/fl_chart/latest/fl_chart/BaseTouchResponse-class.html)|
|longPressDuration|`Duration?`|`null`|This property that allows to customize the duration of the longPress gesture. If null, it uses [kLongPressTimeout](https://api.flutter.dev/flutter/gestures/kLongPressTimeout-constant.html) (500 milliseconds).|
|touchTooltipData|`CandlestickTouchTooltipData?`|`CandlestickTouchTooltipData()`|Determines how the tooltip looks on top of the touched candlestick, see [`CandlestickTouchTooltipData`](#candlesticktouchtooltipdata).|
|handleBuiltInTouches|`bool?`|`true`|If true, the chart handles touches by itself: it shows a tooltip bubble and an indicator on the touched (or hovered) candlestick.|
|touchSpotThreshold|`double?`|`4`|Extends the touchable area of each candlestick by this distance (in pixels).|
<!-- /api -->

### CandlestickTouchTooltipData
<!-- api:CandlestickTouchTooltipData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|tooltipBorderRadius|`BorderRadius?`|`BorderRadius.circular(4)`|Sets a border radius for the tooltip.|
|tooltipPadding|`EdgeInsets?`|`const EdgeInsets.symmetric(horizontal: 16, vertical: 8)`|Applies a padding for showing contents inside the tooltip.|
|tooltipHorizontalAlignment|`FLHorizontalAlignment?`|`FLHorizontalAlignment.center`|Controls showing tooltip on left side, right side or center aligned with spot.|
|tooltipHorizontalOffset|`double?`|`0`|Applies horizontal offset for showing tooltip.|
|maxContentWidth|`double?`|`120`|Maximum width of the tooltip's content, a text row which is wider than this breaks into a new line.|
|getTooltipItems|`CandlestickTooltipItem? Function(FlCandlestickPainter, CandlestickSpot, int)?`|`defaultCandlestickTooltipItem`|Retrieves data for showing content inside the tooltip.|
|fitInsideHorizontally|`bool?`|`false`|Forces the tooltip to shift horizontally inside the chart, if overflow happens.|
|fitInsideVertically|`bool?`|`false`|Forces the tooltip to shift vertically inside the chart, if overflow happens.|
|showOnTopOfTheChartBoxArea|`bool?`|`false`|Forces the tooltip container to top of the line, default 'false'|
|rotateAngle|`double?`|`0.0`|Controls the rotation of the tooltip.|
|tooltipBorder|`BorderSide?`|`BorderSide.none`|Border of the tooltip bubble.|
|getTooltipColor|`Color Function(CandlestickSpot)?`|`defaultCandlestickTooltipColor`|Retrieves the background color of the tooltip for each touched candlestick.|
<!-- /api -->

### CandlestickTooltipItem
<!-- api:CandlestickTooltipItem -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|text|`String`|required|Showing text.|
|textStyle|`TextStyle?`|`null`|Style of showing text.|
|bottomMargin|`double?`|`8`|Defines bottom space from spot.|
|textAlign|`TextAlign?`|`TextAlign.center`|TextAlign of the showing content.|
|textDirection|`TextDirection?`|`TextDirection.ltr`|Direction of showing text.|
|children|`List<TextSpan>?`|`null`|Add further style and format to the text of the tooltip|
<!-- /api -->


### CandlestickTouchResponse
###### you can listen to touch behaviors callback and retrieve this object when any touch action happened.
<!-- api:CandlestickTouchResponse fields -->
|Property|Type|Description|
|:-------|:---|:----------|
|touchLocation|`Offset`|The location of the touch in pixels on the screen.|
|touchChartCoordinate|`Offset`|The axis coordinate of the touch in chart's coordinate system.|
|touchedSpot|`CandlestickTouchedSpot?`|The touched spot, null if no candle is touched.|
<!-- /api -->

### CandlestickTouchedSpot
<!-- api:CandlestickTouchedSpot fields -->
|Property|Type|Description|
|:-------|:---|:----------|
|spot|`CandlestickSpot`|Touch happened on this spot|
|spotIndex|`int`|Touch happened on this spot index|
<!-- /api -->

### some samples
----
##### Sample 1 ([Source Code](/example/lib/presentation/samples/candlestick/candlestick_chart_sample1.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/candlestick_chart/candlestick_chart_sample_1.gif" width="300" >
