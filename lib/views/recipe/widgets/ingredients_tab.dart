import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/views/recipe/recipe_controller/recipe_controller.dart';
import 'package:mekla/views/recipe/widgets/recipe_ingredient_card.dart';
import 'package:mekla/widgets/project/grid_cards.dart';

class IngredientsTab extends GetView<RecipeController> {
  const IngredientsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: controller.fetchData,
        child: GetBuilder<RecipeController>(builder: (controller) {
          return GridCards(
              addElement: controller.add,
              hideAddElement: controller.selectionIsActive,
              children: controller.recipe!.ingredientList
                  .map((ingredient) => RecipeIngredientCard(
                        ingredient: ingredient,
                      ))
                  .toList());
        }));
  }
}
