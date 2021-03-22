## 0.30.0
* [IMPROVEMENT] We now use [RenderObject](https://api.flutter.dev/flutter/rendering/RenderObject-class.html) as our default drawing system. It brings a lot of stability. Such as size handling, hitTest handling (touches), and It makes us possible to paint Widgets inside our chart (It might fix #383, #556, #582, #584, #591).
* [IMPROVEMENT] Added [Radar Chart Documentations](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/radar_chart.md)
* [IMPROVEMENT] Added `textAlign` property in the [BarTooltipItem](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#bartooltipitem), [LineTooltipItem](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#linetooltipitem), and [ScatterTooltipItem](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/scatter_chart.md#scattertooltipitem), default is `TextAlign.center`.
* [IMPROVEMENT] Added `direction` property in the [BarTouchTooltipData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#bartouchtooltipdata), and [LineTouchTooltipData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#linetouchtooltipdata) to specify the position of the tooltip (can be `auto`, `top`, `bottom`), default is `auto`.
* [IMPROVEMENT] Updated touch flow, we now use [hitTest](https://api.flutter.dev/flutter/rendering/RenderProxyBoxWithHitTestBehavior/hitTest.html) for handling touch and interactions.
* [IMPROVEMENT] Added 'clickHappened' property in all of our TouchResponses (such as [LineTouchResponse](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#LineTouchResponse), [BarTouchResponse](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#bartouchresponse), ...), #210.
* [IMPROVEMENT] Added `swapAnimationCurve` property to all chart widgets which handles the built-in animation [Curve](https://api.flutter.dev/flutter/animation/Curves-class.html), #436.
* [BREAKING] Some properties in [ScatterTouchResponse](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/scatter_chart.md#scattertouchresponse), and [PieTouchResponse](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/pie_chart.md#pietouchresponse) moved to a wrapper class, you need to access them through that wrapper class.
* [BREAKING] Renamed `tooltipBottomMargin` to `tooltipMargin` property in the [BarTouchTooltipData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#bartouchtooltipdata), and [LineTouchTooltipData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#linetouchtooltipdata)
* [Bugfix] Fixed `double.infinity` in [PieChartData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/pie_chart.md#piechartdata) .centerSpaceRadius, #584. 

## 0.20.1
* [BREAKING] We now support flutter version 2.0 (null-safety), check out the [migration guide](https://dart.dev/null-safety/migration-guide).
* [NEW_CHART] We have added [RadarChart](https://github.com/payam-zahedi/fl_chart/blob/master/repo_files/documentations/radar_chart.md). Thanks to [Payam Zahedi](https://github.com/payam-zahedi)!

## 0.20.0-nullsafety1
* [BREAKING] **We have migrated our project to null-safety. You may need to change your source-code to compile**. check [migration guide](https://dart.dev/null-safety/migration-guide).
* [BREAKING] You cannot set null value on FlSpot any more (use FlSpot.nullSpot instead).

## 0.12.3
* [Bugfix] Fixed PieChart exception bug on sections tap, #514.
* [Bugfix] Fixed PieChart badges problem, #538.
* [Bugfix] Fixed Bug of drawing lines with strokeWidth zero, #558.
* [Improvement] Updated example app to support web.
* [Improvement] Show tooltips on mouse hover on Web, and Desktop.

## 0.12.2
* [Bugfix] Fixed PieChart badges draw in first frame problem, #513.
* [Improvement] Use CanvasWrapper to proxy draw functions (It does not have any effect on the result, it makes the code testable)

## 0.12.1
* [Bugfix] Fixed PieChart badges bug with re-implementing the solution, #507
* [Bugfix] Fix the setState issue using PieChart in the ListView, #467
* [Bugfix] Fixed formatNumber bug for negative numbers, #486.
* [Improvement] Added applyCutOffY property in [BarAreaSpotsLine](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#barareaspotsline) to inherit cutOffY property of its parent, #478.

## 0.12.0
* [Improvement] [BREAKING] Replaced `color` property with `colors` in [BarChartRodData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#barchartroddata), and [BackgroundBarChartRodData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#backgroundbarchartroddata) to support gradient in BarChart, instead of solid color, #166. Check [BarChartSample3](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#sample-3-source-code)
* [Improvement] Improved gradient stops calculating algorithm.
* [Improvement] [BREAKING] Changed SideTitle's `textStyle` property to `getTextStyles` getter (it gives you the axis value, and you must return a TextStyle based on it), It helps you to have a different style for specific text, #439. Check it here [LineChartSample3](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#sample-3-source-code)
* [Improvement] Added `badgeWidget`, and `badgePositionPercentageOffset` in each [PieChartSectionData](https://github.com/imaNNeoFighT/fl_chart/blob/dev/repo_files/documentations/pie_chart.md#piechartsectiondata) to provide a widget to show in the chart, see [this sample](https://github.com/imaNNeoFighT/fl_chart/blob/dev/repo_files/documentations/pie_chart.md#sample-3-source-code), #443. Providing a widget is an important step in our library, if it works perfectly, we will aplly this solution on other parts. Then I appreciate any feedback.
* [Bugfix] Fixed aboveBarArea flickers after setState, #440.

## 0.11.1
* [Bugfix] Fixed drawing BarChart rods with providing minY (for positive), maxY (for negative) values bug, #404.
* [Bugfix] Fixed example app build fail error, by upgrading flutter_svg package to `0.18.1`

## 0.11.0
* [Bugfix] Prevent show ScatterSpot if show is false, #385.
* [Improvement] Set default centerSpaceRadius to double.infinity in [PieChartData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/pie_chart.md#piechartdata), #384.
* [Improvement] Allowed to have topTitles in the [BarChart](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md), see [BarChartSample5](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#sample-5-source-code), #394.
* [Improvement] Added `touchedStackItem` and `touchedStackItemIndex` properties in the [BarTouchedSpot](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#bartouchedspot) to determine in which [BarChartRodStackItem](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#barchartrodstackitem) click happened, #393. 
* [Improvement] [BREAKING] Renamed `rodStackItem` to `rodStackItems` in [BarChartRodData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#barchartroddata). 

## 0.10.1
* [Improvement] Show barGroups `x` value instead of `index` in bottom titles, #342.
* [Improvement] [BREAKING] Use `double.infinity` instead of `double.nan` for letting `enterSpaceRadius` be as large as possible in the (PieChartData)[https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/pie_chart.md#piechartdata], #377.
* [Bugfix] Fixed PieChart bug with 1 section, #368.

## 0.10.0
* [IMPORTANT] **BLACK LIVES MATTER**
* [Improvement] Auto calculate interval in [SideTitles](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/base_chart.md#sidetitles) and [FlGridData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/base_chart.md#flgriddata), instead of hard coding 1, to prevent some performance issues like #101, #322. see [BarChartSample4](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#sample-4-source-code).
* [Bugfix] drawing dot on null spots
* [Bugfix] Fixed LineChart have multiple NULL spot bug.
* [Feature] Added `checkToShowTitle` property to the [SideTitles](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/base_chart.md#sidetitles), for checking show or not show titles in the provided value, #331. see [LineChartSample8](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#sample-8-source-code).
* [Feature] Added compatibily to have customized shapes for [FlDotData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#fldotdata), just override `FlDotData.etDotPainter` and pass your own painter or use built-in ones, see this [sample](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#sample-3-source-code).
* [Improvement] [BREAKING] Replaced `clipToBorder` with `clipData` in [LineChartData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#linechartdata) to support clipping 4 sides of a chart separately.

## 0.9.4
* [Bugfix] Fixed showing PieChart on web (we've ignored `groupSpace` on web, because some BlendModes are [not working](https://github.com/flutter/flutter/issues/56071) yet)

## 0.9.3
* [BugFix] Fixed groupBarsPosition exception, #313.
* [Improvement] Shadows default off, #316.

## 0.9.2
* [Feature] Added `shadow` property in [LineChartData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#linechartdata) to have shadow effect in our [LineChart](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md), take a look at [LineChartSampl5](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#sample-5-source-code), #304.
* [Feature] Added `isStepLineChart`, and `lineChartStepData` in the [LineChartData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#linechartdata) to support Step Line Chart, take a look at [lineChartSample3](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#sample-3-source-code), #303.
* [Improvement] Added `barData` parameter to checkToShowDot Function in the [FlDotData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#fldotdata).

## 0.9.0
* Added `strokeWidth`, `getStrokeColor`, `getDotColor` in the [FlDotData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#fldotdata), also removed `dotColor` from it (you should use `getDotColor` instead, it gives you more customizability), now we have more customizability on [FlDotData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#fldotdata), check [line_chart_sample3](https://github.com/imaNNeoFighT/fl_chart/blob/dev/repo_files/documentations/line_chart.md#sample-3-source-code), and [line_chart_sample5](https://github.com/imaNNeoFighT/fl_chart/blob/dev/repo_files/documentations/line_chart.md#sample-5-source-code), #233, #99, #274.
* Added `equatable` library to solve some equation issues.
* Implemented negative values feature for the BarChart, #106, #103.
* add Equatable for all models, it leads to have a better performance.
* Fixed a minor touch bug in the [BarChart](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md).
* Fixed ScatterChart built-in touch behaviour.
* Fixed drawing grid lines bug, #280.
* Implemented [FlDotData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#fldotdata).`getDotColor` in a proper way, it returns a color based on the [LineChartBarData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#linechartbardata) color, #274, #282.
* Updated [LineChartData](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#linechartdata).`showingTooltipIndicators` field type to list of [ShowingTooltipIndicators](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#showingtoltipindicators) to have a clean naming.

## 0.8.7
* Added `show` property in the `VerticalLineLabel` and set default to `false`, #256.
* Fixed bug, when the screen size is square, #258.

## 0.8.6
* Fixed exception on extraLinesData, #251.
* Show extra lines value with 1 floating-point.
* Implemented multi-section lines in LineChart, check this issue (#26) and this merge request (#252)

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