### Animations
|Sample1	|Sample2		|Sample3		|
|:------------:|:------------:|:-------------:|
|	[![](https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/line_chart/line_chart_sample_1_anim.gif)](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/line_chart.md#sample-1-source-code)   |	[![](https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/line_chart/line_chart_sample_2_anim.gif)](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/line_chart.md#sample-2-source-code) | [![](https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/bar_chart/bar_chart_sample_1_anim.gif)](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/bar_chart.md#sample-1-source-code) |

##### How?
We handle all animations Implicitly, This is power of the [ImplicitlyAnimatedWidget](https://api.flutter.dev/flutter/widgets/ImplicitlyAnimatedWidget-class.html), just like [AnimatedContainer](https://api.flutter.dev/flutter/widgets/AnimatedContainer-class.html). It means you don't need to do anything, just change any value and the animation is handled under the hood, if you are curious about it, check the source code, reading the source code is the best way to learn things.


##### Properties
You can change the [Duration](https://api.flutter.dev/flutter/dart-core/Duration-class.html) and [Curve](https://api.flutter.dev/flutter/animation/Curves-class.html) of animation using `duration` and `curve` properties respectively.

```dart
LineChart(
  duration: Duration(milliseconds: 150),
  curve: Curves.linear,
  LineChartData(
    isShowingMainData ? sampleData1() : sampleData2(),
  ),
)
```

##### How to disable

If you want to disable the animations, you can set `Duration.zero` as `duration`.
```dart 
LineChart(
  duration: Duration.zero,
  LineChartData(
    // Your chart data here
  ),
)

