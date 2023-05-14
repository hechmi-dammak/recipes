import 'package:flutter/material.dart' hide Step;
import 'package:mekla/models/isar_models/step.dart';
import 'package:mekla/models/selection_model.dart';

class StepPMRecipe extends Step implements SelectionModel {
  @override
  bool selected;
  bool used;
  int order;
  final ImageProvider? image;

  StepPMRecipe(
      {this.selected = false,
      this.used = false,
      required this.order,
      required Step step})
      : image = step.picture.value == null
            ? null
            : MemoryImage(step.picture.value!.image),
        super.fromCopy(step);
}
