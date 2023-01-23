import 'package:isar/isar.dart';
import 'package:recipes/models/picture.dart';

part 'ingredient.g.dart';

@collection
class Ingredient {
  Id? id;
  @Index()
  String name;
  final picture = IsarLink<Picture>();

  Ingredient({
    this.name = '',
  });
}
