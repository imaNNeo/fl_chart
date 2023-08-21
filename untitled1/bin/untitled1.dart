import 'package:untitled1/untitled1.dart' as untitled1;

void main(List<String> arguments) {
  print(concatAll([1.123, 1, 3]));
}

String concatAll(List<int> items) {
  String all = '';
  for (final item in items) {
    all += item.toString();
  }
  return all;
}

