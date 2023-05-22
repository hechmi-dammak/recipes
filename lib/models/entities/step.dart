import 'package:isar/isar.dart';
import 'package:mekla/models/entities/picture.dart';
import 'package:mekla/models/entities/recipe.dart';
import 'package:mekla/models/interfaces/model_id.dart';

part 'step.g.dart';

@collection
class Step implements ModelId {
  @override
  Id? id;
  @Index()
  String instruction;
  final IsarLink<Picture> picture;
  @Backlink(to: 'steps')
  final IsarLink<Recipe> recipe;

  Step({
    this.id,
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

  Map<String, dynamic> toMap([bool withId = true]) {
    return {
      if (withId) 'id': id,
      'instruction': instruction,
      'picture': picture.value?.toMap(withId),
    };
  }

  factory Step.fromMap(Map<String, dynamic> map) {
    final Step step = Step(
      id: map['id'],
      instruction: map['instruction'],
    );
    if (map['picture'] != null) {
      step.picture.value = Picture.fromMap(map['picture']);
    }
    return step;
  }
}
