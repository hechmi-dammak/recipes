import 'package:flutter/material.dart';
import 'package:mekla/models/entities/recipe.dart';
import 'package:mekla/models/interfaces/selection_model.dart';

class RecipePMRecipes extends Recipe implements SelectionModel {
  @override
  bool selected;
  final ImageProvider? image;

  RecipePMRecipes({this.selected = false, required Recipe recipe})
      : image = recipe.picture.value == null
            ? null
            : MemoryImage(recipe.picture.value!.image),
        super.fromCopy(recipe);
}
