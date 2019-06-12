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
|showHorizontalTitles| determines to show or hide the horizontal (below) titles | true|
|getHorizontalTitles| a function to retrieve the title with given value on the related axis|defaultGetTitle|
|horizontalTitlesReservedHeight| a reserved space to show horizontal titles|22|
|horizontalTitlesTextStyle| [TextStyle](https://api.flutter.dev/flutter/painting/TextStyle-class.html) to determine the style of horizontal texts |TextStyle(color: Colors.black, fontSize: 11)|
|horizontalTitleMargin| margin of horizontal titles | 6|
|showVerticalTitles| determines to show or hide the vertical (left) titles | true|
|getVerticalTitles| a function to retrieve the title with given value on the related axis | defaultGetTitle|
|verticalTitlesReservedWidth| a reserved space to show vertical titles|40|
|verticalTitlesTextStyle| [TextStyle](https://api.flutter.dev/flutter/painting/TextStyle-class.html) to determine the style of vertical texts |TextStyle(color: Colors.black, fontSize: 11)|
|verticalTitleMargin| margin of vertical titles | 6|




# AxisChart (Line and Bar Charts)


### FlGridData
|PropName|Description|default value|
|:-------|:----------|:------------|
|show|determines to show or hide the background grid data|true|
|drawHorizontalGrid|determines to show or hide the horizontal grid lines|false|
|horizontalInterval|interval space of grid|1.0|
|horizontalGridColor|colors the horizontal grid lines|Colors.grey|
|horizontalGridLineWidth|stroke width of horizontal grid lines |0.5|
|checkToShowHorizontalGrid|a function to check whether to show or hide the horizontal grid by givingv the related axis value |showAllGrids|
|drawVerticalGrid|determines to show or hide the vertical grid lines|false|
|verticalInterval|interval space of grid|1.0|
|verticalGridColor|colors the vertical grid lines|Colors.grey|
|verticalGridLineWidth|stroke width of vertical grid lines |0.5|
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
