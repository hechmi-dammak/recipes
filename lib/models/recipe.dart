import 'package:recipes/models/ingredient.dart';

class Recipe {
  late int id;
  late String name;
  List<Ingredient>? spices;
  List<Ingredient>? ingredients;

  Recipe({required this.id, required this.name, this.spices, this.ingredients});
  Recipe.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['spices'] != null) {
      spices = <Ingredient>[];
      json['spices'].forEach((v) {
        spices!.add(Ingredient.fromJson(v));
      });
    }
    if (json['ingredients'] != null) {
      ingredients = <Ingredient>[];
      json['ingredients'].forEach((v) {
        ingredients!.add(Ingredient.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (spices != null) {
      data['spices'] = spices!.map((v) => v.toJson()).toList();
    }
    if (ingredients != null) {
      data['ingredients'] = ingredients!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String getName() {
    return name[0].toUpperCase() + name.substring(1);
  }
}
