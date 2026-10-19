# BaseChart

### FlBorderData
<!-- api:FlBorderData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|show|`bool?`|`true`|Determines whether to show or hide the border.|
|border|`Border?`|`Border.all()`|Determines which sides of the border are drawn, and how, see [`Border`](https://api.flutter.dev/flutter/painting/Border-class.html).|
<!-- /api -->


### FlTitlesData
<!-- api:FlTitlesData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|show|`bool`|`true`|Determines whether to show or hide the titles around the chart.|
|leftTitles|`AxisTitles`|`const AxisTitles(sideTitles: SideTitles(reservedSize: 44, showTitles: true))`|Holds data to draw the titles on the left side of the chart, see [`AxisTitles`](#axistitles).|
|topTitles|`AxisTitles`|`const AxisTitles(sideTitles: SideTitles(reservedSize: 30, showTitles: true))`|Holds data to draw the titles on the top side of the chart, see [`AxisTitles`](#axistitles).|
|rightTitles|`AxisTitles`|`const AxisTitles(sideTitles: SideTitles(reservedSize: 44, showTitles: true))`|Holds data to draw the titles on the right side of the chart, see [`AxisTitles`](#axistitles).|
|bottomTitles|`AxisTitles`|`const AxisTitles(sideTitles: SideTitles(reservedSize: 30, showTitles: true))`|Holds data to draw the titles on the bottom side of the chart, see [`AxisTitles`](#axistitles).|
<!-- /api -->

### AxisTitles
<!-- api:AxisTitles -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|axisNameWidget|`Widget?`|`null`|It shows the name of axis, for example your x-axis shows year, then you might want to show it using `axisNameWidget` property as a widget|
|axisNameSize|`double`|`16`|Determines the size of `axisNameWidget`.|
|sideTitles|`SideTitles`|`const SideTitles()`|It is responsible to show your axis side labels.|
|drawBelowEverything|`bool`|`true`|If titles are showing on top of your tooltip, you can draw them below everything.<br><br>In the future, we will convert tooltips to a widget, that would solve this problem.|
|sideTitleAlignment|`SideTitleAlignment`|`SideTitleAlignment.outside`|Where the [`SideTitles`](#sidetitles) are drawn in relation to the chart.|
<!-- /api -->

### SideTitles
<!-- api:SideTitles -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|showTitles|`bool`|`false`|Determines showing or hiding this side titles|
|getTitlesWidget|`Widget Function(double, TitleMeta)`|`defaultGetTitle`|You can override it to pass your custom widget to show in each axis value We recommend you to use [`SideTitleWidget`](https://pub.dev/documentation/fl_chart/latest/fl_chart/SideTitleWidget-class.html).<br><br>If you decide to implement your custom widget (instead of [`SideTitleWidget`](https://pub.dev/documentation/fl_chart/latest/fl_chart/SideTitleWidget-class.html)), you have to take care of the alignment, space to the chart and also the rotation (if you are rotating the chart, for example for Horizontal Bar Chart)|
|reservedSize|`double`|`22`|It determines the maximum space that your titles need, (All titles will stretch using this value)|
|interval|`double?`|`null`|Texts are showing with provided `interval`. If you don't provide anything, we try to find a suitable value to set as `interval` under the hood.|
|minIncluded|`bool`|`true`|If true (default), a title for the minimum data value is included independent of the sampling interval|
|maxIncluded|`bool`|`true`|If true (default), a title for the maximum data value is included independent of the sampling interval|
<!-- /api -->

### SideTitleFitInsideData
<!-- api:SideTitleFitInsideData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|enabled|`bool`|required|Whether to enable fit inside to SideTitleWidget|
|axisPosition|`double`|required|The position (in pixel) that applied to the child widget along its corresponding axis.|
|parentAxisSize|`double`|required|Parent axis max width/height|
|distanceFromEdge|`double`|required|Distance between child widget and its closest corresponding axis edge|
<!-- /api -->

### FlGridData
<!-- api:FlGridData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|show|`bool`|`true`|Determines showing or hiding all horizontal and vertical lines.|
|drawHorizontalLine|`bool`|`true`|Determines showing or hiding all horizontal lines.|
|horizontalInterval|`double?`|`null`|Determines interval between horizontal lines, left it null to be auto calculated.|
|getDrawingHorizontalLine|`FlLine Function(double)`|`defaultGridLine`|Gives you a y value, and gets a [`FlLine`](#flline) that represents specified line.|
|checkToShowHorizontalLine|`bool Function(double)`|`showAllGrids`|Gives you a y value, and gets a boolean that determines showing or hiding specified line.|
|drawVerticalLine|`bool`|`true`|Determines showing or hiding all vertical lines.|
|verticalInterval|`double?`|`null`|Determines interval between vertical lines, left it null to be auto calculated.|
|getDrawingVerticalLine|`FlLine Function(double)`|`defaultGridLine`|Gives you a x value, and gets a [`FlLine`](#flline) that represents specified line.|
|checkToShowVerticalLine|`bool Function(double)`|`showAllGrids`|Gives you a x value, and gets a boolean that determines showing or hiding specified line.|
<!-- /api -->

### FlLabel
<!-- api:FlLabel -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|show|`bool`|`true`|Whether the label is visible.|
|text|`String`|`''`|The text content of the label.|
|style|`TextStyle?`|`null`|The text style of the label.<br><br>When null (or when its `inherit` is true), it is merged with the ambient [`DefaultTextStyle`](https://api.flutter.dev/flutter/widgets/DefaultTextStyle-class.html), and it respects the bold text setting of the platform.|
|angle|`double`|`0`|Rotation angle of the label in degrees.|
|textDirection|`TextDirection`|`TextDirection.ltr`|Text direction of the label.|
<!-- /api -->

### FlSpot
<!-- api:FlSpot -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|x|`double`|required|The x value of the spot, on the horizontal axis (from left to right).|
|y|`double`|required|The y value of the spot, on the vertical axis (from bottom to top).|
|xError|`FlErrorRange?`|`null`|The error range of the spot on the x axis, drawn by the `errorIndicatorData` of the chart, see [`FlErrorRange`](#flerrorrange).|
|yError|`FlErrorRange?`|`null`|The error range of the spot on the y axis, drawn by the `errorIndicatorData` of the chart, see [`FlErrorRange`](#flerrorrange).|
<!-- /api -->


### FlLine
<!-- api:FlLine -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|color|`Color?`||Defines color of the line.<br><br>Defaults to [`Colors.black`](https://api.flutter.dev/flutter/material/Colors-class.html) if neither `color` nor `gradient` is provided.|
|gradient|`Gradient?`|`null`|Defines the gradient of the line.|
|strokeWidth|`double`|`2`|Defines thickness of the line.|
|dashArray|`List<int>?`|`null`|Defines dash effect of the line.<br><br>it is a circular array of dash offsets and lengths. For example, the array `[5, 10]` would result in dashes 5 pixels long followed by blank spaces 10 pixels long.|
<!-- /api -->


### TouchedSpot
<!-- api:TouchedSpot fields -->
|Property|Type|Description|
|:-------|:---|:----------|
|spot|`FlSpot`|Represents the spot inside our axis based chart, 0, 0 is bottom left, and 1, 1 is top right.|
|offset|`Offset`|Represents the touch position in device pixels, 0, 0 is top, left, and 1, 1 is bottom right.|
<!-- /api -->

### RangeAnnotations
<!-- api:RangeAnnotations -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|horizontalRangeAnnotations|`List<HorizontalRangeAnnotation>`|`const []`|Horizontal ranges to highlight, see [`HorizontalRangeAnnotation`](#horizontalrangeannotation).|
|verticalRangeAnnotations|`List<VerticalRangeAnnotation>`|`const []`|Vertical ranges to highlight, see [`VerticalRangeAnnotation`](#verticalrangeannotation).|
<!-- /api -->


### HorizontalRangeAnnotation
<!-- api:HorizontalRangeAnnotation -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|y1|`double`|required|Determines starting point in vertical (y) axis.|
|y2|`double`|required|Determines ending point in vertical (y) axis.|
|color|`Color?`||If provided, this [`HorizontalRangeAnnotation`](#horizontalrangeannotation) draws with this `color` Otherwise we use `gradient` to draw the background. It draws with `gradient` if you provide both `color` and `gradient`. If none is provided, it draws with a white color.|
|gradient|`Gradient?`|`null`|If provided, this [`HorizontalRangeAnnotation`](#horizontalrangeannotation) draws with this `gradient` Otherwise we use `color` to draw the background. It draws with `gradient` if you provide both `color` and `gradient`. If none is provided, it draws with a white color.|
<!-- /api -->


### VerticalRangeAnnotation
<!-- api:VerticalRangeAnnotation -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|x1|`double`|required|Determines starting point in horizontal (x) axis.|
|x2|`double`|required|Determines ending point in horizontal (x) axis.|
|color|`Color?`||If provided, this [`VerticalRangeAnnotation`](#verticalrangeannotation) draws with this `color` Otherwise we use `gradient` to draw the background. It draws with `gradient` if you provide both `color` and `gradient`. If none is provided, it draws with a white color.|
|gradient|`Gradient?`|`null`|If provided, this [`VerticalRangeAnnotation`](#verticalrangeannotation) draws with this `gradient` Otherwise we use `color` to draw the background. It draws with `gradient` if you provide both `color` and `gradient`. If none is provided, it draws with a white color.|
<!-- /api -->

### FlTouchEvent
Base class for all supported touch/pointer events.

|PropName|Description|Inspired from|
|:-------|:----------|:----------|
|FlPanDownEvent|Contains information of happened touch gesture|[GestureDragDownCallback](https://api.flutter.dev/flutter/gestures/GestureDragDownCallback.html)|
|FlPanStartEvent|When a pointer has contacted the screen and has begun to move.|[GestureDragStartCallback](https://api.flutter.dev/flutter/gestures/GestureDragStartCallback.html)|
|FlPanUpdateEvent|When a pointer that is in contact with the screen and moving has moved again.|[GestureDragUpdateCallback](https://api.flutter.dev/flutter/gestures/GestureDragUpdateCallback.html)|
|FlPanCancelEvent|When the pointer that previously triggered a `FlPanStartEvent` did not complete.|[GestureDragCancelCallback](https://api.flutter.dev/flutter/gestures/GestureDragCancelCallback.html)|
|FlPanEndEvent|When a pointer that was previously in contact with the screen and moving is no longer in contact with the screen.|[GestureDragEndCallback](https://api.flutter.dev/flutter/gestures/GestureDragEndCallback.html)|
|FlTapDownEvent|When a pointer that might cause a tap has contacted the screen.|[GestureTapDownCallback](https://api.flutter.dev/flutter/gestures/GestureTapDownCallback.html)|
|FlTapCancelEvent|When the pointer that previously triggered a `FlTapDownEvent` will not end up causing a tap.|[GestureTapCancelCallback](https://api.flutter.dev/flutter/gestures/GestureTapCancelCallback.html)|
|FlTapUpEvent|When a pointer that will trigger a tap has stopped contacting the screen.|[GestureTapUpCallback](https://api.flutter.dev/flutter/gestures/GestureTapUpCallback.html)|
|FlSecondaryTapDownEvent|When a secondary pointer that might cause a tap has contacted the screen.|[GestureTapDownCallback](https://api.flutter.dev/flutter/gestures/GestureTapDownCallback.html)|
|FlSecondaryTapCancelEvent|When the secondary pointer that previously triggered a `FlSecondaryTapDownEvent` will not end up causing a tap.|[GestureTapCancelCallback](https://api.flutter.dev/flutter/gestures/GestureTapCancelCallback.html)|
|FlSecondaryTapUpEvent|When a secondary pointer that will trigger a tap has stopped contacting the screen.|[GestureTapUpCallback](https://api.flutter.dev/flutter/gestures/GestureTapUpCallback.html)|
|FlLongPressStart|Called When a pointer has remained in contact with the screen at the same location for a long period of time.|[GestureLongPressStartCallback](https://api.flutter.dev/flutter/gestures/GestureLongPressStartCallback.html)|
|FlLongPressMoveUpdate|When a pointer is moving after being held in contact at the same location for a long period of time. Reports the new position and its offset from the original down position.|[GestureLongPressMoveUpdateCallback](https://api.flutter.dev/flutter/gestures/GestureLongPressMoveUpdateCallback.html)|
|FlLongPressEnd|When a pointer stops contacting the screen after a long press gesture was detected. Also reports the position where the pointer stopped contacting the screen.|[GestureLongPressEndCallback](https://api.flutter.dev/flutter/gestures/GestureLongPressEndCallback.html)|
|FlSecondaryLongPressStart|Called when a secondary pointer has remained in contact with the screen at the same location for a long period of time.|[GestureLongPressStartCallback](https://api.flutter.dev/flutter/gestures/GestureLongPressStartCallback.html)|
|FlSecondaryLongPressMoveUpdate|When a secondary pointer is moving after being held in contact at the same location for a long period of time. Reports the new position and its offset from the original down position.|[GestureLongPressMoveUpdateCallback](https://api.flutter.dev/flutter/gestures/GestureLongPressMoveUpdateCallback.html)|
|FlSecondaryLongPressEnd|When a secondary pointer stops contacting the screen after a long press gesture was detected. Also reports the position where the pointer stopped contacting the screen.|[GestureLongPressEndCallback](https://api.flutter.dev/flutter/gestures/GestureLongPressEndCallback.html)|
|FlPointerEnterEvent|The pointer has moved with respect to the device while the pointer is or is not in contact with the device, and it has entered our chart.|[PointerEnterEventListener](https://api.flutter.dev/flutter/services/PointerEnterEventListener.html)|
|FlPointerHoverEvent|The pointer has moved with respect to the device while the pointer is not in contact with the device.|[PointerHoverEventListener](https://api.flutter.dev/flutter/services/PointerHoverEventListener.html)|
|FlPointerExitEvent|The pointer has moved with respect to the device while the pointer is or is not in contact with the device, and exited our chart.|[PointerExitEventListener](https://api.flutter.dev/flutter/services/PointerExitEventListener.html)|

### ExtraLinesData
<!-- api:ExtraLinesData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|horizontalLines|`List<HorizontalLine>`|`const []`|Horizontal lines to draw on the chart, see [`HorizontalLine`](#horizontalline).|
|verticalLines|`List<VerticalLine>`|`const []`|Vertical lines to draw on the chart, see [`VerticalLine`](#verticalline).|
|extraLinesOnTop|`bool`|`true`|If true, the extra lines are drawn above the data of the chart, otherwise below it.|
<!-- /api -->


### HorizontalLine
<!-- api:HorizontalLine -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|y|`double`|required|Draws from left to right of the chart using the `y` value.|
|label|`HorizontalLineLabel?`|`HorizontalLineLabel()`|Draws a text label over the line.|
|color|`Color?`|`null`|Defines color of the line.<br><br>Defaults to [`Colors.black`](https://api.flutter.dev/flutter/material/Colors-class.html) if neither `color` nor `gradient` is provided.|
|gradient|`Gradient?`|`null`|Defines the gradient of the line.|
|strokeWidth|`double`|`2`|Defines thickness of the line.|
|dashArray|`List<int>?`|`null`|Defines dash effect of the line.<br><br>it is a circular array of dash offsets and lengths. For example, the array `[5, 10]` would result in dashes 5 pixels long followed by blank spaces 10 pixels long.|
|image|`Image?`|`null`|Use it for any kind of image, to draw it in left side of the chart.|
|sizedPicture|`SizedPicture?`|`null`|Use it for vector images, to draw it in left side of the chart.|
|strokeCap|`StrokeCap`|`StrokeCap.butt`|if not drawing dash line, then this is the StrokeCap for the line. i.e. if the two ends of the line is round or butt or square.|
<!-- /api -->

### VerticalLine
<!-- api:VerticalLine -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|x|`double`|required|Draws from bottom to top of the chart using the `x` value.|
|label|`VerticalLineLabel?`|`VerticalLineLabel()`|Draws a text label over the line.|
|color|`Color?`|`null`|Defines color of the line.<br><br>Defaults to [`Colors.black`](https://api.flutter.dev/flutter/material/Colors-class.html) if neither `color` nor `gradient` is provided.|
|gradient|`Gradient?`|`null`|Defines the gradient of the line.|
|strokeWidth|`double`|`2`|Defines thickness of the line.|
|dashArray|`List<int>?`|`null`|Defines dash effect of the line.<br><br>it is a circular array of dash offsets and lengths. For example, the array `[5, 10]` would result in dashes 5 pixels long followed by blank spaces 10 pixels long.|
|image|`Image?`|`null`|Use it for any kind of image, to draw it in bottom side of the chart.|
|sizedPicture|`SizedPicture?`|`null`|Use it for vector images, to draw it in bottom side of the chart.|
|strokeCap|`StrokeCap`|`StrokeCap.butt`|if not drawing dash line, then this is the StrokeCap for the line. i.e. if the two ends of the line is round or butt or square.|
<!-- /api -->

### SizedPicture
<!-- api:SizedPicture -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|picture|`Picture`|required|Is the showing image.|
|width|`int`|required|width of our `picture`.|
|height|`int`|required|height of our `picture`.|
<!-- /api -->

### HorizontalLineLabel
<!-- api:HorizontalLineLabel -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|padding|`EdgeInsetsGeometry`|`const EdgeInsets.all(6)`|Inner spaces around the drawing text.|
|style|`TextStyle?`|`null`|Sets style of the drawing text.|
|alignment|`Alignment`|`Alignment.topLeft`|Aligns the text on the line.|
|show|`bool`|`false`|Determines showing label or not.|
|direction|`LabelDirection`|`LabelDirection.horizontal`|Determines the direction of the text.|
|labelResolver|`String Function(HorizontalLine)`|`HorizontalLineLabel.defaultLineLabelResolver`|Resolves a label for showing.|
<!-- /api -->

### VerticalLineLabel
<!-- api:VerticalLineLabel -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|padding|`EdgeInsetsGeometry`|`const EdgeInsets.all(6)`|Inner spaces around the drawing text.|
|style|`TextStyle?`|`const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)`|Sets style of the drawing text.|
|alignment|`Alignment`|`Alignment.bottomRight`|Aligns the text on the line.|
|show|`bool`|`false`|Determines showing label or not.|
|direction|`LabelDirection`|`LabelDirection.horizontal`|Determines the direction of the text.|
|labelResolver|`String Function(VerticalLine)`|`VerticalLineLabel.defaultLineLabelResolver`|Resolves a label for showing.|
<!-- /api -->

### FLHorizontalAlignment
<!-- api:FLHorizontalAlignment -->
|Value|Description|
|:----|:----------|
|center|Element shown horizontally center aligned to a given point.|
|left|Element shown on the left side of the given point.|
|right|Element shown on the right side of the given point.|
<!-- /api -->


### FlErrorIndicatorData
<!-- api:FlErrorIndicatorData -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|show|`bool`|`true`|Determines showing the error indicator or not|
|painter|`FlSpotErrorRangePainter Function(T)`|`_defaultGetSpotRangeErrorPainter`|A callback that allows you to return a [`FlSpotErrorRangePainter`](https://pub.dev/documentation/fl_chart/latest/fl_chart/FlSpotErrorRangePainter-class.html) per each data point (for example [`FlSpot`](#flspot) in line chart)|
<!-- /api -->

### FlErrorRange
<!-- api:FlErrorRange -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|lowerBy|`double`|required|determines the lower bound of the error range, it will be subtracted from the main value. So it is non-negative and it is relative to the main value|
|upperBy|`double`|required|determines the upper bound of the error range, it will be added to the main value. So it is non-negative and it is relative to the main value|
<!-- /api -->

### AxisSpotIndicator
<!-- api:AxisSpotIndicator -->
|Property|Type|Default|Description|
|:-------|:---|:------|:----------|
|x|`double?`|`null`|The x value where the indicator is drawn.|
|y|`double?`|`null`|The y value where the indicator is drawn.|
|painter|`AxisSpotIndicatorPainter`|required|Draws the indicator, like [`AxisLinesIndicatorPainter`](https://pub.dev/documentation/fl_chart/latest/fl_chart/AxisLinesIndicatorPainter-class.html) (you can implement your own [`AxisSpotIndicatorPainter`](https://pub.dev/documentation/fl_chart/latest/fl_chart/AxisSpotIndicatorPainter-class.html) to customize it).|
<!-- /api -->

### SideTitleAlignment
<!-- api:SideTitleAlignment -->
|Value|Description|
|:----|:----------|
|outside|Places the titles outside of the chart area.|
|border|Places the titles on the border of the chart area.|
|inside|Places the titles inside of the chart area.|
<!-- /api -->
