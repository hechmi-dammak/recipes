import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/decorator/decorators.dart';
import 'package:mekla/helpers/getx_extension.dart';
import 'package:mekla/repository/recipe_category_repository.dart';
import 'package:mekla/views/recipe_categories/models/recipe_category_pm_recipe_categories.dart';
import 'package:mekla/views/recipes/recipes_page.dart';
import 'package:mekla/widgets/common/snack_bar.dart';
import 'package:mekla/widgets/project/upsert_element/controllers/upsert_recipe_category_controller.dart';
import 'package:mekla/widgets/project/upsert_element/upsert_element_dialog.dart';

class RecipeCategoriesController extends BaseController
    with LoadingDecorator, DataFetchingDecorator, SelectionDecorator {
  static RecipeCategoriesController get find =>
      Get.find<RecipeCategoriesController>();

  List<RecipeCategoryPMRecipeCategories> recipeCategories = [];

  @override
  Future<void> loadData() async {
    await Future.wait([super.loadData(), fetchRecipeCategories()]);
  }

  @override
  void setSelectAllValue([bool value = false]) {
    for (var recipeCategory in recipeCategories) {
      recipeCategory.selected = value;
    }
    super.setSelectAllValue(value);
  }

  @override
  bool get selectionIsActiveFallBack =>
      recipeCategories.any((recipeCategory) => recipeCategory.selected);

  @override
  bool get allItemsSelectedFallBack =>
      recipeCategories.every((recipeCategory) => recipeCategory.selected);

  @override
  int get selectionCount => getSelectedItems().length;

  Future<void> addRecipeCategory() async {
    final created = await UpsertElementDialog<UpsertRecipeCategoryController>(
      controller: UpsertRecipeCategoryController(),
    ).show(false);
    if (created ?? false) await fetchData();
  }

  Future<void> editRecipeCategory() async {
    if (selectionCount != 1) return;
    final updated = await UpsertElementDialog<UpsertRecipeCategoryController>(
      controller:
          UpsertRecipeCategoryController(id: getSelectedItems().first.id),
    ).show(false);
    if (updated ?? false) await fetchData();
  }

  Future<void> fetchRecipeCategories() async {
    recipeCategories = (await RecipeCategoryRepository.find.findAll())
        .map((recipeCategory) =>
            RecipeCategoryPMRecipeCategories(recipeCategory: recipeCategory))
        .toList();
    for (RecipeCategoryPMRecipeCategories recipeCategory in recipeCategories) {
      if (recipeCategory.image != null) {
        precacheImage(recipeCategory.image!, Get.context!);
      }
    }
  }



  Future<void> deleteSelectedCategories() async {
    loading = true;
    for (RecipeCategoryPMRecipeCategories recipeCategory
        in getSelectedItems()) {
      await RecipeCategoryRepository.find.deleteById(recipeCategory.id!);
    }
    await fetchData();
    CustomSnackBar.success('Selected Recipe Categories were deleted.'.tr);
  }

  Iterable<RecipeCategoryPMRecipeCategories> getSelectedItems() {
    return recipeCategories.where((recipeCategory) => recipeCategory.selected);
  }

  void goToRecipes(RecipeCategoryPMRecipeCategories recipeCategory) {
    Get.toNamedWithPathParams(
      RecipesPage.routeName,
      pathParameters: {'id': recipeCategory.id.toString()},
    );
  }
}
