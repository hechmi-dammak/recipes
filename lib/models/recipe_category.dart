import 'package:isar/isar.dart';
import 'package:recipes/models/picture.dart';

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
}
