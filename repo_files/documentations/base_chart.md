# BaseChart



### FlBorderData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|show| determines show and hide the border	|true|
|border| [Border](https://api.flutter.dev/flutter/painting/Border-class.html) details that determines which borders should draw with what color| Border.all(color: Colors.black, width: 1.0, style: BorderStyle.solid)|



### FlTitlesData
|PropName		|Description	|default value|
|:---------------|:---------------|:-------|
|show| determines show and hide the titles Around the chart|true|
|showHorizontalTitles| determines show the horizontal (below) titles | true|
|getHorizontalTitles| a function to retrive the title with given value on the related axis|defaultGetTitle|
|horizontalTitlesReservedHeight| a reserved space to show horizontal titles|22|
|horizontalTitlesTextStyle| [TextStyle](https://api.flutter.dev/flutter/painting/TextStyle-class.html) to determine style of showing horizontal texts |TextStyle(color: Colors.black, fontSize: 11)|
|horizontalTitleMargin| margin of showing horizontal titles | 6|
|showVerticalTitles| determines show the vertical (left) titles | true|
|getVerticalTitles| a function to retrive the title with given value on the related axis | defaultGetTitle|
|verticalTitlesReservedWidth| a reserved space to show vertical titles|40|
|verticalTitlesTextStyle| [TextStyle](https://api.flutter.dev/flutter/painting/TextStyle-class.html) to determine style of showing vertical texts |TextStyle(color: Colors.black, fontSize: 11)|
|verticalTitleMargin| margin of showing vertical titles | 6|




# BaseAxisChart (Line and Bar Charts)


### FlGridData
|PropName|Description|default value|
|:-------|:----------|:------------|
|show|determines show or hide the background grid data|true|
|drawHorizontalGrid|determines show or hide the horizontal grid lines|false|
|horizontalInterval|interval space of showing grid|1.0|
|horizontalGridColor|color of horizontal grid lines|Colors.grey|
|horizontalGridLineWidth|stroke width of horizontal grid lines |0.5|
|checkToShowHorizontalGrid|a function to check show or hide the horizontal grid by given related axis value |showAllGrids|
|drawVerticalGrid|determines show or hide the vertical grid lines|false|
|verticalInterval|interval space of showing grid|1.0|
|verticalGridColor|color of vertical grid lines|Colors.grey|
|verticalGridLineWidth|stroke width of vertical grid lines |0.5|
|checkToShowVerticalGrid|a function to check show or hide the vertical grid by given related axis value |showAllGrids|



### FlSpot
|PropName|Description|default value|
|:-------|:----------|:------------|
|x|represent x on the coordinate system (x starts from left)|null|
|y|represent y on the coordinate system (y starts from bottom)|null|