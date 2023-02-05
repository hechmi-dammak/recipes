import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/views/recipe_categories/recipe_categories_controller.dart';
import 'package:recipes/views/recipe_categories/widgets/recipe_category_card.dart';
import 'package:recipes/widgets/common/svg_button.dart';
import 'package:recipes/widgets/project/add_element_card.dart';
import 'package:recipes/widgets/project/custom_app_bar.dart';
import 'package:recipes/widgets/project/custom_page.dart';
import 'package:recipes/widgets/project/hidden_title_button.dart';
import 'package:recipes/widgets/project/select_all_button.dart';
import 'package:recipes/widgets/project/title_app_bar_button.dart';

class RecipeCategoriesPage extends CustomPage<RecipeCategoriesController> {
  static const routeName = '/recipes-categories';

  const RecipeCategoriesPage({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? appBarBuilder(
      RecipeCategoriesController controller, BuildContext context) {
    return controller.selectionIsActive
        ? CustomAppBar(
            leading: SvgButton.backButton(onTap: controller.setSelectAllValue),
            action: SelectAllButton(
                allItemsSelected: controller.allItemsSelected,
                onTap: controller.toggleSelectAllValue),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TitleAppBarButton(
                  title: 'Delete'.tr,
                  icon: 'assets/icons/trash_icon.svg',
                  onTap: () {
                    controller.deleteSelectedCategories();
                  },
                ),
                HiddenTitleButton(
                    hidden: controller.selectionCount != 1,
                    child: TitleAppBarButton(
                        title: 'Edit'.tr,
                        icon: 'assets/icons/edit_icon.svg',
                        onTap: controller.editRecipeCategory)),
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
        : AppBar(
            centerTitle: true,
            leading: SvgButton(
              onTap: () {}, //todo
              icon: 'assets/icons/menu_icon.svg',
            ),
            title: Text(
              'Categories'.tr,
              style: Get.textTheme.headlineLarge
                  ?.copyWith(color: Get.theme.colorScheme.onPrimary),
            ),
          );
  }

  @override
  Widget bodyBuilder(
      RecipeCategoriesController controller, BuildContext context) {
    return GridView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2,
          crossAxisCount: (MediaQuery.of(context).size.width / 600).ceil(),
          mainAxisSpacing: 20,
          crossAxisSpacing: 20),
      children: [
        ...controller.recipeCategories
            .map((recipeCategory) =>
                RecipeCategoryCard(recipeCategory: recipeCategory))
            .toList(),
        AddElementCard(
            onTap: controller.addRecipeCategory,
            semanticsLabel: 'Add Recipe Category'.tr),
      ],
    );
  }
}
