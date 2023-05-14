import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/views/ingredients/ingredients_controller.dart';
import 'package:mekla/views/ingredients/widgets/ingredient_card.dart';
import 'package:mekla/widgets/common/asset_button.dart';
import 'package:mekla/widgets/project/add_element_card.dart';
import 'package:mekla/widgets/project/custom_app_bar.dart';
import 'package:mekla/widgets/project/custom_page.dart';
import 'package:mekla/widgets/project/hidden_title_button.dart';
import 'package:mekla/widgets/project/title_app_bar_button.dart';

class IngredientsPage extends CustomPage<IngredientsController> {
  static const routeName = '/ingredients';

  const IngredientsPage({Key? key}) : super(key: key, hasSelection: true);

  @override
  PreferredSizeWidget? appBarBuilder(
      IngredientsController controller, BuildContext context) {
    return CustomAppBar(
      leading: AssetButton.back(
        onTap:
            controller.selectionIsActive ? controller.setSelectAllValue : null,
      ),
      fadeAction: !controller.selectionIsActive,
      secondAction: AssetButton.selectAll(
          allItemsSelected: controller.allItemsSelected,
          onTap: controller.toggleSelectAllValue),
      fadeTitle: !controller.selectionIsActive,
      title: Text(
        'Ingredients'.tr,
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
                onTap: controller.deleteSelectedIngredients),
            HiddenTitleButton(
                hidden: controller.selectionCount != 1,
                child: TitleAppBarButton(
                    title: 'Edit'.tr,
                    icon: 'edit_icon',
                    onTap: controller.editIngredient)),
          ],
        ),
      ),
    );
  }

  @override
  Widget bodyBuilder(IngredientsController controller, BuildContext context) {
    return LayoutBuilder(builder: (context, _) {
      return GridView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (Get.width / 300).ceil(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10),
        children: [
          ...controller.ingredients
              .map((ingredient) => IngredientCard(ingredient: ingredient))
              .toList(),
          AnimatedOpacity(
            opacity: controller.selectionIsActive ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            child: AddElementCard(
              onTap: controller.addIngredient,
              semanticsLabel: 'Add Recipe'.tr,
            ),
          ),
        ],
      );
    });
  }
}
