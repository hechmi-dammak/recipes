import 'package:isar/isar.dart';
import 'package:recipes/models/picture.dart';

part 'ingredient.g.dart';

@collection
class Ingredient {
  Id? id;
  @Index()
  String name;
  final IsarLink<Picture> picture;

  Ingredient({
    this.name = '',
    IsarLink<Picture>? picture,
  }) : picture = picture ?? IsarLink<Picture>();

  Ingredient.fromCopy(Ingredient ingredient)
      : id = ingredient.id,
        name = ingredient.name,
        picture = ingredient.picture;
}
