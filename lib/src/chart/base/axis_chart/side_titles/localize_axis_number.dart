import 'package:intl/number_symbols.dart';

/// Uses the locale's number symbols on an already rounded axis label.
String localizeAxisNumber(String label, NumberSymbols symbols) {
  final zero = symbols.ZERO_DIGIT.codeUnitAt(0);
  if (zero == 48 && symbols.DECIMAL_SEP == '.' && symbols.MINUS_SIGN == '-') {
    return label;
  }
  final result = StringBuffer();
  for (final unit in label.codeUnits) {
    if (unit >= 48 && unit <= 57) {
      result.writeCharCode(zero + unit - 48);
    } else if (unit == 46) {
      result.write(symbols.DECIMAL_SEP);
    } else if (unit == 45) {
      result.write(symbols.MINUS_SIGN);
    } else {
      result.writeCharCode(unit);
    }
  }
  return result.toString();
}
