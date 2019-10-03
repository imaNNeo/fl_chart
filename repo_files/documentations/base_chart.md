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
|leftTitles| a [SideTitles](#SideTitles) that holds data to draw left titles | SideTitles(reservedSize: 40, showTitles: true)|
|topTitles| a [SideTitles](#SideTitles) that holds data to draw top titles |SideTitles(reservedSize: 6)|
|rightTitles| a [SideTitles](#SideTitles) that holds data to draw right titles |SideTitles(reservedSize: 40,)|
|bottomTitles| a [SideTitles](#SideTitles) that holds data to draw bottom titles |SideTitles(reservedSize: 22, showTitles: true)|



### SideTitles
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|showTitles| determines to show or hide the titles | false|
|getTitles| a function to retrieve the title with given value on the related axis|defaultGetTitle|
|reservedSize| a reserved space to show titles|22|
|textStyle| [TextStyle](https://api.flutter.dev/flutter/painting/TextStyle-class.html) to determine the style of texts |TextStyle(color: Colors.black, fontSize: 11)|
|margin| margin of horizontal the titles | 6|
|interval| interval between of showing titles in this side,  | 1.0 |




### FlTouchInput
an abstract class that contains a [Offset](https://api.flutter.dev/flutter/dart-ui/Offset-class.html) with x and y of touched point, there is some concrete classes to distinguish between touch behaviours,
currently we have these touch behaviors:
`FlLongPressStart`, `FlLongPressMoveUpdate`, `FlLongPressEnd`.


# AxisChart (Line and Bar Charts)


### FlGridData
|PropName|Description|default value|
|:-------|:----------|:------------|
|show|determines to show or hide the background grid data|true|
|drawHorizontalGrid|determines to show or hide the horizontal grid lines|false|
|horizontalInterval|interval space of grid|1.0|
|getDrawingHorizontalGridLine|a function to get the line style of each grid line by giving the related axis value|defaultGridLine|
|checkToShowHorizontalGrid|a function to check whether to show or hide the horizontal grid by giving the related axis value |showAllGrids|
|drawVerticalGrid|determines to show or hide the vertical grid lines|false|
|verticalInterval|interval space of grid|1.0|
|getDrawingVerticalGridLine|a function to get the line style of each grid line by giving the related axis value|defaultGridLine|
|checkToShowVerticalGrid|a function to determine whether to show or hide the vertical grid by giving the related axis value |showAllGrids|



### FlSpot
|PropName|Description|default value|
|:-------|:----------|:------------|
|x|represents x on the coordinate system (x starts from left)|null|
|y|represents y on the coordinate system (y starts from bottom)|null|



### FlLine
|propName|Description|default valkue|
|:-------|:----------|:------------|
|color|determines the color of line|Colors.black|
|strokeWidth|determines the stroke width of the line|2|


### TouchTooltipData
|PropName|Description|default value|
|:-------|:----------|:------------|
|tooltipBgColor|background color of the tooltip bubble|Colors.white|
|tooltipRoundedRadius|background corner radius of the tooltip bubble|4|
|tooltipPadding|padding of the tooltip|EdgeInsets.symmetric(horizontal: 16, vertical: 8)|
|tooltipBottomMargin|bottom margin of the tooltip (to the top of most top spot)|16|
|maxContentWidth|maximum width of the tooltip (if a text row is wider than this, then the text breaks to a new line|120|
|getTooltipItems|a callback that retrieve list of [TooltipItem](#TooltipItem) by the given list of [TouchedSpot](#TouchedSpot) |defaultTitlesStyle|


### TouchedSpot
|PropName|Description|default value|
|:-------|:----------|:------------|
|spot|the touched [FlSpot](#FlSpot)|null|
|offset|[Offset](https://api.flutter.dev/flutter/dart-ui/Offset-class.html) of the touched spot|null|


### TooltipItem
|PropName|Description|default value|
|:-------|:----------|:------------|
|text|text string of each row in the tooltip bubble|null|
|textStyle|[TextStyle](https://api.flutter.dev/flutter/dart-ui/TextStyle-class.html) of the showing text row|null|