import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/show_dialog.dart';
import 'package:recipes/modules/recipe_list_page/recipes_list_controller.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipesListController>(
      builder: (recipesController) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: recipesController.selectionIsActive ? 75 : 0,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              stops: const [
                0.1,
                0.6,
              ],
              colors: [
                Get.theme.primaryColorDark,
                Get.theme.colorScheme.primary,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    ConfirmationDialog(
                            title: 'These recipes will be deleted.',
                            confirm: recipesController.deleteSelectedRecipes)
                        .show();
                  },
                  child: Column(
                    children: [
                      Icon(Icons.delete_forever_rounded,
                          size: 30, color: Get.theme.colorScheme.onPrimary),
                      Text(
                        'Delete',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Get.theme.colorScheme.onPrimary),
                      )
                    ],
                  ),
                ),
                TextButton(
                  onPressed: recipesController.exportToFile,
                  child: Column(
                    children: [
                      ImageIcon(
                          const AssetImage('assets/images/export_file.png'),
                          size: 30,
                          color: Get.theme.colorScheme.onPrimary),
                      Text(
                        'Export',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Get.theme.colorScheme.onPrimary),
                      )
                    ],
                  ),
                ),
                TextButton(
                  onPressed: recipesController.shareAsFile,
                  child: Column(
                    children: [
                      Icon(Icons.share,
                          size: 30, color: Get.theme.colorScheme.onPrimary),
                      Text(
                        'Share',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Get.theme.colorScheme.onPrimary),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
