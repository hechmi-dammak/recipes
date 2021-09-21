import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:recipes/models/recipe.dart';

class JsonOperations {
  static final JsonOperations instance = JsonOperations._init();
  JsonOperations._init();

  Future<List<Recipe>> readJson() async {
    final String response = await rootBundle.loadString('assets/recipes.json');
    final data = await json.decode(response);
    List<Recipe> recipes = [];
    data.forEach((item) {
      recipes.add(Recipe.fromJson(item));
    });
    return recipes;
  }
}
