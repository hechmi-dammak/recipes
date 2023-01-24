import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:recipes/views/recipe_category/models/recipe_category_page_model.dart';
import 'package:recipes/views/recipe_category/recipes_categories_controller.dart';
import 'package:recipes/views/recipe_category/widgets/add_recipe_category_card.dart';
import 'package:recipes/views/recipe_category/widgets/description_dialog.dart';
import 'package:recipes/widgets/conditional_widget.dart';
import 'package:recipes/widgets/custom_app_bar.dart';
import 'package:recipes/widgets/loading_widget.dart';

class RecipesCategoriesPage extends StatelessWidget {
  static const routeName = '/recipes-categories';

  const RecipesCategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipesCategoriesController>(
        initState: RecipesCategoriesController.find.initState,
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
                            controller.deleteSelectedCategories();
                          },
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 500),
                          child: Container(
                            constraints: controller.selectionCount() != 1
                                ? const BoxConstraints(
                                    maxWidth: 0.0, maxHeight: 0.0)
                                : const BoxConstraints(),
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 400),
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
                                      onTap: controller.editRecipeCategory)
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
                      onTap: () {}, //todo
                      child: SvgPicture.asset('assets/icons/menu_icon.svg',
                          semanticsLabel: 'Menu'.tr,
                          height: 20,
                          width: 20,
                          fit: BoxFit.scaleDown),
                    ),
                    title: Text(
                      'Categories'.tr,
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
                        childAspectRatio: 2,
                        crossAxisCount:
                            (MediaQuery.of(context).size.width / 600).ceil(),
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20),
                    children: [
                      ...controller.recipeCategories
                          .map((recipeCategory) => RecipeCategoryCard(
                              recipeCategory: recipeCategory))
                          .toList(),
                      AddRecipeCategoryCard(
                          onTap: controller.addRecipeCategory,
                          semanticsLabel: 'Add Recipe Category'.tr),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class TitleAppBarButton extends StatelessWidget {
  const TitleAppBarButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);
  final String title;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(icon,
              semanticsLabel: title,
              height: 20,
              width: 20,
              fit: BoxFit.scaleDown),
          const SizedBox(
            width: 5,
          ),
          Text(
            title,
            style: Get.textTheme.labelSmall
                ?.copyWith(color: Get.theme.colorScheme.onPrimary),
          )
        ],
      ),
    );
  }
}

class RecipeCategoryCard extends GetView<RecipesCategoriesController> {
  const RecipeCategoryCard({Key? key, required this.recipeCategory})
      : super(key: key);
  final RecipeCategoryPageModel recipeCategory;
  static const double borderWidth = 4;
  static const double borderRadius = 6.5;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (controller.getSelectionIsActive()) {
          controller.selectCategory(recipeCategory);
        } else {
          //todo navigate to recipes
        }
      },
      onLongPress: () => controller.selectCategory(recipeCategory),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Get.theme.colorScheme.tertiary,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              ConditionalWidget(
                  condition: recipeCategory.picture.value != null,
                  child: (context) => Image.memory(
                        recipeCategory.picture.value!.image,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      )),
              ConditionalWidget(
                  child: (context) => Positioned(
                        top: 8,
                        left: 7,
                        child: GestureDetector(
                          onTap: () {
                            DescriptionDialog(
                                    title: recipeCategory.name,
                                    description: recipeCategory.description!)
                                .show();
                          },
                          child: Container(
                            height: 18,
                            width: 18,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Get.theme.colorScheme.primary),
                            child: SvgPicture.asset(
                              'assets/icons/info_icon.svg',
                              width: 2, height: 9, fit: BoxFit.scaleDown,
                              // color: Get.theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                  condition: recipeCategory.description != null),
              LayoutBuilder(
                builder: (context, constrain) => Transform.translate(
                  offset: Offset(
                      constrain.maxWidth * 0.43, constrain.maxHeight * 0.16),
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      width: constrain.maxWidth * 0.57,
                      decoration: BoxDecoration(
                          color: Get.theme.colorScheme.primaryContainer,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          )),
                      child: Text(recipeCategory.name,
                          style: Get.textTheme.headlineMedium?.copyWith(
                              color: Get.theme.colorScheme.onPrimaryContainer,
                              overflow: TextOverflow.ellipsis))),
                ),
              ),
              ConditionalWidget(
                  condition: recipeCategory.selected,
                  child: (context) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius),
                          border: Border.all(
                            width: borderWidth,
                            color: Get.theme.colorScheme.primary,
                          ),
                        ),
                      ))
            ],
          ),
        ),
      ),
    );
  }
}
