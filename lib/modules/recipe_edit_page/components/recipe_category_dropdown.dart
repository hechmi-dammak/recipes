import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/custom_dropdown.dart';
import 'package:recipes/components/show_dialog.dart';
import 'package:recipes/modules/recipe_edit_page/recipe_edit_controller.dart';

class RecipeCategoryDropdownInput extends StatelessWidget {
  const RecipeCategoryDropdownInput({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeEditController>(
      builder: (recipeEditController) {
        return CustomDropdown(
            value: recipeEditController.recipe.category,
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
                  validate: (value) {
                    if (value?.isEmpty ?? true) {
                      return "Category shouldn't be empty.";
                    }
                    return null;
                  },
                  confirm: (formKey, controller) async {
                    if (!(formKey.currentState?.validate() ?? false)) return;
                    recipeEditController.addNewRecipeCategory(controller.text);
                    recipeEditController.changeRecipeCategory(controller.text);
                    Get.back();
                  }).show();
            });
      },
    );
  }
}
