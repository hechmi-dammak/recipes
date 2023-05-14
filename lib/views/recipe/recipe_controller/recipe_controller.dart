import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/decorator/decorators.dart';
import 'package:mekla/repository/recipe_ingredient_repository.dart';
import 'package:mekla/repository/recipe_repository.dart';
import 'package:mekla/repository/step_repository.dart';
import 'package:mekla/views/recipe/models/recipe_ingredient_pm_recipe.dart';
import 'package:mekla/views/recipe/models/recipe_pm_recipe.dart';
import 'package:mekla/views/recipe/models/step_pm_recipe.dart';
import 'package:mekla/views/recipe/widgets/servings_dialog/servings_dialog.dart';
import 'package:mekla/widgets/common/snack_bar.dart';
import 'package:mekla/widgets/project/upsert_element/controllers/upsert_recipe_ingredient_controller.dart';
import 'package:mekla/widgets/project/upsert_element/controllers/upsert_step_controller.dart';
import 'package:mekla/widgets/project/upsert_element/upsert_element_dialog.dart';

part 'ingredient_recipe_controller_part.dart';

part 'step_recipe_controller_part.dart';

class RecipeController extends BaseController
    with
        LoadingDecorator,
        DataFetchingDecorator,
        SelectionDecorator,
        GetSingleTickerProviderStateMixin {
  RecipeController({required this.recipeId});

  static RecipeController get find => Get.find<RecipeController>();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(() {
      updateSelection();
    });
  }

  final int recipeId;
  RecipePMRecipe? recipe;
  int servings = 4;
  bool _servingsIsSet = false;
  late TabController tabController;

  @override
  Future<void> loadData() async {
    await Future.wait([super.loadData(), fetchRecipe()]);
  }

  @override
  void setSelectAllValue([bool value = false]) {
    if (recipe == null) return;
    if (tabController.index == 0) {
      for (var ingredient in recipe!.ingredientList) {
        ingredient.selected = value;
      }
    }
    if (tabController.index == 1) {
      for (var step in recipe!.stepList) {
        step.selected = value;
      }
    }
    super.setSelectAllValue(value);
  }

  @override
  bool get selectionIsActiveFallBack {
    if (recipe == null) return false;
    if (tabController.index == 0) {
      return recipe!.ingredientList.any((ingredient) => ingredient.selected);
    }
    if (tabController.index == 1) {
      return recipe!.stepList.any((step) => step.selected);
    }
    return false;
  }

  @override
  bool get allItemsSelectedFallBack {
    if (recipe == null) return false;
    if (tabController.index == 0) {
      return recipe!.ingredientList.every((ingredient) => ingredient.selected);
    }
    if (tabController.index == 1) {
      return recipe!.stepList.every((step) => step.selected);
    }
    return false;
  }

  @override
  int get selectionCount {
    if (tabController.index == 0) {
      return getSelectedIngredients().length;
    }
    if (tabController.index == 1) {
      return getSelectedSteps().length;
    }
    return 0;
  }

  Future<void> fetchRecipe() async {
    final recipeModel = await RecipeRepository.find.findById(recipeId);

    if (recipeModel == null) return;
    recipe = RecipePMRecipe(recipe: recipeModel);
    for (RecipeIngredientPMRecipe ingredient in recipe!.ingredientList) {
      if (ingredient.image != null) {
        await precacheImage(ingredient.image!, Get.context!);
      }
    }
    for (StepPMRecipe step in recipe!.stepList) {
      if (step.image != null) {
        await precacheImage(step.image!, Get.context!);
      }
    }
    if (!_servingsIsSet) {
      _servingsIsSet = true;
      servings = recipe!.servings;
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void changeTab(int index) {
    tabController.index = index;
    update();
  }

  void editItem() {
    if (tabController.index == 0) {
      editIngredient();
    }
    if (tabController.index == 1) {
      editStep();
    }
  }

  Future<void> deleteSelectedItems() async {
    loading = true;
    if (tabController.index == 0) {
      await deleteSelectedIngredients();
    }
    if (tabController.index == 1) {
      await deleteSelectedSteps();
    }
    await fetchData();
    CustomSnackBar.success('Selected Items were deleted.'.tr);
  }

  void showServingsDialog() {
    if (recipe == null) return;
    ServingsDialog(
      servings: servings,
      recipe: recipe!,
      onConfirm: (int servings) {
        this.servings = servings;
        update();
      },
    ).show();
  }
}
