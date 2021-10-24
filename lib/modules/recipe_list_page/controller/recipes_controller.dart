import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/service/recipe_operations.dart';
import 'package:recipes/utils/components/dialog_input.dart';
import 'package:recipes/utils/components/show_snack_bar.dart';

class RecipesController extends GetxController {
  var recipes = <Recipe>[];
  var initialRecipes = <Recipe>[];
  var selectionIsActive = false.obs;
  var allItemsSelected = false.obs;
  var loading = false.obs;
  var searchValue = ''.obs;
  static RecipesController get find => Get.find<RecipesController>();
  RecipeOperations recipeOperations = RecipeOperations.instance;

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

//-----------Selection---------------
  setRecipeSelected(int index) {
    recipes[index].selected = !(recipes[index].selected ?? true);
    updateSelectionIsActive();
    updateAllItemsSelected();
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

  bool _allItemsSelected() {
    for (var recipe in recipes) {
      if (!(recipe.selected ?? false)) {
        return false;
      }
    }
    return true;
  }

  void updateAllItemsSelected([bool? allItemsSelected]) {
    this.allItemsSelected.value = allItemsSelected ?? _allItemsSelected();
    update();
  }

  void setSelectAllValue([bool value = false]) {
    for (var recipe in recipes) {
      recipe.selected = value;
    }
    updateAllItemsSelected(value);
    updateSelectionIsActive();
    update();
  }

//-----------get /delete /import /export  Data---------------
  List<Map<String, dynamic>> getSelectedRecipes() {
    List<Map<String, dynamic>> result = [];
    for (Recipe recipe in recipes) {
      if (recipe.selected ?? false) {
        result.add(recipe.toJson());
      }
    }
    return result;
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

  final _fileNameController = TextEditingController();

  exportToFile() async {
    showDialogInput(
        title: 'Pick a name for the file',
        label: 'File name',
        controller: _fileNameController,
        confirm: () async {
          try {
            if (_fileNameController.text == "") {
              showInSnackBar("File name shouldn't be empty.");
              return;
            }
            String? fileDirectory = await FilePicker.platform
                .getDirectoryPath(dialogTitle: "Select where to save to file");
            if (fileDirectory == null) {
              showInSnackBar("You must choose a directory");
              return;
            }
            var fileLocation =
                "$fileDirectory/${_fileNameController.text}.recipe";
            var recipes = getSelectedRecipes();
            File file = File(fileLocation);
            await file.writeAsString(json.encode(recipes));
            Get.back();
            showInSnackBar(
                "Recipes are exported to file ${_fileNameController.text}.",
                status: true);
            _fileNameController.clear();
          } catch (e) {
            showInSnackBar("Failed to  export to file" + e.toString());
          }
        });
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
      await loadRecipes();
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
      await loadRecipes();
      showInSnackBar("Recipes are imported.", status: true);
    } catch (e) {
      showInSnackBar("Failed to  import from file" + e.toString());
    }
    loading.value = false;
    update();
  }
//--------------SEARCH---------------------

  void setSeachValue(String value) {
    searchValue(value);
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
}
