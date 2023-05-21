import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/views/recipes/recipes_controller.dart';
import 'package:mekla/widgets/common/asset_button.dart';

class PopUpMenuButton extends GetView<RecipesController> {
  const PopUpMenuButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipesController>(builder: (controller) {
      return PopupMenuButton<int>(
        offset: const Offset(0, kToolbarHeight),
        child: const AssetButton(
          center: true,
          icon: 'menu_icon',
        ),
        onSelected: (item) => controller.selectedItemMenu(item),
        itemBuilder: (BuildContext context) {
          return [
            CustomPopupMenuItem(
              icon: Icons.upload_file_rounded,
              value: 0,
              title: 'Import From File'.tr,
            ),
            if (controller.items.isEmpty)
              CustomPopupMenuItem(
                icon: Icons.download,
                value: 1,
                title: 'Import from library'.tr,
              ),
            CustomPopupMenuItem(
              assetIcon: 'scale_icon',
              value: 2,
              title: 'Ingredients'.tr,
            ),
            CustomPopupMenuItem(
              assetIcon: 'category_icon',
              value: 3,
              title: 'Recipe Categories'.tr,
            ),
            CustomPopupMenuItem(
              assetIcon: 'category_icon',
              value: 4,
              title: 'Ingredient Categories'.tr,
            ),
          ];
        },
      );
    });
  }
}

class CustomPopupMenuItem extends PopupMenuItem<int> {
  CustomPopupMenuItem(
      {super.key,
      String? assetIcon,
      IconData? icon,
      required int value,
      required String title})
      : super(
            value: value,
            child: Row(
              children: [
                if (assetIcon != null)
                  AssetButton(
                    center: true,
                    icon: assetIcon,
                    color: Get.theme.colorScheme.secondary,
                  ),
                if (icon != null)
                  Icon(
                    icon,
                    size: 20,
                    color: Get.theme.colorScheme.secondary,
                  ),
                const SizedBox(
                  width: 10,
                ),
                Text(title,
                    style: Get.textTheme.bodyLarge
                        ?.copyWith(color: Get.theme.colorScheme.secondary)),
              ],
            ));
}
