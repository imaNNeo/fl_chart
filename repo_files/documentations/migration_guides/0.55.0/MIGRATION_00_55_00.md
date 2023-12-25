# Migrate to new version

## The ability to rotate the RadarChart titles [#1057](https://github.com/imaNNeo/fl_chart/issues/1057)

We added the ability to customize the rotation angles of the RadarChart titles.  
To do that we add to break one thing and added a new type.

<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/documentations/migration_guides/0.55.0/attachments/radar_chart_sample_1.gif" width="300" >  

**Breaking:**

We only changed [RadarChartData.getTitle](https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/radar_chart.md#RadarChartData).
Its type [GetTitleByIndexFunction] changed from `string Function(int index)` to `RadarChartTitle Function(int index, double angle)`.

To reuse the example from the code:

Previously:
```dart
getTitle: (index) {
  switch (index) {
    case 0:
      return 'Mobile or Tablet';
    case 2:
      return 'Desktop';
    case 1:
      return 'TV';
    default:
      return '';
  }
}
```

Now in new version:

```dart
getTitle: (index, angle) {
  switch (index) {
    case 0:
      return RadarChartTitle(text: 'Mobile or Tablet', angle: angle);
    case 2:
      return RadarChartTitle(text: 'Desktop', angle: angle);
    case 1:
      return RadarChartTitle(text: 'TV', angle: angle);
    default:
      return const RadarChartTitle(text: '');
  }
}
```

If you take the provided `angle` and forward it to the [RadarChartTitle] it will behave like in previous versions.
But you can now render all the titles horizontally by avoiding the [RadarChartTitle.angle] prop (`0` by default).

Apply a relative angle, for example: `RadarChartTitle(text: 'Desktop', angle: angle + 90);`  
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/documentations/migration_guides/0.55.0/attachments/radar_chart_sample_2.png" width="300" >

or an absolute angle, for example: `RadarChartTitle(text: 'Desktop', angle: 90);`  
<img src="https://github.com/imaNNeo/fl_chart/raw/main/repo_files/documentations/migration_guides/0.55.0/attachments/radar_chart_sample_3.png" width="300" >