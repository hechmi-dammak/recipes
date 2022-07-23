import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/custom_dropdown.dart';
import 'package:recipes/components/show_dialog.dart';
import 'package:recipes/components/snack_bar.dart';
import 'package:recipes/modules/recipe_edit_page/recipe_edit_controller.dart';

class IngredientSizeDropDownInput extends StatelessWidget {
  const IngredientSizeDropDownInput({Key? key, required this.index})
      : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeEditController>(
      builder: (recipeEditController) {
        return CustomDropdown(
          value: recipeEditController.recipe.ingredients[index].size,
          onChange: (size) =>
              recipeEditController.changeIngredientSize(index, size),
          items: recipeEditController.ingredientSizes,
          onButtonClick: () {
            if (recipeEditController.recipe.ingredients[index].size != null) {
              recipeEditController.changeIngredientSize(index, null);
              return;
            }
            recipeEditController.isDialOpen = false;
            InputDialog(
                title: 'Create a new size',
                label: 'Size',
                confirm: (controller) async {
                  if (controller.text == '') {
                    CustomSnackBar.warning("Size shouldn't be empty.");
                    return;
                  }
                  recipeEditController.addNewIngredientSize(controller.text);
                  recipeEditController.changeIngredientSize(
                      index, controller.text);

                  Get.back();

                  controller.clear();
                }).show();
          },
        );
      },
    );
  }
}
