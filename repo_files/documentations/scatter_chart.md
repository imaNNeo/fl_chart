# ScatterChart

<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/scatter_chart/scatter_chart.png" width="300" >

### How to use
```dart
ScatterChart(
  ScatterChartData(
    // read about it in the below section
  ),
);
```

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
|touchTooltipData|a [ScatterTouchTooltipData](#ScatterTouchTooltipData), that determines how show the tooltip on top of touched spot (appearance of the showing tooltip bubble)|ScatterTouchTooltipData()|
|touchSpotThreshold|the threshold of the touch accuracy|10|
|handleBuiltInTouches| set this true if you want the built in touch handling (show a tooltip bubble and an indicator on touched spots) | true|
|touchCallback| listen to this callback to retrieve touch events, it gives you a [ScatterTouchResponse](#ScatterTouchResponse)| null|


### ScatterTouchTooltipData
|PropName|Description|default value|
|:-------|:----------|:------------|
|tooltipBgColor|background color of the tooltip bubble|Colors.white|
|tooltipRoundedRadius|background corner radius of the tooltip bubble|4|
|tooltipPadding|padding of the tooltip|EdgeInsets.symmetric(horizontal: 16, vertical: 8)|
|maxContentWidth|maximum width of the tooltip (if a text row is wider than this, then the text breaks to a new line|120|
|getTooltipItems|a callback that retrieve a [ScatterTooltipItem](#ScatterTooltipItem) by the given [ScatterSpot](#ScatterSpot) |defaultScatterTooltipItem|
|fitInsideHorizontally| forces tooltip to horizontally shift inside the chart's bounding box| false|
|fitInsideVertically| forces tooltip to vertically shift inside the chart's bounding box| false|

### ScatterTooltipItem
|PropName|Description|default value|
|:-------|:----------|:------------|
|text|text string of each row in the tooltip bubble|null|
|textStyle|[TextStyle](https://api.flutter.dev/flutter/dart-ui/TextStyle-class.html) of the showing text row|null|
|bottomMargin| bottom margin of the tooltip (to the top of most top spot) | radius / 2|


### ScatterTouchResponse
###### you can listen to touch behaviors callback and retrieve this object when any touch action happened.
|PropName|Description|default value|
|:-------|:----------|:------------|
|touchedSpot|touched [ScatterSpot](#ScatterSpot)|null|
|touchedSpotIndex|index of touched [ScatterSpot](#ScatterSpot)|null|
|touchInput|a [FlTouchInput](base_chart.md#FlTouchInput) that is the touch behaviour|null|


### some samples
----
##### Sample 1 ([Source Code](/example/lib/scatter_chart/samples/scatter_chart_sample1.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/scatter_chart/scatter_chart_sample_1.gif" width="300" >


##### Sample 2 ([Source Code](/example/lib/scatter_chart/samples/scatter_chart_sample2.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/scatter_chart/scatter_chart_sample_2.gif" width="300" >
