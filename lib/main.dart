import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/decoration/theme.dart';
import 'package:recipes/controller/recipe_create_controller.dart';
import 'package:recipes/controller/recipe_info_controller.dart';
import 'package:recipes/routes/recipe_list_page.dart';

import 'controller/recipes_controller.dart';

void main() {
  Get.put(RecipesController());
  Get.put(RecipeInfoController());
  Get.put(RecipeCreateController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipes',
      theme: AplicationTheme.getTheme(),
      home: const HomePage(),
    );
  }
}
