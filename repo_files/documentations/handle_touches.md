### Touch Interactivity

|LineChart	|BarChart		|PieChart		|
|:------------:|:------------:|:-------------:|
|	[![](https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_1.gif)](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#sample-1-source-code) [![](https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_2.gif)](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#sample-2-source-code)  |	[![](https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart_sample_1.gif)](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#sample-1-source-code) [![](https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart_sample_2.gif)](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#sample-2-source-code)  | [![](https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/pie_chart/pie_chart_sample_1.gif)](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/pie_chart.md#sample-1-source-code) [![](https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/pie_chart/pie_chart_sample_2.gif)](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/pie_chart.md#sample-2-source-code)  |



#### The Interaction Flow
When an interaction happens, our renderers give us a [PointerEvent](https://api.flutter.dev/flutter/gestures/PointerEvent-class.html).
We pass it to correspond painter class. Then it calculates and gives us a TouchResponse (per interaction).
Then we call the touchCallback function that provided through the chart's data.

If you set `handleBuiltInTouches` true, it will handle touch by showing a tooltip or an indicator on the touched spot (in the line and bar chart), you can also handle your own touch handling along with the built in touches.


#### How to use? (for example in `LineChart`)
##### In the Line and Bar Charts we show a built in tooltip on the touched spots, then you just need to config how to show it, just fill the `touchTooltipData` in the `LineTouchData`.
#####
```dart
LineChart(
  LineChartData(
    lineTouchData: LineTouchData(
      touchTooltipData: TouchTooltipData (
        tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
         .
         .
         .
      )
    )
  )
)
```
##### But if you want more customization on touch behaviors, implement the `touchCallback` and handle it.
```dart

LineChart(
  LineChartData(
    lineTouchData: LineTouchData(
      touchCallback: (LineTouchResponse touchResponse) {
        // handle it
      },
      .
      .
      .
    )
  )
)
```
