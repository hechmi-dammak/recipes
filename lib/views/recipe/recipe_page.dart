import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/views/recipe/recipe_controller.dart';
import 'package:recipes/views/recipe/widgets/bottom_navigation_button.dart';
import 'package:recipes/views/recipe/widgets/ingredients_tab.dart';
import 'package:recipes/views/recipe/widgets/steps_tab.dart';
import 'package:recipes/widgets/common/svg_button.dart';
import 'package:recipes/widgets/project/custom_page.dart';

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
              icon: 'assets/icons/scale_icon.svg',
              selected: controller.tabController.index == 0,
              onTap: () => controller.changeTab(0)),
          BottomNavigationBarButton(
            title: 'Steps'.tr,
            icon: 'assets/icons/hat_icon.svg',
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
    return AppBar(
      centerTitle: true,
      leading: SvgButton.backButton(),
      title: Text(
        controller.recipe?.name ?? '',
        style: Get.textTheme.headlineLarge
            ?.copyWith(color: Get.theme.colorScheme.onPrimary),
      ),
    );
  }
}
