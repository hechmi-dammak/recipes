import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/decorator/decorators.dart';
import 'package:mekla/repository/ingredient_repository.dart';
import 'package:mekla/views/ingredients/models/ingredient_pm_ingredients.dart';
import 'package:mekla/widgets/common/snack_bar.dart';
import 'package:mekla/widgets/project/upsert_element/controllers/upsert_ingredient_controller.dart';
import 'package:mekla/widgets/project/upsert_element/upsert_element_dialog.dart';

class IngredientsController extends BaseController
    with LoadingDecorator, DataFetchingDecorator, SelectionDecorator {
  static IngredientsController get find => Get.find<IngredientsController>();

  List<IngredientPMIngredients> ingredients = [];

  @override
  Future<void> loadData() async {
    await Future.wait([super.loadData(), fetchIngredients()]);
  }

  @override
  void setSelectAllValue([bool value = false]) {
    for (var ingredient in ingredients) {
      ingredient.selected = value;
    }
    super.setSelectAllValue(value);
  }

  @override
  bool get selectionIsActiveFallBack =>
      ingredients.any((ingredient) => ingredient.selected);

  @override
  bool get allItemsSelectedFallBack =>
      ingredients.every((ingredient) => ingredient.selected);

  @override
  int get selectionCount => getSelectedItems().length;

  Iterable<IngredientPMIngredients> getSelectedItems() {
    return ingredients.where((ingredient) => ingredient.selected);
  }

  Future<void> fetchIngredients() async {
    ingredients = (await IngredientRepository.find.findAll())
        .map((ingredient) => IngredientPMIngredients(ingredient: ingredient))
        .toList();
    for (IngredientPMIngredients ingredient in ingredients) {
      if (ingredient.image != null) {
        precacheImage(ingredient.image!, Get.context!);
      }
    }
  }

  Future<void> deleteSelectedIngredients() async {
    loading = true;
    for (IngredientPMIngredients ingredient in getSelectedItems()) {
      await IngredientRepository.find.deleteById(ingredient.id!);
    }
    await fetchData();
    CustomSnackBar.success('Selected Ingredients were deleted.'.tr);
  }

  Future<void> addIngredient() async {
    final created = await UpsertElementDialog<UpsertIngredientController>(
      controller: UpsertIngredientController(),
    ).show(false);
    if (created ?? false) await fetchData();
  }

  Future<void> editIngredient() async {
    if (selectionCount != 1) return;
    final updated = await UpsertElementDialog<UpsertIngredientController>(
      controller: UpsertIngredientController(
        id: getSelectedItems().first.id,
      ),
    ).show(false);
    if (updated ?? false) await fetchData();
  }
}
