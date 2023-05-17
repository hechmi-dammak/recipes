import 'package:isar/isar.dart';
import 'package:mekla/models/isar_models/picture.dart';

part 'ingredient_category.g.dart';

@Collection(accessor: 'ingredientCategories')
class IngredientCategory {
  Id? id;
  @Index()
  String name;
  final IsarLink<Picture> picture;

  IngredientCategory({
    this.id,
    this.name = '',
    IsarLink<Picture>? picture,
  }) : picture = picture ?? IsarLink<Picture>();

  IngredientCategory.fromCopy(IngredientCategory ingredientCategory)
      : id = ingredientCategory.id,
        name = ingredientCategory.name,
        picture = ingredientCategory.picture;

  Map<String, dynamic> toMap([bool withId = true]) {
    return {
      if (withId) 'id': id,
      'name': name,
      'picture': picture.value?.toMap(withId)
    };
  }

  factory IngredientCategory.fromMap(Map<String, dynamic> map) {
    final IngredientCategory ingredientCategory = IngredientCategory(
      id: map['id'],
      name: map['name'],
    );
    if (map['picture'] != null) {
      ingredientCategory.picture.value = Picture.fromMap(map['picture']);
    }
    return ingredientCategory;
  }
}
