const String tableSteps = 'steps';

class StepFields {
  static final List<String> values = [id, order, toDo, recipeId];

  static const String id = '_id';
  static const String order = 'step_order';
  static const String toDo = 'to_do';
  static const String recipeId = 'recipe_id';
}

class Step {
  int? id;
  int? order;
  String? toDo;
  bool? selected;
  bool? inEditing;

  Step(
      {this.id,
      this.toDo = "",
      this.order,
      this.inEditing = false,
      this.selected = false});

  static Step fromJson(Map<String, dynamic> json) => Step(
        id: json[StepFields.id] as int?,
        order: json[StepFields.order] as int?,
        toDo: json[StepFields.toDo] as String?,
      );

  static Step fromDatabaseJson(Map<String, dynamic> json) => Step(
      id: json[StepFields.id] as int?,
      order: json[StepFields.order] as int?,
      toDo: json[StepFields.toDo] as String?);

  Map<String, dynamic> toJson() => {
        StepFields.id: id,
        StepFields.order: order,
        StepFields.toDo: toDo,
      };
  Map<String, dynamic> toDatabaseJson(int? recipeId) => {
        StepFields.id: id,
        StepFields.order: order,
        StepFields.toDo: toDo,
        StepFields.recipeId: recipeId,
      };
  Step copy({int? id, int? order, String? toDo}) => Step(
        id: id ?? this.id,
        order: order ?? this.order,
        toDo: toDo ?? this.toDo,
      );
}
