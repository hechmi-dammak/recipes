import 'package:get/get.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/service/recipe_operations.dart';

class RecipeCreateController extends GetxController {
  final int defaultServingValue = 4;
  var recipe = Recipe().obs;
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
  }

  addNewCategory(String category) {
    recipeCategories.add(category);
    update();
  }
}
