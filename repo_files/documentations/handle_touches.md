### Touch Interactivity

|LineChart	|BarChart		|PieChart		|
|:------------:|:------------:|:-------------:|
|	[![](https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_1.gif)](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#sample-1-source-code) [![](https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_2.gif)](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#sample-2-source-code)  |	[![](https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart_sample_1.gif)](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#sample-1-source-code) [![](https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart_sample_2.gif)](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#sample-2-source-code)  | [![](https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/pie_chart/pie_chart_sample_1.gif)](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/pie_chart.md#sample-1-source-code) [![](https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/pie_chart/pie_chart_sample_2.gif)](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/pie_chart.md#sample-2-source-code)  |



#### The Touch Flow
When user touches on the chart, a touch event notifies to the chart's painter through a [ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) that contains a concrete [TouchInput](base_chart.md#FlTouchInput) that describes the type and details of the touch, then the specific chart detects the touched area and makes an object that contains touch informations, then some basic touch visualized effects will be apply, and finally it creates a concrete [TouchResponse](base_chart.md#BaseTouchResponse) and sends it through a given [StreamSink](https://api.flutter.dev/flutter/dart-async/StreamSink-class.html),

if you want to handle touch events, you should create a [StreamController](https://api.flutter.dev/flutter/dart-async/StreamController-class.html) in your [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html) (don't forget to dispose the StreamController on [dispose method](https://api.flutter.dev/flutter/widgets/State/dispose.html)),  pass the `controller.sink` to the chart's TouchData (inside the ChartData), then listen to it distinctly and do what you want to do with the given `TouchResponse` (for example change the touched section color or something like that).


#### How to use? (for example in `LineChart`)
##### In the Line and Bar Charts we show a built in tooltip on the touched spots, then you just need to config how to show it, just fill the `touchTooltipData` in the `LineTouchData`.
#####
```
FlChart(
  chart: LineChart(
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
)
```
##### But if you want more customization on touch behaviors, make a `StreamController<LineTouchResponse>`, and pass it's `sink` to the chart and then listen to coming touch details(here contains the touched **Spots**, **BarLine**, and [TouchInput](base_chart.md#FlTouchInput))
```
StreamController<LineTouchResponse> controller;

@override
void initState() {
  super.initState();
  controller = StreamController();
  controller.stream.distinct().listen((LineTouchResponse response){
    /// do whatever you want and change any property of the chart.
  });
}

@override
Widget build(BuildContext context) {
  return FlChart(
    chart: LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchResponseSink: controller.sink,
          .
          .
          .
        )
      )
    )
  )
}
```

