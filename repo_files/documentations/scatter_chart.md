# ScatterChart

<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/scatter_chart/scatter_chart.png" width="300" >

### How to use
```dart
ScatterChart(
  ScatterChartData(
    // read about it in the ScatterChartData section
  ),
  swapAnimationDuration: Duration(milliseconds: 150), // Optional
  swapAnimationCurve: Curves.linear, // Optional
);
```

### Implicit Animations
When you change the chart's state, it animates to the new state internally (using [implicit animations](https://flutter.dev/docs/development/ui/animations/implicit-animations)). You can control the animation [duration](https://api.flutter.dev/flutter/dart-core/Duration-class.html) and [curve](https://api.flutter.dev/flutter/animation/Curves-class.html) using optional `swapAnimationDuration` and `swapAnimationCurve` properties, respectively.

### ScatterChartData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|scatterSpots| list of [ScatterSpot ](#ScatterSpot ) to show the scatter spots on the chart|[]|
|titlesData| check the [FlTitlesData](base_chart.md#FlTitlesData)| FlTitlesData()|
|axisTitleData| check the [FlAxisTitleData](base_chart.md#FlAxisTitleData)| FlAxisTitleData()|
|scatterTouchData| [ScatterTouchData](#scattertouchdata-read-about-touch-handling) holds the touch interactivity details| ScatterTouchData()|
|showingTooltipIndicators| indices of showing tooltip|[]|



### ScatterSpot
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|show| determines to show or hide the spot|true|
|radius| radius of the showing spot| [8]
|color| colors of the spot|// a color based on the values|


### ScatterTouchData ([read about touch handling](handle_touches.md))
|PropName|Description|default value|
|:-------|:----------|:------------|
|enabled|determines to enable or disable touch behaviors|true|
|mouseCursorResolver|you can change the mouse cursor based on the provided [FlTouchEvent](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/base_chart.md#fltouchevent) and [ScatterTouchResponse](#ScatterTouchResponse)|MouseCursor.defer|
|touchTooltipData|a [ScatterTouchTooltipData](#ScatterTouchTooltipData), that determines how show the tooltip on top of touched spot (appearance of the showing tooltip bubble)|ScatterTouchTooltipData()|
|touchSpotThreshold|the threshold of the touch accuracy|0|
|handleBuiltInTouches| set this true if you want the built in touch handling (show a tooltip bubble and an indicator on touched spots) | true|
|touchCallback| listen to this callback to retrieve touch/pointer events and responses, it gives you a [FlTouchEvent](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/base_chart.md#fltouchevent) and [ScatterTouchResponse](#ScatterTouchResponse)| null|
|longPressDuration| allows to customize the duration of the longPress gesture. If null, the duration of the longPressGesture is [kLongPressTimeout](https://api.flutter.dev/flutter/gestures/kLongPressTimeout-constant.html)| null|

### ScatterTouchTooltipData
|PropName|Description|default value|
|:-------|:----------|:------------|
|tooltipBorder|border of the tooltip bubble|BorderSide.none|
|tooltipRoundedRadius|background corner radius of the tooltip bubble|4|
|tooltipPadding|padding of the tooltip|EdgeInsets.symmetric(horizontal: 16, vertical: 8)|
|tooltipHorizontalAlignment|horizontal alginment of tooltip relative to the spot|FLHorizontalAlignment.center|
|tooltipHorizontalOffset|horizontal offset of tooltip|0|
|maxContentWidth|maximum width of the tooltip (if a text row is wider than this, then the text breaks to a new line|120|
|getTooltipItems|a callback that retrieve a [ScatterTooltipItem](#ScatterTooltipItem) by the given [ScatterSpot](#ScatterSpot) |defaultScatterTooltipItem|
|fitInsideHorizontally| forces tooltip to horizontally shift inside the chart's bounding box| false|
|fitInsideVertically| forces tooltip to vertically shift inside the chart's bounding box| false|
|getTooltipColor|a callback that retrieves the Color for each touched spots separately from the given [ScatterSpot](#ScatterSpot) to set the background color of the tooltip bubble|Colors.blueGrey.darken(15)| 

### ScatterTooltipItem
|PropName|Description|default value|
|:-------|:----------|:------------|
|text|text string of each row in the tooltip bubble|null|
|textStyle|[TextStyle](https://api.flutter.dev/flutter/dart-ui/TextStyle-class.html) of the showing text row|null|
|textDirection|[TextDirection](https://api.flutter.dev/flutter/dart-ui/TextDirection-class.html) of the showing text row|TextDirection.ltr|
|bottomMargin| bottom margin of the tooltip (to the top of most top spot) | 0|
|children|[List<TextSpan>](https://api.flutter.dev/flutter/painting/InlineSpan-class.html) pass additional InlineSpan children for a more advance tooltip|null|


### ScatterTouchResponse
###### you can listen to touch behaviors callback and retrieve this object when any touch action happened.
|PropName|Description|default value|
|:-------|:----------|:------------|
|touchedSpot|Instance of [ScatterTouchedSpot](#ScatterTouchedSpot) which holds data about the touched section|null|

### ScatterTouchedSpot
|PropName|Description|default value|
|:-------|:----------|:------------|
|spot|touched [ScatterSpot](#ScatterSpot)|null|
|spotIndex|index of touched [ScatterSpot](#ScatterSpot)|null|

### ScatterLabelSettings
|PropName|Description|default value|
|:-------|:----------|:------------|
|showLabel|Determines whether to show or hide the labels.|false|
|getLabelTextStyleFunction|This function gives you the index value of the spot in the list and returns the text style.|null|
|getLabelFunction|This function gives you the index value of the spot in the list and returns the label.|spot.radius.toString()|
|textDirection|Determines the direction of the text for the labels.|TextDirection.ltr|

### some samples
----
##### Sample 1 ([Source Code](/example/lib/presentation/samples/scatter/scatter_chart_sample1.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/scatter_chart/scatter_chart_sample_1.gif" width="300" >


##### Sample 2 ([Source Code](/example/lib/presentation/samples/scatter/scatter_chart_sample2.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/scatter_chart/scatter_chart_sample_2.gif" width="300" >
