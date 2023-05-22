import 'dart:math' as math;

import 'package:flutter/material.dart';

class CustomSizeTransition extends AnimatedWidget {
  /// Creates a size transition.
  ///
  /// The [axis], [sizeFactor], and [axisAlignment] arguments must not be null.
  /// The [axis] argument defaults to [Axis.vertical]. The [axisAlignment]
  /// defaults to 0.0, which centers the child along the main axis during the
  /// transition.
  const CustomSizeTransition({
    super.key,
    this.axis = Axis.vertical,
    required Animation<double> sizeFactor,
    this.axisAlignment = 0.0,
    this.child,
  }) : super(listenable: sizeFactor);

  /// [Axis.horizontal] if [sizeFactor] modifies the width, otherwise
  /// [Axis.vertical].
  final Axis axis;

  /// The animation that controls the (clipped) size of the child.
  ///
  /// The width or height (depending on the [axis] value) of this widget will be
  /// its intrinsic width or height multiplied by [sizeFactor]'s value at the
  /// current point in the animation.
  ///
  /// If the value of [sizeFactor] is less than one, the child will be clipped
  /// in the appropriate axis.
  Animation<double> get sizeFactor => listenable as Animation<double>;

  /// Describes how to align the child along the axis that [sizeFactor] is
  /// modifying.
  ///
  /// A value of -1.0 indicates the top when [axis] is [Axis.vertical], and the
  /// start when [axis] is [Axis.horizontal]. The start is on the left when the
  /// text direction in effect is [TextDirection.ltr] and on the right when it
  /// is [TextDirection.rtl].
  ///
  /// A value of 1.0 indicates the bottom or end, depending upon the [axis].
  ///
  /// A value of 0.0 (the default) indicates the center for either [axis] value.
  final double axisAlignment;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final AlignmentDirectional alignment;
    if (axis == Axis.vertical) {
      alignment = AlignmentDirectional(-1.0, axisAlignment);
    } else {
      alignment = AlignmentDirectional(axisAlignment, 0.0);
    }
    return ClipRect(
      child: Align(
        alignment: alignment,
        heightFactor:
            axis == Axis.vertical ? math.max(sizeFactor.value, 0.0) : null,
        widthFactor:
            axis == Axis.horizontal ? math.max(sizeFactor.value, 0.0) : null,
        child: child,
      ),
    );
  }
}
