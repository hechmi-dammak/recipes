import 'package:get/get.dart';
import 'package:mekla/decorator/decorators.dart';
import 'package:mekla/decorator/decorators/generic_selection_decorator.dart';
import 'package:mekla/helpers/getx_extension.dart';
import 'package:mekla/repositories/recipe_category_repository.dart';
import 'package:mekla/services/image_service.dart';
import 'package:mekla/views/recipe_categories/models/recipe_category_pm_recipe_categories.dart';
import 'package:mekla/views/recipes/recipes_page.dart';
import 'package:mekla/widgets/project/upsert_element/controllers/upsert_recipe_category_controller.dart';
import 'package:mekla/widgets/project/upsert_element/upsert_element_dialog.dart';

class RecipeCategoriesController extends BaseController
    with
        LoadingDecorator,
        DataFetchingDecorator,
        SelectionDecorator,
        GenericSelectionDecorator<RecipeCategoryPMRecipeCategories,
            RecipeCategoryRepository> {
  static RecipeCategoriesController get find =>
      Get.find<RecipeCategoriesController>();

  List<RecipeCategoryPMRecipeCategories> _recipeCategories = [];

  @override
  Future<void> loadData() async {
    await Future.wait([super.loadData(), fetchRecipeCategories()]);
  }

  Future<void> add() async {
    final created = await UpsertElementDialog<UpsertRecipeCategoryController>(
      controller: UpsertRecipeCategoryController(),
    ).show(false);
    if (created ?? false) await fetchData();
  }

  Future<void> edit() async {
    if (selectionCount != 1) return;
    final updated = await UpsertElementDialog<UpsertRecipeCategoryController>(
      controller: UpsertRecipeCategoryController(id: selectedItems.first.id),
    ).show(false);
    if (updated ?? false) await fetchData();
  }

  Future<void> fetchRecipeCategories() async {
    _recipeCategories = (await RecipeCategoryRepository.find.findAll())
        .map((recipeCategory) =>
            RecipeCategoryPMRecipeCategories(recipeCategory: recipeCategory))
        .toList();
    ImageService.find.cacheImages(items);
  }

  void goToRecipes(RecipeCategoryPMRecipeCategories recipeCategory) {
    Get.toNamedWithPathParams(
      RecipesPage.routeName,
      pathParameters: {'id': recipeCategory.id.toString()},
    );
  }

  @override
  List<RecipeCategoryPMRecipeCategories> get items => _recipeCategories;

  @override
  String get itemsName => 'Recipe Categories';
}
