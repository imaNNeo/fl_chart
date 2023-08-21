void main() {

}

String concatAll(List<String> input) {
  String all = '';
  for (final item in input) {
    all += item.toString();
  }

  return all;
}