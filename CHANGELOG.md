## 0.3.0
* 💥 Added Animations 💥, [read about it](https://github.com/imaNNeoFighT/fl_chart/blob/feature/both-axis-titles/repo_files/documentations/handle_animations.md).

## 0.2.2
* fixed a typo on CHANGELOG
* reformatted dart files with `flutter format` command

## 0.2.1
* fixed #64, added a technical debt :(

## 0.2.0
* fixed a critical got stuck in draw loop bug,
* set `BarChartGroupData` x as required property to keep consistency and prevent unpredictable bugs

## 0.1.6
* added `enableNormalTouch` property to chart's TouchData to handle normal taps, and enabled by default.

## 0.1.5
* reverted getPixelY() on axis_chart_painter to solve the regression bug (fixed issue #48)
* (fix) BelowBar considers its own color stops refs #46

## 0.1.4
* bugfix -> fixed draw bug on BarChart when y value is very low in high scale y values (#43).

## 0.1.3
* added `SideTitles` class to hold titles representation data, and used in `FlTitlesData` to show left, top, right, bottom titles, instead of legacy direct parameters, and implemented a reversed chart [sample](https://github.com/imaNNeoFighT/fl_chart/blob/feature/both-axis-titles/repo_files/documentations/line_chart.md#sample-6-source-code) using this update.

## 0.1.2
*  added `preventCurveOverShooting` on BarData, check this [issue](https://github.com/imaNNeoFighT/fl_chart/issues/25)

## 0.1.1
* nothing important

## 0.1.0
* added **Touch Interactivity**, read more about it [here](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/handle_touches.md)

## 0.0.8
* added backgroundColor to axis based charts (LineChart, BarChart) to draw a solid background color behind the chart
* added getDrawingHorizontalGridLine, getDrawingVerticalGridLine on FlGridData to determine how(color, strokeWidth) the grid lines should be drawn with the given value on FlGridLine

## 0.0.7
* added ExtraLinesData in the LineChartData to draw extra horizontal and vertical lines on LineChart
* added BelowSpotsLine in the BlowBarData to draw lines from spot to the bottom of chart on LineChart

## 0.0.6
* fixed charts repainting bug, #16


## 0.0.5
* added clipToBorder to the LineChartData to clip the drawing to the border, #3


## 0.0.4
* fixed bug of adding bar with y = 0 on bar chart #13


## 0.0.3
* renamed `FlChartWidget` to `FlChart` (our main widget) and now you have to import `package:fl_chart/fl_chart.dart` instead of `package:fl_chart/fl_chart_widget.dart`
* renamed `FlChart*` to `BaseChart*` (parent class of our charts like `PieChart`)
* renamed `FlAxisChart*` to `AxisChart*`


## 0.0.2
* fixed `minX`, `maxX` functionality on LineChart
* restricted to access private classes of the library


## 0.0.1 - Released on (2019 June 4)