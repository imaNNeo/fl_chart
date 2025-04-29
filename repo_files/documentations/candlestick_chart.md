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
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|candlestickSpots| Holds the data for the candlestick chart, which is a list of [CandlestickSpot](#CandlestickSpot) objects. Each [CandlestickSpot](#CandlestickSpot) represents a single data point in the chart.|[]|
|candlestickPainter| It is a painter that is used to draw each individual candlestick. You can use this to customize the appearance of the candlesticks (Or you can implement your own painter).|DefaultCandlestickPainter()|
|titlesData| check the [FlAxisTitleData](base_chart.md#FlAxisTitleData)| FlAxisTitleData()|
|candlestickTouchData| [CandlestickTouchData](#CandlestickTouchData) holds the touch interactivity details| CandlestickTouchData()|
|showingTooltipIndicators| indices of showing tooltip, The point is that you need to disable touches to show these tooltips manually|[]|
|gridData|check the [FlGridData](base_chart.md#FlGridData)|FlGridData()|
|borderData|check the [FlBorderData](base_chart.md#FlBorderData)|FlBorderData()|
|minX|gets minimum x of x axis, if null, value will read from the input lineBars (But it is more performant if you provide them)|null|
|maxX|gets maximum x of x axis, if null, value will read from the input lineBars (But it is more performant if you provide them)| null|
|baselineX|defines the baseline of x-axis | 0|
|minY|gets minimum y of y axis, if null, value will read from the input lineBars (But it is more performant if you provide them)| null|
|maxY|gets maximum y of y axis, if null, value will read from the input lineBars (But it is more performant if you provide them)| null|
|baselineY|defines the baseline of y-axis | 0|
|rangeAnnotations|show range annotations behind the chart, check [RangeAnnotations](base_chart.md#RangeAnnotations) | RangeAnnotations()|
|clipData|clip the chart to the border (prevent drawing outside the border) | FlClipData.none()|
|backgroundColor|a background color which is drawn behind th chart| null |
|rotationQuarterTurns|Rotates the chart 90 degrees (clockwise) in every quarter turns. This feature works like the [RotatedBox](https://api.flutter.dev/flutter/widgets/RotatedBox-class.html) widget|0|
|touchedPointIndicator|Shows the touched point in the chart, by default it shows a horizontal and vertical line exactly on the touched candle. If the `handleBuiltInTouches` is true in [CandlestickTouchData](#CandlestickTouchData), this parameter is used under the hood to highlight the selected point. But you can disable the `handleBuiltInTouches` and implement your own way to highlight the point. Look at [AxisSpotIndicator](base_chart.md#AxisSpotIndicator) for more information |null|

### CandlestickSpot
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|open| The open value of the candlestick (based on the [OHLC standard](https://en.wikipedia.org/wiki/Open-high-low-close_chart)|required|
|high| The high value of the candlestick (based on the [OHLC standard](https://en.wikipedia.org/wiki/Open-high-low-close_chart))|required|
|low| The low value of the candlestick (based on the [OHLC standard](https://en.wikipedia.org/wiki/Open-high-low-close_chart))|required|
|close| The close value of the candlestick (based on the [OHLC standard](https://en.wikipedia.org/wiki/Open-high-low-close_chart))|required|
|show| Determines to show or hide this individual candlestick|true|


### CandlestickTouchData ([read about touch handling](handle_touches.md))
|PropName|Description|default value|
|:-------|:----------|:------------|
|enabled|determines to enable or disable touch behaviors|true|
|touchCallback| listen to this callback to retrieve touch/pointer events and responses, it gives you a [FlTouchEvent](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/base_chart.md#fltouchevent) and [CandlestickTouchResponse](#CandlestickTouchResponse)| null|
|mouseCursorResolver|you can change the mouse cursor based on the provided [FlTouchEvent](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/base_chart.md#fltouchevent) and [CandlestickTouchResponse](#CandlestickTouchResponse)|MouseCursor.defer|
|touchTooltipData|a [CandlestickTouchTooltipData](#CandlestickTouchTooltipData), that determines how show the tooltip on top of touched spot (appearance of the showing tooltip bubble)|CandlestickTouchTooltipData()|
|touchSpotThreshold|the threshold of the touch accuracy|4|
|handleBuiltInTouches| set this true if you want the built in touch handling (show a tooltip bubble and an indicator on touched/hovered spots) | true|
|longPressDuration| allows to customize the duration of the longPress gesture. If null, the duration of the longPressGesture is [kLongPressTimeout](https://api.flutter.dev/flutter/gestures/kLongPressTimeout-constant.html)| null|

### CandlestickTouchTooltipData
|PropName|Description|default value|
|:-------|:----------|:------------|
|tooltipBorder|border of the tooltip bubble|BorderSide.none|
|tooltipBorderRadius|background corner radius of the tooltip bubble|BorderRadius.circular(4)|
|tooltipPadding|padding of the tooltip|EdgeInsets.symmetric(horizontal: 16, vertical: 8)|
|tooltipHorizontalAlignment|horizontal alginment of tooltip relative to the spot|FLHorizontalAlignment.center|
|tooltipHorizontalOffset|horizontal offset of tooltip|0|
|maxContentWidth|maximum width of the tooltip (if a text row is wider than this, then the text breaks to a new line|120|
|getTooltipItems|a callback that retrieve a [CandlestickTooltipItem](#CandlestickTooltipItem) by the given [CandlestickSpot](#CandlestickSpot) |defaultCandlestickTooltipItem|
|fitInsideHorizontally| forces tooltip to horizontally shift inside the chart's bounding box| false|
|fitInsideVertically| forces tooltip to vertically shift inside the chart's bounding box| false|
|showOnTopOfTheChartBoxArea| forces the tooltip container to top of the line| false|
|getTooltipColor|a callback that retrieves the Color for each touched spots separately from the given [CandlestickSpot](#CandlestickSpot) to set the background color of the tooltip bubble|Colors.blueGrey.darken(80)|

### CandlestickTooltipItem
|PropName|Description|default value|
|:-------|:----------|:------------|
|text|text string of each row in the tooltip bubble|null|
|textStyle|[TextStyle](https://api.flutter.dev/flutter/dart-ui/TextStyle-class.html) of the showing text row|null|
|textDirection|[TextDirection](https://api.flutter.dev/flutter/dart-ui/TextDirection-class.html) of the showing text row|TextDirection.ltr|
|bottomMargin| bottom margin of the tooltip (to the top of most top spot) | 0|
|children|[List<TextSpan>](https://api.flutter.dev/flutter/painting/InlineSpan-class.html) pass additional InlineSpan children for a more advance tooltip|null|


### CandlestickTouchResponse
###### you can listen to touch behaviors callback and retrieve this object when any touch action happened.
|PropName|Description|default value|
|:-------|:----------|:------------|
|touchLocation|the location of the touch event in the device pixels coordinates|required|
|touchChartCoordinate|the location of the touch event in the chart coordinates|required|
|touchedSpot|Instance of [CandlestickTouchedSpot](#CandlestickTouchedSpot) which holds data about the touched spot|null|

### CandlestickTouchedSpot
|PropName|Description|default value|
|:-------|:----------|:------------|
|spot|touched [CandlestickSpot](#CandlestickSpot)|null|
|spotIndex|index of touched [CandlestickSpot](#CandlestickSpot)|null|

### some samples
----
##### Sample 1 ([Source Code](/example/lib/presentation/samples/candlestick/candlestick_chart_sample1.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/candlestick_chart/candlestick_chart_sample_1.gif" width="300" >
