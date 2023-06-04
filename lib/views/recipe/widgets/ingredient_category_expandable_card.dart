import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/helpers/constants.dart';
import 'package:mekla/helpers/theme.dart';
import 'package:mekla/views/recipe/models/ingredient_category_pm_recipes.dart';
import 'package:mekla/views/recipe/recipe_controller/recipe_controller.dart';
import 'package:mekla/views/recipe/widgets/recipe_ingredient_card.dart';
import 'package:mekla/widgets/common/conditional_widget.dart';
import 'package:mekla/widgets/common/custom_animated_size.dart';
import 'package:mekla/widgets/common/getx/get_builder_view.dart';
import 'package:mekla/widgets/common/getx/get_layout_builder_view.dart';
import 'package:mekla/widgets/project/category_title.dart';
import 'package:mekla/widgets/project/grid_cards.dart';

class IngredientCategoryExpandableCard extends StatelessWidget
    with
        GetBuilderView<RecipeController>,
        GetLayoutBuilderView<RecipeController> {
  const IngredientCategoryExpandableCard({
    super.key,
    required this.category,
  });

  final IngredientCategoryPMRecipe category;
  static const double marginHorizontal = 10;

  static const double splitRatio = 2 / 3;

  @override
  Widget getLayoutBuilder(BuildContext context, RecipeController controller,
      BoxConstraints constraints) {
    final width = (Get.width - 2 * marginHorizontal);
    final height = width * 3 / 10;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        controller.selectItem(category);
      },
      child: Container(
        margin: const EdgeInsets.only(
            left: marginHorizontal, right: marginHorizontal, top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
          color: Get.theme.colorScheme.tertiary,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: height * splitRatio,
              child: Stack(
                children: [
                  ConditionalWidget(
                      condition: category.images != null,
                      child: (context) => ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft:
                                    Radius.circular(Constants.cardBorderRadius),
                                topRight: Radius.circular(
                                    Constants.cardBorderRadius)),
                            child: Image(
                              image: category.images![0],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )),
                  CategoryTitle(
                    name: category.name,
                    splitRatio: splitRatio,
                  ),
                ],
              ),
            ),
            CustomAnimatedSize(
              duration: const Duration(milliseconds: 300),
              hide: category.selected,
              child: Container(
                decoration: BoxDecoration(
                    color: ApplicationTheme.createPrimarySwatch(
                        Get.theme.colorScheme.tertiaryContainer)[200]),
                child: GridCards(
                    useAnimation: false,
                    paddingHorizontal: 10,
                    multiple: true,
                    addElement: () => controller.addIngredient(categoryId: category.id),
                    hideAddElement: controller.selectionIsActive,
                    children: category.ingredients
                        .map((ingredient) =>
                            RecipeIngredientCard(ingredient: ingredient))
                        .toList()),
              ),
            ),
            SizedBox(
              height: height * (1 - splitRatio),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(Constants.cardBorderRadius),
                    bottomRight: Radius.circular(Constants.cardBorderRadius)),
                child: ConditionalWidget(
                    condition: category.images != null,
                    child: (context) => Image(
                          image: category.images![1],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
