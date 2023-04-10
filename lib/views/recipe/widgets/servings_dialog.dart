import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/views/recipe/models/recipe_ingredient_pm_recipe.dart';
import 'package:recipes/views/recipe/recipe_controller/recipe_controller.dart';
import 'package:recipes/views/recipe/widgets/servings_icon.dart';
import 'package:recipes/widgets/common/asset_button.dart';
import 'package:recipes/widgets/common/custom_dialog.dart';
import 'package:recipes/widgets/common/loading_widget.dart';
import 'package:recipes/widgets/project/dialog_bottom.dart';

class ServingsDialog extends CustomDialog<bool> {
  const ServingsDialog({super.key}) : super(dismissible: false);

  @override
  Widget buildChild(BuildContext context) {
    return GetBuilder<RecipeController>(initState: (state) {
      Get.find<RecipeController>().initServingsDialog();
    }, builder: (controller) {
      return LoadingWidget(
        loading: controller.loading,
        child: Column(
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
                    const ServingsEditingButton(),
                    const SizedBox(height: 15),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: controller.recipe?.ingredientList
                                    .map((ingredient) => IngredientSummary(
                                        ingredient: ingredient))
                                    .toList() ??
                                []),
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
        ),
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
    return GetBuilder<RecipeController>(builder: (controller) {
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
              Text(
                  ingredient.getAmount(controller.tmpServings,
                          controller.recipe?.servings) ??
                      '',
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

class ServingsEditingButton extends StatelessWidget {
  const ServingsEditingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeController>(builder: (controller) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Get.theme.colorScheme.secondary),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6.5),
                bottomLeft: Radius.circular(6.5),
              ),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 40, height: 40),
              child: AssetButton(
                  iconColor: Get.theme.colorScheme.secondary,
                  onTap: controller.decrementTmpServings,
                  icon: 'back_arrow_icon'),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Get.theme.colorScheme.secondary),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 40, height: 40),
              child: ServingsIcon(
                  servings: controller.tmpServings,
                  color: Get.theme.colorScheme.secondary),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Get.theme.colorScheme.secondary),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(6.5),
                bottomRight: Radius.circular(6.5),
              ),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 40, height: 40),
              child: AssetButton(
                  iconColor: Get.theme.colorScheme.secondary,
                  flip: true,
                  onTap: controller.incrementTmpServings,
                  icon: 'back_arrow_icon'),
            ),
          )
        ],
      );
    });
  }
}
