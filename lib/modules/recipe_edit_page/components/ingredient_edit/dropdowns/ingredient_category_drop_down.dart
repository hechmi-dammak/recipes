import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/custom_dropdown.dart';
import 'package:recipes/components/show_dialog.dart';
import 'package:recipes/components/snack_bar.dart';
import 'package:recipes/modules/recipe_edit_page/recipe_edit_controller.dart';

class IngredientCategoryDropDownInput extends StatelessWidget {
  const IngredientCategoryDropDownInput({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeEditController>(
      builder: (recipeEditController) {
        return CustomDropdown(
          value: recipeEditController.recipe.ingredients[index].category,
          onChange: (category) =>
              recipeEditController.changeIngredientCategory(index, category),
          items: recipeEditController.ingredientCategories,
          onButtonClick: () {
            if (recipeEditController.recipe.ingredients[index].category !=
                null) {
              recipeEditController.changeIngredientCategory(index, null);
              return;
            }
            recipeEditController.isDialOpen = false;
            InputDialog(
                title: 'Create a new category',
                label: 'Category',
                confirm: (controller) async {
                  if (controller.text == '') {
                    CustomSnackBar.warning("Category shouldn't be empty.");
                    return;
                  }
                  recipeEditController
                      .addNewIngredientCategory(controller.text);
                  recipeEditController.changeIngredientCategory(
                      index, controller.text);
                  Get.back();
                }).show();
          },
        );
      },
    );
  }
}
