import 'package:isar/isar.dart';
import 'package:mekla/models/isar_models/picture.dart';

part 'recipe_category.g.dart';

@Collection(accessor: 'recipeCategories')
class RecipeCategory {
  Id? id;
  @Index()
  String name;
  String? description;
  final IsarLink<Picture> picture;

  RecipeCategory({
    this.id,
    this.name = '',
    this.description,
    IsarLink<Picture>? picture,
  }) : picture = picture ?? IsarLink<Picture>();

  RecipeCategory.fromCopy(RecipeCategory recipeCategory)
      : id = recipeCategory.id,
        name = recipeCategory.name,
        description = recipeCategory.description,
        picture = recipeCategory.picture;

  Map<String, dynamic> toMap([bool withId = true]) {
    return {
      if (withId) 'id': id,
      'name': name,
      'description': description,
      'picture': picture.value?.toMap(withId),
    };
  }

  factory RecipeCategory.fromMap(Map<String, dynamic> map) {
    final RecipeCategory recipeCategory = RecipeCategory(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
    if (map['picture'] != null) {
      recipeCategory.picture.value = Picture.fromMap(map['picture']);
    }
    return recipeCategory;
  }
}
