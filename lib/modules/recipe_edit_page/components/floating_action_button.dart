import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_edit_page/recipe_edit_controller.dart';

class RecipeCreateFloatingButton extends StatelessWidget {
  const RecipeCreateFloatingButton({
    this.iconSize = 30,
    Key? key,
  }) : super(key: key);

  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeEditController>(builder: (recipeEditController) {
      return SpeedDial(
        backgroundColor: Get.theme.colorScheme.primary,
        icon: Icons.add_rounded,
        renderOverlay: false,
        activeIcon: Icons.close,
        spacing: 3,
        openCloseDial: recipeEditController.isDialOpenNotifier,
        childPadding: const EdgeInsets.all(5),
        spaceBetweenChildren: 4,
        buttonSize: const Size(60, 60),
        iconTheme: IconThemeData(
            color: Get.theme.colorScheme.onPrimary, size: iconSize + 5),
        childrenButtonSize: const Size(65, 65),
        elevation: 8.0,
        animationDuration: const Duration(milliseconds: 200),
        children: [
          SpeedDialChild(
            child: Icon(Icons.fastfood_rounded, size: iconSize),
            backgroundColor: Get.theme.colorScheme.primaryContainer,
            foregroundColor: Get.theme.colorScheme.onPrimary,
            label: 'Create new ingredient',
            onTap: () async {
              await recipeEditController.addNewIngredient();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                recipeEditController.mainScrollController.animateTo(
                  recipeEditController
                          .ingredientListKey.currentContext?.size?.height ??
                      recipeEditController
                          .mainScrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.bounceInOut,
                );
              });
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.format_list_numbered, size: iconSize),
            backgroundColor: Get.theme.colorScheme.primaryContainer,
            foregroundColor: Get.theme.colorScheme.onPrimary,
            label: 'Create new instruction',
            onTap: () async {
              await recipeEditController.addNewInstruction();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                recipeEditController.mainScrollController.animateTo(
                  recipeEditController
                      .mainScrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.bounceInOut,
                );
              });
            },
          ),
        ],
      );
    });
  }
}
