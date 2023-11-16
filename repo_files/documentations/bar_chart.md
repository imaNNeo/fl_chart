# BarChart

<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart.jpg" width="300" >

### How to use
```dart
BarChart(
  BarChartData(
    // read about it in the BarChartData section
  ),
  swapAnimationDuration: Duration(milliseconds: 150), // Optional
  swapAnimationCurve: Curves.linear, // Optional
);
```

### Implicit Animations
When you change the chart's state, it animates to the new state internally (using [implicit animations](https://flutter.dev/docs/development/ui/animations/implicit-animations)). You can control the animation [duration](https://api.flutter.dev/flutter/dart-core/Duration-class.html) and [curve](https://api.flutter.dev/flutter/animation/Curves-class.html) using optional `swapAnimationDuration` and `swapAnimationCurve` properties, respectively.

### BarChartData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|barGroups| list of [BarChartGroupData ](#BarChartGroupData) to show the bar lines together, you can provide one item per group to show normal bar chart|[]|
|groupsSpace| space between groups, it applies only when the [alignment](#BarChartAlignment) is `BarChartAlignment.start`, `BarChartAlignment.center` or `BarChartAlignment.end`|16|
|alignment| a [BarChartAlignment](#BarChartAlignment) that determines the alignment of the barGroups, inspired by [Flutter MainAxisAlignment](https://docs.flutter.io/flutter/rendering/MainAxisAlignment-class.html)| BarChartAlignment.spaceBetween|
|titlesData| check the [FlTitlesData](base_chart.md#FlTitlesData)|FlTitlesData()|
|axisTitleData| check the [FlAxisTitleData](base_chart.md#FlAxisTitleData)| FlAxisTitleData()|
|rangeAnnotations| show range annotations behind the chart, check [RangeAnnotations](base_chart.md#RangeAnnotations) | RangeAnnotations()|
|backgroundColor| a background color which is drawn behind the chart| null |
|barTouchData| [BarTouchData](#BarTouchData) holds the touch interactivity details|BarTouchData()|
|gridData| check the [FlGridData](base_chart.md#FlGridData)|FlGridData()|
|borderData| check the [FlBorderData](base_chart.md#FlBorderData)|FlBorderData()|
|maxY| gets maximum y of y axis, if null, value will be read from the input barGroups | null|
|minY| gets minimum y of y axis, if null, value will be read from the input barGroups | null|
|baselineY| defines the baseline of y-axis | 0|
|extraLinesData| allows extra horizontal lines to be drawn on the chart. Vertical lines are ignored when used with BarChartData, please see [#1149](https://github.com/imaNNeo/fl_chart/issues/1149), check [ExtraLinesData](base_chart.md#ExtraLinesData)|ExtraLinesData()|


### BarChartGroupData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|x| x position of the group on horizontal axis|null|
|barRods| list of [BarChartRodData](#BarChartRodData) that are a bar line| []
|barsSpace| the space between barRods of the group|2|
|showingTooltipIndicators| indexes of barRods to show the tooltip on top of them | []|


### BarChartAlignment
enum values {`start`, `end`, `center`, `spaceEvenly`, `spaceAround`, `spaceBetween`}


### BarChartRodData
|PropName|Description|default value|
|:-------|:----------|:------------|
|fromY|Position that this bar starts from|0|
|toY|This rod is from `fromY` to `toY` in the vertical axis|null|
|color|color of the rod bar|[Colors.cyan]|
|gradient| You can use any [Gradient](https://api.flutter.dev/flutter/dart-ui/Gradient-class.html) here. such as [LinearGradient](https://api.flutter.dev/flutter/painting/LinearGradient-class.html) or [RadialGradient](https://api.flutter.dev/flutter/painting/RadialGradient-class.html)|null|
|width|stroke width of the rod bar|8|
|borderRadius|Determines the edge rounding of the bar corners, see [BorderRadius](https://api.flutter.dev/flutter/painting/BorderRadius-class.html). When `null`, it defaults to completely round bars. |null|
|borderDashArray|Determines wether the border stroke is dashed. It is a circular array of dash offsets and lengths. For example, the array `[5, 10]` would result in dashes 5 pixels long followed by blank spaces 10 pixels long.  The array `[5, 10, 5]` would result in a 5 pixel dash, a 10 pixel gap, a 5 pixel dash, a 5 pixel gap, a 10 pixel dash, etc.|null|
|borderSide|Determines the border stroke around of the bar, see [BorderSide](https://api.flutter.dev/flutter/painting/BorderSide-class.html). When `null`, it defaults to draw no stroke. |null|
|backDrawRodData|if provided, draws a rod in the background of the line bar, check the [BackgroundBarChartRodData](#BackgroundBarChartRodData)|null|
|rodStackItem|if you want to have stacked bar chart, provide a list of [BarChartRodStackItem](#BarChartRodStackItem), it will draw over your rod.|[]|


### BackgroundBarChartRodData
|PropName|Description|default value|
|:-------|:----------|:------------|
|fromY|same as [BarChartRodData](#BarChartRodData)'s fromY|0|
|toY|same as [BarChartRodData](#BarChartRodData)'s y|8|
|show|determines to show or hide this section|false|
|color|same as [BarChartRodData](#BarChartRodData)'s colors|[Colors.blueGrey]|
|gradient|same as [BarChartRodData](#BarChartRodData)'s gradient|null|

### BarChartRodStackItem
|PropName|Description|default value|
|:-------|:----------|:------------|
|fromY|draw stack item from this value|null|
|toY|draw stack item to this value|null|
|color|color of the stack item|null|
|borderSide|draw border stroke for each stack item|null|

### BarTouchData ([read about touch handling](handle_touches.md))
|PropName|Description|default value|
|:-------|:----------|:------------|
|enabled|determines to enable or disable touch behaviors|true|
|mouseCursorResolver|you can change the mouse cursor based on the provided [FlTouchEvent](https://github.com/imaNNeo/fl_chart/blob/master/repo_files/documentations/base_chart.md#fltouchevent) and [BarTouchResponse](#BarTouchResponse)|MouseCursor.defer|
|touchTooltipData|a [BarTouchTooltipData](#BarTouchTooltipData), that determines how show the tooltip on top of touched spots (appearance of the showing tooltip bubble)|BarTouchTooltipData()|
|touchExtraThreshold|an [EdgeInsets](https://api.flutter.dev/flutter/painting/EdgeInsets-class.html) class to hold a bounding threshold of touch accuracy|EdgeInsets.all(4)|
|allowTouchBarBackDraw| if sets true, touch works on backdraw bar line| false |
|handleBuiltInTouches| set this true if you want the built in touch handling (show a tooltip bubble and an indicator on touched spots) | true|
|touchCallback| listen to this callback to retrieve touch/pointer events and responses, it gives you a [FlTouchEvent](https://github.com/imaNNeo/fl_chart/blob/master/repo_files/documentations/base_chart.md#fltouchevent) and [BarTouchResponse](#BarTouchResponse)| null|
|longPressDuration| allows to customize the duration of the longPress gesture. If null, the duration of the longPressGesture is [kLongPressTimeout](https://api.flutter.dev/flutter/gestures/kLongPressTimeout-constant.html)| null|

### BarTouchTooltipData
 |PropName|Description|default value|
 |:-------|:----------|:------------|
 |tooltipBgColor|background color of the tooltip bubble|Colors.white|
 |tooltipBorder|border of the tooltip bubble|BorderSide.none|
 |tooltipRoundedRadius|background corner radius of the tooltip bubble|4|
 |tooltipPadding|padding of the tooltip|EdgeInsets.symmetric(horizontal: 16, vertical: 8)|
 |tooltipMargin|margin between the tooltip and the touched spot|16|
 |tooltipHorizontalAlignment|horizontal alginment of tooltip relative to the bar|FLHorizontalAlignment.center|
 |tooltipHorizontalOffset|horizontal offset of tooltip|0|
 |maxContentWidth|maximum width of the tooltip (if a text row is wider than this, then the text breaks to a new line|120|
 |getTooltipItems|a callback that retrieve [BarTooltipItem](#BarTooltipItem) by the given [BarChartGroupData](#BarChartGroupData), groupIndex, [BarChartRodData](#BarChartRodData) and rodIndex |defaultBarTooltipItem|
 |fitInsideHorizontally| forces tooltip to horizontally shift inside the chart's bounding box| false|
 |fitInsideVertically| forces tooltip to vertically shift inside the chart's bounding box| false|
 |direction| Controls showing tooltip on top or bottom, default is auto.| auto|

### BarTooltipItem
|PropName|Description|default value|
|:-------|:----------|:------------|
|text|text string of each row in the tooltip bubble|null|
|textStyle|[TextStyle](https://api.flutter.dev/flutter/dart-ui/TextStyle-class.html) of the showing text row|null|
|textAlign|[TextAlign](https://api.flutter.dev/flutter/dart-ui/TextAlign-class.html) of the showing text row|TextAlign.center|
|textDirection|[TextDirection](https://api.flutter.dev/flutter/dart-ui/TextDirection-class.html) of the showing text row|TextDirection.ltr|
|children|[List<TextSpan>](https://api.flutter.dev/flutter/painting/InlineSpan-class.html) pass additional InlineSpan children for a more advance tooltip|null|


### BarTouchResponse
|PropName|Description|default value|
|:-------|:----------|:------------|
|spot|a [BarTouchedSpot](#BarTouchedSpot) class to hold data about touched spot| null |

### BarTouchedSpot
|PropName|Description|default value|
|:-------|:----------|:------------|
|touchedBarGroup|the [BarChartGroupData](#BarChartGroupData) that user touched its rod's spot| null |
|touchedBarGroupIndex| index of touched barGroup| null|
|touchedRodData|the [BarChartRodData](#BarChartRodData) that user touched its spot|null|
|touchedRodDataIndex| index of touchedRod | null|
|touchedStackItem| [BarChartRodStackItem](#BarChartRodStackItem) is the touched stack (if you have stacked bar chart) |null|
|touchedStackItemIndex| index of barChartRodStackItem, -1 if nothing found | -1|


### Some Samples
----
##### Sample 1 ([Source Code](/example/lib/presentation/samples/bar/bar_chart_sample1.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart_sample_1.gif" width="300" >

<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart_sample_1_anim.gif" width="300" >



##### Sample 2 ([Source Code](/example/lib/presentation/samples/bar/bar_chart_sample2.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart_sample_2.gif" width="300" >

##### Sample 3 ([Source Code](/example/lib/presentation/samples/bar/bar_chart_sample3.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart_sample_3.png" width="300" >

##### Sample 4 ([Source Code](/example/lib/presentation/samples/bar/bar_chart_sample4.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart_sample_4.png" width="300" >

##### Sample 5 ([Source Code](/example/lib/presentation/samples/bar/bar_chart_sample5.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart_sample_5.gif" width="300" >

##### Sample 6 ([Source Code](/example/lib/presentation/samples/bar/bar_chart_sample6.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart_sample_6.png" width="300" >

##### Sample 7 ([Source Code](/example/lib/presentation/samples/bar/bar_chart_sample7.dart))
<img src="https://github.com/imaNNeo/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart_sample_7.gif" width="300" >

##### Gist - Toggleable Tooltip ([Source Code](https://gist.github.com/imaNNeo/bce3f0169ff3fd6c3f137cdeb5005c0e))
https://user-images.githubusercontent.com/7009300/156784816-53f95dd9-f387-4600-8a92-d05b1aeea3da.mov
