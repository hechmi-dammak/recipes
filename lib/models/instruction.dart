import 'package:isar/isar.dart';

part 'instruction.g.dart';

@collection
class Instruction {
  Id? id;
  @Index()
  int order;
  String description;

  Instruction({
    this.description = '',
    required this.order,
  });
}
