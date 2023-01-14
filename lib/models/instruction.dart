const String tableInstructions = 'instructions';

class InstructionFields {
  static final List<String> values = [id, order, description, recipeId];

  static const String id = '_id';
  static const String order = 'instruction_order';
  static const String description = 'description';
  static const String recipeId = 'recipe_id';
}

class Instruction {
  int? id;
  String? uuid;
  int order;
  String description;

  Instruction({
    this.id,
    this.uuid,
    this.description = '',
    required this.order,
  });

  factory Instruction.fromJson(
    Map<String, dynamic> json, {
    bool database = false,
  }) {
    return Instruction(
      id: json[InstructionFields.id],
      order: json[InstructionFields.order],
      description: json[InstructionFields.description],
    );
  }

  Map<String, dynamic> toJson({
    bool database = false,
    bool withId = true,
    int? recipeId,
  }) =>
      {
        if (!database || withId) InstructionFields.id: id,
        InstructionFields.order: order,
        InstructionFields.description: description == '' ? null : description,
        InstructionFields.recipeId: recipeId,
      };

  Instruction copy({
    int? id,
    int? order,
    String? description,
  }) =>
      Instruction(
        id: id ?? this.id,
        order: order ?? this.order,
        description: description ?? this.description,
      );
}
