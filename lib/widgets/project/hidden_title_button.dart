import 'package:flutter/material.dart';
import 'package:mekla/widgets/common/custom_animated_size.dart';

class HiddenTitleButton extends StatelessWidget {
  const HiddenTitleButton({
    super.key,
    required this.hidden,
    required this.child,
  });

  final bool hidden;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomAnimatedSize(
      axis: Axis.horizontal,
      hide: hidden,
      duration: const Duration(milliseconds: 200),
      child: child,
    );
  }
}
