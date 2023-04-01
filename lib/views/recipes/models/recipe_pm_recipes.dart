import 'package:flutter/material.dart';
import 'package:recipes/models/recipe.dart';

class RecipePMRecipes extends Recipe {
  bool selected;
  final ImageProvider? image;

  RecipePMRecipes({this.selected = false, required Recipe recipe})
      : image = recipe.picture.value == null
            ? null
            : MemoryImage(recipe.picture.value!.image),
        super.fromCopy(recipe);
}
