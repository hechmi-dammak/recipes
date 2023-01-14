import 'package:recipes/models/picture.dart';

const String tableRecipesCategories = 'recipes_categorys';

class RecipeCategoryFields {
  static final List<String> values = [id, name, description, pictureId];
  static const String id = '_id';
  static const String name = 'name';
  static const String description = 'description';
  static const String pictureId = 'picture_id';
  static const String picture = 'picture';
}

class RecipeCategory {
  int? id;
  String? uuid;
  String name;
  String? description;
  Picture? picture;

  RecipeCategory({
    this.id,
    this.uuid,
    this.name = '',
    this.description,
    this.picture,
  });

  RecipeCategory.fromCopy(RecipeCategory recipeCategory)
      : id = recipeCategory.id,
        uuid = recipeCategory.uuid,
        name = recipeCategory.name,
        description = recipeCategory.description,
        picture = recipeCategory.picture;

  factory RecipeCategory.fromJson(
    Map<String, dynamic> json, {
    bool database = false,
  }) {
    final recipeCategory = RecipeCategory(
      id: json[RecipeCategoryFields.id],
      name: json[RecipeCategoryFields.name],
      description: json[RecipeCategoryFields.description],
    );
    if (!database) {
      recipeCategory.picture = json[RecipeCategoryFields.picture] != null
          ? Picture.fromJson(json[RecipeCategoryFields.picture])
          : null;
    }
    return recipeCategory;
  }

  Map<String, dynamic> toJson({
    bool database = false,
    bool withId = true,
  }) =>
      {
        if (!database || withId) RecipeCategoryFields.id: id,
        RecipeCategoryFields.name: name,
        RecipeCategoryFields.description:
            description == '' ? null : description,
        if (database && picture != null)
          RecipeCategoryFields.pictureId: picture?.id,
        if (!database && picture != null)
          RecipeCategoryFields.picture: picture?.toJson(),
      };

  RecipeCategory copy({
    int? id,
    String? name,
    String? description,
    Picture? picture,
  }) =>
      RecipeCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        picture: picture ?? this.picture,
      );
}
