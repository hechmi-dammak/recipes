import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/views/recipes/models/recipe_pm_recipes.dart';
import 'package:recipes/views/recipes/recipes_controller.dart';
import 'package:recipes/widgets/common/conditional_widget.dart';
import 'package:recipes/widgets/info_button.dart';

class RecipeCard extends GetView<RecipesController> {
  const RecipeCard({Key? key, required this.recipe}) : super(key: key);
  final RecipePMRecipes recipe;
  static const double borderWidth = 4;
  static const double borderRadius = 6.5;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (controller.selectionIsActive) {
          controller.selectRecipe(recipe);
          return;
        }
        controller.goToRecipe(recipe);
      },
      onLongPress: () => controller.selectRecipe(recipe),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Get.theme.colorScheme.tertiary,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              ConditionalWidget(
                  condition: recipe.image != null,
                  child: (context) => Image(
                        image: recipe.image!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 20),
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
              ConditionalWidget(
                  condition: recipe.selected,
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
                      )),
              InfoButton(
                name: recipe.name,
                description: recipe.description,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
