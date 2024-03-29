import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/helpers/constants.dart';
import 'package:mekla/widgets/common/asset_button.dart';
import 'package:mekla/widgets/project/servings_icon.dart';

class ServingsEditingButton extends StatelessWidget {
  const ServingsEditingButton({
    super.key,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                strokeAlign: BorderSide.strokeAlignCenter,
                color: Get.theme.colorScheme.secondary),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(Constants.cardBorderRadius),
              bottomLeft: Radius.circular(Constants.cardBorderRadius),
            ),
          ),
          child: SizedBox(
            width: 40,
            height: 40,
            child: AssetButton(
                center: true,
                color: Get.theme.colorScheme.secondary,
                onTap: onDecrement,
                icon: 'back_arrow_icon'),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                strokeAlign: BorderSide.strokeAlignCenter,
                color: Get.theme.colorScheme.secondary),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
            child: ServingsIcon(
                servings: value, color: Get.theme.colorScheme.secondary),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                strokeAlign: BorderSide.strokeAlignCenter,
                color: Get.theme.colorScheme.secondary),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(Constants.cardBorderRadius),
              bottomRight: Radius.circular(Constants.cardBorderRadius),
            ),
          ),
          child: SizedBox(
            width: 40,
            height: 40,
            child: AssetButton(
                color: Get.theme.colorScheme.secondary,
                flip: true,
                center: true,
                onTap: onIncrement,
                icon: 'back_arrow_icon'),
          ),
        )
      ],
    );
  }
}
