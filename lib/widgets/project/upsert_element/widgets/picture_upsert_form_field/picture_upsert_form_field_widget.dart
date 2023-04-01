import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes/widgets/common/conditional_widget.dart';
import 'package:recipes/widgets/common/svg_button.dart';
import 'package:recipes/widgets/project/upsert_element/models/upsert_from_field.dart';
import 'package:recipes/widgets/project/upsert_element/widgets/field_title.dart';
import 'package:recipes/widgets/project/upsert_element/widgets/picture_upsert_form_field/picture_upsert_form_field_controller.dart';

class PictureUpsertFormFieldWidget extends StatelessWidget {
  const PictureUpsertFormFieldWidget({Key? key, required this.formField})
      : super(key: key);
  final PictureUpsertFormField formField;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PictureUpsertFormFieldController>(
        init: PictureUpsertFormFieldController(formField: formField),
        tag: formField.name,
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FieldTitle(
                title: formField.label.tr,
                optional: formField.optional,
              ),
              const SizedBox(height: 7),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  height: controller.pictureIsSet ? null : 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.5),
                    border: Border.all(color: Get.theme.colorScheme.secondary),
                  ),
                  child: ConditionalWidget(
                    condition: controller.pictureIsSet,
                    child: (context) => AspectRatio(
                      aspectRatio: controller.aspectRatio,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.5),
                              child: Image.memory(
                                controller.picture!.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: SvgButton(
                              onTap: controller.clearImage,
                              icon: 'assets/icons/trash_icon.svg',
                              iconHeight: 16,
                              iconWidth: 14,
                              iconColor: Get.theme.colorScheme.onSecondary,
                              parentBuilder: (child) => Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Get.theme.colorScheme.secondary),
                                child: child,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    secondChild: (context) => Row(
                      children: [
                        Flexible(
                          child: SvgButton(
                            onTap: () =>
                                controller.pickImage(ImageSource.gallery),
                            icon: 'assets/icons/gallery_icon.svg',
                            center: true,
                            iconColor: Get.theme.colorScheme.secondary,
                            iconHeight: 30,
                            iconWidth: 40,
                            scaleDown: false,
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
                          child: SvgButton(
                            onTap: () =>
                                controller.pickImage(ImageSource.camera),
                            icon: 'assets/icons/camera_icon.svg',
                            center: true,
                            iconColor: Get.theme.colorScheme.secondary,
                            iconHeight: 30,
                            iconWidth: 40,
                            scaleDown: false,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }
}
