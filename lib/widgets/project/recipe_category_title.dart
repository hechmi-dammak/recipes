import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecipeCategoryTitle extends StatelessWidget {
  const RecipeCategoryTitle({Key? key, required this.name, this.splitRatio = 1})
      : super(key: key);
  final String name;
  final double splitRatio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrain) => Transform.translate(
        offset: Offset(
            constrain.maxWidth * 0.43, constrain.maxHeight * 0.16 / splitRatio),
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            width: constrain.maxWidth * 0.57,
            decoration: BoxDecoration(
                color: Get.theme.colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )),
            child: Text(name,
                style: Get.textTheme.headlineMedium?.copyWith(
                    color: Get.theme.colorScheme.onPrimaryContainer,
                    overflow: TextOverflow.ellipsis))),
      ),
    );
  }
}
