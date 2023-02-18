import 'package:isar/isar.dart';
import 'package:recipes/models/picture.dart';
import 'package:recipes/models/recipe.dart';

part 'step.g.dart';

@collection
class Step {
  Id? id;
  @Index()
  String instruction;
  final IsarLink<Picture> picture;
  @Backlink(to: 'steps')
  final IsarLink<Recipe> recipe;

  Step({
    this.instruction = '',
    IsarLink<Picture>? picture,
    IsarLink<Recipe>? recipe,
  })  : picture = picture ?? IsarLink<Picture>(),
        recipe = recipe ?? IsarLink<Recipe>();

  Step.fromCopy(Step step)
      : id = step.id,
        instruction = step.instruction,
        picture = step.picture,
        recipe = step.recipe;
}
