import 'package:fl_chart/src/utils/list_wrapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test ListWrapper equality check', () {
    final wrapper1 = ['test1', 'test2'].toWrapperClass();
    final wrapper2 = ['test1', 'test2'].toWrapperClass();
    expect(wrapper1, wrapper2);
  });

  test('test ListWrapper equality check', () {
    final wrapper1 = ['test1', 'test2'].toWrapperClass();
    final wrapper2 = ['test1', 'test2'].toWrapperClass();
    var myMap = <ListWrapper, int>{};
    myMap[wrapper1] = 11;
    expect(myMap.containsKey(wrapper2), true);
  });
}
