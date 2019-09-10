import 'package:flutter/material.dart';

class FlTouchInputNotifier extends ValueNotifier<FlTouchInput> {
  FlTouchInputNotifier(FlTouchInput value) : super(value);
}

abstract class FlTouchInput {
  Offset getOffset();
}

abstract class FlTouchLongInput extends FlTouchInput {}

class FlLongPressStart extends FlTouchLongInput {
  final Offset localPosition;

  FlLongPressStart(this.localPosition);

  @override
  Offset getOffset() {
    return localPosition;
  }
}

class FlLongPressMoveUpdate extends FlTouchLongInput {
  final Offset localPosition;

  FlLongPressMoveUpdate(this.localPosition);

  @override
  Offset getOffset() {
    return localPosition;
  }
}

class FlLongPressEnd extends FlTouchLongInput {
  final Offset localPosition;

  FlLongPressEnd(this.localPosition);

  @override
  Offset getOffset() {
    return localPosition;
  }
}

abstract class FlTouchNormapInput extends FlTouchInput {}

class FlPanStart extends FlTouchNormapInput {
  final Offset localPosition;

  FlPanStart(this.localPosition);

  @override
  Offset getOffset() {
    return localPosition;
  }
}

class FlPanMoveUpdate extends FlTouchNormapInput {
  final Offset localPosition;

  FlPanMoveUpdate(this.localPosition);

  @override
  Offset getOffset() {
    return localPosition;
  }
}

class FlPanEnd extends FlTouchNormapInput {
  final Offset localPosition;

  FlPanEnd(this.localPosition);

  @override
  Offset getOffset() {
    return localPosition;
  }
}

class NonTouch extends FlTouchInput {
  @override
  Offset getOffset() {
    return null;
  }
}
