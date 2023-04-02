part of 'recipe_controller.dart';

extension ServingsRecipeController on RecipeController {
  Future<void> confirmSavingServings(
      void Function([bool? result, bool forceClose]) close) async {
    servings = tmpServings;
    close(true,true);
    update();
  }

  Future<void> cancelSavingServings(
      void Function([bool? result, bool forceClose]) close) async {
    close(false, true);
  }

  void initServingsDialog() {
    tmpServings = servings;
  }

  void decrementTmpServings() {
    if (tmpServings == 1) return;
    tmpServings--;
    tmpServings = math.max(1, tmpServings);
    update();
  }

  void incrementTmpServings() {
    tmpServings++;
    update();
  }
}
