import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/service/recipe_operations.dart';
import 'package:recipes/utils/components/show_snack_bar.dart';

class RecipesController extends GetxController {
  var recipes = <Recipe>[];
  var initialRecipes = <Recipe>[];
  var selectionIsActive = false.obs;
  var loading = false.obs;
  var searchActive = false.obs;
  var isDialOpen = ValueNotifier<bool>(false);
  var searchValue = ''.obs;
  static RecipesController get find => Get.find<RecipesController>();
  RecipeOperations recipeOperations = RecipeOperations.instance;
  setDialOpen(value) {
    isDialOpen.value = value;
    update();
  }

  @override
  void onInit() {
    debounce(searchValue, (_) => updateSearch(),
        time: const Duration(milliseconds: 200));
    super.onInit();
  }

  Future<void> loadRecipes() async {
    loading.value = true;
    update();
    initialRecipes = await recipeOperations.readAll();
    recipes = initialRecipes.toList();
    updateSelectionIsActive();
    loading.value = false;
    update();
  }

  updateSearch() {
    recipes = initialRecipes.toList();
    for (Recipe recipe in initialRecipes) {
      if (!recipe.name
          .toLowerCase()
          .trim()
          .contains(searchValue.value.toLowerCase().trim())) {
        recipes.remove(recipe);
      }
    }
    update();
  }

  setRecipeSelected(int index) {
    recipes[index].selected = !(recipes[index].selected ?? true);
    updateSelectionIsActive();
    update();
  }

  setSearchActive(bool value) {
    searchActive(value);
    if (value) {
      updateSearch();
    } else {
      recipes = initialRecipes.toList();
    }
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

    recipes = initialRecipes.toList();
    for (Recipe recipe in recipes) {
      if ((recipe.selected ?? false) && (recipe.id != null)) {
        recipeOperations.delete(recipe.id!);
        initialRecipes.remove(recipe);
      }
      recipes = initialRecipes.toList();
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

  void setSeachValue(String value) {
    searchValue(value);
  }
}
