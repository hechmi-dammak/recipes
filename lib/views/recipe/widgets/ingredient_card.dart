import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/views/recipe/models/recipe_ingredient_pm_recipe.dart';
import 'package:recipes/views/recipe/recipe_controller/recipe_controller.dart';
import 'package:recipes/widgets/common/conditional_widget.dart';
import 'package:recipes/widgets/info_button.dart';

class IngredientCard extends GetView<RecipeController> {
  const IngredientCard({Key? key, required this.ingredient}) : super(key: key);

  final RecipeIngredientPMRecipe ingredient;

  static const double borderWidth = 4;
  static const double borderRadius = 6.5;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (controller.selectionIsActive) {
          controller.selectIngredient(ingredient);
          return;
        }
        controller.useIngredient(ingredient);
      },
      onLongPress: () => controller.selectIngredient(ingredient),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Get.theme.colorScheme.primaryContainer,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(borderRadius),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Get.theme.colorScheme.tertiary),
                            ),
                            ConditionalWidget(
                              condition:
                                  ingredient.ingredient.value?.picture.value !=
                                      null,
                              child: (context) => Image.memory(
                                ingredient
                                    .ingredient.value!.picture.value!.image,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            ConditionalWidget(
                              condition: ingredient.amount != null,
                              child: (context) => Positioned(
                                left: 0,
                                top: 14,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Get.theme.colorScheme.primary,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5))),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  child: Text(
                                    ingredient.getAmount(controller.servings,
                                        controller.recipe?.servings)!,
                                    textAlign: TextAlign.center,
                                    style: Get.textTheme.labelMedium?.copyWith(
                                        color: Get.theme.colorScheme.onPrimary),
                                  ),
                                ),
                              ),
                            ),
                            InfoButton(
                                name: ingredient.ingredient.value?.name ?? '',
                                description: ingredient.description,
                                isRight: true),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(bottom: 8, left: 10, right: 10),
                    child: Text(
                      ingredient.ingredient.value?.name ?? '',
                      textAlign: TextAlign.center,
                      style: Get.textTheme.headlineMedium?.copyWith(
                          color: Get.theme.colorScheme.onPrimaryContainer,
                          overflow: TextOverflow.ellipsis),
                    ),
                  )
                ],
              ),
              ConditionalWidget(
                condition: ingredient.used,
                child: (context) => Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.tertiary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(
                      width: borderWidth,
                      color: Get.theme.colorScheme.tertiary,
                    ),
                  ),
                ),
              ),
              ConditionalWidget(
                condition: ingredient.selected,
                child: (context) => Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(
                      width: borderWidth,
                      color: Get.theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
