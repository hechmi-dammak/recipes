import 'package:get/get.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/modules/recipe_edit_page/recipe_edit_page.dart';
import 'package:recipes/service/repository/recipe_repository.dart';

class RecipeInfoController extends GetxController {
  static RecipeInfoController get find => Get.find<RecipeInfoController>();

  final int defaultServingValue = 4;
  final Rx<Recipe> _recipe = Recipe().obs;

  final RxInt _servings = 4.obs;
  final RxBool _loading = false.obs;
  final int recipeId;

  RecipeInfoController({required this.recipeId}) {
    initRecipe();
  }

  Recipe get recipe => _recipe.value;

  set recipe(Recipe value) {
    _recipe(value);
    update();
  }

  bool get loading => _loading.value;

  set loading(value) {
    _loading(value);

    update();
  }

  int get servings => _servings.value;

  set servings(int? value) {
    if (value != null) {
      _servings(value);
      return;
    }
    _servings(defaultServingValue);
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

    servings = null;
    update();
  }

  void editRecipe() async {
    await Get.toNamed(RecipeEditPage.routeName, arguments: recipeId);
    initRecipe();
  }
}
