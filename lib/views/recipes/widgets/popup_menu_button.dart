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
            PopupMenuItem<int>(
              value: 0,
              child: Row(
                children: [
                  Icon(
                    Icons.upload_file_rounded,
                    size: 20,
                    color: Get.theme.colorScheme.secondary,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Import From File',
                    style: Get.textTheme.bodyLarge
                        ?.copyWith(color: Get.theme.colorScheme.secondary),
                  ),
                ],
              ),
            ),
            if (controller.recipes.isEmpty)
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(
                      Icons.download,
                      size: 20,
                      color: Get.theme.colorScheme.secondary,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('Import from library',
                        style: Get.textTheme.bodyLarge
                            ?.copyWith(color: Get.theme.colorScheme.secondary)),
                  ],
                ),
              ),
            PopupMenuItem<int>(
              value: 2,
              child: Row(
                children: [
                  AssetButton(
                    center: true,
                    icon: 'scale_icon',
                    color: Get.theme.colorScheme.secondary,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('Ingredients',
                      style: Get.textTheme.bodyLarge
                          ?.copyWith(color: Get.theme.colorScheme.secondary)),
                ],
              ),
            )
          ];
        },
      );
    });
  }
}
