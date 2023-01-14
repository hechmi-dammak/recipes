import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes/helpers/form_validators.dart';
import 'package:recipes/helpers/input_decoration.dart';
import 'package:recipes/views/recipe_category/widgets/add_recipe_category/add_recipe_category_controller.dart';
import 'package:recipes/widgets/conditional_widget.dart';
import 'package:recipes/widgets/custom_dialog.dart';
import 'package:recipes/widgets/dialog_bottom.dart';

class AddRecipeCategoryDialog extends CustomDialog<bool> {
  const AddRecipeCategoryDialog({super.key}) : super(dismissible: false);

  @override
  Widget buildChild(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Get.theme.colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(6.5),
                  topLeft: Radius.circular(6.5))),
          padding: const EdgeInsets.all(30),
          constraints: BoxConstraints(maxHeight: Get.height * .45),
          child: const SingleChildScrollView(
            child: AddRecipeCategoryForm(),
          ),
        ),
        DialogBottom(
          onConfirm: () => AddRecipeCategoryController.find.confirm(close),
          onCancel: () => close(false, true),
        )
      ],
    );
  }
}

class AddRecipeCategoryForm extends StatelessWidget {
  const AddRecipeCategoryForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddRecipeCategoryController>(
        init: AddRecipeCategoryController(),
        builder: (controller) {
          return Form(
            key: controller.formKey,
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
                  controller: controller.nameController,
                  style: Get.textTheme.bodyLarge,
                  decoration: CustomInputDecoration(),
                  validator: FormValidators.notEmptyOrNullValidator,
                ),
                const SizedBox(height: 15),
                Text(
                  'Description:'.tr,
                  style: Get.textTheme.bodyLarge,
                ),
                const SizedBox(height: 7),
                TextFormField(
                  controller: controller.descriptionController,
                  maxLines: null,
                  style: Get.textTheme.bodyLarge,
                  decoration: CustomInputDecoration(),
                ),
                const SizedBox(height: 15),
                Text(
                  'Image:'.tr,
                  style: Get.textTheme.bodyLarge,
                ),
                const SizedBox(height: 7),
                AnimatedContainer(
                  height: controller.picture == null ? 60 : null,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.5),
                    border: Border.all(color: Get.theme.colorScheme.secondary),
                  ),
                  duration: const Duration(seconds: 1),
                  child: ConditionalWidget(
                    condition: controller.picture == null,
                    secondChild: (context) => AspectRatio(
                      aspectRatio: 2,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6.5),
                            child: Image.memory(
                              controller.picture!.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: controller.clearImage,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Get.theme.colorScheme.secondary),
                                  child: SvgPicture.asset(
                                      'assets/icons/trash_icon.svg',
                                      fit: BoxFit.scaleDown,
                                      height: 16,
                                      width: 14,
                                      color: Get.theme.colorScheme.onSecondary),
                                ),
                              ))
                        ],
                      ),
                    ),
                    child: (context) => Row(
                      children: [
                        Flexible(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () =>
                                controller.pickImage(ImageSource.gallery),
                            child: SizedBox(
                              // width: double.infinity,
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/icons/gallery_icon.svg',
                                  color: Get.theme.colorScheme.secondary,
                                  height: 30,
                                  width: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                        VerticalDivider(
                          indent: 7,
                          endIndent: 7,
                          width: 1,
                          thickness: 1,
                          color: Get.theme.colorScheme.secondary,
                        ),
                        Flexible(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () =>
                                controller.pickImage(ImageSource.camera),
                            child: SizedBox(
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/icons/camera_icon.svg',
                                  color: Get.theme.colorScheme.secondary,
                                  height: 30,
                                  width: 40,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
