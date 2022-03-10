import 'dart:math';

extension ListExtension<T> on List<T> {
  T get randomElement => this[Random().nextInt(length)];
}
