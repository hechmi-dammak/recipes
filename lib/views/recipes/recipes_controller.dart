import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/decorator/decorators.dart';
import 'package:mekla/helpers/getx_extension.dart';
import 'package:mekla/repository/recipe_repository.dart';
import 'package:mekla/service/recipe_operations.dart';
import 'package:mekla/views/ingredients/ingredients_page.dart';
import 'package:mekla/views/recipe/recipe_page.dart';
import 'package:mekla/views/recipes/models/recipe_pm_recipes.dart';
import 'package:mekla/widgets/common/snack_bar.dart';
import 'package:mekla/widgets/project/upsert_element/controllers/upsert_recipe_controller.dart';
import 'package:mekla/widgets/project/upsert_element/upsert_element_dialog.dart';

class RecipesController extends BaseController
    with LoadingDecorator, DataFetchingDecorator, SelectionDecorator {
  RecipesController({this.categoryId});

  static RecipesController get find => Get.find<RecipesController>();

  final int? categoryId;
  List<RecipePMRecipes> recipes = [];

  @override
  Future<void> loadData() async {
    await Future.wait([super.loadData(), fetchRecipes()]);
  }

  @override
  void setSelectAllValue([bool value = false]) {
    for (var recipe in recipes) {
      recipe.selected = value;
    }
    super.setSelectAllValue(value);
  }

  @override
  bool get selectionIsActiveFallBack =>
      recipes.any((recipe) => recipe.selected);

  @override
  bool get allItemsSelectedFallBack =>
      recipes.every((recipe) => recipe.selected);

  @override
  int get selectionCount => getSelectedItems().length;

  Iterable<RecipePMRecipes> getSelectedItems() {
    return recipes.where((recipe) => recipe.selected);
  }

  Future<void> fetchRecipes() async {
    if (categoryId == null) {
      recipes = (await RecipeRepository.find.findAll())
          .map((recipe) => RecipePMRecipes(recipe: recipe))
          .toList();
    } else {
      recipes =
          (await RecipeRepository.find.findAllByRecipeCategoryId(categoryId))
              .map((recipe) => RecipePMRecipes(recipe: recipe))
              .toList();
    }
    for (RecipePMRecipes recipe in recipes) {
      if (recipe.image != null) {
        precacheImage(recipe.image!, Get.context!);
      }
    }
  }

  void goToRecipe(RecipePMRecipes recipe) {
    Get.toNamedWithPathParams(
      RecipePage.routeName,
      pathParameters: {'id': recipe.id.toString()},
    );
  }

  Future<void> deleteSelectedRecipes() async {
    loading = true;
    for (RecipePMRecipes recipe in getSelectedItems()) {
      await RecipeRepository.find.deleteById(recipe.id!);
    }
    await fetchData();
    CustomSnackBar.success('Selected Recipes were deleted.'.tr);
  }

  Future<void> addRecipe() async {
    final created = await UpsertElementDialog<UpsertRecipeController>(
      controller: UpsertRecipeController(
        categoryId: categoryId,
      ),
    ).show(false);
    if (created ?? false) await fetchData();
  }

  Future<void> editRecipe() async {
    if (selectionCount != 1) return;
    final updated = await UpsertElementDialog<UpsertRecipeController>(
      controller: UpsertRecipeController(
        id: getSelectedItems().first.id,
        categoryId: categoryId,
      ),
    ).show(false);
    if (updated ?? false) await fetchData();
  }

  Future<void> shareRecipes() async {
    RecipeOperations.find.shareAsFile(
        recipes:
            getSelectedItems().map((recipe) => recipe.toMap(false)).toList());
  }
  Future<void> exportRecipes() async {
    RecipeOperations.find.exportToFile(
        recipes:
        getSelectedItems().map((recipe) => recipe.toMap(false)).toList());
  }
  Future<void> selectedItemMenu(int item) async {
    switch (item) {
      case 0:
        RecipeOperations.find.importFromFile(
            onStart: () async {
              loading = true;
            },
            onFailure: () async {
              loading = false;
            },
            onFinish: () async {
              loading = false;
            },
            onSuccess: fetchData);
        break;
      case 1:
        RecipeOperations.find.importFromLibrary(
            onStart: () async {
              loading = true;
            },
            onFailure: () async {
              loading = false;
            },
            onFinish: () async {
              loading = false;
            },
            onSuccess: fetchData);
        break;
      case 2:
        Get.toNamed(IngredientsPage.routeName);
        break;
    }
  }
}
