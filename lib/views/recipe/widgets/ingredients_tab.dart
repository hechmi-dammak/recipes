import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/views/recipe/recipe_controller/recipe_controller.dart';
import 'package:mekla/views/recipe/widgets/ingredient_card.dart';
import 'package:mekla/widgets/project/add_element_card.dart';

class IngredientsTab extends StatelessWidget {
  const IngredientsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeController>(builder: (controller) {
      return RefreshIndicator(
        onRefresh: controller.fetchData,
        child: LayoutBuilder(builder: (context, _) {
          return GridView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (Get.width / 300).ceil(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10),
            children: [
              ...controller.recipe!.ingredientList
                  .map((ingredient) => IngredientCard(
                        ingredient: ingredient,
                      ))
                  .toList(),
              AnimatedOpacity(
                opacity: controller.selectionIsActive ? 0 : 1,
                duration: const Duration(milliseconds: 300),
                child: AddElementCard(
                    onTap: controller.addIngredient,
                    semanticsLabel: 'Add Ingredient'.tr),
              ),
            ],
          );
        }),
      );
    });
  }
}
