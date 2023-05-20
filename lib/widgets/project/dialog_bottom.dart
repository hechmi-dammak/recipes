import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/helpers/constants.dart';
import 'package:mekla/services/asset_service.dart';

class DialogBottom extends StatelessWidget {
  const DialogBottom(
      {super.key, required this.onConfirm, required this.onCancel});

  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DialogButton(
          isLeft: true,
          onTap: onConfirm,
          icon: Image(
              image: AssetService.assets['confirm_icon']!,
              height: 25,
              width: 25,
              colorBlendMode: BlendMode.srcIn,
              color: Get.theme.colorScheme.onPrimary,
              fit: BoxFit.contain),
          text: Text(
            'Confirm'.tr,
            style: Get.textTheme.displayMedium
                ?.copyWith(color: Get.theme.colorScheme.onPrimary),
          ),
          backgroundColor: Get.theme.colorScheme.primary,
        ),
        DialogButton(
          isRight: true,
          onTap: onCancel,
          icon: Image(
              image: AssetService.assets['cancel_icon']!,
              height: 25,
              width: 25,
              colorBlendMode: BlendMode.srcIn,
              color: Get.theme.colorScheme.onSecondary,
              fit: BoxFit.contain),
          text: Text(
            'Cancel'.tr,
            style: Get.textTheme.displayMedium
                ?.copyWith(color: Get.theme.colorScheme.onSecondary),
          ),
          backgroundColor: Get.theme.colorScheme.secondary,
        ),
      ],
    );
  }
}

class DialogButton extends StatelessWidget {
  const DialogButton(
      {super.key,
      required this.icon,
      required this.text,
      required this.backgroundColor,
      required this.onTap,
      this.isLeft = false,
      this.isRight = false});

  final Widget icon;
  final Widget text;
  final Color backgroundColor;
  final bool isLeft;
  final bool isRight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: isLeft
                      ? const Radius.circular(Constants.cardBorderRadius)
                      : Radius.zero,
                  bottomRight: isRight
                      ? const Radius.circular(Constants.cardBorderRadius)
                      : Radius.zero)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(
                width: 5,
              ),
              text
            ],
          ),
        ),
      ),
    );
  }
}
