import 'package:flutter/material.dart';
import 'package:mekla/models/entities/recipe_category.dart';
import 'package:mekla/models/interfaces/model_images.dart';
import 'package:mekla/models/interfaces/model_selected.dart';
import 'package:mekla/services/image_service.dart';
import 'package:mekla/views/recipes/models/recipe_pm_recipes.dart';

class RecipeCategoryPMRecipes extends RecipeCategory
    implements ModelSelected, ModelImages {
  @override
  bool selected;
  @override
  final List<ImageProvider>? images;
  List<RecipePMRecipes> recipes;

  RecipeCategoryPMRecipes(
      {this.selected = false,
      required RecipeCategory recipeCategory,
      List<RecipePMRecipes>? recipes})
      : recipes = recipes ?? [],
        images = recipeCategory.picture.value == null
            ? null
            : ImageService.find.splitImage(recipeCategory.picture.value!.image),
        super.fromCopy(recipeCategory);
}
