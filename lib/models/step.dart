import 'package:flutter/material.dart';

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
  Key? key;
  Step(
      {this.id,
      this.toDo = "",
      this.order,
      this.inEditing = false,
      this.selected = false,
      this.key});

  static Step fromJson(Map<String, dynamic> json) => Step(
        id: json[StepFields.id] as int?,
        order: json[StepFields.order] as int?,
        toDo: json[StepFields.toDo] as String?,
      );

  static Step fromDatabaseJson(Map<String, dynamic> json) => Step(
      id: json[StepFields.id] as int?,
      order: json[StepFields.order] as int?,
      toDo: json[StepFields.toDo] as String?);

  Map<String, dynamic> toJson([export = false]) => {
        if (!export) StepFields.id: id,
        if (!export || order != null) StepFields.order: order,
        if (!export || toDo != null || toDo!.isNotEmpty)
          StepFields.toDo: toDo == "" ? null : toDo,
      };
  Map<String, dynamic> toDatabaseJson(int? recipeId, [bool noId = false]) => {
        StepFields.id: noId ? null : id,
        StepFields.order: order,
        StepFields.toDo: toDo == "" ? null : toDo,
        StepFields.recipeId: recipeId,
      };
  Step copy({int? id, int? order, String? toDo}) => Step(
        id: id ?? this.id,
        order: order ?? this.order,
        toDo: toDo ?? this.toDo,
      );
}
