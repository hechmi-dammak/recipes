import 'package:flutter/material.dart' hide Step;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/picture.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/models/step.dart';
import 'package:recipes/modules/recipe_list_page/controller/recipes_controller.dart';
import 'package:recipes/service/image_getter.dart';
import 'package:recipes/service/ingredient_operations.dart';
import 'package:recipes/service/picture_operations.dart';
import 'package:recipes/service/recipe_operations.dart';
import 'package:recipes/service/step_operations.dart';
import 'package:recipes/utils/components/show_snack_bar.dart';

class RecipeEditController extends GetxController {
  final RecipesController recipesController = RecipesController.find;
  final PictureOperations pictureOperations = PictureOperations.instance;
  final ImageOperations imageOperations = ImageOperations.instance;
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
  var allItemsSelected = false.obs;

  static RecipeEditController get find => Get.find<RecipeEditController>();
  RecipeOperations recipeOperations = RecipeOperations.instance;
  IngredientOperations ingredientOperations = IngredientOperations.instance;
  StepOperations stepOperations = StepOperations.instance;

//-----------init/save  Data---------------
  Future<void> initRecipe(int? recipeId) async {
    loading.value = true;
    if (recipeId == null) {
      recipe.value = Recipe();
      setServingValue();
    } else {
      recipe.value = await recipeOperations.read(recipeId) ?? Recipe();
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
    updateAllItemsSelected();
    loading.value = false;
    update();
  }

  saveRecipe() async {
    if (recipe.value.steps == null) {
      return;
    }
    recipe.value.steps!
        .asMap()
        .forEach((index, element) => {element.order = index});
    recipe.value.servings = servings.value;
    if (recipe.value.id == null) {
      await recipeOperations.create(recipe.value);
    } else {
      await recipeOperations.update(recipe.value);
    }
    await recipesController.loadRecipes();
    update();
  }
//-----------Selection---------------

  setItemSelected(item) {
    item.selected = !(item.selected ?? true);
    updateSelectionIsActive();
    updateAllItemsSelected();
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

  bool _allItemsSelected() {
    if (recipe.value.ingredients != null) {
      for (var ingredient in recipe.value.ingredients!) {
        if (!(ingredient.selected ?? false)) {
          return false;
        }
      }
    }
    if (recipe.value.steps != null) {
      for (var step in recipe.value.steps!) {
        if (!(step.selected ?? false)) {
          return false;
        }
      }
    }

    return true;
  }

  void updateAllItemsSelected([bool? allItemsSelected]) {
    this.allItemsSelected.value = allItemsSelected ?? _allItemsSelected();
    update();
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

    updateSelectionIsActive(value);
    updateAllItemsSelected(value);
    update();
  }

//-----------delete  Data---------------
  void deleteSelectedItems() async {
    loading.value = true;
    update();
    recipe.update((recipe) {
      if (recipe == null) {
        return;
      }
      if (recipe.steps != null) {
        var steps = recipe.steps!.toList();
        steps.removeWhere((step) {
          if (step.selected ?? false) {
            stepOperations.delete(step.id);
          }
          return step.selected ?? false;
        });
        recipe.steps = steps;
      }
      if (recipe.ingredients != null) {
        var ingredients = recipe.ingredients!.toList();
        ingredients.removeWhere((ingredient) {
          if (ingredient.selected ?? false) {
            ingredientOperations.delete(ingredient.id);
          }
          return ingredient.selected ?? false;
        });
        recipe.ingredients = ingredients;
      }
    });
    updateSelectionIsActive();
    loading.value = false;
    update();
    showInSnackBar("Selected items were deleted.", status: true);
  }

  void setLoading(bool bool) {
    loading(bool);
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

  setDialOpen(value) {
    isDialOpen.value = value;
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

  //-----------new Elements---------------
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

//-----------order steps---------------
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

//-----------image fetch--------------
  getImage(ImageSource source) async {
    Picture? picture = await imageOperations.getImage(source);
    if (picture != null) {
      recipe.value.picture = picture;
    }
    update();
  }
}
