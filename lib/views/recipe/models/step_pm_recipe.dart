import 'package:flutter/material.dart' hide Step;
import 'package:mekla/models/entities/step.dart';
import 'package:mekla/models/interfaces/model_image.dart';
import 'package:mekla/models/interfaces/model_selected.dart';
import 'package:mekla/models/interfaces/model_used.dart';

class StepPMRecipe extends Step
    implements ModelSelected, ModelImage, ModelUsed {
  @override
  bool selected;
  @override
  bool used;
  int order;
  @override
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
