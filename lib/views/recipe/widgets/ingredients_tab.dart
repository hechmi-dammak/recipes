import 'package:flutter/material.dart';
import 'package:mekla/views/recipe/recipe_controller/recipe_controller.dart';
import 'package:mekla/views/recipe/widgets/recipe_ingredient_card.dart';
import 'package:mekla/widgets/common/getx/get_builder_view.dart';
import 'package:mekla/widgets/project/grid_cards.dart';

class IngredientsTab extends StatelessWidget
    with GetBuilderView<RecipeController> {
  const IngredientsTab({Key? key}) : super(key: key);

  @override
  Widget getBuilder(BuildContext context, controller) {
    return RefreshIndicator(
        onRefresh: controller.fetchData,
        child: GridCards(
            addElement: controller.add,
            hideAddElement: controller.selectionIsActive,
            children: controller.recipe!.ingredientList
                .map((ingredient) => RecipeIngredientCard(
                      ingredient: ingredient,
                    ))
                .toList()));
  }
}
