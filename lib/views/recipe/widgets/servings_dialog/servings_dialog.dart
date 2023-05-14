import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/views/recipe/models/recipe_ingredient_pm_recipe.dart';
import 'package:mekla/views/recipe/models/recipe_pm_recipe.dart';
import 'package:mekla/views/recipe/widgets/servings_dialog/serving_dialog_controller.dart';
import 'package:mekla/widgets/common/custom_dialog.dart';
import 'package:mekla/widgets/project/dialog_bottom.dart';
import 'package:mekla/widgets/project/servings_editing_button.dart';

class ServingsDialog extends CustomDialog<bool> {
  const ServingsDialog(
      {required this.servings,
      required this.onConfirm,
      required this.recipe,
      super.key})
      : super(dismissible: false);
  final int servings;
  final void Function(int servings) onConfirm;
  final RecipePMRecipe recipe;

  @override
  Widget buildChild(BuildContext context) {
    return GetBuilder<ServingsDialogController>(
        init: ServingsDialogController(
            servings: servings, onConfirm: onConfirm, recipe: recipe),
        builder: (controller) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Get.theme.colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(6.5),
                          topLeft: Radius.circular(6.5))),
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ServingsEditingButton(
                        value: controller.servings,
                        onIncrement: controller.incrementTmpServings,
                        onDecrement: controller.decrementTmpServings,
                      ),
                      const SizedBox(height: 15),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: controller.recipe.ingredientList
                                  .map((ingredient) =>
                                      IngredientSummary(ingredient: ingredient))
                                  .toList()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              DialogBottom(
                onConfirm: () => controller.confirmSavingServings(close),
                onCancel: () => controller.cancelSavingServings(close),
              )
            ],
          );
        });
  }
}

class IngredientSummary extends StatelessWidget {
  const IngredientSummary({
    super.key,
    required this.ingredient,
  });

  final RecipeIngredientPMRecipe ingredient;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServingsDialogController>(builder: (controller) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ingredient.ingredient.value?.name ?? '',
                style: Get.textTheme.bodyLarge,
              ),
              Text(ingredient.getAmount(controller.servings) ?? '',
                  style: Get.textTheme.bodyLarge),
            ],
          ),
          Divider(
            thickness: 0.5,
            color: Get.theme.colorScheme.onSecondaryContainer,
          )
        ],
      );
    });
  }
}
