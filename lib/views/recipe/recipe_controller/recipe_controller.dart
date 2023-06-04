import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/decorator/decorators.dart';
import 'package:mekla/decorator/decorators/used_decorator.dart';
import 'package:mekla/helpers/constants.dart';
import 'package:mekla/models/entities/recipe.dart';
import 'package:mekla/models/interfaces/model_name.dart';
import 'package:mekla/repositories/recipe_ingredient_repository.dart';
import 'package:mekla/repositories/recipe_repository.dart';
import 'package:mekla/repositories/step_repository.dart';
import 'package:mekla/services/image_service.dart';
import 'package:mekla/views/recipe/models/ingredient_category_pm_recipes.dart';
import 'package:mekla/views/recipe/models/recipe_ingredient_pm_recipe.dart';
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
        GetSingleTickerProviderStateMixin,
        UsedDecorator {
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
  Recipe? recipe;
  int servings = Constants.defaultServings;
  bool _servingsIsSet = false;
  late TabController tabController;
  bool categorize = false;
  List<RecipeIngredientPMRecipe> ingredientsWithoutCategory = [];
  List<IngredientCategoryPMRecipe> categories = [];
  List<RecipeIngredientPMRecipe> ingredientList = [];
  List<StepPMRecipe> stepList = [];

  @override
  Future<void> loadData() async {
    await Future.wait([super.loadData(), fetchRecipe()]);
  }

  @override
  void setSelectAllValue([bool value = false]) {
    if (tabController.index == 0) {
      for (var ingredient in ingredientList) {
        ingredient.selected = value;
      }
    }
    if (tabController.index == 1) {
      for (var step in stepList) {
        step.selected = value;
      }
    }
    super.setSelectAllValue(value);
  }

  @override
  bool get selectionIsActiveFallBack {
    if (tabController.index == 0) {
      return ingredientList.any((ingredient) => ingredient.selected);
    }
    if (tabController.index == 1) {
      return stepList.any((step) => step.selected);
    }
    return false;
  }

  @override
  bool get allItemsSelectedFallBack {
    if (tabController.index == 0) {
      return ingredientList.every((ingredient) => ingredient.selected);
    }
    if (tabController.index == 1) {
      return stepList.every((step) => step.selected);
    }
    return false;
  }

  @override
  int get selectionCount {
    if (tabController.index == 0) {
      return _ingredientSelectionCount;
    }
    if (tabController.index == 1) {
      return _stepSelectionCount;
    }
    return 0;
  }

  Future<void> fetchRecipe() async {
    recipe = await RecipeRepository.find.findById(recipeId);
    if (recipe == null) return;
    ingredientList = recipe!.ingredients
        .toList()
        .map((recipeIngredient) =>
            RecipeIngredientPMRecipe(recipeIngredient: recipeIngredient))
        .toList();
    stepList = recipe!.steps
        .toList()
        .asMap()
        .entries
        .map((entry) => StepPMRecipe(order: entry.key + 1, step: entry.value))
        .toList();
    ImageService.find.cacheImages(stepList);
    ImageService.find.cacheImages(ingredientList);

    if (!_servingsIsSet) {
      _servingsIsSet = true;
      servings = recipe!.servings;
    }
    await _initCategories();
  }

  Future<void> _initCategories() async {
    final Map<int, List<RecipeIngredientPMRecipe>> ingredientsByCategoryMap =
        {};
    ingredientsWithoutCategory = [];
    for (var ingredient in ingredientList) {
      if (ingredient.category.value == null) {
        ingredientsWithoutCategory.add(ingredient);
      } else {
        ingredientsByCategoryMap.update(ingredient.category.value!.id!,
            (value) {
          value.add(ingredient);
          return value;
        }, ifAbsent: () => List.from([ingredient]));
      }
    }
    categories = ingredientsByCategoryMap.entries
        .map((e) => IngredientCategoryPMRecipe(
            ingredientCategory: e.value.first.category.value!,
            ingredients: e.value))
        .toList();
    categories.sort(ModelName.nameComparator);
    await ImageService.find.cacheMultiImages(categories);
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

  Future<void> edit() async {
    if (tabController.index == 0) {
      await _editIngredient();
    }
    if (tabController.index == 1) {
      await _editStep();
    }
  }

  Future<void> add() async {
    if (tabController.index == 0) {
      await addIngredient();
    }
    if (tabController.index == 1) {
      await _addStep();
    }
  }

  Future<void> deleteSelectedItems() async {
    loading = true;
    if (tabController.index == 0) {
      await _deleteSelectedIngredients();
    }
    if (tabController.index == 1) {
      await _deleteSelectedSteps();
    }
    await fetchData();
    CustomSnackBar.success('Selected Items were deleted.'.tr);
  }

  Future<void> showServingsDialog() async {
    await ServingsDialog(
      servings: servings,
      ingredientList: ingredientList,
      onConfirm: (int servings) {
        this.servings = servings;
        update();
      },
    ).show();
  }
}
