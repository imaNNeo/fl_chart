# BaseChart

### FlBorderData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|show| determines to show or hide the border	|true|
|border| [Border](https://api.flutter.dev/flutter/painting/Border-class.html) details that determines which border should be drawn with which color| Border.all(color: Colors.black, width: 1.0, style: BorderStyle.solid)|


### FlTitlesData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|show| determines to show or hide the titles Around the chart|true|
|leftTitles| an [AxisTitle](#AxisTitle) that holds data to draw left titles | AxisTitles(sideTitles: SideTitles(reservedSize: 40, showTitles: true))|
|topTitles| an [AxisTitle](#AxisTitle) that holds data to draw top titles | AxisTitles(sideTitles: SideTitles(reservedSize: 6, showTitles: true))|
|rightTitles| an [AxisTitle](#AxisTitle) that holds data to draw right titles | AxisTitles(sideTitles: SideTitles(reservedSize: 40, showTitles: true))|
|bottomTitles| an [AxisTitle](#AxisTitle) that holds data to draw bottom titles | AxisTitles(sideTitles: SideTitles(reservedSize: 6, showTitles: true))|

### AxisTitle
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|axisNameSize| Determines the size of [axisName] | `16`|
|axisNameWidget| It shows the name of axis (you can pass a Widget)| `null`|
|sideTitles| It accepts a [SideTitles](#SideTitles) which is responsible to show your axis side titles| `SideTitles()`|
|drawBehindEverything| If titles are showing on top of your tooltip, you can draw them behind everything.| `false`|

### SideTitles
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|showTitles| determines whether to show or hide the titles | false|
|getTitlesWidget| A function to retrieve the title widget with given value on the related axis.|defaultGetTitle|
|reservedSize| It determines the maximum space that your titles need, |22|
|interval| Texts are showing with provided `interval`. If you don't provide anything, we try to find a suitable value to set as `interval` under the hood. | null |

### FlGridData
|PropName|Description|default value|
|:-------|:----------|:------------|
|show|determines to show or hide the background grid data|true|
|drawHorizontalLine|determines to show or hide the horizontal grid lines|true|
|horizontalInterval|interval space of grid, left it null to be calculate automatically |null|
|getDrawingHorizontalLine|a function to get the line style of each grid line by giving the related axis value|defaultGridLine|
|checkToShowHorizontalLine|a function to check whether to show or hide the horizontal grid by giving the related axis value |showAllGrids|
|drawVerticalLine|determines to show or hide the vertical grid lines|false|
|verticalInterval|interval space of grid, left it null to be calculate automatically |null|
|getDrawingVerticalLine|a function to get the line style of each grid line by giving the related axis value|defaultGridLine|
|checkToShowVerticalLine|a function to determine whether to show or hide the vertical grid by giving the related axis value |showAllGrids|



### FlSpot
|PropName|Description|default value|
|:-------|:----------|:------------|
|x|represents x on the coordinate system (x starts from left)|null|
|y|represents y on the coordinate system (y starts from bottom)|null|



### FlLine
|propName|Description|default value|
|:-------|:----------|:------------|
|color|determines the color of line|Colors.black|
|strokeWidth|determines the stroke width of the line|2|
|dashArray|A circular array of dash offsets and lengths. For example, the array `[5, 10]` would result in dashes 5 pixels long followed by blank spaces 10 pixels long.  The array `[5, 10, 5]` would result in a 5 pixel dash, a 10 pixel gap, a 5 pixel dash, a 5 pixel gap, a 10 pixel dash, etc.|null|


### TouchedSpot
|PropName|Description|default value|
|:-------|:----------|:------------|
|spot|the touched [FlSpot](#FlSpot)|null|
|offset|[Offset](https://api.flutter.dev/flutter/dart-ui/Offset-class.html) of the touched spot|null|

### RangeAnnotations
|PropName|Description|default value|
|:-------|:----------|:------------|
|horizontalRangeAnnotations|list of [horizontalRangeAnnotation](#HorizontalRangeAnnotation) to draw on the chart|[]|
|verticalRangeAnnotations|list of [VerticalRangeAnnotation](#VerticalRangeAnnotation) to draw on the chart|[]|


### HorizontalRangeAnnotation
|PropName|Description|default value|
|:-------|:----------|:------------|
|y1|start interval of horizontal rectangle|null|
|y2|end interval of horizontal rectangle|null|
|color|color of the rectangle|Colors.white|


### VerticalRangeAnnotation
|PropName|Description|default value|
|:-------|:----------|:------------|
|x1|start interval of vertical rectangle|null|
|x2|end interval of vertical rectangle|null|
|color|color of the rectangle|Colors.white|

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
|FlLongPressStart|Called When a pointer has remained in contact with the screen at the same location for a long period of time.|[GestureLongPressStartCallback](https://api.flutter.dev/flutter/gestures/GestureLongPressStartCallback.html)|
|FlLongPressMoveUpdate|When a pointer is moving after being held in contact at the same location for a long period of time. Reports the new position and its offset from the original down position.|[GestureLongPressMoveUpdateCallback](https://api.flutter.dev/flutter/gestures/GestureLongPressMoveUpdateCallback.html)|
|FlLongPressEnd|When a pointer stops contacting the screen after a long press gesture was detected. Also reports the position where the pointer stopped contacting the screen.|[GestureLongPressEndCallback](https://api.flutter.dev/flutter/gestures/GestureLongPressEndCallback.html)|
|FlPointerEnterEvent|The pointer has moved with respect to the device while the pointer is or is not in contact with the device, and it has entered our chart.|[PointerEnterEventListener](https://api.flutter.dev/flutter/services/PointerEnterEventListener.html)|
|FlPointerHoverEvent|The pointer has moved with respect to the device while the pointer is not in contact with the device.|[PointerHoverEventListener](https://api.flutter.dev/flutter/services/PointerHoverEventListener.html)|
|FlPointerExitEvent|The pointer has moved with respect to the device while the pointer is or is not in contact with the device, and exited our chart.|[PointerExitEventListener](https://api.flutter.dev/flutter/services/PointerExitEventListener.html)|
