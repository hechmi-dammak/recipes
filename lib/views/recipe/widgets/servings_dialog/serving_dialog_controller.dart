import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:recipes/views/recipe/models/recipe_pm_recipe.dart';

class ServingsDialogController extends GetxController {
  int servings;
  final void Function(int servings) onConfirm;
  final RecipePMRecipe recipe;

  ServingsDialogController({
    required this.recipe,
    required this.servings,
    required this.onConfirm,
  });

  Future<void> confirmSavingServings(
      void Function([bool? result, bool forceClose]) close) async {
    onConfirm(servings);
    close(true, true);
  }

  Future<void> cancelSavingServings(
      void Function([bool? result, bool forceClose]) close) async {
    close(false, true);
  }

  void decrementTmpServings() {
    if (servings == 1) return;
    servings--;
    servings = math.max(1, servings);
    update();
  }

  void incrementTmpServings() {
    servings++;
    update();
  }
}
