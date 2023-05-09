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
    this.id,
    this.name = '',
    IsarLink<Picture>? picture,
  }) : picture = picture ?? IsarLink<Picture>();

  Ingredient.fromCopy(Ingredient ingredient)
      : id = ingredient.id,
        name = ingredient.name,
        picture = ingredient.picture;

  Map<String, dynamic> toMap([bool withId = true]) {
    return {
      if (withId) 'id': id,
      'name': name,
      'picture': picture.value?.toMap(withId),
    };
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    final Ingredient ingredient = Ingredient(
      id: map['id'],
      name: map['name'],
    );
    if (map['picture'] != null) {
      ingredient.picture.value = Picture.fromMap(map['picture']);
    }
    return ingredient;
  }
}
