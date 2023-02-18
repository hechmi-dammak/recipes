import 'package:get/get.dart';
import 'package:recipes/decorator/decorators.dart';
import 'package:recipes/helpers/getx_extension.dart';
import 'package:recipes/service/repository/recipe_repository.dart';
import 'package:recipes/views/recipe/recipe_page.dart';
import 'package:recipes/views/recipes/models/recipe_pm_recipes.dart';
import 'package:recipes/widgets/common/snack_bar.dart';
import 'package:recipes/widgets/project/upsert_element/controllers/upsert_recipe_controller.dart';
import 'package:recipes/widgets/project/upsert_element/upsert_element_dialog.dart';

class RecipesController extends BaseController
    with LoadingDecorator, DataFetchingDecorator, SelectionDecorator {
  RecipesController({required this.categoryId});

  static RecipesController get find => Get.find<RecipesController>();

  final int categoryId;
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
    recipes =
        (await RecipeRepository.find.findAllByRecipeCategoryId(categoryId))
            .map((recipe) => RecipePMRecipes(recipe: recipe))
            .toList();
  }

  void goToRecipe(RecipePMRecipes recipe) {
    Get.toNamedWithPathParams(
      RecipePage.routeName,
      pathParameters: {'id': recipe.id.toString()},
    );
  }

  void selectRecipe(RecipePMRecipes recipe) {
    recipe.selected = !recipe.selected;
    updateSelection();
  }

  Future<void> deleteSelectedRecipes() async {
    loading = true;
    for (RecipePMRecipes recipe in getSelectedItems()) {
      await RecipeRepository.find.deleteById(recipe.id!);
    }
    await fetchData();
    CustomSnackBar.success('Selected Recipe  were deleted.'.tr);
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
}
