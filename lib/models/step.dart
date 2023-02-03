import 'package:isar/isar.dart';
import 'package:recipes/models/picture.dart';

part 'step.g.dart';

@collection
class Step {
  Id? id;
  @Index()
  int order;
  String instruction;
  final IsarLink<Picture> picture;

  Step({
    this.instruction = '',
    required this.order,
    IsarLink<Picture>? picture,
  }) : picture = picture ?? IsarLink<Picture>();

  Step.fromCopy(Step step)
      : id = step.id,
        instruction = step.instruction,
        order = step.order,
        picture = step.picture;
}
