import 'package:flutter/material.dart';

class ConditionalWidget extends StatelessWidget {
  final WidgetBuilder child;
  final WidgetBuilder? secondChild;
  final bool condition;

  const ConditionalWidget(
      {super.key,
      required this.child,
      required this.condition,
      this.secondChild});

  @override
  Widget build(BuildContext context) {
    return condition
        ? child(context)
        : (secondChild?.call(context) ?? Container());
  }
}
