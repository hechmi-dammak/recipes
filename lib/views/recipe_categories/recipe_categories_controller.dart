import 'package:get/get.dart';
import 'package:recipes/decorator/decorators.dart';
import 'package:recipes/helpers/getx_extension.dart';
import 'package:recipes/service/repository/recipe_category_repository.dart';
import 'package:recipes/views/recipe_categories/models/recipe_category_pm_recipe_categories.dart';
import 'package:recipes/views/recipes/recipes_page.dart';
import 'package:recipes/widgets/common/snack_bar.dart';
import 'package:recipes/widgets/project/upsert_element/controllers/upsert_recipe_category_controller.dart';
import 'package:recipes/widgets/project/upsert_element/upsert_element_dialog.dart';

class RecipeCategoriesController extends ControllerDecorator {
  RecipeCategoriesController({super.controller, super.child});

  static RecipeCategoriesController get find =>
      Get.find<RecipeCategoriesController>();

  factory RecipeCategoriesController.create() {
    final recipesCategoriesController = RecipeCategoriesController(
        controller: SelectionDecorator.create(
      controller: DataFetchingDecorator.create(
        controller: LoadingDecorator.create(),
      ),
    ));
    recipesCategoriesController.controller.child = recipesCategoriesController;
    return recipesCategoriesController;
  }

  List<RecipeCategoryPMRecipeCategories> recipeCategories = [];

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
    final created = await UpsertElementDialog<UpsertRecipeCategoryController>(
      controller: UpsertRecipeCategoryController.create(),
    ).show(false);
    if (created ?? false) await fetchData();
  }

  Future<void> editRecipeCategory() async {
    if (selectionCount() != 1) return;
    final updated = await UpsertElementDialog<UpsertRecipeCategoryController>(
      controller: UpsertRecipeCategoryController.create(
          id: getSelectedItems().first.id),
    ).show(false);
    if (updated ?? false) await fetchData();
  }

  Future<void> fetchRecipeCategories() async {
    recipeCategories = (await RecipeCategoryRepository.find.findAll())
        .map((recipeCategory) =>
            RecipeCategoryPMRecipeCategories(recipeCategory: recipeCategory))
        .toList();
    updateSelection();
  }

  Future<void> selectCategory(
      RecipeCategoryPMRecipeCategories recipeCategory) async {
    recipeCategory.selected = !recipeCategory.selected;
    updateSelection();
  }

  Future<void> deleteSelectedCategories() async {
    setLoading(true);
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
