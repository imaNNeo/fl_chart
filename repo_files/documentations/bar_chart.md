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

### LineChartData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|barGroups| list of [BarChartGroupData ](#BarChartGroupData) to showing the bar lines together, you can provide one item per group to show normal bar chart|[]|
|alignment| a [BarChartAlignment](#BarChartAlignment) that determines alignment of the barGroups, inspired from [Flutter MainAxisAlignment](https://docs.flutter.io/flutter/rendering/MainAxisAlignment-class.html)| BarChartAlignment.spaceBetween|
|titlesData| check the [FlTitlesData](base_chart.md#FlTitlesData)|FlTitlesData()|


### BarChartGroupData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|x| x position of the group on horizontal axis|null|
|barRods| list of [BarChartRodData](#BarChartRodData) that they are a bar line| []
|barsSpace| space between barRods of the group|2|


### BarChartRodData
|PropName|Description|default value|
|:-------|:----------|:------------|
|y|endY position of the bar on vertical axis (height of the bar)|null|
|color|color of the bar rod|Colors.blueAccent|
|width|stroke width of the bar rod|8|
|isRound|determines that the bar lines is round or qubic |true|
|backDrawRodData|if provided, draw a rod on behind, check the [BackgroundBarChartRodData](#BackgroundBarChartRodData)|null|


### BackgroundBarChartRodData
|PropName|Description|default value|
|:-------|:----------|:------------|
|y|same as [BarChartRodData](#BarChartRodData)'s y|8|
|show|determines show or hide this section|false|
|color|same as [BarChartRodData](#BarChartRodData)'s color|Colors.blueGrey|

### some samples
----
##### Sample 1 ([Source Code](/example/lib/bar_chart/samples/bar_chart_sample1.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart_sample_1.png" width="300" >


##### Sample 2 ([Source Code](/example/lib/bar_chart/samples/bar_chart_sample2.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart_sample_2.png" width="300" >
