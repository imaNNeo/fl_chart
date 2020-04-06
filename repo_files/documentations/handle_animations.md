### Animations
|Sample1	|Sample2		|Sample3		|
|:------------:|:------------:|:-------------:|
|	[![](https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_1_anim.gif)](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#sample-1-source-code)   |	[![](https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/line_chart/line_chart_sample_2_anim.gif)](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/line_chart.md#sample-2-source-code) | [![](https://github.com/imaNNeoFighT/fl_chart/raw/master/repo_files/images/bar_chart/bar_chart_sample_1_anim.gif)](https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md#sample-1-source-code) |

##### How?
We handle all animations Implicitly, This is power of the [ImplicitlyAnimatedWidget](https://api.flutter.dev/flutter/widgets/ImplicitlyAnimatedWidget-class.html), just like [AnimatedContainer](https://api.flutter.dev/flutter/widgets/AnimatedContainer-class.html). It means you don't need to do anything, just change any value and the animation is handled under the hood, if you are curious about it, check the source code, reading the source code is the best way to learn things.


##### Duration
we added an optional argument in the `FlChart` class called  `swapAnimationDuration`, this is a [Duration](https://api.flutter.dev/flutter/dart-core/Duration-class.html) class that you can set the duration of the animation. the default value is `150 ms`, you can change it to fit your requirements.
```dart
LineChart(
  swapAnimationDuration: Duration(milliseconds: 150),
  LineChartData(
    isShowingMainData ? sampleData1() : sampleData2(),
  ),
)
```

##### How to disable

If you want to disable animation, I you should set the duration `0`.
