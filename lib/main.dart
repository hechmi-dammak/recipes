import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/modules/recipe_list_page/page/recipe_list_page.dart';

import 'modules/recipe_edit_page/controller/recipe_edit_controller.dart';
import 'modules/recipe_info_page.dart/controller/recipe_info_controller.dart';
import 'modules/recipe_list_page/controller/recipes_controller.dart';
import 'utils/decorations/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.put(RecipesController());
        Get.put(RecipeInfoController());
        Get.put(RecipeEditController());
      }),
      debugShowCheckedModeBanner: false,
      title: 'Recipes',
      theme: AplicationTheme.getTheme(),
      home: const RecipeListPage(),
    );
  }
}
