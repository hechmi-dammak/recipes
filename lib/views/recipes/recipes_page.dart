import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:recipes/views/recipe_categories/recipe_categories_page.dart';
import 'package:recipes/views/recipes/recipes_controller.dart';
import 'package:recipes/views/recipes/widgets/recipe_card.dart';
import 'package:recipes/widgets/common/loading_widget.dart';
import 'package:recipes/widgets/project/add_element_card.dart';
import 'package:recipes/widgets/project/custom_app_bar.dart';

import 'package:recipes/widgets/project/title_app_bar_button.dart';

class RecipesPage extends StatelessWidget {
  static const routeName = '${RecipeCategoriesPage.routeName}/:id/recipes';

  const RecipesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipesController>(
        initState: RecipesController.find.initState,
        builder: (controller) {
          return Scaffold(
            appBar: controller.getSelectionIsActive()
                ? CustomAppBar(
                    leading: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        controller.setSelectAllValue();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: SvgPicture.asset(
                            'assets/icons/back_arrow_icon.svg',
                            semanticsLabel: 'Cancel Selection'.tr,
                            height: 20,
                            width: 20,
                            fit: BoxFit.scaleDown),
                      ),
                    ),
                    action: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        controller.setSelectAllValue(
                            value: !controller.getAllItemsSelected());
                      },
                      child: Container(
                        padding: const EdgeInsets.only(right: 10),
                        child: SvgPicture.asset(
                            !controller.getAllItemsSelected()
                                ? 'assets/icons/deselect_all_icon.svg'
                                : 'assets/icons/select_all_icon.svg',
                            semanticsLabel: !controller.getAllItemsSelected()
                                ? 'Deselect All'.tr
                                : 'Select All'.tr,
                            height: 20,
                            width: 20,
                            fit: BoxFit.scaleDown),
                      ),
                    ),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TitleAppBarButton(
                          title: 'Delete'.tr,
                          icon: 'assets/icons/trash_icon.svg',
                          onTap: () {
                            controller.deleteSelectedRecipes();
                          },
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            constraints: controller.selectionCount() != 1
                                ? const BoxConstraints(
                                    maxWidth: 0.0, maxHeight: 0.0)
                                : const BoxConstraints(),
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 200),
                              scale: controller.selectionCount() != 1 ? 0 : 1,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    width: 25,
                                  ),
                                  TitleAppBarButton(
                                      title: 'Edit'.tr,
                                      icon: 'assets/icons/edit_icon.svg',
                                      onTap: controller.editRecipe)
                                ],
                              ),
                            ),
                          ),
                        ),
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
                    leading: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset(
                          'assets/icons/back_arrow_icon.svg',
                          semanticsLabel: 'back arrow'.tr,
                          height: 20,
                          width: 20,
                          fit: BoxFit.scaleDown),
                    ),
                    title: Text(
                      'Recipes'.tr,
                      style: Get.textTheme.headlineLarge
                          ?.copyWith(color: Get.theme.colorScheme.onPrimary),
                    ),
                  ),
            body: SafeArea(
              child: LoadingWidget(
                loading: controller.getLoading(),
                child: RefreshIndicator(
                  onRefresh: controller.fetchData,
                  child: GridView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (MediaQuery.of(context).size.width / 300).ceil(),
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20),
                    children: [
                      ...controller.recipes
                          .map((recipe) => RecipeCard(recipe: recipe))
                          .toList(),
                      AddElementCard(
                          onTap: controller.addRecipe,
                          semanticsLabel: 'Add Recipe'.tr),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
