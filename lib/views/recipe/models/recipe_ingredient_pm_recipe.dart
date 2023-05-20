import 'package:flutter/material.dart';
import 'package:mekla/models/entities/recipe_ingredient.dart';
import 'package:mekla/models/interfaces/selection_model.dart';

class RecipeIngredientPMRecipe extends RecipeIngredient
    implements SelectionModel {
  @override
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
