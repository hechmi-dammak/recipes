import 'package:recipes/models/step.dart';

class StepPMRecipe extends Step {
  bool selected;
  bool used;

  StepPMRecipe({this.selected = false, this.used = false, required Step step})
      : super.fromCopy(step);
}
