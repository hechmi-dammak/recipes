import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/helpers/constants.dart';
import 'package:mekla/helpers/theme.dart';
import 'package:mekla/views/recipes/models/recipe_category_pm_recipes.dart';
import 'package:mekla/views/recipes/recipes_controller.dart';
import 'package:mekla/views/recipes/widgets/recipe_card.dart';
import 'package:mekla/widgets/common/conditional_widget.dart';
import 'package:mekla/widgets/common/custom_animated_size.dart';
import 'package:mekla/widgets/project/category_title.dart';
import 'package:mekla/widgets/project/grid_cards.dart';
import 'package:mekla/widgets/project/info_button.dart';

class RecipeCategoryExpandableCard extends StatelessWidget {
  const RecipeCategoryExpandableCard({
    super.key,
    required this.category,
  });

  final RecipeCategoryPMRecipes category;
  static const double marginHorizontal = 10;

  static const double splitRatio = 0.8;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipesController>(builder: (controller) {
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
                height: (Get.width - 2 * marginHorizontal) * splitRatio / 2,
                child: Stack(
                  children: [
                    ConditionalWidget(
                        condition: category.images != null,
                        child: (context) => ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(
                                      Constants.cardBorderRadius),
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
                    InfoButton(
                      name: category.name,
                      description: category.description,
                    ),
                  ],
                ),
              ),
              CustomAnimatedSize(
                duration: const Duration(milliseconds: 400),
                hide: category.selected,
                child: Container(
                  decoration: BoxDecoration(
                      color: ApplicationTheme.createPrimarySwatch(
                          Get.theme.colorScheme.tertiaryContainer)[200]),
                  child: GridCards(
                      useAnimation: !category.selected,
                      paddingHorizontal: 10,
                      multiple: true,
                      addElement: () => controller.add(categoryId: category.id),
                      hideAddElement: controller.selectionIsActive,
                      children: category.recipes
                          .map((recipe) => RecipeCard(recipe: recipe))
                          .toList()),
                ),
              ),
              SizedBox(
                height:
                    (Get.width - 2 * marginHorizontal) * (1 - splitRatio) / 2,
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
    });
  }
}
