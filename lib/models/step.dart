import 'package:isar/isar.dart';

part 'step.g.dart';

@collection
class Step {
  Id? id;
  @Index()
  int order;
  String instruction;

  Step({
    this.instruction = '',
    required this.order,
  });
}
