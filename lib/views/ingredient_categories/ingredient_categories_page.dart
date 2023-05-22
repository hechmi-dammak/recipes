import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/views/ingredient_categories/ingredient_categories_controller.dart';
import 'package:mekla/views/ingredient_categories/widgets/ingredient_category_card.dart';
import 'package:mekla/widgets/common/asset_button.dart';
import 'package:mekla/widgets/project/custom_app_bar.dart';
import 'package:mekla/widgets/project/custom_page.dart';
import 'package:mekla/widgets/project/grid_cards.dart';
import 'package:mekla/widgets/project/hidden_title_button.dart';
import 'package:mekla/widgets/project/title_app_bar_button.dart';

class IngredientCategoriesPage
    extends CustomPage<IngredientCategoriesController> {
  static const routeName = '/ingredient-categories';

  const IngredientCategoriesPage({Key? key})
      : super(key: key, hasSelection: true);

  @override
  PreferredSizeWidget? appBarBuilder(
      IngredientCategoriesController controller, BuildContext context) {
    return CustomAppBar(
      fadeTitle: !controller.selectionIsActive,
      fadeAction: !controller.selectionIsActive,
      leading: AssetButton.back(
          onTap: controller.selectionIsActive
              ? controller.setSelectAllValue
              : null),
      secondAction: AssetButton.selectAll(
          allItemsSelected: controller.allItemsSelected,
          onTap: controller.toggleSelectAllValue),
      title: Text(
        'Categories'.tr,
        style: Get.textTheme.headlineLarge
            ?.copyWith(color: Get.theme.colorScheme.onPrimary),
      ),
      secondTitle: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TitleAppBarButton(
                isStart: true,
                title: 'Delete'.tr,
                icon: 'trash_icon',
                onTap: controller.deleteSelectedItems),
            HiddenTitleButton(
                hidden: controller.selectionCount != 1,
                child: TitleAppBarButton(
                    title: 'Edit'.tr,
                    icon: 'edit_icon',
                    onTap: controller.edit))
          ],
        ),
      ),
    );
  }

  @override
  Widget bodyBuilder(
      IngredientCategoriesController controller, BuildContext context) {
    return GridCards(
      addElement: controller.add,
      hideAddElement: controller.selectionIsActive,
      crossAxisWidth: 600,
      childAspectRatio: 2,
      children: controller.items
          .map((ingredientCategory) =>
              IngredientCategoryCard(ingredientCategory: ingredientCategory))
          .toList(),
    );
  }
}
