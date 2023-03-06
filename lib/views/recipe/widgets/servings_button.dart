import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/views/recipe/widgets/servings_icon.dart';

class ServingsButton extends StatelessWidget {
  const ServingsButton({
    super.key,
    required this.servings,
    required this.onTap,
  });

  final VoidCallback onTap;
  final int servings;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ServingsIcon(
        servings: servings,
        color: Get.theme.colorScheme.onPrimary,
      ),
    );
  }
}
