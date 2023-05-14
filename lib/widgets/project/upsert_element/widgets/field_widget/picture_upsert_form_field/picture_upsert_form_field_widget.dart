import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mekla/widgets/common/asset_button.dart';
import 'package:mekla/widgets/common/conditional_widget.dart';
import 'package:mekla/widgets/project/upsert_element/models/upsert_from_field.dart';
import 'package:mekla/widgets/project/upsert_element/widgets/field_title.dart';
import 'package:mekla/widgets/project/upsert_element/widgets/field_widget/picture_upsert_form_field/picture_upsert_form_field_controller.dart';

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
                  height: controller.picture != null ? null : 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.5),
                    border: Border.all(color: Get.theme.colorScheme.secondary),
                  ),
                  child: ConditionalWidget(
                    condition: controller.picture != null,
                    child: (context) => AspectRatio(
                      aspectRatio: controller.aspectRatio,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.5),
                              child: Image(
                                image: controller.formField.image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: AssetButton(
                              center: true,
                              onTap: controller.setPicture,
                              icon: 'trash_icon',
                              height: 16,
                              width: 14,
                              color: Get.theme.colorScheme.onSecondary,
                              parentBuilder: (context, child) => Container(
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
                          child: AssetButton(
                            onTap: () =>
                                controller.pickImage(ImageSource.gallery),
                            icon: 'gallery_icon',
                            center: true,
                            color: Get.theme.colorScheme.secondary,
                            height: 30,
                            width: 40,
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
                          child: AssetButton(
                            onTap: () =>
                                controller.pickImage(ImageSource.camera),
                            icon: 'camera_icon',
                            center: true,
                            color: Get.theme.colorScheme.secondary,
                            height: 30,
                            width: 40,
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
