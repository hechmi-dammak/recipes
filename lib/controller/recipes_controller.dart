import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:recipes/components/utils/show_snack_bar.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/service/recipe_operations.dart';

class RecipesController extends GetxController {
  var recipes = <Recipe>[];
  var selectionIsActive = false.obs;
  var loading = false.obs;
  static RecipesController get find => Get.find<RecipesController>();
  RecipeOperations recipeOperations = RecipeOperations.instance;

  Future<void> loadRecipes() async {
    loading.value = true;
    recipes.removeWhere((element) => true);
    recipes.addAll(await recipeOperations.readAll());
    updateSelectionIsActive();
    loading.value = false;
    update();
  }

  setRecipeSelected(int index) {
    recipes[index].selected = !(recipes[index].selected ?? true);
    updateSelectionIsActive();
    update();
  }

  unloadRecipes() {
    recipes.removeWhere((element) => true);
    update();
  }

  bool _selectionIsActive() {
    for (var recipe in recipes) {
      if (recipe.selected ?? false) {
        return true;
      }
    }
    return false;
  }

  void updateSelectionIsActive([bool? selectionIsActive]) {
    this.selectionIsActive.value = selectionIsActive ?? _selectionIsActive();
  }

  void deleteSelectedRecipes() async {
    var _copyRecipes = recipes.toList();
    for (Recipe recipe in _copyRecipes) {
      if ((recipe.selected ?? false) && (recipe.id != null)) {
        recipeOperations.delete(recipe.id!);
        recipes.remove(recipe);
      }
    }
    updateSelectionIsActive();
    update();
  }

  void setSelectAllValue([bool value = false]) {
    for (var recipe in recipes) {
      recipe.selected = value;
    }
    updateSelectionIsActive();
    update();
  }

  void exportSelectedDataToFile(String fileLocation) async {
    List result = [];
    for (Recipe recipe in recipes) {
      if (recipe.selected ?? false) {
        result.add(recipe.toJson());
      }
    }
    File file = File(fileLocation);
    await file.writeAsString(json.encode(result));
  }

  importFromFile(context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result == null || result.count == 0) {
      showInSnackBar(
          "you must pick a file that has the extension recipe", context);
      return;
    }
    loading.value = true;
    final response = await File(result.files.single.path!).readAsString();
    final data = await json.decode(response);
    List<Recipe> recipes = [];
    data.forEach((item) {
      recipes.add(Recipe.fromJson(item));
    });

    await recipeOperations.createAll(recipes);
    loadRecipes();
  }
}
