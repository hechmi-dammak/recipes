import 'package:flutter/material.dart';
import 'package:mekla/models/entities/recipe_category.dart';
import 'package:mekla/models/interfaces/selection_model.dart';

class RecipeCategoryPMRecipeCategories extends RecipeCategory
    implements SelectionModel {
  @override
  bool selected;
  final ImageProvider? image;

  RecipeCategoryPMRecipeCategories(
      {this.selected = false, required RecipeCategory recipeCategory})
      : image = recipeCategory.picture.value == null
            ? null
            : MemoryImage(recipeCategory.picture.value!.image),
        super.fromCopy(recipeCategory);
}