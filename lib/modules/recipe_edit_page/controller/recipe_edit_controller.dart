import 'package:flutter/material.dart' hide Step;
import 'package:get/get.dart';

import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/models/step.dart';
import 'package:recipes/modules/recipe_list_page/controller/recipes_controller.dart';
import 'package:recipes/service/ingredient_operations.dart';
import 'package:recipes/service/recipe_operations.dart';
import 'package:recipes/utils/components/show_snack_bar.dart';

class RecipeEditController extends GetxController {
  final RecipesController recipesController = RecipesController.find;

  final int defaultServingValue = 4;
  var recipe = Rx<Recipe>(Recipe());
  var servings = Rx<int>(4);
  var loading = false.obs;
  var recipeCategories = <String>[];
  var ingredientCategories = <String>[];
  var ingredientMeasurings = <String>[];
  var ingredientSizes = <String>[];
  var isDialOpen = ValueNotifier<bool>(false);
  var selectionIsActive = false.obs;
  static RecipeEditController get find => Get.find<RecipeEditController>();
  RecipeOperations recipeOperations = RecipeOperations.instance;
  IngredientOperations ingredientOperations = IngredientOperations.instance;
  setDialOpen(value) {
    isDialOpen.value = value;
    update();
  }

  Future<void> initRecipe(int? recipeId) async {
    loading.value = true;
    if (recipeId == null) {
      recipe.value = Recipe();
      setServingValue();
    } else {
      recipe.value = await recipeOperations.read(recipeId);
      setServingValue(recipe.value.servings ?? 1);
    }
    recipeCategories = await recipeOperations.getAllCategories();
    ingredientCategories = await ingredientOperations
        .getAllValuesOfAttribute(IngredientFields.category);
    ingredientMeasurings = await ingredientOperations
        .getAllValuesOfAttribute(IngredientFields.measuring);
    ingredientSizes = await ingredientOperations
        .getAllValuesOfAttribute(IngredientFields.size);
    updateSelectionIsActive();
    loading.value = false;
    update();
  }

  setItemSelected(item) {
    item.selected = !(item.selected ?? true);
    updateSelectionIsActive();
    update();
  }

  bool _selectionIsActive() {
    if (recipe.value.ingredients != null) {
      for (var ingredient in recipe.value.ingredients!) {
        if (ingredient.selected ?? false) {
          return true;
        }
      }
    }
    if (recipe.value.steps != null) {
      for (var step in recipe.value.steps!) {
        if (step.selected ?? false) {
          return true;
        }
      }
    }
    return false;
  }

  void updateSelectionIsActive([bool? selectionIsActive]) {
    this.selectionIsActive.value = selectionIsActive ?? _selectionIsActive();
    update();
  }

  void deleteSelectedItems() async {
    loading.value = true;
    update();
    recipe.update((recipe) {
      if (recipe == null) {
        return;
      }
      if (recipe.steps != null) {
        var steps = recipe.steps!.toList();
        steps.removeWhere((element) => element.selected ?? false);
        recipe.steps = steps;
      }
      if (recipe.ingredients != null) {
        var ingredients = recipe.ingredients!.toList();
        ingredients.removeWhere((element) => element.selected ?? false);
        recipe.ingredients = ingredients;
      }
    });
    updateSelectionIsActive();
    loading.value = false;
    update();
    showInSnackBar("Selected items were deleted.", status: true);
  }

  void setSelectAllValue([bool value = false]) {
    recipe.update((recipe) {
      if (recipe == null) {
        return;
      }
      if (recipe.steps != null) {
        for (var element in recipe.steps!) {
          element.selected = value;
        }
      }
      if (recipe.ingredients != null) {
        for (var element in recipe.ingredients!) {
          element.selected = value;
        }
      }
    });

    updateSelectionIsActive();
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

  addNewRecipeCategory(String category) {
    recipeCategories.add(category);
    update();
  }

  addNewIngredientCategory(String category) {
    ingredientCategories.add(category);
    update();
  }

  addNewIngredientMeasuring(String measuring) {
    ingredientMeasurings.add(measuring);
    update();
  }

  addNewIngredientSize(String size) {
    ingredientSizes.add(size);
    update();
  }

  setInEditing(dynamic editable, {bool value = true}) {
    recipe.update((recipe) {
      if (recipe == null) {
        return;
      }
      if (value == false) {
        editable.inEditing = false;
        return;
      }
      recipe.ingredients?.forEach((ingredient) {
        ingredient.inEditing = false;
      });
      recipe.steps?.forEach((step) {
        step.inEditing = false;
      });
      editable.inEditing = true;
    });
    update();
  }

  Future setInEditingWithNoPropagation(dynamic editable,
      {bool value = true}) async {
    editable.inEditing = value;
    update();
  }

  addNewStep() {
    recipe.update((recipe) {
      if (recipe == null) {
        recipe = Recipe(steps: [Step(key: const ValueKey(0))]);
        return;
      }
      if (recipe.steps == null) {
        recipe.steps = [Step(key: const ValueKey(0))];
        return;
      }
      var steps = recipe.steps!.toList();
      steps.add(Step(key: ValueKey(steps.length)));
      recipe.steps = steps;
      setInEditing(recipe.steps!.last);
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
      setInEditing(recipe.ingredients!.last);
    });

    update();
  }

  int _indexOfKey(Key key) {
    return (recipe.value.steps!).indexWhere((Step step) => step.key == key);
  }

  bool reorderCallback(Key item, Key newPosition) {
    recipe.update((recipe) {
      if (recipe == null) {
        return;
      }
      if (recipe.steps == null) {
        return;
      }
      var steps = recipe.steps!.toList();
      int draggingIndex = _indexOfKey(item);
      int newPositionIndex = _indexOfKey(newPosition);
      final draggedItem = steps.removeAt(draggingIndex);
      steps.insert(newPositionIndex, draggedItem);
      recipe.steps = steps;
    });

    update();
    return true;
  }

  saveRecipe() async {
    recipe.update((recipe) async {
      if (recipe == null) {
        return;
      }
      if (recipe.steps == null) {
        return;
      }
      recipe.steps!
          .asMap()
          .forEach((index, element) => {element.order = index});
      recipe.servings = servings.value;
      if (recipe.id == null) {
        await recipeOperations.create(recipe);
      } else {
        await recipeOperations.update(recipe);
      }
      await recipesController.loadRecipes();
    });
  }

  void setLoading(bool bool) {
    loading(bool);
    update();
  }
}
