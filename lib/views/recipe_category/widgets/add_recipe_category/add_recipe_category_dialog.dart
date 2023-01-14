import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:recipes/helpers/input_decoration.dart';
import 'package:recipes/views/recipe_category/widgets/add_recipe_category/add_recipe_cateogry_controller.dart';
import 'package:recipes/widgets/custom_dialog.dart';

class AddRecipeCategoryDialog extends CustomDialog<bool> {
  const AddRecipeCategoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
              color: Get.theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(6.5)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                constraints: BoxConstraints(maxHeight: Get.height * .4),
                child: SingleChildScrollView(
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Name:'.tr,
                          style: Get.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 7),
                        TextFormField(
                          style: Get.textTheme.bodyLarge,
                          decoration: CustomInputDecoration(),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Description:'.tr,
                          style: Get.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 7),
                        TextFormField(
                          maxLines: null,
                          style: Get.textTheme.bodyLarge,
                          decoration: CustomInputDecoration(),
                        ),
                        Text(
                          'Image:'.tr,
                          style: Get.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 7),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21),
                              border: Border.all(
                                  color: Get.theme.colorScheme.secondary)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/gallery_icon.svg',
                                color: Get.theme.colorScheme.secondary,
                                height: 25.5,
                                width: 38,
                              ),
                              SvgPicture.asset(
                                'assets/icons/camera_icon.svg',
                                color: Get.theme.colorScheme.secondary,
                                height: 25,
                                width: 35,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  DialogButton.left(
                    onTap: () =>
                        AddRecipeCategoryController.find.confirm(close),
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
                  DialogButton.right(
                    onTap: () => close(false, true),
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
              )
            ],
          ),
        ));
  }
}

class DialogButton extends StatelessWidget {
  const DialogButton.left({
    super.key,
    required this.icon,
    required this.text,
    required this.backgroundColor,
    required this.onTap,
  })  : isLeft = true,
        isRight = false;

  const DialogButton.right({
    super.key,
    required this.icon,
    required this.text,
    required this.backgroundColor,
    required this.onTap,
  })  : isLeft = false,
        isRight = true;

  const DialogButton.all({
    super.key,
    required this.icon,
    required this.text,
    required this.backgroundColor,
    required this.onTap,
  })  : isLeft = true,
        isRight = true;

  const DialogButton({
    super.key,
    required this.icon,
    required this.text,
    required this.backgroundColor,
    required this.onTap,
  })  : isLeft = false,
        isRight = false;
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
