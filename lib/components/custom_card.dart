import 'package:flutter/material.dart';
import 'package:recipes/decorations/gradient_decoration.dart';

class CustomCard extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool selected;
  final Widget child;
  const CustomCard({super. key, required this.onTap, required this.onLongPress, this.selected=false, required this.child}) ;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(5),
        child: Ink(
          decoration: GradientDecoration.secondary(selected),
          child: InkWell(
            onTap:  onTap,
            onLongPress:  onLongPress,
            child: child
          ),
        ),
      ),
    );
  }
}
