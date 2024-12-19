# Migrate to version 0.70.0

## Fixed the equatable functionality in our PieChartSectionData
Please check any code that compares `PieChartSectionData` classes or other objects containing `PieChartSectionData` and make sure it is not affected by this change.

## `BarChart` is not const anymore
We added an assert to check if transformations are allowed depending on the `BarChartData.alignment` property. If you are using `BarChart` as a const, you need to remove the const keyword from the `BarChart` constructor. The compiler will show you an error if you try to use `BarChart` as a const.
