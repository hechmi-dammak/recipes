import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:recipes/helpers/input_decoration.dart';
import 'package:recipes/views/recipe_category/widgets/add_recipe_category/add_recipe_cateogry_controller.dart';
import 'package:recipes/widgets/custom_dialog.dart';
import 'package:recipes/widgets/dialog_buttom.dart';

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
                constraints: BoxConstraints(maxHeight: Get.height * .5),
                child: const SingleChildScrollView(
                  child: AddRecipeCategoryForm(),
                ),
              ),
              DialogBottom(
                onConfirm: () =>
                    AddRecipeCategoryController.find.confirm(close),
                onCancel: () => close(false, true),
              )
            ],
          ),
        ));
  }
}

class AddRecipeCategoryForm extends StatelessWidget {
  const AddRecipeCategoryForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
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
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.5),
              border: Border.all(color: Get.theme.colorScheme.secondary),
            ),
            child: Row(
              children: [
                Flexible(
                  child: GestureDetector(
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/gallery_icon.svg',
                          color: Get.theme.colorScheme.secondary,
                          height: 25.5,
                          width: 38,
                        ),
                      ),
                    ),
                  ),
                ),
                VerticalDivider(
                  indent: 7,
                  endIndent: 7,
                  width: 2,
                  thickness: 2,
                  color: Get.theme.colorScheme.secondary,
                ),
                Flexible(
                  child: GestureDetector(
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/camera_icon.svg',
                          color: Get.theme.colorScheme.secondary,
                          height: 25,
                          width: 35,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
