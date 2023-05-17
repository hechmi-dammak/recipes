import 'package:flutter/material.dart';

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
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: Container(
        constraints: hidden
            ? const BoxConstraints(maxWidth: 0.0, maxHeight: 0.0)
            : const BoxConstraints(),
        child: AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: hidden ? 0 : 1,
            child: child),
      ),
    );
  }
}
