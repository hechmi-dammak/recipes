import 'package:flutter/material.dart';
import 'package:mekla/models/entities/recipe_category.dart';
import 'package:mekla/models/interfaces/model_image.dart';
import 'package:mekla/models/interfaces/model_selected.dart';

class RecipeCategoryPMRecipeCategories extends RecipeCategory
    implements ModelSelected, ModelImage {
  @override
  bool selected;
  @override
  final ImageProvider? image;

  RecipeCategoryPMRecipeCategories(
      {this.selected = false, required RecipeCategory recipeCategory})
      : image = recipeCategory.picture.value == null
            ? null
            : MemoryImage(recipeCategory.picture.value!.image),
        super.fromCopy(recipeCategory);
}
