import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/helpers/constants.dart';
import 'package:mekla/views/recipes/models/recipe_pm_recipes.dart';
import 'package:mekla/views/recipes/recipes_controller.dart';
import 'package:mekla/widgets/project/conditional_image.dart';
import 'package:mekla/widgets/project/info_button.dart';
import 'package:mekla/widgets/project/selected_border.dart';

class RecipeCard extends GetView<RecipesController> {
  const RecipeCard({Key? key, required this.recipe}) : super(key: key);
  final RecipePMRecipes recipe;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipesController>(builder: (controller) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (controller.selectionIsActive) {
            controller.selectItem(recipe);
            return;
          }
          controller.goToRecipe(recipe);
        },
        onLongPress: () => controller.selectItem(recipe),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
            color: Get.theme.colorScheme.tertiary,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
            child: Stack(
              children: [
                ConditionalImage(image: recipe.image),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 20),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Get.theme.colorScheme.primaryContainer,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          )),
                      child: Text(recipe.name,
                          textAlign: TextAlign.center,
                          style: Get.textTheme.headlineMedium?.copyWith(
                              color: Get.theme.colorScheme.onPrimaryContainer,
                              overflow: TextOverflow.ellipsis))),
                ),
                SelectedBorder(
                  selected: recipe.selected,
                ),
                InfoButton(
                  name: recipe.name,
                  description: recipe.description,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
