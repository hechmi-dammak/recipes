const String tableIngredients = 'ingredients';

class IngredientFields {
  static final List<String> values = [
    id,
    name,
    category,
    quantity,
    measuring,
    size,
    method,
    recipeId
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String category = 'category';
  static const String quantity = 'quantity';
  static const String measuring = 'measuring';
  static const String size = 'size';
  static const String method = 'method';
  static const String recipeId = 'recipe_id';
}

class Ingredient {
  late int? id;
  String name;
  String category;
  num? quantity;
  String? measuring;
  String? size;
  String? method;
  bool? selected;

  Ingredient(
      {this.id,
      this.name = "",
      this.category = "",
      this.quantity,
      this.measuring,
      this.size,
      this.method,
      this.selected = false});

  static Ingredient fromJson(Map<String, dynamic> json) => Ingredient(
      id: json[IngredientFields.id] as int?,
      name: json[IngredientFields.name] as String,
      category: json[IngredientFields.category] as String,
      quantity: json[IngredientFields.quantity] as num?,
      measuring: json[IngredientFields.measuring] as String?,
      size: json[IngredientFields.size] as String?,
      method: json[IngredientFields.method] as String?,
      selected: false);

  static Ingredient fromDatabaseJson(Map<String, dynamic> json) => Ingredient(
      id: json[IngredientFields.id] as int?,
      name: json[IngredientFields.name] as String,
      category: json[IngredientFields.category] as String,
      quantity: json[IngredientFields.quantity] as num?,
      measuring: json[IngredientFields.measuring] as String?,
      size: json[IngredientFields.size] as String?,
      method: json[IngredientFields.method] as String?,
      selected: false);

  Map<String, dynamic> toJson() => {
        IngredientFields.id: id,
        IngredientFields.name: name,
        IngredientFields.category: category,
        IngredientFields.quantity: quantity,
        IngredientFields.measuring: measuring,
        IngredientFields.size: size,
        IngredientFields.method: method,
      };
  Map<String, dynamic> toDatabaseJson(int? recipeId) => {
        IngredientFields.id: id,
        IngredientFields.name: name,
        IngredientFields.category: category,
        IngredientFields.quantity: quantity,
        IngredientFields.measuring: measuring,
        IngredientFields.size: size,
        IngredientFields.method: method,
        IngredientFields.recipeId: recipeId
      };

  String? getQuantity(int servings) {
    String result = "";
    if (quantity != null) {
      num resultQuantity = (quantity! * servings);
      if (resultQuantity % 1 == 0) {
        result += (quantity! * servings).toInt().toString() + " ";
      } else {
        result += (quantity! * servings).toString() + " ";
      }
    }
    if (size != null) {
      result += size! + " ";
    }
    if (measuring != null) {
      result += measuring! + " ";
    }
    return result == "" ? null : result;
  }

  Ingredient copy(
          {int? id,
          String? name,
          String? category,
          double? quantity,
          String? measuring,
          String? size,
          String? method,
          bool? selected}) =>
      Ingredient(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        quantity: quantity ?? this.quantity,
        measuring: measuring ?? this.measuring,
        size: size ?? this.size,
        method: method ?? this.method,
        selected: selected ?? this.selected,
      );
}
