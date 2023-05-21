import 'package:flutter/material.dart';
import 'package:mekla/models/entities/recipe_ingredient.dart';
import 'package:mekla/models/interfaces/model_image.dart';
import 'package:mekla/models/interfaces/model_selected.dart';
import 'package:mekla/models/interfaces/model_used.dart';

class RecipeIngredientPMRecipe extends RecipeIngredient
    implements ModelSelected, ModelImage, ModelUsed {
  @override
  bool selected;
  @override
  bool used;
  @override
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
