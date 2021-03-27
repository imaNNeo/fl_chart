# PieChart

<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/pie_chart/pie_chart.jpg" width="300" >

### How to use
```dart
PieChart(
  PieChartData(
    // read about it in the PieChartData section
  ),
  swapAnimationDuration: Duration(milliseconds: 150), // Optional
  swapAnimationCurve: Curves.linear, // Optional
);
```

**If you have a padding widget around the PieChart, make sure to set `PieChartData.centerSpaceRadius` to `double.infinity`**


### Implicit Animations
When you change the chart's state, it animates to the new state internally (using [implicit animations](https://flutter.dev/docs/development/ui/animations/implicit-animations)). You can control the animation [duration](https://api.flutter.dev/flutter/dart-core/Duration-class.html) and [curve](https://api.flutter.dev/flutter/animation/Curves-class.html) using optional `swapAnimationDuration` and `swapAnimationCurve` properties, respectively.

### PieChartData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|sections| list of [PieChartSectionData ](#PieChartSectionData) that is shown on the pie chart|[]|
|centerSpaceRadius| free space in the middle of the PieChart, set `double.infinity` if you want it to be calculated according to the view size| double.nan|
|centerSpaceColor| colors the free space in the middle of the PieChart|Colors.transparent|
|sectionsSpace| space between the sections (margin of them), **Ignored on web**|2|
|startDegreeOffset| degree offset of the sections around the pie chart, should be between 0 and 360|0|
|pieTouchData| [PieTouchData](#PieTouchData) holds the touch interactivity details| PieTouchData()|
|borderData| shows a border around the chart, check the [FlBorderData](base_chart.md#FlBorderData)|FlBorderData()|


### PieChartSectionData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|value| value is the weight of each section, for example if all values is 25, and we have 4 section, then the sum is 100 and each section takes 1/4 of the whole circle (360/4) degree|10|
|color| colors the section| Colors.red
|radius| the width radius of each section|40|
|showTitle| determines to show or hide the titles on each section|true|
|titleStyle| TextStyle of the titles| TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)|
|title| title of the section| value|
|badgeWidget| badge component of the section| null|
|titlePositionPercentageOffset|the place of the title in the section, this field should be between 0 and 1|0.5|
|badgePositionPercentageOffset|the place of the badge component in the section, this field should be between 0 and 1|0.5|


### PieTouchData ([read about touch handling](handle_touches.md))
|PropName|Description|default value|
|:-------|:----------|:------------|
|enabled|determines to enable or disable touch behaviors|true|
|touchCallback| listen to this callback to retrieve touch events, it gives you a [PieTouchResponse](#PieTouchResponse)| null|

### PieTouchResponse
|PropName|Description|default value|
|:-------|:----------|:------------|
|touchedSection|Instance of [PieTouchedSection](#PieTouchedSection) which holds data about the touched section|null|
|touchInput|a [PointerEvent](https://api.flutter.dev/flutter/gestures/PointerEvent-class.html) that is the touch behaviour|null|
|clickHappened|If we detect a click event, this property is tru|false|

### PieTouchedSection
|PropName|Description|default value|
|:-------|:----------|:------------|
|touchedSection|the [PieChartSectionData](#PieChartSectionData) that user touched| null |
|touchedSectionIndex| index of the touched section | null|
|touchAngle|the angle of the touch|null|
|touchRadius| the radius of the touch|null|

### some samples
----
##### Sample 1 ([Source Code](/example/lib/pie_chart/samples/pie_chart_sample1.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/pie_chart/pie_chart_sample_1.gif" width="300" >


##### Sample 2 ([Source Code](/example/lib/pie_chart/samples/pie_chart_sample2.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/pie_chart/pie_chart_sample_2.gif" width="300" >


##### Sample 3 ([Source Code](/example/lib/pie_chart/samples/pie_chart_sample3.dart))
<img src="https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/pie_chart/pie_chart_sample_3.gif" width="300" >
