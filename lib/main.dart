import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/controller_decorator/base_contoller.dart';
import 'package:recipes/helpers/theme.dart';
import 'package:recipes/service/data_base_provider.dart';
import 'package:recipes/service/image_operations.dart';
import 'package:recipes/service/repository/ingredient_repository.dart';
import 'package:recipes/service/repository/instruction_repository.dart';
import 'package:recipes/service/repository/picture_repository.dart';
import 'package:recipes/service/repository/recipe_category_repository.dart';
import 'package:recipes/service/repository/recipe_repository.dart';
import 'package:recipes/views/recipe_category/recipes_categories_controller.dart';
import 'package:recipes/views/recipe_category/recipes_categories_page.dart';

void main() {
  runApp(const RecipesApp());
}

class RecipesApp extends StatelessWidget {
  const RecipesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: GetMaterialApp(
        initialBinding: InitialBindings(),
        debugShowCheckedModeBanner: false,
        title: 'Recipes',
        theme: ApplicationTheme.getTheme(),
        initialRoute: RecipesCategoriesPage.routeName,
        getPages: [
          GetPage(
            name: RecipesCategoriesPage.routeName,
            page: () => const RecipesCategoriesPage(),
            binding: BindingsBuilder.put(
              () => RecipesCategoriesController.create(
                  controller: BaseController()),
            ),
          ),
        ],
      ),
    );
  }
}

class InitialBindings implements Bindings {
  @override
  void dependencies() async {
    Get.put(DataBaseProvider());
    Get.put(InstructionRepository());
    Get.put(PictureRepository());
    Get.put(IngredientRepository());
    Get.put(RecipeRepository());
    Get.put(RecipeCategoryRepository());
    Get.put(ImageOperations());
    await DataBaseProvider.database;
  }
}
