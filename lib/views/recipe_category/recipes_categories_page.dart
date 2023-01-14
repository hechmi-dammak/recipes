import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:recipes/views/recipe_category/widgets/add_recipe_category_button.dart';
import 'package:recipes/views/recipe_category/recipes_categories_controller.dart';
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
                      AddRecipeCategoryButton(
                          onTap: controller.addRecipeCategory,
                          semanticsLabel: 'Add Recipe Category'.tr),
                    ],
                    // child: Container(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20),
                    //   child: Column(
                    //     children: [
                    //       ...controller.recipeCategories
                    //           .map((recipeCategory) =>
                    //               Container(child: Text(recipeCategory.name)))
                    //           .toList(),
                    //       RecipeCategoryAddButton()
                    //     ],
                    //   ),
                    // ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
