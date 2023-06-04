import 'package:flutter/material.dart';
import 'package:mekla/views/recipe/recipe_controller/recipe_controller.dart';
import 'package:mekla/views/recipe/widgets/ingredient_category_expandable_card.dart';
import 'package:mekla/views/recipe/widgets/recipe_ingredient_card.dart';
import 'package:mekla/widgets/common/conditional_widget.dart';
import 'package:mekla/widgets/common/getx/get_builder_view.dart';
import 'package:mekla/widgets/project/grid_cards.dart';

class IngredientsTab extends StatelessWidget
    with GetBuilderView<RecipeController> {
  const IngredientsTab({Key? key}) : super(key: key);

  @override
  Widget getBuilder(BuildContext context, controller) {
    return RefreshIndicator(
        onRefresh: controller.fetchData,
        child: ConditionalWidget(
          condition: controller.categorize,
          child: (context) => ListView(
            shrinkWrap: true,
            children: [
              ...controller.categories
                  .map((category) => IngredientCategoryExpandableCard(
                        category: category,
                      ))
                  .toList(),
              GridCards(
                multiple: true,
                addElement: controller.add,
                hideAddElement: controller.selectionIsActive,
                children: controller.ingredientsWithoutCategory
                    .map((ingredient) =>
                        RecipeIngredientCard(ingredient: ingredient))
                    .toList(),
              )
            ],
          ),
          secondChild: (context) => GridCards(
              addElement: controller.add,
              hideAddElement: controller.selectionIsActive,
              children: controller.ingredientList
                  .map((ingredient) => RecipeIngredientCard(
                        ingredient: ingredient,
                      ))
                  .toList()),
        ));
  }
}
