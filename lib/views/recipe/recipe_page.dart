import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/views/recipe/recipe_controller/recipe_controller.dart';
import 'package:mekla/views/recipe/widgets/bottom_navigation_button.dart';
import 'package:mekla/views/recipe/widgets/ingredients_tab.dart';
import 'package:mekla/views/recipe/widgets/steps_tab.dart';
import 'package:mekla/widgets/common/asset_button.dart';
import 'package:mekla/widgets/common/conditional_widget.dart';
import 'package:mekla/widgets/project/custom_app_bar.dart';
import 'package:mekla/widgets/project/custom_page.dart';
import 'package:mekla/widgets/project/hidden_title_button.dart';
import 'package:mekla/widgets/project/servings_icon.dart';
import 'package:mekla/widgets/project/title_app_bar_button.dart';

class RecipePage extends CustomPage<RecipeController> {
  static const routeName = '/recipes/:id';

  const RecipePage({Key? key}) : super(key: key, hasSelection: true);

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
    return CustomAppBar(
      leading: AssetButton.back(
        onTap:
            controller.selectionIsActive ? controller.setSelectAllValue : null,
      ),
      fadeAction: !controller.selectionIsActive,
      action: ConditionalWidget(
        animated: true,
        condition: controller.tabController.index == 0,
        child: (context) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AssetButton.toggleButton(
                onTap: controller.toggleCategorize,
                icon: 'category_icon',
                active: controller.categorize),
            const SizedBox(
              width: 7,
            ),
            ServingsIcon(
                color: Get.theme.colorScheme.onPrimary,
                servings: controller.servings,
                onTap: () => controller.showServingsDialog()),
            const SizedBox(
              width: 7,
            ),
          ],
        ),
      ),
      secondAction: AssetButton.selectAll(
          allItemsSelected: controller.allItemsSelected,
          onTap: controller.toggleSelectAllValue),
      fadeTitle: !controller.selectionIsActive,
      title: Text(
        controller.recipe?.name ?? '',
        style: Get.textTheme.headlineLarge
            ?.copyWith(color: Get.theme.colorScheme.onPrimary),
      ),
      secondTitleChildren: [
        TitleAppBarButton(
            isStart: true,
            title: 'Delete'.tr,
            icon: 'trash_icon',
            onTap: controller.deleteSelectedItems),
        HiddenTitleButton(
            hidden: controller.selectionCount != 1,
            child: TitleAppBarButton(
                title: 'Edit'.tr, icon: 'edit_icon', onTap: controller.edit))
      ],
    );
  }
}
