import 'package:flutter/material.dart';
import 'package:mekla/models/entities/recipe_category.dart';
import 'package:mekla/models/interfaces/selection_model.dart';
import 'package:mekla/services/image_operations.dart';
import 'package:mekla/views/recipes/models/recipe_pm_recipes.dart';

class RecipeCategoryPMRecipes extends RecipeCategory implements SelectionModel {
  @override
  bool selected;
  final List<ImageProvider>? image;
  List<RecipePMRecipes> recipes;

  RecipeCategoryPMRecipes(
      {this.selected = false,
      required RecipeCategory recipeCategory,
      List<RecipePMRecipes>? recipes})
      : recipes = recipes ?? [],
        image = recipeCategory.picture.value == null
            ? null
            : ImageService.find.splitImage(recipeCategory.picture.value!.image),
        super.fromCopy(recipeCategory);
}
