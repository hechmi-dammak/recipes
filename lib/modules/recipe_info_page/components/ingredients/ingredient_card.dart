import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/decorations/gradient_decoration.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/modules/recipe_info_page/components/ingredients/ingredient_info_bottom_sheet.dart';
import 'package:recipes/modules/recipe_info_page/recipe_info_controller.dart';

class IngredientCard extends StatelessWidget {
  final Ingredient ingredient;

  const IngredientCard({
    Key? key,
    required this.ingredient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeInfoController>(builder: (recipeInfoController) {
      return Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(2),
          child: Ink(
            width: min(MediaQuery.of(context).size.width * 3 / 5, 300),
            decoration: GradientDecoration.secondary(ingredient.selected),
            child: InkWell(
              onLongPress: () => IngredientInfoBottomSheet(
                servings: recipeInfoController.servings,
                recipeServings: recipeInfoController.recipe.servings,
                ingredient: ingredient,
              ).show(),
              onTap: () {
                recipeInfoController.toggleIngredientSelected(ingredient);
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                child: Ink(
                  decoration: BoxDecoration(
                      color: Get.theme.backgroundColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Stack(
                    children: [
                      Align(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                ingredient.name.capitalize!,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Get.theme.buttonTheme.colorScheme!
                                        .onSecondary),
                              ),
                              if (ingredient.getQuantity(
                                    recipeInfoController.servings,
                                    recipeInfoController.recipe.servings,
                                  ) !=
                                  null)
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    ingredient
                                        .getQuantity(
                                          recipeInfoController.servings,
                                          recipeInfoController.recipe.servings,
                                        )!
                                        .capitalize!,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Get.theme.buttonTheme
                                            .colorScheme!.onSecondary),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (ingredient.method != null)
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              Icons.info_outline,
                              size: 27,
                              color: ingredient.selected
                                  ? Get.theme.colorScheme.secondary
                                  : Get.theme.colorScheme.primary,
                            ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
