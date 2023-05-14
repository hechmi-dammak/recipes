import 'package:flutter/material.dart';
import 'package:mekla/models/isar_models/ingredient.dart';
import 'package:mekla/models/selection_model.dart';

class IngredientPMIngredients extends Ingredient implements SelectionModel {
  @override
  bool selected;
  final ImageProvider? image;

  IngredientPMIngredients(
      {this.selected = false, required Ingredient ingredient})
      : image = ingredient.picture.value == null
            ? null
            : MemoryImage(ingredient.picture.value!.image),
        super.fromCopy(ingredient);
}
