# Migrate to new version

## Replaced tooltipBgColor

**Breaking: [#1595](https://github.com/imaNNeo/fl_chart/pull/1595)**

We added the ability to customize the tooltip background color for each point.

The property `Color tooltipBgColor` from Bar, Line and Scatter Charts is replaced with a callback `Color Function(spot) getTooltipColor`

#### BarChartData

Previously:
```dart
BarChartData(
  barTouchData: BarTouchData(
    touchTooltipData: BarTouchTooltipData(
      tooltipBgColor: Colors.blueGrey,
    )
  )
)
```

Now in new version:

```dart
BarChartData(
  barTouchData: BarTouchData(
    touchTooltipData: BarTouchTooltipData(
      getTooltipColor: (BarChartGroupData group) => Colors.blueGrey,
    )
  )
)
```

#### LineChartData

Previously:
```dart
LineChartData(
  lineTouchData: LineTouchData(
    touchTooltipData: LineTouchTooltipData(
      tooltipBgColor: Colors.blueGrey,
    )
  )
)
```

Now in new version:

```dart
LineChartData(
  lineTouchData: LineTouchData(
    touchTooltipData: LineTouchTooltipData(
      getTooltipColor: (LineBarSpot touchedSpot) => Colors.blueGrey,
    )
  )
)
```

#### ScatterChartData

Previously:
```dart
ScatterChartData(
  scatterTouchData: ScatterTouchData(
    touchTooltipData: ScatterTouchTooltipData(
      tooltipBgColor: Colors.blueGrey,
    )
  )
)
```

Now in new version:

```dart
ScatterChartData(
  scatterTouchData: ScatterTouchData(
    touchTooltipData: ScatterTouchTooltipData(
      getTooltipColor: (ScatterSpot touchedBarSpot) => Colors.blueGrey,
    )
  )
)
```

