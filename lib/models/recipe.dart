import 'package:recipes/models/ingredient.dart';
import 'dart:convert';

const String tableRecipes = 'recipes';

class RecipeFields {
  static final List<String> values = [
    /// Add all fields
    id, name, category, steps
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
  List<String>? steps;

  List<Ingredient>? ingredients;
  Map<String, List<Ingredient>>? ingredientsByCategory;
  bool? selected = false;
  Recipe(
      {this.id,
      this.name = "",
      this.category,
      this.ingredients,
      this.steps,
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
  }

  static Recipe fromJson(Map<String, dynamic> json) => Recipe(
      id: json[RecipeFields.id] as int?,
      name: json[RecipeFields.name] as String,
      category: json[RecipeFields.category] as String,
      steps: json[RecipeFields.steps] as List<String>?,
      ingredients: getIngridientfromJson(json));

  static Recipe fromDatabaseJson(Map<String, dynamic> json) => Recipe(
      id: json[RecipeFields.id] as int?,
      name: json[RecipeFields.name] as String,
      category: json[RecipeFields.category] as String,
      steps: json[RecipeFields.steps] == null
          ? null
          : jsonDecode(json[RecipeFields.steps]),
      ingredients: []);

  static getIngridientfromJson(Map<String, dynamic> json) {
    if (json[RecipeFields.ingredients] == null) return [];
    List<Ingredient> ingredientstmp = [];
    json[RecipeFields.ingredients].forEach((v) {
      ingredientstmp.add(Ingredient.fromJson(v));
    });
    return ingredientstmp;
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
          List<String>? steps,
          List<Ingredient>? ingredients}) =>
      Recipe(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        ingredients: ingredients ?? this.ingredients,
        steps: steps ?? this.steps,
      );
}
