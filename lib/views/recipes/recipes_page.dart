import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/views/recipe_categories/recipe_categories_page.dart';
import 'package:recipes/views/recipes/recipes_controller.dart';
import 'package:recipes/views/recipes/widgets/recipe_card.dart';
import 'package:recipes/widgets/common/svg_button.dart';
import 'package:recipes/widgets/project/add_element_card.dart';
import 'package:recipes/widgets/project/custom_app_bar.dart';
import 'package:recipes/widgets/project/custom_page.dart';
import 'package:recipes/widgets/project/hidden_title_button.dart';
import 'package:recipes/widgets/project/select_all_button.dart';
import 'package:recipes/widgets/project/title_app_bar_button.dart';

class RecipesPage extends CustomPage<RecipesController> {
  static const routeNameCategoriesRecipes = '${RecipeCategoriesPage.routeName}/:id/recipes';
  static const routeName = '/recipes';

  const RecipesPage({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? appBarBuilder(
      RecipesController controller, BuildContext context) {
    return controller.selectionIsActive
        ? CustomAppBar(
            leading: SvgButton.backButton(
              onTap: controller.setSelectAllValue,
            ),
            action: SelectAllButton(
                allItemsSelected: controller.allItemsSelected,
                onTap: controller.toggleSelectAllValue),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TitleAppBarButton(
                    title: 'Delete'.tr,
                    icon: 'assets/icons/trash_icon.svg',
                    onTap: controller.deleteSelectedRecipes),
                HiddenTitleButton(
                    hidden: controller.selectionCount != 1,
                    child: TitleAppBarButton(
                        title: 'Edit'.tr,
                        icon: 'assets/icons/edit_icon.svg',
                        onTap: controller.editRecipe)),
                const SizedBox(
                  width: 25,
                ),
                TitleAppBarButton(
                  title: 'Share'.tr,
                  icon: 'assets/icons/share_icon.svg',
                  onTap: () {
                    //todo: implement share
                  },
                )
              ],
            ),
          )
        : CustomAppBar(
            title: Text(
              'Recipes'.tr,
              style: Get.textTheme.headlineLarge
                  ?.copyWith(color: Get.theme.colorScheme.onPrimary),
            ),
          );
  }

  @override
  Widget bodyBuilder(RecipesController controller, BuildContext context) {
    return GridView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (Get.width / 300).ceil(),
          mainAxisSpacing: 20,
          crossAxisSpacing: 20),
      children: [
        ...controller.recipes
            .map((recipe) => RecipeCard(recipe: recipe))
            .toList(),
        AddElementCard(
            onTap: controller.addRecipe, semanticsLabel: 'Add Recipe'.tr),
      ],
    );
  }
}
