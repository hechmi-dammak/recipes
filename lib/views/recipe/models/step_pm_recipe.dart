import 'package:flutter/material.dart' hide Step;
import 'package:recipes/models/step.dart';

class StepPMRecipe extends Step {
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
