import 'package:get/get.dart';
import 'package:recipes/controller_decorator/controller.dart';
import 'package:recipes/controller_decorator/controller_decorator.dart';
import 'package:recipes/controller_decorator/decorators/image_picker_decorator.dart';
import 'package:recipes/service/repository/recipe_repository.dart';
import 'package:recipes/views/recipes/models/recipe_page_model.dart';
import 'package:recipes/views/recipes/widgets/upsert_recipe/upsert_recipe_controller.dart';
import 'package:recipes/widgets/common/snack_bar.dart';
import 'package:recipes/widgets/project/upsert_element/upsert_element_dialog.dart';

class RecipesController extends ControllerDecorator {
  RecipesController({super.controller, super.child, required this.categoryId});

  static RecipesController get find => Get.find<RecipesController>();

  factory RecipesController.create(
      {Controller? controller, required int categoryId}) {
    final recipesCategoriesController =
        RecipesController(controller: controller, categoryId: categoryId);
    recipesCategoriesController.controller.child = recipesCategoriesController;
    return recipesCategoriesController;
  }

  final int categoryId;
  List<RecipePageModel> recipes = [];

  @override
  Future<void> loadData({bool callChild = true}) async {
    if (child != null && callChild) {
      await child!.loadData();
      return;
    }
    await Future.wait([super.loadData(callChild: false), fetchRecipes()]);
  }

  @override
  void setSelectAllValue({bool value = false, callChild = true}) {
    if (child != null && callChild) {
      child!.setSelectAllValue(value: value);
      return;
    }

    for (var recipe in recipes) {
      recipe.selected = value;
    }
    super.setSelectAllValue(value: value, callChild: false);
  }

  @override
  bool selectionIsActiveFallBack({bool callChild = true}) {
    if (child != null && callChild) {
      return child!.selectionIsActiveFallBack();
    }
    return recipes.any((recipe) => recipe.selected);
  }

  @override
  bool allItemsSelectedFallBack({bool callChild = true}) {
    if (child != null && callChild) {
      return child!.allItemsSelectedFallBack();
    }
    return recipes.every((recipe) => recipe.selected);
  }

  @override
  int selectionCount({callChild = true}) {
    if (child != null && callChild) {
      return child!.selectionCount();
    }
    return getSelectedItems().length;
  }

  Iterable<RecipePageModel> getSelectedItems() {
    return recipes.where((recipe) => recipe.selected);
  }

  Future<void> fetchRecipes() async {
    recipes =
        (await RecipeRepository.find.findAllByRecipeCategoryId(categoryId))
            .map((recipe) => RecipePageModel(recipe: recipe))
            .toList();
    updateSelection();
  }

  void goToRecipe(RecipePageModel recipe) {}

  void selectRecipe(RecipePageModel recipe) {
    recipe.selected = !recipe.selected;
    updateSelection();
  }

  Future<void> deleteSelectedRecipes() async {
    setLoading(true);
    for (RecipePageModel recipe in getSelectedItems()) {
      await RecipeRepository.find.deleteById(recipe.id!);
    }
    await fetchData();
    CustomSnackBar.success('Selected Recipe  were deleted.'.tr);
  }

  Future<void> addRecipe() async {
    final created = await UpsertElementDialog<UpsertRecipeController>(
      controller: UpsertRecipeController.create(
        controller: ImagePickerDecorator.create(),
        categoryId: categoryId,
      ),
    ).show(false);
    if (created ?? false) await fetchData();
  }

  Future<void> editRecipe() async {
    if (selectionCount() != 1) return;
    final updated = await UpsertElementDialog<UpsertRecipeController>(
      controller: UpsertRecipeController.create(
        id: getSelectedItems().first.id,
        controller: ImagePickerDecorator.create(),
        categoryId: categoryId,
      ),
    ).show(false);
    if (updated ?? false) await fetchData();
  }
}
