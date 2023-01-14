import 'package:flutter/material.dart';

class ConditionalWidget extends StatelessWidget {
  final Widget child;
  final Widget? secondChild;
  final bool condition;

  const ConditionalWidget(
      {super.key,
      required this.child,
      required this.condition,
      this.secondChild});

  @override
  Widget build(BuildContext context) {
    return condition ? child : (secondChild ?? Container());
  }
}
