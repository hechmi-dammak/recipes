import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes/decorator/controller.dart';
import 'package:recipes/widgets/common/conditional_widget.dart';
import 'package:recipes/widgets/common/svg_button.dart';

class ImagePickerFormDialog<T extends Controller> extends StatelessWidget {
  const ImagePickerFormDialog({Key? key, this.aspectRatio = 2})
      : super(key: key);
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(builder: (controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Image:'.tr,
            style: Get.textTheme.bodyLarge,
          ),
          const SizedBox(height: 7),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: Container(
              height: controller.getPicture() == null ? 60 : null,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.5),
                border: Border.all(color: Get.theme.colorScheme.secondary),
              ),
              child: ConditionalWidget(
                condition: controller.getPicture() == null,
                secondChild: (context) => AspectRatio(
                  aspectRatio: aspectRatio,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.5),
                          child: Image.memory(
                            controller.getPicture()!.image,
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
                child: (context) => Row(
                  children: [
                    Flexible(
                      child: SvgButton(
                        onTap: () => controller.pickImage(ImageSource.gallery,
                            aspectRatio: aspectRatio),
                        icon: 'assets/icons/gallery_icon.svg',
                        center: true,
                        iconColor: Get.theme.colorScheme.secondary,
                        iconHeight: 30,
                        iconWidth: 40,
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
                        onTap: () => controller.pickImage(ImageSource.camera,
                            aspectRatio: aspectRatio),
                        icon: 'assets/icons/camera_icon.svg',
                        center: true,
                        iconColor: Get.theme.colorScheme.secondary,
                        iconHeight: 30,
                        iconWidth: 40,
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
