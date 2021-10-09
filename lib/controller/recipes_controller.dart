import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
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
    recipes = await recipeOperations.readAll();
    updateSelectionIsActive();
    loading.value = false;
    update();
  }

  setRecipeSelected(int index) {
    recipes[index].selected = !(recipes[index].selected ?? true);
    updateSelectionIsActive();
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
    update();
  }

  void deleteSelectedRecipes() async {
    loading.value = true;
    update();

    var _copyRecipes = recipes.toList();
    for (Recipe recipe in _copyRecipes) {
      if ((recipe.selected ?? false) && (recipe.id != null)) {
        recipeOperations.delete(recipe.id!);
        recipes.remove(recipe);
      }
    }
    updateSelectionIsActive();
    loading.value = false;
    update();
    showInSnackBar("Selected Recipe were deleted.", status: true);
  }

  void setSelectAllValue([bool value = false]) {
    for (var recipe in recipes) {
      recipe.selected = value;
    }
    updateSelectionIsActive();
    update();
  }

  List<Map<String, dynamic>> getSelectedRecipes() {
    List<Map<String, dynamic>> result = [];
    for (Recipe recipe in recipes) {
      if (recipe.selected ?? false) {
        result.add(recipe.toJson());
      }
    }
    return result;
  }

  importFromFile(context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );
      if (result == null || result.count == 0) {
        showInSnackBar("You must pick a file that has the extension recipe.");
        loading.value = false;
        update();
        return;
      }
      loading.value = true;
      update();
      final response = await File(result.files.single.path!).readAsString();
      final data = await json.decode(response);
      List<Recipe> recipes = [];
      data.forEach((item) {
        recipes.add(Recipe.fromJson(item));
      });

      await recipeOperations.createAll(recipes);
      loadRecipes();
      showInSnackBar("Recipes are imported.", status: true);
    } catch (e) {
      showInSnackBar("Failed to  import from file" + e.toString());
    }
    loading.value = false;
    update();
  }

  importFromLibrary() async {
    try {
      loading.value = true;
      update();
      final String response =
          await rootBundle.loadString('assets/recipes.json');
      final data = await json.decode(response);
      List<Recipe> recipes = [];
      data.forEach((item) {
        recipes.add(Recipe.fromJson(item));
      });

      await recipeOperations.createAll(recipes);
      loadRecipes();
      showInSnackBar("Recipes are imported.", status: true);
    } catch (e) {
      showInSnackBar("Failed to  import from file" + e.toString());
    }
    loading.value = false;
    update();
  }
}
