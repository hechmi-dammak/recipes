import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/views/recipe/recipe_controller/recipe_controller.dart';
import 'package:recipes/views/recipe/widgets/bottom_navigation_button.dart';
import 'package:recipes/views/recipe/widgets/ingredients_tab.dart';
import 'package:recipes/views/recipe/widgets/steps_tab.dart';
import 'package:recipes/widgets/common/asset_button.dart';
import 'package:recipes/widgets/common/conditional_widget.dart';
import 'package:recipes/widgets/project/custom_app_bar.dart';
import 'package:recipes/widgets/project/custom_page.dart';
import 'package:recipes/widgets/project/hidden_title_button.dart';
import 'package:recipes/widgets/project/servings_icon.dart';
import 'package:recipes/widgets/project/title_app_bar_button.dart';

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
        condition: controller.tabController.index == 0,
        child: (context) => ServingsIcon(
            color: Get.theme.colorScheme.onPrimary,
            servings: controller.servings,
            onTap: () => controller.showServingsDialog()),
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
      secondTitle: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
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
      ),
    );
  }
}
