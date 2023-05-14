import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mekla/helpers/theme.dart';
import 'package:mekla/repository/ingredient_category_repository.dart';
import 'package:mekla/repository/ingredient_repository.dart';
import 'package:mekla/repository/picture_repository.dart';
import 'package:mekla/repository/recipe_category_repository.dart';
import 'package:mekla/repository/recipe_ingredient_repository.dart';
import 'package:mekla/repository/recipe_repository.dart';
import 'package:mekla/repository/step_repository.dart';
import 'package:mekla/service/asset_service.dart';
import 'package:mekla/service/image_operations.dart';
import 'package:mekla/service/isar_service.dart';
import 'package:mekla/service/logger_service.dart';
import 'package:mekla/service/recipe_operations.dart';
import 'package:mekla/service/utils_service.dart';
import 'package:mekla/views/ingredients/ingredients_controller.dart';
import 'package:mekla/views/ingredients/ingredients_page.dart';
import 'package:mekla/views/recipe/recipe_controller/recipe_controller.dart';
import 'package:mekla/views/recipe/recipe_page.dart';
import 'package:mekla/views/recipe_categories/recipe_categories_controller.dart';
import 'package:mekla/views/recipe_categories/recipe_categories_page.dart';
import 'package:mekla/views/recipes/recipes_controller.dart';
import 'package:mekla/views/recipes/recipes_page.dart';

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
          GetPage(
            name: IngredientsPage.routeName,
            page: () => const IngredientsPage(),
            binding: BindingsBuilder.put(
              () => IngredientsController(),
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
