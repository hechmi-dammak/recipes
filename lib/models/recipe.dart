import 'package:recipes/models/ingredient.dart';
import 'dart:convert';

import 'package:recipes/models/step.dart';

const String tableRecipes = 'recipes';

class RecipeFields {
  static final List<String> values = [
    /// Add all fields expect ManyToMany and OneToMany
    id, name, category
  ];
  static const String id = '_id';
  static const String name = 'name';
  static const String category = 'category';
  static const String ingredients = 'ingredients';
  static const String steps = 'steps';
}

class Recipe {
  int? id;
  String name;
  String? category;
  List<Step>? steps;
  List<Ingredient>? ingredients;
  Map<String, List<Ingredient>>? ingredientsByCategory;
  bool? selected = false;
  Recipe(
      {this.id,
      this.name = "",
      this.category,
      this.ingredients = const [],
      this.steps = const [],
      this.selected = false}) {
    initIngredientsByCategory();
  }
  initIngredientsByCategory() {
    ingredientsByCategory = {};
    if (ingredients != null) {
      for (var ingredient in ingredients!) {
        ingredientsByCategory!.update(ingredient.category, (value) {
          value.add(ingredient);
          return value;
        }, ifAbsent: () => List.from([ingredient]));
      }
    }
    ingredientsByCategory!.forEach((key, value) {
      value.sort((a, b) {
        return a.name.compareTo(b.name);
      });
    });
  }

  static Recipe fromJson(Map<String, dynamic> json) => Recipe(
      id: json[RecipeFields.id] as int?,
      name: json[RecipeFields.name] as String,
      category: json[RecipeFields.category] as String,
      steps: getStepsfromJson(json),
      ingredients: getIngredientsfromJson(json));

  static Recipe fromDatabaseJson(Map<String, dynamic> json) => Recipe(
      id: json[RecipeFields.id] as int?,
      name: json[RecipeFields.name] as String,
      category: json[RecipeFields.category] as String,
      steps: json[RecipeFields.steps] == null
          ? null
          : jsonDecode(json[RecipeFields.steps]));

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

  Map<String, dynamic> toJson() => {
        RecipeFields.id: id,
        RecipeFields.name: name,
        RecipeFields.category: category,
        RecipeFields.steps: steps,
        RecipeFields.ingredients: ingredients == null
            ? null
            : ingredients!.map((v) => v.toJson()).toList(),
      };
  Map<String, dynamic> toDatabaseJson() => {
        RecipeFields.id: id,
        RecipeFields.name: name,
        RecipeFields.category: category,
        RecipeFields.steps: jsonEncode(steps),
      };
  Recipe copy(
          {int? id,
          String? name,
          String? category,
          List<Step>? steps,
          List<Ingredient>? ingredients}) =>
      Recipe(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        ingredients: ingredients ?? this.ingredients,
        steps: steps ?? this.steps,
      );
}
