import 'package:get/get.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/service/recipe_operations.dart';

class RecipeInfoController extends GetxController {
  final int defaultServingValue = 4;
  var recipe = Recipe().obs;
  var servings = 4.obs;
  var loading = false.obs;
  static RecipeInfoController get find => Get.find<RecipeInfoController>();
  RecipeOperations recipeOperations = RecipeOperations.instance;

  Future<void> initRecipe(int? recipeId) async {
    loading.value = true;
    if (recipeId == null) {
      recipe.value = Recipe();
    } else {
      recipe.value = await recipeOperations.read(recipeId) ?? Recipe();
    }
    setServingValue();
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

  resetRecipe() {
    if (recipe.value.ingredients != null) {
      for (var element in recipe.value.ingredients!) {
        element.selected = false;
      }
    }
    setServingValue();
    update();
  }
}
