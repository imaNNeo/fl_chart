## 0.8.5
* Added `fitInsideHorizontally` and `fitInsideVertically` in [ScatterTouchTooltipData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/scatter_chart.md#scattertouchtooltipdata)
* Fixed `clipToBorder` functionality basdd on the border sides.



## 0.8.4-test1
* Improved documentations

## 0.8.4
* Added `preventCurveOvershootingThreshold` in `LineChartBarData` for applying prevent overshooting algorithm, #193.
* Fixed `clipToBorder` bug in the [LineChartData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#linechartdata), #228, #214.
* Removed unused `enableNormalTouch` property from all charts TouchData.
* Implemented ImageAnnotations feature (added `image`, and `sizedPicture` in the [VerticalLine](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#verticalline), and the [HorizontalLine](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#horizontalline), check [this sample](https://github.com/imaNNeoFighT/fl_chart/blob/dev/repo_files/documentations/line_chart.md#sample-8-source-code) for more information.
* Enable 'fitInsideTheChart' to support vertical tooltip overflow as well, #225.
* BREAKING CHANGE-> changed `fitInsideTheChart` to `fitInsideHorizontally` and added `fitInsideVertically` to support both sides, #225.

## 0.8.3
* prevent to set BorderRadius with numbers larger than (width / 2), fixed #200.
* added `fitInsideTheChart` property inside `BarTouchTooltipData` and `LineTouchTooltipData` to force tooltip draw inside the chart (shift it to the chart), fixed #159.

## 0.8.2
* added `fullHeightTouchLine` in [LineTouchData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#linetouchdata-read-about-touch-handling) to show a full height touch line, see sample in merge request #208.
* added `label` ([HorizontalLineLabel](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#horizontallinelabel)) inside [HorizontalLine](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#horizontalline) and [VerticalLine](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#verticalline) to show a lable text on the lines.

## 0.8.1
* yaaay, added some basic unit tests
* skipped the first and the last grid lines from drawing, #174.
* prevent to draw touchedSpotDot if `show` is false, #180.
* improved paint order, more details in #175.
* added possibility to set `double.nan` in `centerSpaceRadius` for the PieChart to let it to be calculated according to the view size, fixed #179.

## 0.8.0
* added functionallity to have dashed lines, in everywhere we draw line, there should be a property called `dashArray` (for example check [LineChartBarData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#linechartbardata), and see [LineChartSample8](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#sample-8-source-code))
* BREAKING CHANGE:
* swapped [HorizontalExtraLines](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#horizontalline), and [VerticalExtraLines](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#verticalline) functionalities (now it has a well definition)
* and also removed `showVerticalLines`, and `showHorizontalLines` from [ExtraLinesData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#ExtraLinesData), if the `horizontalLines`, or `verticalLines` is empty we don't show them

## 0.7.0
* added rangeAnnotations in the [LineChartData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#linechartdata) to show range annotations, #163.
* removed `isRound` fiend in the [BarChartRodData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#barchartroddata) to add more customizability, and fixed #147 bug.
* fixed sever bug of click on pie chart, #146.

## 0.6.3
* Fixed drawing borddr bug, #143.
* Respect text scale factor when drawing text.

## 0.6.2
* added `axisTitleData` field to all axis base charts (Line, Bar, Scatter) to show the axes titles, see [LineChartSample4](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#sample-4-source-code) and [LineChartSample5](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#sample-5-source-code).

## 0.6.1
* added `betweenBarsData` property in [LineChartData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#linechartdata), fixed #93.

## 0.6.0
* fixed calculating size for handling touches bug, #126
* added `rotateAngle` property to rotate the [SideTitles](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/base_chart.md#sidetitles), fixed issue [#75](https://github.com/imaNNeoFighT/fl_chart/issues/75) , see in this [sample](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#sample-5-source-code)
* BREAKING CHANGES:
* some property names updated in the [FlGridData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/base_chart.md#flgriddata): `drawHorizontalGrid` -> `drawHorizontalLine`, `getDrawingHorizontalGridLine` -> `getDrawingHorizontalLine`, `checkToShowHorizontalGrid` -> `checkToShowHorizontalLine` (and same for vertical properties), fixed issue [#92](https://github.com/imaNNeoFighT/fl_chart/issues/92)

## 0.5.2
* drawing titles using targetData instead of animating data, fixed issue #130.

## 0.5.1
* prevent to show touch indicators if barData.show is false in LineChart, [#125](https://github.com/imaNNeoFighT/fl_chart/issues/125).

## 0.5.0
* 💥 Added ScatterChart ([read about it](https://jbt.github.io/markdown-editor/repo_files/documentations/scatter_chart.md)) 💥
* Added Velocity to in  [FlPanEnd](https://github.com/imaNNeoFighT/fl_chart/blob/feature/scatter-chart/repo_files/documentations/base_chart.md#fltouchinput) to determine the Tap event.

## 0.4.3
* fixed a size bug, #100.
* direction support for gradient on the LineChart (added `gradientFrom` and `gradientTo` in the [LineChartBarData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#linechartbardata)).

## 0.4.2
* implemented stacked bar chart, check the [samples](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#sample-5-source-code)
* added `groupSpace in [BarChartData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#barchartdata) to apply space between bar groups
* fixed drawing left and right titles of the BarChart
* fixed showing gridLines bug (the grid line of exact max value of each direction doesn't show)

## 0.4.1
* fixed handling disabled `handleBuiltInTouches` state bug

## 0.4.0
* BIG BREAKING CHANGES
* There is no `FlChart` class anymore, instead use [LineChart](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md), [BarChart](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md), and [PieChart](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/pie_chart.md) directly as a widget.
* Touch handling system is improved and for sure we have some changes, there is no `touchedResultSink` anymore and use `touchCallback` function which is added to each TouchData like ([LineTouchData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#linetouchdata-read-about-touch-handling)), [read more](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/handle_touches.md).
* `TouchTooltipData` class inside `LineTouchData` and `BarTouchData` renamed to `LineTouchTooltipData` and `BarTouchTooltipData` respectively, and also `TooltipItem` class renamed to `LineTooltipItem` and `BarTooltipItem`.
* `spots` inside `LineTouchResponse` renamed to `lineBarSpots` and type changed from `LineTouchedSpot` to `LineBarSpot`.
* `FlTouchNormapInput` renamed to `FlTouchNormalInput` (fixed typo)
* added `showingTooltipIndicators` in [LineChartData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#linechartdata) to show manually tooltips in `LineChart`.
* added `showingIndicators` in [LineChartBarData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#linechartbardata) to show manually indicators in `LineChart`.
* added `showingTooltipIndicators` in [BarChartGroupData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#barchartgroupdata) to show manually tooltips in `BarChart`.



## 0.3.4
* BREAKING CHANGES
* swapped horizontal and vertical semantics in [FlGridData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/base_chart.md#FlGridData), fixed this [issue](https://github.com/imaNNeoFighT/fl_chart/issues/85).

## 0.3.3
* BREAKING CHANGES
* added support for drawing below and above areas separately in LineChart
* added cutOffY feature in LineChart, see this [issue](https://github.com/imaNNeoFighT/fl_chart/issues/62)
* added `aboveBarData` in [LineChartBarData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#linechartbardata)
* `BelowBarData` class renamed to [BarAreaData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#barareadata) to reuse for both above and below areas
* `belowSpotsLine` renamed to `spotsLine` in [BarAreaData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#barareadata)
* `cutOffY` and `applyCutOffY` fields are added in [BarAreaData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#barareadata) to handle cutting of drawing below or above area
* `BelowSpotsLine` renamed to [BarAreaSpotsLine](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#barareaspotsline), and inside it `checkToShowSpotBelowLine` renamed to `checkToShowSpotLine`

## 0.3.2
* provided default size (square with 30% smaller than screen) for the FLChart, fixed this [issue](https://github.com/imaNNeoFighT/fl_chart/issues/74).

## 0.3.1
* added `interval` field in [SideTitles](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/base_chart.md#sidetitles), fixed this [issue](https://github.com/imaNNeoFighT/fl_chart/issues/67)

## 0.3.0
* 💥 Added Animations 💥, [read about it](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/handle_animations.md).

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
* added `SideTitles` class to hold titles representation data, and used in `FlTitlesData` to show left, top, right, bottom titles, instead of legacy direct parameters, and implemented a reversed chart [sample](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#sample-6-source-code) using this update.

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