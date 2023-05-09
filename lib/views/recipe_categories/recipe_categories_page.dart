import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/views/recipe_categories/recipe_categories_controller.dart';
import 'package:recipes/views/recipe_categories/widgets/recipe_category_card.dart';
import 'package:recipes/widgets/common/asset_button.dart';
import 'package:recipes/widgets/project/add_element_card.dart';
import 'package:recipes/widgets/project/custom_app_bar.dart';
import 'package:recipes/widgets/project/custom_page.dart';
import 'package:recipes/widgets/project/hidden_title_button.dart';
import 'package:recipes/widgets/project/title_app_bar_button.dart';

class RecipeCategoriesPage extends CustomPage<RecipeCategoriesController> {
  static const routeName = '/recipes-categories';

  const RecipeCategoriesPage({Key? key}) : super(key: key, hasSelection: true);

  @override
  PreferredSizeWidget? appBarBuilder(
      RecipeCategoriesController controller, BuildContext context) {
    return CustomAppBar(
      fadeTitle: !controller.selectionIsActive,
      fadeLeading: !controller.selectionIsActive,
      fadeAction: !controller.selectionIsActive,
      secondLeading: AssetButton.back(onTap: controller.setSelectAllValue),
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
              title: 'Delete'.tr,
              icon: 'trash_icon',
              onTap: () {
                controller.deleteSelectedCategories();
              },
            ),
            HiddenTitleButton(
                hidden: controller.selectionCount != 1,
                child: TitleAppBarButton(
                    title: 'Edit'.tr,
                    icon: 'edit_icon',
                    onTap: controller.editRecipeCategory)),
            const SizedBox(
              width: 25,
            ),
            TitleAppBarButton(
              title: 'Share'.tr,
              icon: 'share_icon',
              onTap: () {
                //todo: implement share
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget bodyBuilder(
      RecipeCategoriesController controller, BuildContext context) {
    return LayoutBuilder(builder: (context, _) {
      return GridView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 2,
            crossAxisCount: (Get.width / 600).ceil(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10),
        children: [
          ...controller.recipeCategories
              .map((recipeCategory) =>
                  RecipeCategoryCard(recipeCategory: recipeCategory))
              .toList(),
          AnimatedOpacity(
            opacity: controller.selectionIsActive ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            child: AddElementCard(
                onTap: controller.addRecipeCategory,
                semanticsLabel: 'Add Recipe Category'.tr),
          ),
        ],
      );
    });
  }
}
