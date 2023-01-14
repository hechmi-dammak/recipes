import 'dart:collection';

import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/instruction.dart';
import 'package:recipes/models/picture.dart';
import 'package:recipes/models/recipe_category.dart';

const String tableRecipes = 'recipes';

class RecipeFields {
  static final List<String> values = [
    id,
    name,
    categoryId,
    servings,
    pictureId
  ];
  static const String id = '_id';
  static const String name = 'name';
  static const String categoryId = 'category_id';
  static const String category = 'category';
  static const String ingredients = 'ingredients';
  static const String instructions = 'instructions';
  static const String servings = 'servings';
  static const String pictureId = 'picture_id';
  static const String picture = 'picture';
}

class Recipe {
  int? id;
  String? uuid;
  String name;
  RecipeCategory? category;
  int servings;
  List<Instruction> instructions;
  List<Ingredient> ingredients;
  Map<String, List<Ingredient>>? ingredientsByCategory;
  Picture? picture;

  Recipe(
      {this.id,
      this.uuid,
      this.name = '',
      this.category,
      this.servings = 4,
      List<Ingredient>? ingredients,
      List<Instruction>? instructions,
      this.picture})
      : instructions = instructions ?? [],
        ingredients = ingredients ?? [] {
    initIngredientsByCategory();
  }

  factory Recipe.fromJson(
    Map<String, dynamic> json, {
    bool database = false,
  }) {
    final recipe = Recipe(
      id: json[RecipeFields.id],
      name: json[RecipeFields.name],
      category: json[RecipeFields.category],
      servings: json[RecipeFields.servings],
    );
    if (!database) {
      recipe.category = json[RecipeFields.category] != null
          ? RecipeCategory.fromJson(json[RecipeFields.category])
          : null;

      recipe.instructions = (json[RecipeFields.instructions] as List?)
              ?.map((instruction) => Instruction.fromJson(instruction))
              .toList() ??
          [];
      recipe.ingredients = (json[RecipeFields.ingredients] as List?)
              ?.map((ingredient) => Ingredient.fromJson(ingredient))
              .toList() ??
          [];
      recipe.picture = json[RecipeFields.picture] != null
          ? Picture.fromJson(json[RecipeFields.picture])
          : null;
    }
    return recipe;
  }

  Map<String, dynamic> toJson({
    bool database = false,
    bool withId = true,
  }) =>
      {
        if (!database || withId) RecipeFields.id: id,
        RecipeFields.name: name,
        if (database) RecipeFields.categoryId: category?.id,
        if (!database && category != null)
          RecipeFields.category: category?.toJson(),
        RecipeFields.servings: servings,
        if (!database && (instructions.isNotEmpty))
          RecipeFields.instructions:
              instructions.map((instruction) => instruction.toJson()).toList(),
        if (!database && (ingredients.isNotEmpty))
          RecipeFields.ingredients:
              ingredients.map((ingredient) => ingredient.toJson()).toList(),
        if (database && picture != null) RecipeFields.pictureId: picture?.id,
        if (!database && picture != null)
          RecipeFields.picture: picture?.toJson(),
      };

  Recipe copy({
    int? id,
    String? name,
    RecipeCategory? category,
    int? servings,
    List<Instruction>? instructions,
    List<Ingredient>? ingredients,
    Picture? picture,
  }) =>
      Recipe(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        servings: servings ?? this.servings,
        ingredients: ingredients ?? this.ingredients,
        instructions: instructions ?? this.instructions,
        picture: picture ?? this.picture,
      );

  //todo review
  void initIngredientsByCategory() {
    ingredientsByCategory = {};

    for (var ingredient in ingredients) {
      ingredientsByCategory!.update(ingredient.category ?? 'ingredient',
          (value) {
        value.add(ingredient);
        return value;
      }, ifAbsent: () => List.from([ingredient]));
    }

    ingredientsByCategory = SplayTreeMap.from(ingredientsByCategory!,
        (String key1, String key2) => key1.compareTo(key2));

    ingredientsByCategory!.forEach((key, value) {
      value.sort((a, b) {
        return a.name.compareTo(b.name);
      });
    });
  }
}
