import 'package:flutter/material.dart';

const String tableInstructions = 'instructions';

class InstructionFields {
  static final List<String> values = [id, order, toDo, recipeId];

  static const String id = '_id';
  static const String order = 'instruction_order';
  static const String toDo = 'to_do';
  static const String recipeId = 'recipe_id';
}

class Instruction {
  int? id;
  int? order;
  String toDo;
  bool selected;
  bool inEditing;
  Key? key;
  Instruction({
    this.id,
    this.toDo = '',
    this.order,
    this.inEditing = false,
    this.selected = false,
    this.key
  });

  factory Instruction.fromJson(Map<String, dynamic> json) => Instruction(
        id: json[InstructionFields.id],
        order: json[InstructionFields.order] ,
        toDo: json[InstructionFields.toDo],
      );

  factory Instruction.fromDatabaseJson(Map<String, dynamic> json) => Instruction(
      id: json[InstructionFields.id] ,
      order: json[InstructionFields.order] ,
      toDo: json[InstructionFields.toDo]);

  Map<String, dynamic> toJson([export = false]) => {
        if (!export) InstructionFields.id: id,
        if (!export || order != null) InstructionFields.order: order,
        if (!export || toDo.isNotEmpty)
          InstructionFields.toDo: toDo == '' ? null : toDo,
      };
  Map<String, dynamic> toDatabaseJson(int? recipeId, [bool noId = false]) => {
        InstructionFields.id: noId ? null : id,
        InstructionFields.order: order,
        InstructionFields.toDo: toDo == '' ? null : toDo,
        InstructionFields.recipeId: recipeId,
      };
  Instruction copy({int? id, int? order, String? toDo}) => Instruction(
        id: id ?? this.id,
        order: order ?? this.order,
        toDo: toDo ?? this.toDo,
      );
}
