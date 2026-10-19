# RadarChart
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/radar_chart/radar_chart_sample_1.jpg" width="300" >

### How to use
```dart
RadarChart(
  RadarChartData(
    // read about it in the RadarChartData section
  ),
  duration: Duration(milliseconds: 150), // Optional
  curve: Curves.linear, // Optional
);
```

### Implicit Animations
When you change the chart's state, it animates to the new state internally (using [implicit animations](https://flutter.dev/docs/development/ui/animations/implicit-animations)). You can control the animation [duration](https://api.flutter.dev/flutter/dart-core/Duration-class.html) and [curve](https://api.flutter.dev/flutter/animation/Curves-class.html) using optional `duration` and `curve` properties, respectively.


### RadarChartData
<!-- api:RadarChartData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|dataSets|`List<RadarDataSet>?`|required|[`RadarChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/RadarChart-class.html) draw `dataSets` that each of them showing a list of [`RadarEntry`](#radarentry)|
|radarBackgroundColor|`Color?`|`Colors.transparent`|`radarBackgroundColor` draw the background color of the [`RadarChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/RadarChart-class.html)|
|radarBorderData|`BorderSide?`|`const BorderSide(width: 2)`|`radarBorderData` is used to draw [`RadarChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/RadarChart-class.html) border|
|radarShape|`RadarShape?`|`RadarShape.circle`|`radarShape` is used to draw [`RadarChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/RadarChart-class.html) border and background|
|getTitle|`RadarChartTitle Function(int, double)?`|`null`|`getTitle` is used to draw titles outside the [`RadarChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/RadarChart-class.html) `getTitle` is type of [`GetTitleByIndexFunction`](https://pub.dev/documentation/fl_chart/latest/fl_chart/GetTitleByIndexFunction.html) so you should return a valid [`RadarChartTitle`](#radarcharttitle) for each `index` (we provide a default `angle` = index * 360 / titleCount)<br><br><pre>getTitle: (index, angle) {<br>  switch (index) {<br>    case 0:<br>      return RadarChartTitle(text: 'Mobile or Tablet', angle: angle);<br>    case 2:<br>      return RadarChartTitle(text: 'Desktop', angle: angle);<br>    case 1:<br>      return RadarChartTitle(text: 'TV', angle: angle);<br>    default:<br>      return const RadarChartTitle(text: '');<br>  }<br>}</pre>|
|titleTextStyle|`TextStyle?`|`null`|Defines style of showing [`RadarChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/RadarChart-class.html) titles.|
|titlePositionPercentageOffset|`double?`|`0.2`|the `titlePositionPercentageOffset` is the place of showing title on the [`RadarChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/RadarChart-class.html) The higher the value of this field, the more titles move away from the chart. this field should be between 0 and 1, if it is 0 the title will be drawn near the inside section, if it is 1 the title will be drawn near the outside of section, the default value is 0.2.|
|tickCount|`int?`|`1`|Defines the number of ticks that should be paint in [`RadarChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/RadarChart-class.html) the default &amp; minimum value of this field is 1.|
|ticksTextStyle|`TextStyle?`|`null`|Defines style of showing [`RadarChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/RadarChart-class.html) tick titles.|
|tickBorderData|`BorderSide?`|`const BorderSide(width: 2)`|Defines style of showing [`RadarChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/RadarChart-class.html) tick borders.|
|gridBorderData|`BorderSide?`|`const BorderSide(width: 2)`|Defines style of showing [`RadarChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/RadarChart-class.html) grid borders.|
|radarTouchData|`RadarTouchData?`|`RadarTouchData()`|Handles touch behaviors and responses.|
|isMinValueAtCenter|`bool`|`false`|If `isMinValueAtCenter` is true, the minimum value of the [`RadarChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/RadarChart-class.html) will be at the center of the chart.|
|borderData|`FlBorderData?`|`FlBorderData()`|Holds data to draw the border around the chart, see [`FlBorderData`](base_chart.md#flborderdata).|
<!-- /api -->

### RadarDataSet
<!-- api:RadarDataSet -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|dataEntries|`List<RadarEntry>?`|`const []`|each section or dataSets consists of a set of `dataEntries`.|
|fillColor|`Color?`|`Colors.cyan`|defines the color that fills the [`RadarDataSet`](#radardataset).|
|fillGradient|`Gradient?`|`null`|defines the gradient that fills the [`RadarDataSet`](#radardataset), if provided it is used instead of `fillColor`.|
|borderColor|`Color?`|`Colors.cyan`|defines the border color of the [`RadarDataSet`](#radardataset).|
|borderWidth|`double?`|`2.0`|defines the width of [`RadarDataSet`](#radardataset) border. the default value of this field is 2.0|
|entryRadius|`double?`|`5.0`|defines the radius of each entry the default value of this field is 5.0|
<!-- /api -->

### RadarEntry
<!-- api:RadarEntry -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|value|`double`|required|[`RadarChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/RadarChart-class.html) uses this field to render every point in chart.|
<!-- /api -->

### RadarTouchData ([read about touch handling](handle_touches.md))
<!-- api:RadarTouchData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|enabled|`bool?`|`true`|Determines whether to enable or disable touch behaviors.|
|touchCallback|`void Function(FlTouchEvent, RadarTouchResponse?)?`|`null`|`touchCallback` notifies you about the happened touch/pointer events. It gives you a [`FlTouchEvent`](base_chart.md#fltouchevent) which is the happened event such as [`FlPointerHoverEvent`](https://pub.dev/documentation/fl_chart/latest/fl_chart/FlPointerHoverEvent-class.html), [`FlTapUpEvent`](https://pub.dev/documentation/fl_chart/latest/fl_chart/FlTapUpEvent-class.html), ... It also gives you a [`BaseTouchResponse`](https://pub.dev/documentation/fl_chart/latest/fl_chart/BaseTouchResponse-class.html) which is the chart specific type and contains information about the elements that has touched.|
|mouseCursorResolver|`MouseCursor Function(FlTouchEvent, RadarTouchResponse?)?`|`null`|Using `mouseCursorResolver` you can change the mouse cursor based on the provided [`FlTouchEvent`](base_chart.md#fltouchevent) and [`BaseTouchResponse`](https://pub.dev/documentation/fl_chart/latest/fl_chart/BaseTouchResponse-class.html)|
|longPressDuration|`Duration?`|`null`|This property that allows to customize the duration of the longPress gesture. If null, it uses [kLongPressTimeout](https://api.flutter.dev/flutter/gestures/kLongPressTimeout-constant.html) (500 milliseconds).|
|touchSpotThreshold|`double?`|`10`|we find the nearest spots on touched position based on this threshold|
<!-- /api -->


### RadarTouchResponse
<!-- api:RadarTouchResponse fields -->
|Property|Type|Description|
|:-------|:---|:----------|
|touchLocation|`Offset`|The location of the touch in pixels on the screen.|
|touchedSpot|`RadarTouchedSpot?`|touch happened on this spot. this spot has useful information about spot or entry|
<!-- /api -->

### RadarTouchedSpot
<!-- api:RadarTouchedSpot fields -->
Also has the properties of [`TouchedSpot`](base_chart.md#touchedspot).

|Property|Type|Description|
|:-------|:---|:----------|
|touchedDataSet|`RadarDataSet`|The [`RadarDataSet`](#radardataset) of the touched entry.|
|touchedDataSetIndex|`int`|The index of `touchedDataSet` in [`RadarChartData.dataSets`](#radarchartdata).|
|touchedRadarEntry|`RadarEntry`|The touched [`RadarEntry`](#radarentry).|
|touchedRadarEntryIndex|`int`|The index of `touchedRadarEntry` in [`RadarDataSet.dataEntries`](#radardataset).|
<!-- /api -->

### RadarChartTitle
<!-- api:RadarChartTitle -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|text|`String`|required|`text` is used to draw titles outside the [`RadarChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/RadarChart-class.html)|
|children|`List<InlineSpan>?`|`null`|Additional spans after `text`, to have texts with different styles (like the children of a [`TextSpan`](https://api.flutter.dev/flutter/painting/TextSpan-class.html)).|
|angle|`double`|`0`|Rotates the title (in degrees).|
|positionPercentageOffset|`double?`|`null`|`positionPercentageOffset` is the place of showing title on the [`RadarChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/RadarChart-class.html) The higher the value of this field, the more titles move away from the chart. The value of `positionPercentageOffset` takes precedence over the value of [`RadarChartData.titlePositionPercentageOffset`](#radarchartdata), even if it is set.|
<!-- /api -->

### some samples
----
##### Sample 1 ([Source Code](/example/lib/presentation/samples/radar/radar_chart_sample1.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/radar_chart/radar_chart_sample_1.jpg" width="300" >
