import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/views/recipe/recipe_controller/recipe_controller.dart';
import 'package:recipes/views/recipe/widgets/ingredient_card.dart';
import 'package:recipes/widgets/project/add_element_card.dart';

class IngredientsTab extends StatelessWidget {
  const IngredientsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeController>(builder: (controller) {
      return RefreshIndicator(
        onRefresh: controller.fetchData,
        child: GridView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (Get.width / 300).ceil(),
              mainAxisSpacing: 20,
              crossAxisSpacing: 20),
          children: [
            ...controller.recipe!.ingredientList
                .map((ingredient) => IngredientCard(
                      ingredient: ingredient,
                    ))
                .toList(),
            AddElementCard(
                onTap: controller.addIngredient,
                semanticsLabel: 'Add Ingredient'.tr),
          ],
        ),
      );
    });
  }
}
