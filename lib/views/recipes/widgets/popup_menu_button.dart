import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/views/recipes/recipes_controller.dart';
import 'package:recipes/widgets/common/asset_button.dart';

class PopUpMenuButton extends StatelessWidget {
  const PopUpMenuButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipesController>(
      builder: (controller) {
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
                  children: const [
                    Icon(Icons.upload_file_rounded, size: 20),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Import From File'),
                  ],
                ),
              ),
              if (controller.recipes.isEmpty)
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: const [
                      Icon(Icons.download, size: 20),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Import from library'),
                    ],
                  ),
                )
            ];
          },
        );
      },
    );
  }
}
