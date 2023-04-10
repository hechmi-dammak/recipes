import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/views/recipe/recipe_controller/recipe_controller.dart';
import 'package:recipes/views/recipe/widgets/bottom_navigation_button.dart';
import 'package:recipes/views/recipe/widgets/ingredients_tab.dart';
import 'package:recipes/views/recipe/widgets/servings_button.dart';
import 'package:recipes/views/recipe/widgets/servings_dialog.dart';
import 'package:recipes/views/recipe/widgets/steps_tab.dart';
import 'package:recipes/widgets/common/asset_button.dart';
import 'package:recipes/widgets/project/custom_app_bar.dart';
import 'package:recipes/widgets/project/custom_page.dart';
import 'package:recipes/widgets/project/hidden_title_button.dart';
import 'package:recipes/widgets/project/title_app_bar_button.dart';

class RecipePage extends CustomPage<RecipeController> {
  static const routeName = '/recipes/:id';

  const RecipePage({Key? key}) : super(key: key);

  @override
  Widget bodyBuilder(RecipeController controller, BuildContext context) {
    return TabBarView(
      controller: controller.tabController,
      children: const [IngredientsTab(), StepsTab()],
    );
  }

  @override
  Widget? bottomNavigationBarBuilder(
      RecipeController controller, BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      child: Row(
        children: [
          BottomNavigationBarButton(
              title: 'Ingredient'.tr,
              icon: 'scale_icon',
              selected: controller.tabController.index == 0,
              onTap: () => controller.changeTab(0)),
          BottomNavigationBarButton(
            title: 'Steps'.tr,
            icon: 'hat_icon',
            selected: controller.tabController.index == 1,
            onTap: () => controller.changeTab(1),
          ),
        ],
      ),
    );
  }

  @override
  PreferredSizeWidget? appBarBuilder(
      RecipeController controller, BuildContext context) {
    return controller.selectionIsActive
        ? CustomAppBar(
            leading: AssetButton.back(
              onTap: controller.setSelectAllValue,
            ),
            action: AssetButton.selectAll(
                allItemsSelected: controller.allItemsSelected,
                onTap: controller.toggleSelectAllValue),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TitleAppBarButton(
                    title: 'Delete'.tr,
                    icon: 'trash_icon',
                    onTap: controller.deleteSelectedItems),
                HiddenTitleButton(
                    hidden: controller.selectionCount != 1,
                    child: TitleAppBarButton(
                        title: 'Edit'.tr,
                        icon: 'edit_icon',
                        onTap: controller.editItem))
              ],
            ),
          )
        : CustomAppBar(
            action: controller.tabController.index == 0
                ? ServingsButton(
                    servings: controller.servings,
                    onTap: () => const ServingsDialog().show())
                : null,
            title: Text(
              controller.recipe?.name ?? '',
              style: Get.textTheme.headlineLarge
                  ?.copyWith(color: Get.theme.colorScheme.onPrimary),
            ),
          );
  }
}
