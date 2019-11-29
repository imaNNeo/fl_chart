import 'package:flutter/material.dart';

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

abstract class FlTouchNormalInput extends FlTouchInput {}

class FlPanStart extends FlTouchNormalInput {
  final Offset localPosition;

  FlPanStart(this.localPosition);

  @override
  Offset getOffset() {
    return localPosition;
  }
}

class FlPanMoveUpdate extends FlTouchNormalInput {
  final Offset localPosition;

  FlPanMoveUpdate(this.localPosition);

  @override
  Offset getOffset() {
    return localPosition;
  }
}

class FlPanEnd extends FlTouchNormalInput {
  final Offset localPosition;
  final Velocity velocity;

  FlPanEnd(this.localPosition, this.velocity,);

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
