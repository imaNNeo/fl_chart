<a href="https://www.youtube.com/watch?v=VlXC-RAaX4Y&list=PL1-_rCwRcnbNpvodmbt43O81wMUdBv8-a"><img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/pie_chart/pie_chart_video_thumbnail.png" width=540></a>

### How to use
```dart
PieChart(
  PieChartData(
    // read about it in the PieChartData section
  ),
  duration: Duration(milliseconds: 150), // Optional
  curve: Curves.linear, // Optional
);
```

**If you have a padding widget around the PieChart, make sure to set `PieChartData.centerSpaceRadius` to `double.infinity`**


### Implicit Animations
When you change the chart's state, it animates to the new state internally (using [implicit animations](https://flutter.dev/docs/development/ui/animations/implicit-animations)). You can control the animation [duration](https://api.flutter.dev/flutter/dart-core/Duration-class.html) and [curve](https://api.flutter.dev/flutter/animation/Curves-class.html) using optional `duration` and `curve` properties, respectively.

### PieChartData
<!-- api:PieChartData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|sections|`List<PieChartSectionData>?`|`const []`|Defines showing sections of the [`PieChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/PieChart-class.html).|
|centerSpaceRadius|`double?`|`double.infinity`|Radius of free space in center of the circle.<br><br>If it's not finite (like [`double.infinity`](https://api.flutter.dev/flutter/dart-core/double-class.html)), it is calculated from the size of the chart.|
|centerSpaceColor|`Color?`|`Colors.transparent`|Color of free space in center of the circle.|
|sectionsSpace|`double?`|`2`|Defines gap between sections.<br><br>Does not work on html-renderer, https://github.com/imaNNeo/fl_chart/issues/955|
|startDegreeOffset|`double?`|`0`|[`PieChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/PieChart-class.html) draws `sections` from zero degree (right side of the circle) clockwise.|
|pieTouchData|`PieTouchData?`|`PieTouchData()`|Handles touch behaviors and responses.|
|borderData|`FlBorderData?`|`FlBorderData(show: false)`|Holds data to draw the border around the chart, see [`FlBorderData`](base_chart.md#flborderdata).|
|titleSunbeamLayout|`bool?`|`false`|Whether to rotate the titles on each section of the chart|
<!-- /api -->


### PieChartSectionData
<!-- api:PieChartSectionData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|value|`double?`|`10`|It determines how much space it should occupy around the circle.<br><br>This is depends on sum of all sections, each section should occupy (`value` / sumValues) * 360 degrees.<br><br>value can not be null.|
|color|`Color?`|`Colors.cyan`|Defines the color of section.|
|gradient|`Gradient?`|`null`|Defines the gradient of section. If specified, overrides the color setting.|
|radius|`double?`|`40`|Defines the radius of section.|
|showTitle|`bool?`|`true`|Defines show or hide the title of section.|
|titleStyle|`TextStyle?`|`null`|Defines style of showing title of section, merged with the text style of the theme.|
|title|`String?`||Defines text of showing title at the middle of section.<br><br>Defaults to the `value` of the section, if it is provided.|
|borderSide|`BorderSide?`|`const BorderSide(width: 0)`|Defines border stroke around the section|
|cornerRadius|`double?`|`0.0`|Defines corner radius for rounded edges (applies to all corners)|
|badgeWidget|`Widget?`|`null`|Defines a widget that represents the section.<br><br>This can be anything from a text, an image, an animation, and even a combination of widgets. Use AnimatedWidgets to animate this widget.|
|titlePositionPercentageOffset|`double?`|`0.5`|Defines position of showing title in the section.<br><br>It should be between 0.0 to 1.0, 0.0 means near the center, 1.0 means near the outside of the [`PieChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/PieChart-class.html).|
|badgePositionPercentageOffset|`double?`|`0.5`|Defines position of badge widget in the section.<br><br>It should be between 0.0 to 1.0, 0.0 means near the center, 1.0 means near the outside of the [`PieChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/PieChart-class.html).|
|segments|`List<PieChartStackSegmentData>?`|`const []`|Stacked segments rendered on top of the main section.<br><br>Each segment defines [`PieChartStackSegmentData.fromRadius`](#piechartstacksegmentdata) and [`PieChartStackSegmentData.toRadius`](#piechartstacksegmentdata) to specify its position within the section's `radius`. Values are clamped to [0, radius] at render time.|
<!-- /api -->


### PieChartStackSegmentData
<!-- api:PieChartStackSegmentData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|fromRadius|`double?`|`0`|The start radius of this segment (distance from center of the section). Clamped to [0, sectionRadius] at render time.|
|toRadius|`double`|required|The end radius of this segment (distance from center of the section). Clamped to [0, sectionRadius] at render time.|
|color|`Color?`|`Colors.purple`|Defines the color of segment.|
|gradient|`Gradient?`|`null`|Defines the gradient of segment. If specified, overrides the color setting.|
<!-- /api -->


### PieTouchData ([read about touch handling](handle_touches.md))
<!-- api:PieTouchData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|enabled|`bool?`|`true`|Determines whether to enable or disable touch behaviors.|
|touchCallback|`void Function(FlTouchEvent, PieTouchResponse?)?`|`null`|`touchCallback` notifies you about the happened touch/pointer events. It gives you a [`FlTouchEvent`](base_chart.md#fltouchevent) which is the happened event such as [`FlPointerHoverEvent`](https://pub.dev/documentation/fl_chart/latest/fl_chart/FlPointerHoverEvent-class.html), [`FlTapUpEvent`](https://pub.dev/documentation/fl_chart/latest/fl_chart/FlTapUpEvent-class.html), ... It also gives you a [`BaseTouchResponse`](https://pub.dev/documentation/fl_chart/latest/fl_chart/BaseTouchResponse-class.html) which is the chart specific type and contains information about the elements that has touched.|
|mouseCursorResolver|`MouseCursor Function(FlTouchEvent, PieTouchResponse?)?`|`null`|Using `mouseCursorResolver` you can change the mouse cursor based on the provided [`FlTouchEvent`](base_chart.md#fltouchevent) and [`BaseTouchResponse`](https://pub.dev/documentation/fl_chart/latest/fl_chart/BaseTouchResponse-class.html)|
|longPressDuration|`Duration?`|`null`|This property that allows to customize the duration of the longPress gesture. If null, it uses [kLongPressTimeout](https://api.flutter.dev/flutter/gestures/kLongPressTimeout-constant.html) (500 milliseconds).|
<!-- /api -->

### PieTouchResponse
<!-- api:PieTouchResponse fields -->
|Property|Type|Description|
|:-------|:---|:----------|
|touchLocation|`Offset`|The location of the touch in pixels on the screen.|
|touchedSection|`PieTouchedSection?`|Contains information about touched section, like index, angle, radius, ...|
<!-- /api -->

### PieTouchedSection
<!-- api:PieTouchedSection fields -->
|Property|Type|Description|
|:-------|:---|:----------|
|touchedSection|`PieChartSectionData?`|The touched section, null if no section is touched.|
|touchedSectionIndex|`int`|The index of `touchedSection` in [`PieChartData.sections`](#piechartdata), -1 if no section is touched.|
|touchAngle|`double`|The angle of the touch around the center of the [`PieChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/PieChart-class.html), in degrees.|
|touchRadius|`double`|The distance of the touch from the center of the [`PieChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/PieChart-class.html).|
<!-- /api -->

### some samples
----
##### Sample 1 ([Source Code](/example/lib/presentation/samples/pie/pie_chart_sample1.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/pie_chart/pie_chart_sample_1.gif" width="300" >


##### Sample 2 ([Source Code](/example/lib/presentation/samples/pie/pie_chart_sample2.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/pie_chart/pie_chart_sample_2.gif" width="300" >


##### Sample 3 ([Source Code](/example/lib/presentation/samples/pie/pie_chart_sample3.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/pie_chart/pie_chart_sample_3.gif" width="300" >
