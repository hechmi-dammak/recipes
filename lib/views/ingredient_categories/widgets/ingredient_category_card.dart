import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/helpers/constants.dart';
import 'package:mekla/views/ingredient_categories/ingredient_categories_controller.dart';
import 'package:mekla/views/ingredient_categories/models/ingredient_category_pm_ingredient_categories.dart';
import 'package:mekla/widgets/common/getx/get_builder_view.dart';
import 'package:mekla/widgets/project/category_title.dart';
import 'package:mekla/widgets/project/conditional_image.dart';
import 'package:mekla/widgets/project/selected_border.dart';

class IngredientCategoryCard extends StatelessWidget
    with GetBuilderView<IngredientCategoriesController> {
  const IngredientCategoryCard({Key? key, required this.ingredientCategory})
      : super(key: key);
  final IngredientCategoryPMIngredientCategories ingredientCategory;

  @override
  Widget getBuilder(BuildContext context, controller) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => controller.selectItem(ingredientCategory),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
          color: Get.theme.colorScheme.tertiary,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
          child: Stack(
            children: [
              ConditionalImage(image: ingredientCategory.image),
              CategoryTitle(name: ingredientCategory.name),
              SelectedBorder(
                selected: ingredientCategory.selected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
