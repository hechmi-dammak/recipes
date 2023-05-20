import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/decorator/decorators.dart';
import 'package:mekla/helpers/getx_extension.dart';
import 'package:mekla/models/interfaces/model_name.dart';
import 'package:mekla/repositories/recipe_repository.dart';
import 'package:mekla/services/recipe_operations.dart';
import 'package:mekla/views/ingredients/ingredients_page.dart';
import 'package:mekla/views/recipe/recipe_page.dart';
import 'package:mekla/views/recipe_categories/recipe_categories_page.dart';
import 'package:mekla/views/recipes/models/recipe_category_pm_recipes.dart';
import 'package:mekla/views/recipes/models/recipe_pm_recipes.dart';
import 'package:mekla/widgets/common/snack_bar.dart';
import 'package:mekla/widgets/project/upsert_element/controllers/upsert_recipe_controller.dart';
import 'package:mekla/widgets/project/upsert_element/upsert_element_dialog.dart';

class RecipesController extends BaseController
    with LoadingDecorator, DataFetchingDecorator, SelectionDecorator {
  RecipesController({this.categoryId});

  static RecipesController get find => Get.find<RecipesController>();
  List<RecipePMRecipes> recipes = [];
  List<RecipePMRecipes> recipesWithoutCategory = [];
  List<RecipeCategoryPMRecipes> categories = [];
  final int? categoryId;
  bool categorize = false;

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
        await precacheImage(recipe.image!, Get.context!);
      }
    }
    recipes.sort(ModelName.nameComparator);
    await _initCategories();
  }

  Future<void> _initCategories() async {
    final Map<int, List<RecipePMRecipes>> recipesByCategoryMap = {};
    recipesWithoutCategory = [];
    for (var recipe in recipes) {
      if (recipe.category.value == null) {
        recipesWithoutCategory.add(recipe);
      } else {
        recipesByCategoryMap.update(recipe.category.value!.id!, (value) {
          value.add(recipe);
          return value;
        }, ifAbsent: () => List.from([recipe]));
      }
    }
    categories = recipesByCategoryMap.entries
        .map((e) => RecipeCategoryPMRecipes(
            recipeCategory: e.value.first.category.value!, recipes: e.value))
        .toList();
    categories.sort(ModelName.nameComparator);
    for (RecipeCategoryPMRecipes category in categories) {
      if (category.image != null) {
        for (ImageProvider image in category.image!) {
          await precacheImage(image, Get.context!);
        }
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

  Future<void> addRecipe({int? categoryId}) async {
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
        );
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
        );
        break;
      case 2:
        await Get.toNamed(IngredientsPage.routeName);
        break;
      case 3:
        await Get.toNamed(RecipeCategoriesPage.routeName);
        break;
    }
    await fetchData();
  }

  void toggleCategorize() {
    categorize = !categorize;
    update();
  }
}
