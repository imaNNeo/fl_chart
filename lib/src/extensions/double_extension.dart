extension DoubleExtension on double {
  int get precisionCount {
    if (this % 1.0 == 0) {
      return 0;
    }
    final str = toString();
    final eDashIndex = str.indexOf('e-');
    if (eDashIndex > -1) {
      final firstPart = str.substring(0, eDashIndex);
      final firstPartPrecision = double.parse(firstPart).precisionCount;
      final secondPart = str.substring(eDashIndex + 2);
      return firstPartPrecision + int.parse(secondPart);
    }
    return toString().length - 2;
  }
}
