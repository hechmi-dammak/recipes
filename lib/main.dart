import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_edit_page/recipe_edit_controller.dart';
import 'package:recipes/modules/recipe_info_page/recipe_info_controller.dart';
import 'package:recipes/modules/recipe_info_page/recipe_info_page.dart';
import 'package:recipes/modules/recipe_list_page/recipe_list_page.dart';
import 'package:recipes/modules/recipe_list_page/recipes_list_controller.dart';
import 'package:recipes/service/data_base_provider.dart';
import 'package:recipes/service/image_operations.dart';
import 'package:recipes/service/repository/ingredient_repository.dart';
import 'package:recipes/service/repository/instruction_repository.dart';
import 'package:recipes/service/repository/picture_repository.dart';
import 'package:recipes/service/repository/recipe_repository.dart';
import 'package:recipes/utils/decorations/theme.dart';

import 'modules/recipe_edit_page/recipe_edit_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        initialRoute: RecipeListPage.routeName,
        getPages: [
          GetPage(
              name: RecipeListPage.routeName,
              page: () {
                return const RecipeListPage();
              },
              binding: BindingsBuilder.put(() {
                return RecipesListController();
              })),
          GetPage(
              name: RecipeInfoPage.routeName,
              page: () => const RecipeInfoPage(),
              binding: BindingsBuilder.put(
                  () => RecipeInfoController(recipeId: Get.arguments))),
          GetPage(
              name: RecipeEditPage.routeName,
              page: () => RecipeEditPage(),
              binding: BindingsBuilder.put(
                  () => RecipeEditController(recipeId: Get.arguments)))
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
    Get.put(ImageOperations());
    await DataBaseProvider.database;
  }
}
