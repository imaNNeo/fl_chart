### DraggableLineChart

A LineChart wrapper that enables drag-to-edit functionality for chart data points.

### How to use
```dart
DraggableLineChart(
  data: LineChartData(
    lineBarsData: [
      LineChartBarData(
        spots: [FlSpot(0, 1), FlSpot(1, 3), FlSpot(2, 2)],
      ),
    ],
    minX: 0,
    maxX: 10,
    minY: 0,
    maxY: 10,
  ),
  onDragStart: (barIndex, spotIndex, spot) {
    // Handle drag start
  },
  onDragUpdate: (barIndex, spotIndex, oldSpot, newSpot) {
    // Update your data model
  },
  onDragEnd: () {
    // Handle drag end
  },
);
```

### Properties
|PropName|Description|default value|
|:-------|:----------|:------------|
|data|[LineChartData](line_chart.md#LineChartData) to display. LineTouchData.enabled is automatically set to false.|required|
|onDragStart|Called when dragging starts. Provides barIndex, spotIndex, and spot coordinates.|null|
|onDragUpdate|Called during dragging (throttled by dragThrottle). Provides barIndex, spotIndex, oldSpot, and newSpot.|null|
|onDragEnd|Called when dragging ends.|null|
|onSpotTap|Called when a spot is tapped (not dragged). Provides barIndex, spotIndex, and spot coordinates.|null|
|canDragSpot|Callback to determine if a spot can be dragged. Return true to allow, false to ignore.|null (all spots draggable)|
|constrainDrag|Callback to constrain/modify drag positions. Return the constrained FlSpot.|null (no constraints)|
|dragTolerance|Maximum distance (in normalized data space) for considering a touch as hitting a spot.|3.5|
|dragThrottle|Minimum time between onDragUpdate callbacks.|Duration(milliseconds: 33)|

### Callbacks

#### DragStartCallback
```dart
void Function(int barIndex, int spotIndex, FlSpot spot)
```
Called when drag begins. Use this to disable scrolling or prepare for drag operations.

#### DragUpdateCallback
```dart
void Function(int barIndex, int spotIndex, FlSpot oldSpot, FlSpot newSpot)
```
Called during dragging. Updates are throttled according to `dragThrottle`. The final position is always sent on drag end (bypassing throttle).

#### DragEndCallback
```dart
void Function()
```
Called when drag ends. Use this to re-enable scrolling or finalize changes.

#### SpotTapCallback
```dart
void Function(int barIndex, int spotIndex, FlSpot spot)
```
Called when a spot is tapped without dragging.

#### CanDragSpotCallback
```dart
bool Function(int barIndex, int spotIndex)
```
Return true to allow dragging the specified spot, false to skip it.

#### ConstrainDragCallback
```dart
FlSpot Function(int barIndex, int spotIndex, FlSpot oldSpot, FlSpot proposedSpot)
```
Modify the proposed drag position to enforce constraints. Return the constrained FlSpot.

### Usage Notes

- Touch handling on the underlying LineChart is automatically disabled
- Drag gestures claim priority early to prevent scroll conflicts
- Use `canDragSpot` for selective dragging (e.g., only selected series)
- Use `constrainDrag` for business rules (e.g., keeping points in order, axis restrictions)
- Coordinate conversion accounts for axis labels and padding automatically

### Example with Constraints
```dart
DraggableLineChart(
  data: lineChartData,
  canDragSpot: (barIndex, spotIndex) {
    // Only allow dragging spots from bar 0
    return barIndex == 0;
  },
  constrainDrag: (barIndex, spotIndex, oldSpot, proposedSpot) {
    // Keep points between min and max
    return FlSpot(
      proposedSpot.x.clamp(0, 10),
      proposedSpot.y.clamp(0, 100),
    );
  },
  onDragUpdate: (barIndex, spotIndex, oldSpot, newSpot) {
    setState(() {
      spots[spotIndex] = newSpot;
    });
  },
);
```

### Sample
##### Draggable Line Chart ([Source Code](/example/lib/presentation/samples/line/draggable_line_chart_sample.dart))
Interactive chart with draggable data points.
