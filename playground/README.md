# FL Chart Playground

Interactive demos of the fl_chart properties, embedded in the docs of [flchart.dev](https://flchart.dev/docs):
`/playground/#/LineChartBarData/isCurved` shows a live chart with a control to change `isCurved`,
and the code of the result.

```bash
flutter run -d chrome   # then add #/LineChartBarData/isCurved to the URL
flutter test
```

- `lib/generated/api_registry.g.dart` is generated from the dartdoc by `make docs` (from the
  repository root): the documented classes, their properties, and how to read and copy them.
  The control of each property is chosen from its type (a switch for a `bool`, a dropdown for an
  enum, ...).
- `lib/src/hosts.dart` shows each documented class in a chart (a starting instance, and the chart
  around it).
- `lib/src/hints.dart` tells what the types don't: the range of a number, values to pick for
  other types (gradients, callbacks, ...), and the other properties a demo needs.

`flutter test` renders every value of every control, and prints the properties that have no
control yet.

To see it in the docs, build it into the website: `npm run build:playground` in `../website`.
