# RadarChart
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/radar_chart/radar_chart_sample_1.jpg" width="300" >

### How to use
```dart
RadarChart(
  RadarChartData(
    // read about it in the RadarChartData section
  ),
  swapAnimationDuration: Duration(milliseconds: 150), // Optional
  swapAnimationCurve: Curves.linear, // Optional
);
```

### Implicit Animations
When you change the chart's state, it animates to the new state internally (using [implicit animations](https://flutter.dev/docs/development/ui/animations/implicit-animations)). You can control the animation [duration](https://api.flutter.dev/flutter/dart-core/Duration-class.html) and [curve](https://api.flutter.dev/flutter/animation/Curves-class.html) using optional `swapAnimationDuration` and `swapAnimationCurve` properties, respectively.


### RadarChartData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|dataSets| list of [RadarDataSet ](#RadarDataSet) that is shown on the radar chart|[]|
|radarBackgroundColor| This property fills the background of the radar with the specified color.| Colors.transparent|
|radarShape| the shape of the border and background |RadarShape.circle|
|radarBorderData| shows a border for radar chart|BorderSide(color: Colors.black, width: 2)|
|getTitle| This function helps the radar chart to draw titles outside the chart. The default angle provided when called is making the title tangent to the radar chart. |null|
|titleTextStyle|TextStyle of the titles|TextStyle(color: Colors.black, fontSize: 12)|
|titlePositionPercentageOffset|this field is the place of showing title on the RadarChart. The higher the value of this field, the more titles move away from the chart. this field should be between 0 and 1.|0.2|
|tickCount|Defines the number of ticks that should be paint in RadarChart|1|
|ticksTextStyle|TextStyle of the tick titles|TextStyle(fontSize: 10, color: Colors.black)|
|tickBorderData|Style of the tick borders|BorderSide(color: Colors.black, width: 2)|
|gridBorderData|Style of the grid borders|BorderSide(color: Colors.black, width: 2)|
|radarTouchData|[RadarTouchData](#radartouchdata-read-about-touch-handling) handles the touch behaviors and responses.|RadarTouchData()|

### RadarDataSet
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|dataEntries|Each RadarDataSet contains list of [RadarEntries ](#RadarEntry) that is shown in RadarChart.|[]|
|fillColor|fills the DataSet with the specified color.|Colors.black12|
|borderColor|Paint the DataSet border with the specified color.|Colors.blueAccent|
|borderWidth|defines the width of [RadarDataSet](#RadarDataSet) border.|2.0|
|entryRadius|defines the radius of each [RadarEntries ](#RadarEntry).|5.0|

### RadarEntry
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|value| RadarChart uses this field to render every point in chart.| null |

### RadarTouchData ([read about touch handling](handle_touches.md))
|PropName|Description|default value|
|:-------|:----------|:------------|
|enabled|determines to enable or disable touch behaviors|true|
|mouseCursorResolver|you can change the mouse cursor based on the provided [FlTouchEvent](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/base_chart.md#fltouchevent) and [RadarTouchResponse](#RadarTouchResponse)|MouseCursor.defer|
|touchCallback| listen to this callback to retrieve touch/pointer events and responses, it gives you a [FlTouchEvent](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/base_chart.md#fltouchevent) and [RadarTouchResponse](#RadarTouchResponse)| null|
|longPressDuration| allows to customize the duration of the longPress gesture. If null, the duration of the longPressGesture is [kLongPressTimeout](https://api.flutter.dev/flutter/gestures/kLongPressTimeout-constant.html)| null|
|touchSpotThreshold|the threshold of the touch accuracy. we find the nearest spots on touched position based on this field.|10|


### RadarTouchResponse
|PropName|Description|default value|
|:-------|:----------|:------------|
|touchedSpot|the [RadarTouchedSpot](#RadarTouchedSpot) that user touched| null |

### RadarTouchedSpot
|PropName|Description|default value|
|:-------|:----------|:------------|
|touchedDataSet|the [RadarDataSet](#RadarDataSet) that user touched| null |
|touchedDataSetIndex| index of the [RadarDataSet](#RadarDataSet) that user touched| null |
|touchedRadarEntry|the [RadarEntry](#RadarEntry) that user touched| null |
|touchedRadarEntryIndex| index of the [RadarEntry](#RadarEntry) that user touched| null |

### RadarChartTitle
|PropName|Description|default value|
|:-------|:----------|:------------|
|text|the text of the title|required|
|angle|the angle used to rotate the title (in degree)|0|
|positionPercentageOffset|this field is the place of showing title. The higher the value of this field, the more titles move away from the chart. this field should be between 0 and 1|null|

### some samples
----
##### Sample 1 ([Source Code](/example/lib/presentation/samples/radar/radar_chart_sample1.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/radar_chart/radar_chart_sample_1.jpg" width="300" >
