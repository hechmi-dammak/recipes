import 'package:get/get.dart';
import 'package:recipes/controller_decorator/controller.dart';
import 'package:recipes/controller_decorator/controller_decorator.dart';
import 'package:recipes/service/repository/recipe_category_repository.dart';
import 'package:recipes/views/recipe_category/models/recipe_category_page_model.dart';
import 'package:recipes/views/recipe_category/widgets/add_recipe_category/upsert_recipe_category_dialog.dart';
import 'package:recipes/widgets/snack_bar.dart';

class RecipesCategoriesController extends ControllerDecorator {
  RecipesCategoriesController({required super.controller, super.child});

  static RecipesCategoriesController get find =>
      Get.find<RecipesCategoriesController>();

  factory RecipesCategoriesController.create({required Controller controller}) {
    final recipesCategoriesController =
        RecipesCategoriesController(controller: controller);
    recipesCategoriesController.controller.child = recipesCategoriesController;
    return recipesCategoriesController;
  }

  List<RecipeCategoryPageModel> recipeCategories = [];

  @override
  Future<void> loadData({bool callChild = true}) async {
    if (child != null && callChild) {
      await child!.loadData();
      return;
    }
    await Future.wait(
        [super.loadData(callChild: false), fetchRecipeCategories()]);
  }

  @override
  void setSelectAllValue({bool value = false, callChild = true}) {
    if (child != null && callChild) {
      child!.setSelectAllValue(value: value);
      return;
    }

    for (var recipeCategory in recipeCategories) {
      recipeCategory.selected = value;
    }
    super.setSelectAllValue(value: value, callChild: false);
  }

  @override
  bool selectionIsActiveFallBack({bool callChild = true}) {
    if (child != null && callChild) {
      return child!.selectionIsActiveFallBack();
    }
    return recipeCategories.any((recipeCategory) => recipeCategory.selected);
  }

  @override
  bool allItemsSelectedFallBack({bool callChild = true}) {
    if (child != null && callChild) {
      return child!.allItemsSelectedFallBack();
    }
    return recipeCategories.every((recipeCategory) => recipeCategory.selected);
  }

  @override
  int selectionCount({callChild = true}) {
    if (child != null && callChild) {
      return child!.selectionCount();
    }
    return getSelectedItems().length;
  }

  Future<void> addRecipeCategory() async {
    final created = await const UpsertRecipeCategoryDialog().show(false);
    if (created ?? false) await fetchData();
  }

  Future<void> editRecipeCategory() async {
    if (selectionCount() != 1) return;
    final updated =
        await UpsertRecipeCategoryDialog(id: getSelectedItems().first.id)
            .show(false);
    if (updated ?? false) await fetchData();
  }

  Future<void> fetchRecipeCategories() async {
    recipeCategories = (await RecipeCategoryRepository.find.findAll())
        .map((recipeCategory) =>
            RecipeCategoryPageModel(recipeCategory: recipeCategory))
        .toList();
    updateSelection();
  }

  Future<void> selectCategory(RecipeCategoryPageModel recipeCategory) async {
    recipeCategory.selected = !recipeCategory.selected;
    updateSelection();
  }

  Future<void> deleteSelectedCategories() async {
    setLoading(true);
    for (RecipeCategoryPageModel recipeCategory in getSelectedItems()) {
      await RecipeCategoryRepository.find.deleteById(recipeCategory.id!);
    }
    await fetchData();
    CustomSnackBar.success('Selected Recipe Categories were deleted.'.tr);
  }

  Iterable<RecipeCategoryPageModel> getSelectedItems() {
    return recipeCategories.where((recipeCategory) => recipeCategory.selected);
  }
}
