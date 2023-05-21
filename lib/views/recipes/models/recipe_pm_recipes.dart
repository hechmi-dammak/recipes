import 'package:flutter/material.dart';
import 'package:mekla/models/entities/recipe.dart';
import 'package:mekla/models/interfaces/model_image.dart';
import 'package:mekla/models/interfaces/model_selected.dart';

class RecipePMRecipes extends Recipe implements ModelSelected, ModelImage {
  @override
  bool selected;
  @override
  final ImageProvider? image;

  RecipePMRecipes({this.selected = false, required Recipe recipe})
      : image = recipe.picture.value == null
            ? null
            : MemoryImage(recipe.picture.value!.image),
        super.fromCopy(recipe);
}
