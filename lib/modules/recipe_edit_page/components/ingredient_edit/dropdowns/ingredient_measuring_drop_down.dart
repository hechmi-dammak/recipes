import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/custom_dropdown.dart';
import 'package:recipes/components/show_dialog.dart';
import 'package:recipes/components/snack_bar.dart';
import 'package:recipes/modules/recipe_edit_page/recipe_edit_controller.dart';

class IngredientMeasuringDropDownInput extends StatelessWidget {
  const IngredientMeasuringDropDownInput({Key? key, required this.index})
      : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeEditController>(
      builder: (recipeEditController) {
        return CustomDropdown(
          value: recipeEditController.recipe.ingredients[index].measuring,
          onChange: (measuring) =>
              recipeEditController.changeIngredientMeasuring(index, measuring),
          items: recipeEditController.ingredientMeasuring,
          onButtonClick: () {
            if (recipeEditController.recipe.ingredients[index].measuring !=
                null) {
              recipeEditController.changeIngredientMeasuring(index, null);

              return;
            }
            recipeEditController.isDialOpen = false;
            InputDialog(
                title: 'Create a new measuring',
                label: 'Measuring',
                confirm: (controller) async {
                  if (controller.text == '') {
                    CustomSnackBar.warning("Measuring shouldn't be empty.");
                    return;
                  }
                  recipeEditController
                      .addNewIngredientMeasuring(controller.text);
                  recipeEditController.changeIngredientMeasuring(
                      index, controller.text);
                  Get.back();
                }).show();
          },
        );
      },
    );
  }
}
