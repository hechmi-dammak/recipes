import 'package:flutter/material.dart';
import 'package:recipes/models/recipe_ingredient.dart';

class RecipeIngredientPMRecipe extends RecipeIngredient {
  bool selected;
  bool used;
  final ImageProvider? image;

  RecipeIngredientPMRecipe(
      {this.selected = false,
      this.used = false,
      required RecipeIngredient recipeIngredient})
      : image = recipeIngredient.ingredient.value?.picture.value == null
            ? null
            : MemoryImage(
                recipeIngredient.ingredient.value!.picture.value!.image),
        super.fromCopy(recipeIngredient);
}
