import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/custom_app_bar.dart';
import 'package:recipes/components/custom_app_bar_bottom.dart';
import 'package:recipes/components/loading_widget.dart';
import 'package:recipes/components/serving_spin_box.dart';
import 'package:recipes/modules/recipe_info_page/components/image_view.dart';
import 'package:recipes/modules/recipe_info_page/components/ingredients/ingredients_list.dart';
import 'package:recipes/modules/recipe_info_page/components/instructions/instructions_list.dart';
import 'package:recipes/modules/recipe_info_page/recipe_info_controller.dart';

class RecipeInfoPage extends StatelessWidget {
  static const routeName = '/recipe';

  const RecipeInfoPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecipeInfoController>(
      builder: (recipeInfoController) {
        return SafeArea(
          child: Scaffold(
            appBar: CustomAppBar(
                title: recipeInfoController.recipe.name.capitalize!,
                actions: [
                  IconButton(
                      onPressed: recipeInfoController.editRecipe,
                      icon: Icon(
                        Icons.edit,
                        size: 30,
                        color: Get.theme.colorScheme.onPrimary,
                      ))
                ],
                leading: Navigator.of(context).canPop()
                    ? IconButton(
                        onPressed: () async {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Get.theme.colorScheme.onPrimary,
                          size: 25,
                        ))
                    : null),
            body: CustomAppBarBottom(
              child: RefreshIndicator(
                onRefresh: recipeInfoController.initRecipe,
                child: LoadingWidget(
                  loading: recipeInfoController.loading,
                  child: ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    children: [
                      Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: ServingSpinBox(
                              changeServingFunction: (value) =>
                                  recipeInfoController.servings = value,
                              servings: recipeInfoController.servings)),
                      if (recipeInfoController.recipe.picture?.image != null)
                        ImageView(
                            image: recipeInfoController.recipe.picture!.image!),
                      const IngredientsList(),
                      const InstructionsList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
