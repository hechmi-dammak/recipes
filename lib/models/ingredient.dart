const String tableIngredients = 'ingredients';

class IngredientFields {
  static final List<String> values = [
    id,
    name,
    category,
    quantity,
    measuring,
    description,
    recipeId
  ];
  static const String id = '_id';
  static const String name = 'name';
  static const String category = 'category';
  static const String quantity = 'quantity';
  static const String measuring = 'measuring';
  static const String description = 'description';
  static const String recipeId = 'recipe_id';
}

class Ingredient {
  int? id;
  String name;
  String? category;
  double? quantity;
  String? measuring;
  String? description;

  Ingredient({
    this.id,
    this.name = '',
    this.category,
    this.quantity,
    this.measuring,
    this.description,
  });

  factory Ingredient.fromJson(
    Map<String, dynamic> json, {
    bool database = false,
  }) {
    return Ingredient(
        id: json[IngredientFields.id] as int?,
        name: json[IngredientFields.name] as String,
        category: json[IngredientFields.category] as String?,
        quantity: json[IngredientFields.quantity] as double?,
        measuring: json[IngredientFields.measuring] as String?,
        description: json[IngredientFields.description] as String?);
  }

  Map<String, dynamic> toJson({
    bool database = false,
    bool withId = true,
    int? recipeId,
  }) =>
      {
        if (!database || withId) IngredientFields.id: id,
        IngredientFields.name: name,
        IngredientFields.category: category == '' ? null : category,
        IngredientFields.quantity: quantity,
        IngredientFields.measuring: measuring == '' ? null : measuring,
        IngredientFields.description: description == '' ? null : description,
        IngredientFields.recipeId: recipeId,
      };

  String? getQuantity(int servings, [int? recipeServings]) {
    String result = '';
    if (quantity != null) {
      final num resultQuantity =
          ((quantity! * servings) / (recipeServings ?? 1));
      if (resultQuantity % 1 == 0) {
        result += '${resultQuantity.toInt()} ';
      } else {
        result += '$resultQuantity ';
      }
    }
    if (measuring != null) {
      result += '${measuring!} ';
    }
    return result == '' ? null : result;
  }

  Ingredient copy({
    int? id,
    String? name,
    String? category,
    double? quantity,
    String? measuring,
    String? size,
    String? description,
  }) =>
      Ingredient(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        quantity: quantity ?? this.quantity,
        measuring: measuring ?? this.measuring,
        description: description ?? this.description,
      );
}
