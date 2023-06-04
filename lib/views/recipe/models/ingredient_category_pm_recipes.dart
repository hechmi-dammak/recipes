import 'package:flutter/material.dart';
import 'package:mekla/models/entities/ingredient_category.dart';
import 'package:mekla/models/interfaces/model_images.dart';
import 'package:mekla/models/interfaces/model_selected.dart';
import 'package:mekla/services/image_service.dart';
import 'package:mekla/views/recipe/models/recipe_ingredient_pm_recipe.dart';

class IngredientCategoryPMRecipe extends IngredientCategory
    implements ModelSelected, ModelImages {
  @override
  bool selected;
  @override
  final List<ImageProvider>? images;
  List<RecipeIngredientPMRecipe> ingredients;

  IngredientCategoryPMRecipe(
      {this.selected = false,
      required IngredientCategory ingredientCategory,
      List<RecipeIngredientPMRecipe>? ingredients})
      : ingredients = ingredients ?? [],
        images = ingredientCategory.picture.value == null
            ? null
            : ImageService.find
                .splitImage(ingredientCategory.picture.value!.image),
        super.fromCopy(ingredientCategory);
}
