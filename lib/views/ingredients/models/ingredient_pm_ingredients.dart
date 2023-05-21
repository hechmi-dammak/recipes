import 'package:flutter/material.dart';
import 'package:mekla/models/entities/ingredient.dart';
import 'package:mekla/models/interfaces/model_image.dart';
import 'package:mekla/models/interfaces/model_selected.dart';

class IngredientPMIngredients extends Ingredient
    implements ModelSelected, ModelImage {
  @override
  bool selected;
  @override
  final ImageProvider? image;

  IngredientPMIngredients(
      {this.selected = false, required Ingredient ingredient})
      : image = ingredient.picture.value == null
            ? null
            : MemoryImage(ingredient.picture.value!.image),
        super.fromCopy(ingredient);
}
