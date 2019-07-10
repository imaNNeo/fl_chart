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