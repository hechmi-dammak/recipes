import 'dart:collection';

import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/picture.dart';
import 'package:recipes/models/step.dart';

const String tableRecipes = 'recipes';

class RecipeFields {
  static final List<String> values = [
    /// Add all fields expect ManyToMany and OneToMany
    id, name, category, servings, pictureId
  ];
  static const String id = '_id';
  static const String name = 'name';
  static const String category = 'category';
  static const String ingredients = 'ingredients';
  static const String steps = 'steps';
  static const String servings = 'servings';
  static const String pictureId = 'picture_id';
  static const String picture = 'picture';
}

class Recipe {
  int? id;
  String name;
  String? category;
  int? servings;
  List<Step>? steps;
  List<Ingredient>? ingredients;
  Map<String, List<Ingredient>>? ingredientsByCategory;
  bool? selected = false;
  Picture? picture;
  Recipe(
      {this.id,
      this.name = "",
      this.category,
      this.servings = 1,
      this.ingredients = const [],
      this.steps = const [],
      this.selected = false,
      this.picture}) {
    initIngredientsByCategory();
  }
  initIngredientsByCategory() {
    ingredientsByCategory = {};
    if (ingredients != null) {
      for (var ingredient in ingredients!) {
        ingredientsByCategory!.update(ingredient.category ?? "ingredient",
            (value) {
          value.add(ingredient);
          return value;
        }, ifAbsent: () => List.from([ingredient]));
      }
    }
    ingredientsByCategory = SplayTreeMap.from(ingredientsByCategory!,
        (String key1, String key2) => key1.compareTo(key2));

    ingredientsByCategory!.forEach((key, value) {
      value.sort((a, b) {
        return a.name.compareTo(b.name);
      });
    });
  }

  static Recipe fromJson(Map<String, dynamic> json) => Recipe(
      id: json[RecipeFields.id] as int?,
      name: json[RecipeFields.name] as String,
      category: json[RecipeFields.category] as String?,
      servings: json[RecipeFields.servings] as int?,
      steps: getStepsfromJson(json),
      ingredients: getIngredientsfromJson(json),
      picture: json[RecipeFields.picture] != null
          ? Picture.fromJson(json[RecipeFields.picture])
          : null);

  static Recipe fromDatabaseJson(Map<String, dynamic> json) => Recipe(
        id: json[RecipeFields.id] as int?,
        name: json[RecipeFields.name] as String,
        category: json[RecipeFields.category] as String?,
        servings: json[RecipeFields.servings] as int?,
      );

  static List<Step> getStepsfromJson(Map<String, dynamic> json) {
    if (json[RecipeFields.steps] == null) return [];
    List<Step> steps = [];
    json[RecipeFields.steps].forEach((v) {
      steps.add(Step.fromJson(v));
    });
    return steps;
  }

  static List<Ingredient> getIngredientsfromJson(Map<String, dynamic> json) {
    if (json[RecipeFields.ingredients] == null) return [];
    List<Ingredient> ingredients = [];
    json[RecipeFields.ingredients].forEach((v) {
      ingredients.add(Ingredient.fromJson(v));
    });
    return ingredients;
  }

  Map<String, dynamic> toJson([export = false]) => {
        if (!export) RecipeFields.id: id,
        RecipeFields.name: name,
        if (!export || (category != null && category!.isNotEmpty))
          RecipeFields.category: category == "" ? null : category,
        if (!export || servings != null) RecipeFields.servings: servings,
        if (!export || (steps != null && steps!.isNotEmpty))
          RecipeFields.steps: steps == null || steps!.isEmpty
              ? null
              : steps!.map((v) => v.toJson(export)).toList(),
        if (!export || (ingredients != null && ingredients!.isNotEmpty))
          RecipeFields.ingredients: ingredients == null || ingredients!.isEmpty
              ? null
              : ingredients!.map((v) => v.toJson(export)).toList(),
        if (!export || picture != null) RecipeFields.picture: picture?.toJson(),
      };
  Map<String, dynamic> toDatabaseJson([bool noId = false]) => {
        RecipeFields.id: noId ? null : id,
        RecipeFields.name: name,
        RecipeFields.category: category == "" ? null : category,
        RecipeFields.servings: servings ?? 1,
        RecipeFields.pictureId: picture?.id
      };
  Recipe copy(
          {int? id,
          String? name,
          String? category,
          int? servings,
          List<Step>? steps,
          List<Ingredient>? ingredients,
          Picture? picture}) =>
      Recipe(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        servings: servings ?? this.servings,
        ingredients: ingredients ?? this.ingredients,
        steps: steps ?? this.steps,
        picture: picture ?? this.picture,
      );
}
