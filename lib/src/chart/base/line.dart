import 'package:flutter/painting.dart';

/// Describes a line model (contains [from], and end [to])
class Line {
  /// Start of the line
  final Offset from;

  /// End of the line
  final Offset to;

  Line(this.from, this.to);
}
