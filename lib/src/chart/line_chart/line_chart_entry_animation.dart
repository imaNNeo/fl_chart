enum LineChartEntryAnimation {
  original,
  leftToRightSlideAll,
  leftToRightSlideWithoutPoints;

  bool get isSlideAnimation =>
      this == LineChartEntryAnimation.leftToRightSlideAll ||
      this == LineChartEntryAnimation.leftToRightSlideWithoutPoints;
}
