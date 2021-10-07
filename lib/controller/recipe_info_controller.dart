import 'package:get/get.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/service/recipe_operations.dart';

class RecipeInfoController extends GetxController {
  final int defaultServingValue = 4;
  var recipe = Recipe();
  var servings = Rx<int>(4);
  var loading = false.obs;
  static RecipeInfoController get find => Get.find<RecipeInfoController>();
  RecipeOperations recipeOperations = RecipeOperations.instance;

  Future<void> initRecipe(int? recipeId) async {
    loading.value = true;
    if (recipeId == null) {
      recipe = Recipe();
    } else {
      recipe = await recipeOperations.read(recipeId);
    }
    setServingDefaultValue();
    loading.value = false;
    update();
  }

  setServingDefaultValue() {
    servings.value = defaultServingValue;
  }
}
