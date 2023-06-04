import 'package:flutter/material.dart';

class ConditionalWidget extends StatelessWidget {
  final WidgetBuilder child;
  final WidgetBuilder? secondChild;
  final bool condition;
  final bool animated;
  final Duration duration;

  const ConditionalWidget(
      {super.key,
      required this.child,
      required this.condition,
      this.secondChild,
      this.animated = false,
      this.duration = const Duration(milliseconds: 300)});

  @override
  Widget build(BuildContext context) {
    if (animated) {
      return AnimatedSwitcher(
          duration: duration,
          child: condition ? child(context) : secondChild?.call(context));
    }

    return condition
        ? child(context)
        : (secondChild?.call(context) ?? Container());
  }
}
