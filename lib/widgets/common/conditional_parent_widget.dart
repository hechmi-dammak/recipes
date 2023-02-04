import 'package:flutter/material.dart';

typedef ParentChildBuilder = Widget Function(Widget child);

class ConditionalParentWidget extends StatelessWidget {
  const ConditionalParentWidget({
    super.key,
    required this.condition,
    required this.child,
    required this.parentBuilder,
  });

  final Widget child;

  final bool condition;

  final ParentChildBuilder parentBuilder;

  @override
  Widget build(BuildContext context) {
    return condition ? parentBuilder(child) : child;
  }
}
