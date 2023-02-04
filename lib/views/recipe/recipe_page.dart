import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/views/recipe/recipe_controller.dart';
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
  Widget? bottom(
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
