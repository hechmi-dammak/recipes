import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/helpers/constants.dart';
import 'package:mekla/views/recipe_categories/models/recipe_category_pm_recipe_categories.dart';
import 'package:mekla/views/recipe_categories/recipe_categories_controller.dart';
import 'package:mekla/widgets/common/getx/get_builder_view.dart';
import 'package:mekla/widgets/project/category_title.dart';
import 'package:mekla/widgets/project/conditional_image.dart';
import 'package:mekla/widgets/project/info_button.dart';
import 'package:mekla/widgets/project/selected_border.dart';

class RecipeCategoryCard extends StatelessWidget
    with GetBuilderView<RecipeCategoriesController> {
  const RecipeCategoryCard({Key? key, required this.recipeCategory})
      : super(key: key);
  final RecipeCategoryPMRecipeCategories recipeCategory;

  @override
  Widget getBuilder(BuildContext context, controller) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => controller.selectItem(recipeCategory),
      onLongPress: () => controller.selectItem(recipeCategory),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
          color: Get.theme.colorScheme.tertiary,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
          child: Stack(
            children: [
              ConditionalImage(image: recipeCategory.image),
              CategoryTitle(name: recipeCategory.name),
              SelectedBorder(
                selected: recipeCategory.selected,
              ),
              InfoButton(
                name: recipeCategory.name,
                description: recipeCategory.description,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
