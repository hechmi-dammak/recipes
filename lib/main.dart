import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/decorations/theme.dart';
import 'package:recipes/controller/recipe_info_controller.dart';
import 'package:recipes/routes/home_page.dart';

import 'controller/recipes_controller.dart';

void main() {
  Get.put(RecipesController());
  Get.put(RecipeInfoController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipes',
      theme: AplicationTheme.getTheme()
          .copyWith(backgroundColor: Colors.grey.shade200),
      home: const HomePage(),
    );
  }
}
