import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/controller_decorator/base_controller/base_contoller.dart';
import 'package:recipes/controller_decorator/decorators/selection_decorator.dart';
import 'package:recipes/helpers/theme.dart';
import 'package:recipes/service/image_operations.dart';
import 'package:recipes/service/isar_service.dart';
import 'package:recipes/service/repository/ingredient_repository.dart';
import 'package:recipes/service/repository/instruction_repository.dart';
import 'package:recipes/service/repository/picture_repository.dart';
import 'package:recipes/service/repository/recipe_category_repository.dart';
import 'package:recipes/service/repository/recipe_repository.dart';
import 'package:recipes/views/recipe_categories/recipe_categories_controller.dart';
import 'package:recipes/views/recipe_categories/recipe_categories_page.dart';
import 'package:recipes/views/recipes/recipes_page.dart';

import 'views/recipes/recipes_controller.dart';

void main() async{
  Get.put(IsarService());
await IsarService.find.init();
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
        initialRoute: RecipeCategoriesPage.routeName,
        getPages: [
          GetPage(
            name: RecipeCategoriesPage.routeName,
            page: () => const RecipeCategoriesPage(),
            binding: BindingsBuilder.put(
              () => RecipeCategoriesController.create(
                  controller:
                      SelectionDecorator.create(controller: BaseController())),
            ),
          ),          GetPage(
            name: RecipesPage.routeName,
            page: () => const RecipesPage(),
            binding: BindingsBuilder.put(
              () => RecipesController.create(
                  controller:
                      SelectionDecorator.create(controller: BaseController())),
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

    // Get.put(InstructionRepository());
    Get.put(PictureRepository());
    // Get.put(IngredientRepository());
    // Get.put(RecipeRepository());
    Get.put(RecipeCategoryRepository());
    Get.put(ImageOperations());

  }
}
