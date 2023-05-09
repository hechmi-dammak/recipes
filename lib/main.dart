import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:recipes/helpers/theme.dart';
import 'package:recipes/repository/ingredient_category_repository.dart';
import 'package:recipes/repository/ingredient_repository.dart';
import 'package:recipes/repository/picture_repository.dart';
import 'package:recipes/repository/recipe_category_repository.dart';
import 'package:recipes/repository/recipe_ingredient_repository.dart';
import 'package:recipes/repository/recipe_repository.dart';
import 'package:recipes/repository/step_repository.dart';
import 'package:recipes/service/asset_service.dart';
import 'package:recipes/service/image_operations.dart';
import 'package:recipes/service/isar_service.dart';
import 'package:recipes/service/logger_service.dart';
import 'package:recipes/service/recipe_operations.dart';
import 'package:recipes/service/utils_service.dart';
import 'package:recipes/views/recipe/recipe_controller/recipe_controller.dart';
import 'package:recipes/views/recipe/recipe_page.dart';
import 'package:recipes/views/recipe_categories/recipe_categories_controller.dart';
import 'package:recipes/views/recipe_categories/recipe_categories_page.dart';
import 'package:recipes/views/recipes/recipes_controller.dart';
import 'package:recipes/views/recipes/recipes_page.dart';

void main() async {
  await dependencies();
  runZonedGuarded(() async {
    runApp(const RecipesApp());
  }, (error, stackTrace) {
    LoggerService.logger?.errorStackTrace(error, stackTrace, method: 'main');
  });
}

Future<void> dependencies() async {
  Get.put(LoggerService());
  Get.put(IsarService());
  Get.put(AssetService());
  Get.put(RecipeOperations());
  await LoggerService.find.init();
  await IsarService.find.init();
  await RecipeOperations.find.init();
}

class RecipesApp extends StatelessWidget {
  const RecipesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AssetService.find.init(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: GetMaterialApp(
        logWriterCallback: (text, {isError = false}) =>
            LoggerService.logger?.log(isError ? Level.error : Level.info, text),
        initialBinding: InitialBindings(),
        debugShowCheckedModeBanner: false,
        title: 'Recipes',
        theme: ApplicationTheme.getTheme(),
        initialRoute: RecipesPage.routeName,
        getPages: [
          //disabled
          GetPage(
            name: RecipeCategoriesPage.routeName,
            page: () => const RecipeCategoriesPage(),
            binding: BindingsBuilder.put(
              () => RecipeCategoriesController(),
            ),
          ),
          GetPage(
            name: RecipesPage.routeName,
            page: () => const RecipesPage(),
            binding: BindingsBuilder.put(
              () => RecipesController(),
            ),
          ),
          GetPage(
            name: RecipesPage.routeNameCategoriesRecipes,
            page: () => const RecipesPage(),
            binding: BindingsBuilder.put(
              () => RecipesController(
                  categoryId: int.parse(Get.parameters['id'] ?? '')),
            ),
          ),
          GetPage(
            name: RecipePage.routeName,
            page: () => const RecipePage(),
            binding: BindingsBuilder.put(
              () => RecipeController(
                  recipeId: int.parse(Get.parameters['id'] ?? '')),
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
    Get.put(StepRepository());
    Get.put(PictureRepository());
    Get.put(IngredientRepository());
    Get.put(RecipeIngredientRepository());
    Get.put(RecipeRepository());
    Get.put(UtilsService());
    Get.put(RecipeCategoryRepository());
    Get.put(IngredientCategoryRepository());
    Get.put(ImageService());
  }
}
