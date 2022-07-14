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
  String? category;
  num? quantity;
  String? measuring;
  String? size;
  String? method;
  bool selected;
  bool inEditing;

  Ingredient(
      {this.id,
      this.name = '',
      this.category,
      this.quantity,
      this.measuring,
      this.size,
      this.method,
      this.selected = false,
      this.inEditing = false});

  static Ingredient fromJson(Map<String, dynamic> json) => Ingredient(
      id: json[IngredientFields.id] as int?,
      name: json[IngredientFields.name] as String,
      category: json[IngredientFields.category] as String?,
      quantity: json[IngredientFields.quantity] as num?,
      measuring: json[IngredientFields.measuring] as String?,
      size: json[IngredientFields.size] as String?,
      method: json[IngredientFields.method] as String?);

  static Ingredient fromDatabaseJson(Map<String, dynamic> json) => Ingredient(
        id: json[IngredientFields.id] as int?,
        name: json[IngredientFields.name] as String,
        category: json[IngredientFields.category] as String?,
        quantity: json[IngredientFields.quantity] as num?,
        measuring: json[IngredientFields.measuring] as String?,
        size: json[IngredientFields.size] as String?,
        method: json[IngredientFields.method] as String?,
      );

  Map<String, dynamic> toJson([export = false]) => {
        if (!export) IngredientFields.id: id,
        IngredientFields.name: name,
        if (!export || (category != null && category!.isNotEmpty))
          IngredientFields.category: category == '' ? null : category,
        if (!export || quantity != null) IngredientFields.quantity: quantity,
        if (!export || (measuring != null && measuring!.isNotEmpty))
          IngredientFields.measuring: measuring == '' ? null : measuring,
        if (!export || (size != null && size!.isNotEmpty))
          IngredientFields.size: size == '' ? null : size,
        if (!export || (method != null && method!.isNotEmpty))
          IngredientFields.method: method == '' ? null : method,
      };

  Map<String, dynamic> toDatabaseJson(int? recipeId, [bool noId = false]) => {
        IngredientFields.id: noId ? null : id,
        IngredientFields.name: name,
        IngredientFields.category: category == '' ? null : category,
        IngredientFields.quantity: quantity,
        IngredientFields.measuring: measuring == '' ? null : measuring,
        IngredientFields.size: size == '' ? null : size,
        IngredientFields.method: method == '' ? null : method,
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
    if (size != null) {
      result += '${size!} ';
    }
    if (measuring != null) {
      result += '${measuring!} ';
    }
    return result == '' ? null : result;
  }

  Ingredient copy(
          {int? id,
          String? name,
          String? category,
          double? quantity,
          String? measuring,
          String? size,
          String? method,
          bool? selected,
          bool? inEditing}) =>
      Ingredient(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        quantity: quantity ?? this.quantity,
        measuring: measuring ?? this.measuring,
        size: size ?? this.size,
        method: method ?? this.method,
        selected: selected ?? this.selected,
        inEditing: inEditing ?? this.inEditing,
      );
}
