import 'package:flutter/material.dart';

class FlTouchInputNotifier extends ValueNotifier<FlTouchInput> {
  FlTouchInputNotifier(FlTouchInput value) : super(value);

}

abstract class FlTouchInput {
  Offset getOffset();
}

class FlLongPressStart extends FlTouchInput {

  final Offset localPosition;

  FlLongPressStart(this.localPosition);

  @override
  Offset getOffset() {
    return localPosition;
  }

}

class FlLongPressMoveUpdate extends FlTouchInput {

  final Offset localPosition;

  FlLongPressMoveUpdate(this.localPosition);

  @override
  Offset getOffset() {
    return localPosition;
  }

}

class FlLongPressEnd extends FlTouchInput {

  final Offset localPosition;

  FlLongPressEnd(this.localPosition);

  @override
  Offset getOffset() {
    return localPosition;
  }

}