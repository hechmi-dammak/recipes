import 'dart:collection';

import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/instruction.dart';
import 'package:recipes/models/picture.dart';

const String tableRecipes = 'recipes';

class RecipeFields {
  static final List<String> values = [id, name, category, servings, pictureId];
  static const String id = '_id';
  static const String name = 'name';
  static const String category = 'category';
  static const String ingredients = 'ingredients';
  static const String instructions = 'instructions';
  static const String servings = 'servings';
  static const String pictureId = 'picture_id';
  static const String picture = 'picture';
}

class Recipe {
  int? id;
  String name;
  String? category;
  int servings;
  List<Instruction> instructions;
  List<Ingredient> ingredients;
  Map<String, List<Ingredient>>? ingredientsByCategory;
  bool selected = false;
  Picture? picture;
  Recipe(
      {this.id,
      this.name = '',
      this.category,
      this.servings = 1,
      List<Ingredient>? ingredients,
      List<Instruction>? instructions,
      this.selected = false,
      this.picture})
      : instructions = instructions ?? [],
        ingredients = ingredients ?? [] {
    initIngredientsByCategory();
  }
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

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
      id: json[RecipeFields.id],
      name: json[RecipeFields.name],
      category: json[RecipeFields.category],
      servings: json[RecipeFields.servings],
      instructions: getInstructionsFromJson(json),
      ingredients: getIngredientsFromJson(json),
      picture: json[RecipeFields.picture] != null
          ? Picture.fromJson(json[RecipeFields.picture])
          : null);

  factory Recipe.fromDatabaseJson(Map<String, dynamic> json) => Recipe(
        id: json[RecipeFields.id],
        name: json[RecipeFields.name],
        category: json[RecipeFields.category],
        servings: json[RecipeFields.servings],
      );

  static List<Instruction> getInstructionsFromJson(Map<String, dynamic> json) {
    if (json[RecipeFields.instructions] == null) return [];
    final List<Instruction> instructions = [];
    json[RecipeFields.instructions].forEach((v) {
      instructions.add(Instruction.fromJson(v));
    });
    return instructions;
  }

  static List<Ingredient> getIngredientsFromJson(Map<String, dynamic> json) {
    if (json[RecipeFields.ingredients] == null) return [];
    final List<Ingredient> ingredients = [];
    json[RecipeFields.ingredients].forEach((v) {
      ingredients.add(Ingredient.fromJson(v));
    });
    return ingredients;
  }

  Map<String, dynamic> toJson([export = false]) => {
        if (!export) RecipeFields.id: id,
        RecipeFields.name: name,
        if (!export || (category != null && category!.isNotEmpty))
          RecipeFields.category: category == '' ? null : category,
        if (!export) RecipeFields.servings: servings,
        if (!export || (instructions.isNotEmpty))
          RecipeFields.instructions: instructions.isEmpty
              ? null
              :instructions.map((v) => v.toJson(export)).toList(),
        if (!export || (ingredients.isNotEmpty))
          RecipeFields.ingredients: ingredients.isEmpty
              ? null
              : ingredients.map((v) => v.toJson(export)).toList(),
        if (!export || picture != null) RecipeFields.picture: picture?.toJson(),
      };
  Map<String, dynamic> toDatabaseJson([bool noId = false]) => {
        RecipeFields.id: noId ? null : id,
        RecipeFields.name: name,
        RecipeFields.category: category == '' ? null : category,
        RecipeFields.servings: servings,
        RecipeFields.pictureId: picture?.id
      };
  Recipe copy(
          {int? id,
          String? name,
          String? category,
          int? servings,
          List<Instruction>? instructions,
          List<Ingredient>? ingredients,
          Picture? picture}) =>
      Recipe(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        servings: servings ?? this.servings,
        ingredients: ingredients ?? this.ingredients,
        instructions: instructions ?? this.instructions,
        picture: picture ?? this.picture,
      );
}
