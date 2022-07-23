import 'package:get/get.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/instruction.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/modules/recipe_edit_page/recipe_edit_page.dart';
import 'package:recipes/service/repository/recipe_repository.dart';

class RecipeInfoController extends GetxController {
  static RecipeInfoController get find => Get.find<RecipeInfoController>();

  static const int _defaultServingValue = 4;

  Recipe _recipe = Recipe();

  int _servings = 4;
  bool _loading = false;
  final int recipeId;

  RecipeInfoController({required this.recipeId}) {
    initRecipe();
  }

  Recipe get recipe => _recipe;

  set recipe(Recipe value) {
    _recipe = value;
    update();
  }

  bool get loading => _loading;

  set loading(value) {
    _loading = value;
    update();
  }

  int get servings => _servings;

  set servings(int? value) {
    if (value != null) {
      _servings = value;
      return;
    }
    _servings = _defaultServingValue;
    update();
  }

  Future<void> initRecipe() async {
    loading = true;
    recipe = await RecipeRepository.find.read(recipeId) ?? Recipe();
    servings = null;
    loading = false;
  }

  void resetRecipe() {
    for (var element in recipe.ingredients) {
      element.selected = false;
    }
    for (var element in recipe.instructions) {
      element.selected = false;
    }
    servings = null;
    update();
  }

  void editRecipe() async {
    await Get.toNamed(RecipeEditPage.routeName, arguments: recipeId);
    initRecipe();
  }

  void toggleIngredientSelected(Ingredient ingredient) {
    ingredient.selected = !ingredient.selected;
    update();
  }

  void toggleInstructionSelected(Instruction instruction) {
    instruction.selected = !instruction.selected;
    update();
  }
}
