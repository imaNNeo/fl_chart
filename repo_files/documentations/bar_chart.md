# BarChart

<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart.jpg" width="300" >

### How to use
```
FlChart(
   chart: BarChart(
      BarChartData(
         // read about it in the below section
      ),
   ),
);
```

### BarChartData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|barGroups| list of [BarChartGroupData ](#BarChartGroupData) to show the bar lines together, you can provide one item per group to show normal bar chart|[]|
|alignment| a [BarChartAlignment](#BarChartAlignment) that determines the alignment of the barGroups, inspired by [Flutter MainAxisAlignment](https://docs.flutter.io/flutter/rendering/MainAxisAlignment-class.html)| BarChartAlignment.spaceBetween|
|titlesData| check the [FlTitlesData](base_chart.md#FlTitlesData)|FlTitlesData()|
|backgroundColor| a background color which is drawn behind th chart| null |
|barTouchData| [BarTouchData](#BarTouchData) holds the touch interactivity details|BarTouchData()|
|gridData| check the [FlGridData](base_chart.md#FlGridData)|FlGridData()|
|borderData| check the [FlBorderData](base_chart.md#FlBorderData)|FlBorderData()|
|maxY| gets maximum y of y axis, if null, value will read from the input barGroups | null|


### BarChartGroupData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|x| x position of the group on horizontal axis|null|
|barRods| list of [BarChartRodData](#BarChartRodData) that are a bar line| []
|barsSpace| the space between barRods of the group|2|


### BarChartAlignment
enum values {`start`, `end`, `center`, `spaceEvenly`, `spaceAround`, `spaceBetween`}


### BarChartRodData
|PropName|Description|default value|
|:-------|:----------|:------------|
|y|endY position of the bar on vertical axis (height of the bar)|null|
|color|colors the bar rod|Colors.blueAccent|
|width|stroke width of the bar rod|8|
|isRound|determines that the bar lines is round or qubic |true|
|backDrawRodData|if provided, draws a rod in the background of the line bar, check the [BackgroundBarChartRodData](#BackgroundBarChartRodData)|null|


### BackgroundBarChartRodData
|PropName|Description|default value|
|:-------|:----------|:------------|
|y|same as [BarChartRodData](#BarChartRodData)'s y|8|
|show|determines to show or hide this section|false|
|color|same as [BarChartRodData](#BarChartRodData)'s color|Colors.blueGrey|

### BarTouchData ([read about touch handling](handle_touches.md))
|PropName|Description|default value|
|:-------|:----------|:------------|
|enabled|determines to enable or disable touch behaviors|true|
|touchTooltipData|a [TouchTooltipData](base_chart.md#TouchTooltipData), that determines how show the tooltip on top of touched spots (appearance of the showing tooltip bubble)|TouchTooltipData()|
|touchExtraThreshold|an [EdgeInsets](https://api.flutter.dev/flutter/painting/EdgeInsets-class.html) class to hold a bounding threshold of touch accuracy|EdgeInsets.all(4)|
|allowTouchBarBackDraw| if sets true, touch works on backdraw bar line| false |
|touchResponseSink| a [StreamSink](https://api.flutter.dev/flutter/dart-async/StreamSink-class.html)<[BarTouchResponse](#BarTouchResponse)> to broadcast the touch response (with useful data) when touched on the chart| null|


### BarTouchResponse
|PropName|Description|default value|
|:-------|:----------|:------------|
|spot|a [BarTouchedSpot](#BarTouchedSpot) class to hold data about touched spot| null |
|touchInput|a [FlTouchInput](base_chart.md#FlTouchInput) that is the touch behaviour|null|


### BarTouchedSpot
|PropName|Description|default value|
|:-------|:----------|:------------|
|touchedBarGroup|the [BarChartGroupData](#BarChartGroupData) that user touched it's rod's spot| null |
|touchedRodData|the [BarChartRodData](#BarChartRodData) that user touched it's spot|null|


### some samples
----
##### Sample 1 ([Source Code](/example/lib/bar_chart/samples/bar_chart_sample1.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart_sample_1.gif" width="300" >


##### Sample 2 ([Source Code](/example/lib/bar_chart/samples/bar_chart_sample2.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart_sample_2.gif" width="300" >
