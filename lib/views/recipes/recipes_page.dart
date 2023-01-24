import 'package:flutter/material.dart';
import 'package:recipes/views/recipe_categories/recipe_categories_page.dart';

class RecipesPage extends StatelessWidget {
  static const routeName = '${RecipeCategoriesPage.routeName}/:id/recipes';

  const RecipesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
