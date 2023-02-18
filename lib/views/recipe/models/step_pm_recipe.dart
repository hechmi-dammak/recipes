import 'package:recipes/models/step.dart';

class StepPMRecipe extends Step {
  bool selected;
  bool used;
  int order;

  StepPMRecipe(
      {this.selected = false,
      this.used = false,
      required this.order,
      required Step step})
      : super.fromCopy(step);
}
