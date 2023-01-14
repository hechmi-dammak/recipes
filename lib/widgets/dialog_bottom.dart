import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

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
          icon: SvgPicture.asset(
            'assets/icons/confirm_icon.svg',
            fit: BoxFit.scaleDown,
            height: 25,
            color: Get.theme.colorScheme.onPrimary,
            width: 25,
          ),
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
          icon: SvgPicture.asset(
            'assets/icons/cancel_icon.svg',
            fit: BoxFit.scaleDown,
            color: Get.theme.colorScheme.onSecondary,
            height: 25,
            width: 25,
          ),
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
        onTap: onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: isLeft ? const Radius.circular(6.5) : Radius.zero,
                  bottomRight:
                      isRight ? const Radius.circular(6.5) : Radius.zero)),
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
