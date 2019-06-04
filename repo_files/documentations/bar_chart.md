# BarChart

<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart.jpg" width="300" >

### How to use
```
FlChartWidget(
      flChart: BarChart(
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

### some samples
----
##### Sample 1 ([Source Code](/example/lib/bar_chart/samples/bar_chart_sample1.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart_sample_1.png" width="300" >


##### Sample 2 ([Source Code](/example/lib/bar_chart/samples/bar_chart_sample2.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart_sample_2.png" width="300" >
