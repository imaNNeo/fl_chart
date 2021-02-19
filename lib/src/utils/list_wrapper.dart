import 'package:equatable/equatable.dart';

/// Wraps a list as a property
///
/// We needed to use list as key for Maps.
/// But in dart, List doesn't implement hashCode and equals functions.
/// That is a workaround to solve the problem.
/// Issue link: https://github.com/dart-lang/sdk/issues/17963
class ListWrapper<T> with EquatableMixin {
  final List<T> list;

  ListWrapper(this.list);

  @override
  List<Object?> get props => [list];
}

/// An Extension to convert a List into ListWrapper class
extension ListExtension<T> on List<T> {
  /// Converts List into ListWrapper class
  ListWrapper<T> toWrapperClass() => ListWrapper<T>(this);
}
