import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final Color backgroundColor;

  const CustomCard(
      {Key? key,
      this.onTap,
      required this.child,
      required this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.5), color: backgroundColor),
          child: child),
    );
  }
}
