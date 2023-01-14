import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:recipes/models/recipe_category.dart';
import 'package:recipes/views/recipe_category/recipes_categories_controller.dart';
import 'package:recipes/views/recipe_category/widgets/add_recipe_category_card.dart';
import 'package:recipes/widgets/conditional_widget.dart';
import 'package:recipes/widgets/custom_card.dart';
import 'package:recipes/widgets/loading_widget.dart';

import 'widgets/description_dialog.dart';

class RecipesCategoriesPage extends StatelessWidget {
  static const routeName = '/recipes-categories';

  const RecipesCategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipesCategoriesController>(
        initState: RecipesCategoriesController.find.initState,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: InkWell(
                radius: 1, borderRadius: BorderRadius.circular(5),
                //todo
                onTap: () {},
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

class RecipeCategoryCard extends StatelessWidget {
  const RecipeCategoryCard({Key? key, required this.recipeCategory})
      : super(key: key);
  final RecipeCategory recipeCategory;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      backgroundColor: Get.theme.colorScheme.tertiary,
      child: Stack(
        children: [
          ConditionalWidget(
              condition: recipeCategory.picture != null,
              child: (context) => ClipRRect(
                    borderRadius: BorderRadius.circular(6.5),
                    child: Image.memory(
                      recipeCategory.picture!.image,
                      fit: BoxFit.cover,
                    ),
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
              offset:
                  Offset(constrain.maxWidth * .43, constrain.maxHeight * 0.16),
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
          )
        ],
      ),
    );
  }
}
