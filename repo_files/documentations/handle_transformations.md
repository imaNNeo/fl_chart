# FL Chart Transformation Guide

The transformation feature in `fl_chart` allows users to interact with charts through scaling and panning, similar to Flutter's `InteractiveViewer` widget.

## Basic Usage

To enable transformations, provide a `FlTransformationConfig` to your chart:

```dart
LineChart(
  LineChartData(...),
  transformationConfig: FlTransformationConfig(
    scaleAxis: FlScaleAxis.horizontal,
    minScale: 1.0,
    maxScale: 2.5,
  ),
)
```

### Configuration Options
See [FlTransformationConfig](https://github.com/imaNNeo/fl_chart/blob/main/lib/src/chart/base/axis_chart/transformation_config.dart) for more information.

### Chart-Specific Limitations

- **Bar Chart**: When using `BarChartAlignment.center`, `end`, or `start`, horizontal scaling is not supported
- **Line Chart**: Supports all transformation types
- **Scatter Chart**: Supports all transformation types

## Advanced Usage: Custom Transformation Controller

For more control over transformations, you can provide a `TransformationController`. This allows you to:
- Programmatically control the chart's transformation
- Reset to initial state
- Implement custom zoom/pan controls

### Limitations
At this moment, transformations made with a custom `TransformationController` are not prevented from moving the chart out of the screen. Developers are responsible for ensuring that the chart remains within the visible area and within the transformation limits. 

See the implementation of [AxisChartScaffoldWidget](https://github.com/imaNNeo/fl_chart/blob/main/lib/src/chart/base/axis_chart/axis_chart_scaffold_widget.dart) for how to prevent the chart from moving out of the screen when using a custom `TransformationController`.

### Example Implementation

```dart
class ChartWithControls extends StatefulWidget {
  @override
  State<ChartWithControls> createState() => _ChartWithControlsState();
}

class _ChartWithControlsState extends State<ChartWithControls> {
  late TransformationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TransformationController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.4,
          child: LineChart(
            LineChartData(...),
            transformationConfig: FlTransformationConfig(
              scaleAxis: FlScaleAxis.horizontal,
              minScale: 1.0,
              maxScale: 25.0,
              transformationController: _controller,
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.zoom_in),
              onPressed: () {
                _controller.value *= Matrix4.diagonal3Values(1.1, 1.1, 1);
              },
            ),
            IconButton(
              icon: Icon(Icons.zoom_out),
              onPressed: () {
                _controller.value *= Matrix4.diagonal3Values(0.9, 0.9, 1);
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _controller.value = Matrix4.identity();
              },
            ),
          ],
        ),
      ],
    );
  }
}
```

### Common Transformation Operations
See [Matrix4](https://pub.dev/documentation/vector_math/latest/vector_math_64/Matrix4-class.html) for more information on how to manipulate the matrix.

## Best Practices

1. Always dispose of the `TransformationController` when you're done with it
2. Set appropriate `minScale` and `maxScale` values to prevent excessive zooming
3. Consider your chart's alignment when choosing a `scaleAxis`
4. Provide visual feedback for transformation limits
5. Consider adding reset functionality for better user experience
6. If you have touch indicators, consider allowing users to disable panning when zoomed in. This way the touch indicators will be shown when users hold and drag to explore the chart's data, instead of panning the chart.

Remember that transformations are purely visual and don't affect the underlying data. They're particularly useful for exploring detailed data sets or allowing users to focus on specific regions of interest in your charts.
