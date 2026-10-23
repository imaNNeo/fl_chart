<a href="https://www.youtube.com/watch?v=vYe0RY1nCAA&list=PL1-_rCwRcnbNpvodmbt43O81wMUdBv8-a"><img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/bar_chart/bar_chart_video_thumbnail.png" width=540></a>

### How to use
```dart
BarChart(
  BarChartData(
    // read about it in the BarChartData section
  ),
  duration: Duration(milliseconds: 150), // Optional
  curve: Curves.linear, // Optional
);
```

### Implicit Animations
When you change the chart's state, it animates to the new state internally (using [implicit animations](https://flutter.dev/docs/development/ui/animations/implicit-animations)). You can control the animation [duration](https://api.flutter.dev/flutter/dart-core/Duration-class.html) and [curve](https://api.flutter.dev/flutter/animation/Curves-class.html) using optional `duration` and `curve` properties, respectively.

### BarChartData
<!-- api:BarChartData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|barGroups|`List<BarChartGroupData>?`|`const []`|[`BarChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/BarChart-class.html) draws `barGroups` that each of them contains a list of [`BarChartRodData`](#barchartroddata).|
|groupsSpace|`double?`|`16`|Apply space between the `barGroups`.<br><br>It is used only when `alignment` is [`BarChartAlignment.start`](#barchartalignment), [`BarChartAlignment.center`](#barchartalignment) or [`BarChartAlignment.end`](#barchartalignment) (the other alignments spread the groups in the free space).|
|alignment|`BarChartAlignment?`|`BarChartAlignment.spaceEvenly`|Arrange the `barGroups`, see [`BarChartAlignment`](#barchartalignment).|
|titlesData|`FlTitlesData?`|`const FlTitlesData(topTitles: AxisTitles())`|Holds data to draw the titles around the chart, see [`FlTitlesData`](base_chart.md#fltitlesdata).|
|barTouchData|`BarTouchData?`|`const BarTouchData()`|Handles touch behaviors and responses.|
|maxY|`double?`||Maximum y value of the chart. If you don't provide it, it is calculated from the chart's data (providing it is more performant).|
|minY|`double?`||Minimum y value of the chart. If you don't provide it, it is calculated from the chart's data (providing it is more performant).|
|baselineY|`double?`|`0`|The y value that the horizontal grid lines and the titles are aligned to, they are drawn at every `baselineY + n * interval`.|
|gridData|`FlGridData?`|`const FlGridData()`|Holds data to draw the grid lines behind the chart, see [`FlGridData`](base_chart.md#flgriddata).|
|borderData|`FlBorderData?`|`FlBorderData()`|Holds data to draw the border around the chart, see [`FlBorderData`](base_chart.md#flborderdata).|
|rangeAnnotations|`RangeAnnotations?`|`const RangeAnnotations()`|Highlights some horizontal or vertical ranges behind the chart, see [`RangeAnnotations`](base_chart.md#rangeannotations).|
|backgroundColor|`Color?`|`Colors.transparent`|A background color which is drawn behind the chart.|
|extraLinesData|`ExtraLinesData?`|`const ExtraLinesData()`|Extra horizontal or vertical lines to draw on the chart, see [`ExtraLinesData`](base_chart.md#extralinesdata) (the bar chart only draws the horizontal ones).|
|rotationQuarterTurns|`int`|`0`|Rotates the chart 90 degrees (clockwise) in every quarter turn. It works like the [`RotatedBox`](https://api.flutter.dev/flutter/widgets/RotatedBox-class.html) widget.|
|errorIndicatorData|`FlErrorIndicatorData<BarChartSpotErrorRangeCallbackInput>`|`const FlErrorIndicatorData()`|Holds data for showing error (threshold) indicators on the spots in the different [`BarChartGroupData.barRods`](#barchartgroupdata)|
<!-- /api -->

### BarChartGroupData
<!-- api:BarChartGroupData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|x|`int`|required|Order along the x axis in which titles, and titles only, will be shown.<br><br>Note `x` does not reorder bars from `barRods`; instead, it gets the title in `x` position through [`SideTitles.getTitlesWidget`](base_chart.md#sidetitles) function.|
|groupVertically|`bool?`|`false`|If set true, it will show bars below/above each other. Otherwise, it will show bars beside each other.|
|barRods|`List<BarChartRodData>?`|`const []`|[`BarChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/BarChart-class.html) renders `barRods` that represents a rod (or a bar) in the bar chart.|
|barsSpace|`double?`|`2`|[`BarChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/BarChart-class.html) applies `barsSpace` between `barRods` if `groupVertically` is false.|
|showingTooltipIndicators|`List<int>?`|`const []`|you can show some tooltipIndicators (a popup with an information) on top of each [`BarChartRodData`](#barchartroddata) using `showingTooltipIndicators`, just put indices you want to show it on top of them.<br><br>An important point is that you have to disable the default touch behaviour to show the tooltip manually, see [`BarTouchData.handleBuiltInTouches`](#bartouchdata-read-about-touch-handling).|
<!-- /api -->


### BarChartAlignment
<!-- api:BarChartAlignment -->
|Value|Description|
|:----|:----------|
|start|Places the groups at the start of the chart.|
|end|Places the groups at the end of the chart.|
|center|Places the groups in the middle of the chart.|
|spaceEvenly|Places the free space evenly between the groups, and before the first and after the last one.|
|spaceAround|Places the free space evenly between the groups, and half of it before the first and after the last one.|
|spaceBetween|Places the free space evenly between the groups, and none before the first and after the last one.|
<!-- /api -->


### BarChartRodData
<!-- api:BarChartRodData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|fromY|`double?`|`0`|[`BarChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/BarChart-class.html) renders rods vertically from `fromY`.|
|toY|`double`|required|[`BarChart`](https://pub.dev/documentation/fl_chart/latest/fl_chart/BarChart-class.html) renders rods vertically from `fromY` to `toY`.|
|toYErrorRange|`FlErrorRange?`|`null`|If the data has error range/threshold, it will be rendered with this error range. So you can provide the [`FlErrorRange.lowerBy`](base_chart.md#flerrorrange) and [`FlErrorRange.upperBy`](base_chart.md#flerrorrange) that is relative to the `toY` property.<br><br>If you want to customize the visual representation of the error range, you can use [`BarChartData.errorIndicatorData`](#barchartdata) to customize the error range|
|color|`Color?`||If provided, this [`BarChartRodData`](#barchartroddata) draws with this `color`. Otherwise we use `gradient` to draw the rod. It throws an exception if you provide both `color` and `gradient`.<br><br>Defaults to [`Colors.cyan`](https://api.flutter.dev/flutter/material/Colors-class.html) if neither `color` nor `gradient` is provided.|
|gradient|`Gradient?`|`null`|If provided, this [`BarChartRodData`](#barchartroddata) draws with this `gradient`. Otherwise we use `color` to draw the rod. It throws an exception if you provide both `color` and `gradient`.<br><br>You can use any [`Gradient`](https://api.flutter.dev/flutter/painting/Gradient-class.html) here, such as [`LinearGradient`](https://api.flutter.dev/flutter/painting/LinearGradient-class.html) or [`RadialGradient`](https://api.flutter.dev/flutter/painting/RadialGradient-class.html).|
|width|`double?`|`8`|The width of the rod.|
|borderRadius|`BorderRadiusGeometry?`|`null`|The rounding of the corners of the rod. When null, the rod is fully rounded (with a radius of half of its `width`). Accepts a [`BorderRadiusDirectional`](https://api.flutter.dev/flutter/painting/BorderRadiusDirectional-class.html) as well as a plain [`BorderRadius`](https://api.flutter.dev/flutter/painting/BorderRadius-class.html).|
|borderDashArray|`List<int>?`|`null`|Draws the `borderSide` dashed, it's a circular array of dash lengths and gaps. For example, `[5, 10]` results in dashes 5 pixels long followed by gaps 10 pixels long.|
|borderSide|`BorderSide?`||The border stroke around the rod, see [`BorderSide`](https://api.flutter.dev/flutter/painting/BorderSide-class.html).<br><br>When null, the rod has no border (a [`BorderSide`](https://api.flutter.dev/flutter/painting/BorderSide-class.html) with a width of `0`). The width of the border is capped to half of the rod's `width`.|
|backDrawRodData|`BackgroundBarChartRodData?`|`BackgroundBarChartRodData()`|If you want to have a bar drawn in rear of this rod, use `backDrawRodData`, it uses to have a bar with a passive color in rear of the rod, for example you can use it as the maximum value place holder.|
|rodStackItems|`List<BarChartRodStackItem>?`|`const []`|If you are a fan of stacked charts (If you don't know what is it, google it), you can fill up the `rodStackItems` to have a Stacked Chart.|
|label|`BarChartRodLabel`|`const BarChartRodLabel(show: false)`|Optional label to display near the rod tip.|
<!-- /api -->

### BackgroundBarChartRodData
<!-- api:BackgroundBarChartRodData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|fromY|`double?`|`0`|`fromY` is where background starts to show|
|toY|`double?`|`0`|background starts to show from `fromY` to `toY`|
|show|`bool?`|`false`|Determines to show or hide this|
|color|`Color?`||If provided, the background rod draws with this `color`. Otherwise we use `gradient` to draw it. It throws an exception if you provide both `color` and `gradient`.<br><br>Defaults to [`Colors.blueGrey`](https://api.flutter.dev/flutter/material/Colors-class.html) if neither `color` nor `gradient` is provided.|
|gradient|`Gradient?`|`null`|If provided, the background rod draws with this `gradient`. Otherwise we use `color` to draw it. It throws an exception if you provide both `color` and `gradient`.|
<!-- /api -->

### BarChartRodStackItem
<!-- api:BarChartRodStackItem -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|fromY|`double`|required|Renders a Stacked Chart section from `fromY`|
|toY|`double`|required|Renders a Stacked Chart section to `toY`|
|color|`Color?`|required|Renders a Stacked Chart section with `color`|
|gradient|`Gradient?`|`null`|Renders a Stacked Chart section with `gradient`|
|label|`String?`|`null`|An optional text label of the stack item.|
|labelStyle|`TextStyle?`|`null`|The [`TextStyle`](https://api.flutter.dev/flutter/painting/TextStyle-class.html) of the `label`.|
|borderSide|`BorderSide`|`Utils.defaultBorderSide`|Renders border stroke for a Stacked Chart section|
<!-- /api -->

### BarChartRodLabel
Extends [FlLabel](base_chart.md#FlLabel).
<!-- api:BarChartRodLabel -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|show|`bool`|`true`|Whether the label is visible.|
|text|`String`|`''`|The text content of the label.|
|style|`TextStyle?`|`null`|The text style of the label.<br><br>When null (or when its `inherit` is true), it is merged with the ambient [`DefaultTextStyle`](https://api.flutter.dev/flutter/widgets/DefaultTextStyle-class.html), and it respects the bold text setting of the platform.|
|angle|`double`|`0`|Rotation angle of the label in degrees.|
|textDirection|`TextDirection`|`TextDirection.ltr`|Text direction of the label.|
|offset|`Offset`|`const Offset(0, 8)`|Offset from the rod tip to position the label. [`Offset.dx`](https://api.flutter.dev/flutter/dart-ui/Offset-class.html) shifts horizontally, [`Offset.dy`](https://api.flutter.dev/flutter/dart-ui/Offset-class.html) shifts vertically.|
<!-- /api -->

### BarTouchData ([read about touch handling](handle_touches.md))
<!-- api:BarTouchData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|enabled|`bool?`|`true`|Determines whether to enable or disable touch behaviors.|
|touchCallback|`void Function(FlTouchEvent, BarTouchResponse?)?`|`null`|`touchCallback` notifies you about the happened touch/pointer events. It gives you a [`FlTouchEvent`](base_chart.md#fltouchevent) which is the happened event such as [`FlPointerHoverEvent`](https://pub.dev/documentation/fl_chart/latest/fl_chart/FlPointerHoverEvent-class.html), [`FlTapUpEvent`](https://pub.dev/documentation/fl_chart/latest/fl_chart/FlTapUpEvent-class.html), ... It also gives you a [`BaseTouchResponse`](https://pub.dev/documentation/fl_chart/latest/fl_chart/BaseTouchResponse-class.html) which is the chart specific type and contains information about the elements that has touched.|
|mouseCursorResolver|`MouseCursor Function(FlTouchEvent, BarTouchResponse?)?`|`null`|Using `mouseCursorResolver` you can change the mouse cursor based on the provided [`FlTouchEvent`](base_chart.md#fltouchevent) and [`BaseTouchResponse`](https://pub.dev/documentation/fl_chart/latest/fl_chart/BaseTouchResponse-class.html)|
|longPressDuration|`Duration?`|`null`|This property that allows to customize the duration of the longPress gesture. If null, it uses [kLongPressTimeout](https://api.flutter.dev/flutter/gestures/kLongPressTimeout-constant.html) (500 milliseconds).|
|touchTooltipData|`BarTouchTooltipData?`|`const BarTouchTooltipData()`|Determines how the tooltip looks on top of the touched rods, see [`BarTouchTooltipData`](#bartouchtooltipdata).|
|touchExtraThreshold|`EdgeInsets?`|`const EdgeInsets.all(4)`|Extends the touchable area of each rod by these insets.|
|allowTouchBarBackDraw|`bool?`|`false`|If true, touching the background rod ([`BarChartRodData.backDrawRodData`](#barchartroddata)) counts as touching the rod.|
|handleBuiltInTouches|`bool?`|`true`|If true, the chart handles touches by itself: it shows a tooltip bubble on top of the touched rod.|
<!-- /api -->

### BarTouchTooltipData
<!-- api:BarTouchTooltipData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|tooltipBorderRadius|`BorderRadius?`|`BorderRadius.circular(4)`|Sets a rounded radius for the tooltip.|
|tooltipPadding|`EdgeInsets?`|`const EdgeInsets.symmetric(horizontal: 16, vertical: 8)`|Applies a padding for showing contents inside the tooltip.|
|tooltipMargin|`double?`|`16`|Margin between the tooltip and the touched rod.|
|tooltipHorizontalAlignment|`FLHorizontalAlignment?`|`FLHorizontalAlignment.center`|Controls showing tooltip on left side, right side or center aligned with rod.|
|tooltipHorizontalOffset|`double?`|`0`|Applies horizontal offset for showing tooltip.|
|maxContentWidth|`double?`|`120`|Maximum width of the tooltip's content, a text row which is wider than this breaks into a new line.|
|getTooltipItem|`BarTooltipItem? Function(BarChartGroupData, int, BarChartRodData, int)?`|`defaultBarTooltipItem`|Retrieves data for showing content inside the tooltip.|
|getTooltipColor|`Color Function(BarChartGroupData)?`|`defaultBarTooltipColor`|Retrieves the background color of the tooltip for each touched rod.|
|fitInsideHorizontally|`bool?`|`false`|Forces the tooltip to shift horizontally inside the chart, if overflow happens.|
|fitInsideVertically|`bool?`|`false`|Forces the tooltip to shift vertically inside the chart, if overflow happens.|
|direction|`TooltipDirection?`|`TooltipDirection.auto`|Controls showing tooltip on top or bottom, default is auto.|
|rotateAngle|`double?`|`0.0`|Controls the rotation of the tooltip (in degrees)|
|tooltipBorder|`BorderSide?`|`BorderSide.none`|Border of the tooltip bubble.|
<!-- /api -->

### BarTooltipItem
<!-- api:BarTooltipItem -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|text|`String`|required|Text of the content.|
|textStyle|`TextStyle`|required|TextStyle of the showing content.|
|textAlign|`TextAlign`|`TextAlign.center`|TextAlign of the showing content.|
|textDirection|`TextDirection`|`TextDirection.ltr`|Direction of showing text.|
|children|`List<TextSpan>?`|`null`|Add further style and format to the text of the tooltip|
<!-- /api -->


### BarTouchResponse
<!-- api:BarTouchResponse fields -->
|Property|Type|Description|
|:-------|:---|:----------|
|touchLocation|`Offset`|The location of the touch in pixels on the screen.|
|touchChartCoordinate|`Offset`|The axis coordinate of the touch in chart's coordinate system.|
|spot|`BarTouchedSpot?`|Gives information about the touched spot|
<!-- /api -->

### BarTouchedSpot
<!-- api:BarTouchedSpot fields -->
Also has the properties of [`TouchedSpot`](base_chart.md#touchedspot).

|Property|Type|Description|
|:-------|:---|:----------|
|touchedBarGroup|`BarChartGroupData`|The [`BarChartGroupData`](#barchartgroupdata) of the touched rod.|
|touchedBarGroupIndex|`int`|The index of `touchedBarGroup` in [`BarChartData.barGroups`](#barchartdata).|
|touchedRodData|`BarChartRodData`|The touched [`BarChartRodData`](#barchartroddata).|
|touchedRodDataIndex|`int`|The index of `touchedRodData` in [`BarChartGroupData.barRods`](#barchartgroupdata).|
|touchedStackItem|`BarChartRodStackItem?`|The touched [`BarChartRodStackItem`](#barchartrodstackitem) (in a stacked bar chart), null if no stack item is touched.|
|touchedStackItemIndex|`int`|The index of `touchedStackItem` in [`BarChartRodData.rodStackItems`](#barchartroddata), -1 if no stack item is touched.|
<!-- /api -->


### Some Samples
----
##### Sample 1 ([Source Code](/example/lib/presentation/samples/bar/bar_chart_sample1.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/bar_chart/bar_chart_sample_1.gif" width="300" >

<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/bar_chart/bar_chart_sample_1_anim.gif" width="300" >



##### Sample 2 ([Source Code](/example/lib/presentation/samples/bar/bar_chart_sample2.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/bar_chart/bar_chart_sample_2.gif" width="300" >

##### Sample 3 ([Source Code](/example/lib/presentation/samples/bar/bar_chart_sample3.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/bar_chart/bar_chart_sample_3.png" width="300" >

##### Sample 4 ([Source Code](/example/lib/presentation/samples/bar/bar_chart_sample4.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/bar_chart/bar_chart_sample_4.png" width="300" >

##### Sample 5 ([Source Code](/example/lib/presentation/samples/bar/bar_chart_sample5.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/bar_chart/bar_chart_sample_5.gif" width="300" >

##### Sample 6 ([Source Code](/example/lib/presentation/samples/bar/bar_chart_sample6.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/bar_chart/bar_chart_sample_6.png" width="300" >

##### Sample 7 ([Source Code](/example/lib/presentation/samples/bar/bar_chart_sample7.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/bar_chart/bar_chart_sample_7.gif" width="300" >

##### Gist - Toggleable Tooltip ([Source Code](https://gist.github.com/imaNNeo/bce3f0169ff3fd6c3f137cdeb5005c0e))
https://user-images.githubusercontent.com/7009300/156784816-53f95dd9-f387-4600-8a92-d05b1aeea3da.mov
