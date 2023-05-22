import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mekla/helpers/theme.dart';
import 'package:mekla/repositories/ingredient_category_repository.dart';
import 'package:mekla/repositories/ingredient_repository.dart';
import 'package:mekla/repositories/picture_repository.dart';
import 'package:mekla/repositories/recipe_category_repository.dart';
import 'package:mekla/repositories/recipe_ingredient_repository.dart';
import 'package:mekla/repositories/recipe_repository.dart';
import 'package:mekla/repositories/step_repository.dart';
import 'package:mekla/services/asset_service.dart';
import 'package:mekla/services/image_service.dart';
import 'package:mekla/services/isar_service.dart';
import 'package:mekla/services/logger_service.dart';
import 'package:mekla/services/sharing_service.dart';
import 'package:mekla/views/ingredient_categories/ingredient_categories_controller.dart';
import 'package:mekla/views/ingredient_categories/ingredient_categories_page.dart';
import 'package:mekla/views/ingredients/ingredients_controller.dart';
import 'package:mekla/views/ingredients/ingredients_page.dart';
import 'package:mekla/views/recipe/recipe_controller/recipe_controller.dart';
import 'package:mekla/views/recipe/recipe_page.dart';
import 'package:mekla/views/recipe_categories/recipe_categories_controller.dart';
import 'package:mekla/views/recipe_categories/recipe_categories_page.dart';
import 'package:mekla/views/recipes/recipes_controller.dart';
import 'package:mekla/views/recipes/recipes_page.dart';

void main() async {
  runZonedGuarded(() async {
    await dependencies();
    runApp(const RecipesApp());
  }, (error, stackTrace) {
    LoggerService.logger?.errorStackTrace(error, stackTrace, method: 'main');
  });
}

Future<void> dependencies() async {
  Get.put(LoggerService());
  Get.put(IsarService());
  Get.put(AssetService());
  Get.put(SharingService());
  await LoggerService.find.init();
  await IsarService.find.init();
  await SharingService.find.init();
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
            name: RecipeCategoriesPage.routeName,
            page: () => const RecipeCategoriesPage(),
            binding: BindingsBuilder.put(
              () => RecipeCategoriesController(),
            ),
          ),
          GetPage(
            name: IngredientsPage.routeName,
            page: () => const IngredientsPage(),
            binding: BindingsBuilder.put(
              () => IngredientsController(),
            ),
          ),
          GetPage(
            name: IngredientCategoriesPage.routeName,
            page: () => const IngredientCategoriesPage(),
            binding: BindingsBuilder.put(
              () => IngredientCategoriesController(),
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
    Get.put(RecipeCategoryRepository());
    Get.put(IngredientCategoryRepository());
    Get.put(ImageService());
  }
}
