import 'package:get/get.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/models/step.dart';
import 'package:recipes/service/recipe_operations.dart';

class RecipeCreateController extends GetxController {
  final int defaultServingValue = 4;
  var recipe = Rx<Recipe>(Recipe());
  var servings = Rx<int>(4);
  var loading = false.obs;
  var recipeCategories = <String>[];
  static RecipeCreateController get find => Get.find<RecipeCreateController>();
  RecipeOperations recipeOperations = RecipeOperations.instance;

  Future<void> initRecipe() async {
    loading.value = true;
    recipe.value = Recipe();
    setServingValue();
    recipeCategories = await recipeOperations.getAllCategories();
    loading.value = false;
    update();
  }

  setServingValue([int? value]) {
    if (value != null) {
      servings.value = value;
      return;
    }
    servings.value = defaultServingValue;
    update();
  }

  addNewCategory(String category) {
    recipeCategories.add(category);
    update();
  }

  addNewStep() {
    recipe.update((recipe) {
      if (recipe == null) {
        recipe = Recipe(steps: [Step()]);
        return;
      }
      if (recipe.steps == null) {
        recipe.steps = [Step()];
        return;
      }
      var steps = recipe.steps!.toList();
      steps.add(Step());
      recipe.steps = steps;
    });
    update();
  }

  addNewIngredient() {
    recipe.update((recipe) {
      if (recipe == null) {
        recipe = Recipe(ingredients: [Ingredient()]);
        return;
      }
      if (recipe.ingredients == null) {
        recipe.ingredients = [Ingredient()];
        return;
      }
      var ingredients = recipe.ingredients!.toList();
      ingredients.add(Ingredient());
      recipe.ingredients = ingredients;
    });
    update();
  }
}
