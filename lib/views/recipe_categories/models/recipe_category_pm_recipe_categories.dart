import 'package:flutter/material.dart';
import 'package:mekla/models/recipe_category.dart';

class RecipeCategoryPMRecipeCategories extends RecipeCategory {
  bool selected;
  final ImageProvider? image;

  RecipeCategoryPMRecipeCategories(
      {this.selected = false, required RecipeCategory recipeCategory})
      : image = recipeCategory.picture.value == null
            ? null
            : MemoryImage(recipeCategory.picture.value!.image),
        super.fromCopy(recipeCategory);
}
