import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/custom_dropdown.dart';
import 'package:recipes/components/show_dialog.dart';
import 'package:recipes/components/snack_bar.dart';
import 'package:recipes/modules/recipe_edit_page/recipe_edit_controller.dart';

class RecipeCategoryDropDownInput extends StatelessWidget {
  const RecipeCategoryDropDownInput({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeEditController>(
      builder: (recipeEditController) {
        return CustomDropdown(
            items: recipeEditController.recipeCategories,
            onChange: (category) =>
                recipeEditController.changeRecipeCategory(category),
            onButtonClick: () {
              if (recipeEditController.recipe.category != null) {
                recipeEditController.changeRecipeCategory(null);
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
                    recipeEditController.addNewRecipeCategory(controller.text);
                    recipeEditController.changeRecipeCategory(controller.text);
                    Get.back();
                  }).show();
            });
      },
    );
  }
}
