import 'package:flutter/material.dart';
import 'package:mekla/models/entities/ingredient_category.dart';
import 'package:mekla/models/interfaces/model_image.dart';
import 'package:mekla/models/interfaces/model_selected.dart';

class IngredientCategoryPMIngredientCategories extends IngredientCategory
    implements ModelSelected, ModelImage {
  @override
  bool selected;
  @override
  final ImageProvider? image;

  IngredientCategoryPMIngredientCategories(
      {this.selected = false, required IngredientCategory ingredientCategory})
      : image = ingredientCategory.picture.value == null
            ? null
            : MemoryImage(ingredientCategory.picture.value!.image),
        super.fromCopy(ingredientCategory);
}
