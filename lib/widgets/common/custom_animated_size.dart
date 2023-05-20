import 'package:flutter/material.dart';
import 'package:mekla/widgets/common/custom_size_transition.dart';

class CustomAnimatedSize extends ImplicitlyAnimatedWidget {
  const CustomAnimatedSize({
    super.key,
    this.child,
    this.hide = false,
    this.axis = Axis.vertical,
    super.curve,
    required super.duration,
    super.onEnd,
  });

  final Axis axis;

  final Widget? child;

  final bool hide;

  @override
  ImplicitlyAnimatedWidgetState<CustomAnimatedSize> createState() =>
      _CustomAnimatedSizeState();
}

class _CustomAnimatedSizeState
    extends ImplicitlyAnimatedWidgetState<CustomAnimatedSize> {
  Tween<double>? _size;
  late Animation<double> _sizeAnimation;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _size = visitor(_size, widget.hide ? 0.0 : 1.0,
            (dynamic value) => Tween<double>(begin: value as double))
        as Tween<double>?;
  }

  @override
  void didUpdateTweens() {
    _sizeAnimation = animation.drive(_size!);
  }

  @override
  Widget build(BuildContext context) {
    return CustomSizeTransition(
      axis: widget.axis,
      sizeFactor: _sizeAnimation,
      child: widget.child,
    );
  }
}
