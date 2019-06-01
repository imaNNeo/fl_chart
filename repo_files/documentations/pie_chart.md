# PieChart

<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/pie_chart/pie_chart.jpg" width="300" >

### How to use
```
FlChartWidget(
      flChart: PieChart(
        PieChartData(
        	// read about it in the below section
        ),
      ),
    );
```

### PieChartData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|sections| list of [PieChartSectionData ](#PieChartSectionData) that will show on the pie chart|[]|
|centerSpaceRadius| free space on the middle of PieChart| 80|
|centerSpaceColor| color of the free space on the middle of PieChart|Colors.transparent|
|sectionsSpace| space between of sections (margin of them)|2|
|startDegreeOffset| degree offset of drawing sections around the pie chart, should be between 0 and 360|0|
|borderData| show a border around the chart, check the [FlBorderData](base_chart.md#FlBorderData)|FlBorderData()|


### PieChartSectionData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|value| value is the weight of each section, for example if all values is 25, and we have 4 section, then the sum is 100 and each section takes 1/4 of whole circle (360/4) degree|10|
|color| color of the drawing section| Colors.red
|radius| the width radius of each section|40|
|showTitle| determines to show or hide the titles on each section|true|
|titleStyle| TextStyle of showing titles| TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)|
|title| title of the section| "1"|
|titlePositionPercentageOffset|the place of showing title on the section, this field should be between 0 and 1|0.5|


### some samples
----
##### Sample 1 ([Source Code](/example/lib/pie_chart/samples/pie_chart_sample1.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/pie_chart/pie_chart_sample_1.png" width="300" >


##### Sample 2 ([Source Code](/example/lib/pie_chart/samples/pie_chart_sample2.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/pie_chart/pie_chart_sample_2.png" width="300" >
