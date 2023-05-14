import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/views/recipe_categories/recipe_categories_page.dart';
import 'package:mekla/views/recipes/recipes_controller.dart';
import 'package:mekla/views/recipes/widgets/popup_menu_button.dart';
import 'package:mekla/views/recipes/widgets/recipe_card.dart';
import 'package:mekla/widgets/common/asset_button.dart';
import 'package:mekla/widgets/project/add_element_card.dart';
import 'package:mekla/widgets/project/custom_app_bar.dart';
import 'package:mekla/widgets/project/custom_page.dart';
import 'package:mekla/widgets/project/hidden_title_button.dart';
import 'package:mekla/widgets/project/title_app_bar_button.dart';

class RecipesPage extends CustomPage<RecipesController> {
  static const routeNameCategoriesRecipes =
      '${RecipeCategoriesPage.routeName}/:id/recipes';
  static const routeName = '/recipes';

  const RecipesPage({Key? key}) : super(key: key, hasSelection: true);

  @override
  PreferredSizeWidget? appBarBuilder(
      RecipesController controller, BuildContext context) {
    return CustomAppBar(
      fadeLeading: !controller.selectionIsActive,
      secondLeading: AssetButton.back(
        onTap: controller.setSelectAllValue,
      ),
      fadeAction: !controller.selectionIsActive,
      action: const PopUpMenuButton(),
      secondAction: AssetButton.selectAll(
          allItemsSelected: controller.allItemsSelected,
          onTap: controller.toggleSelectAllValue),
      fadeTitle: !controller.selectionIsActive,
      title: Text(
        'Recipes'.tr,
        style: Get.textTheme.headlineLarge
            ?.copyWith(color: Get.theme.colorScheme.onPrimary),
      ),
      secondTitle: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TitleAppBarButton(
                title: 'Delete'.tr,
                icon: 'trash_icon',
                onTap: controller.deleteSelectedRecipes),
            HiddenTitleButton(
                hidden: controller.selectionCount != 1,
                child: TitleAppBarButton(
                    title: 'Edit'.tr,
                    icon: 'edit_icon',
                    onTap: controller.editRecipe)),
            const SizedBox(
              width: 25,
            ),
            TitleAppBarButton(
              title: 'Share'.tr,
              icon: 'share_icon',
              onTap: controller.shareRecipes,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget bodyBuilder(RecipesController controller, BuildContext context) {
    return LayoutBuilder(builder: (context, _) {
      return GridView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (Get.width / 300).ceil(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10),
        children: [
          ...controller.recipes
              .map((recipe) => RecipeCard(recipe: recipe))
              .toList(),
          AnimatedOpacity(
            opacity: controller.selectionIsActive ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            child: AddElementCard(
              onTap: controller.addRecipe,
              semanticsLabel: 'Add Recipe'.tr,
            ),
          ),
        ],
      );
    });
  }
}
