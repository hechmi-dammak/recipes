import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/views/recipe_categories/recipe_categories_page.dart';
import 'package:mekla/views/recipes/recipes_controller.dart';
import 'package:mekla/views/recipes/widgets/popup_menu_button.dart';
import 'package:mekla/views/recipes/widgets/recipe_card.dart';
import 'package:mekla/views/recipes/widgets/recipe_category_expandable_card.dart';
import 'package:mekla/widgets/common/asset_button.dart';
import 'package:mekla/widgets/common/conditional_widget.dart';
import 'package:mekla/widgets/project/custom_app_bar.dart';
import 'package:mekla/widgets/project/custom_page.dart';
import 'package:mekla/widgets/project/grid_cards.dart';
import 'package:mekla/widgets/project/hidden_title_button.dart';
import 'package:mekla/widgets/project/title_app_bar_button.dart';

class RecipesPage extends CustomPage<RecipesController> {
  static const routeName = '/recipes';
  static const routeNameCategoriesRecipes =
      '${RecipeCategoriesPage.routeName}/:id/recipes';

  const RecipesPage({Key? key}) : super(key: key, hasSelection: true);

  @override
  PreferredSizeWidget? appBarBuilder(
      RecipesController controller, BuildContext context) {
    return CustomAppBar(
      fadeLeading: !controller.selectionIsActive,
      leading: const PopUpMenuButton(),
      secondLeading: AssetButton.back(
        onTap: controller.setSelectAllValue,
      ),
      fadeAction: !controller.selectionIsActive,
      action: AssetButton.toggleButton(
          onTap: controller.toggleCategorize,
          icon: 'category_icon',
          active: controller.categorize),
      secondAction: AssetButton.selectAll(
          allItemsSelected: controller.allItemsSelected,
          onTap: controller.toggleSelectAllValue),
      fadeTitle: !controller.selectionIsActive,
      title: Text(
        'Recipes'.tr,
        style: Get.textTheme.headlineLarge
            ?.copyWith(color: Get.theme.colorScheme.onPrimary),
      ),
      secondTitleChildren: [
        TitleAppBarButton(
            isStart: true,
            hideTitle: controller.selectionCount == 1,
            title: 'Delete'.tr,
            icon: 'trash_icon',
            onTap: controller.deleteSelectedItems),
        HiddenTitleButton(
            hidden: controller.selectionCount != 1,
            child: TitleAppBarButton(
                hideTitle: controller.selectionCount == 1,
                title: 'Edit'.tr,
                icon: 'edit_icon',
                onTap: controller.edit)),
        TitleAppBarButton(
          hideTitle: controller.selectionCount == 1,
          title: 'Share'.tr,
          icon: 'share_icon',
          onTap: controller.shareRecipes,
        ),
        TitleAppBarButton(
          hideTitle: controller.selectionCount == 1,
          title: 'Export'.tr,
          icon: 'export_file',
          onTap: controller.exportRecipes,
        )
      ],
    );
  }

  @override
  Widget bodyBuilder(RecipesController controller, BuildContext context) {
    return ConditionalWidget(
      condition: controller.categorize,
      child: (context) => ListView(
        shrinkWrap: true,
        children: [
          ...controller.categories
              .map((category) => RecipeCategoryExpandableCard(
                    category: category,
                  ))
              .toList(),
          GridCards(
            multiple: true,
            addElement: controller.add,
            hideAddElement: controller.selectionIsActive,
            children: controller.recipesWithoutCategory
                .map((recipe) => RecipeCard(recipe: recipe))
                .toList(),
          )
        ],
      ),
      secondChild: (context) => GridCards(
        addElement: controller.add,
        hideAddElement: controller.selectionIsActive,
        children: controller.items
            .map((recipe) => RecipeCard(recipe: recipe))
            .toList(),
      ),
    );
  }
}
