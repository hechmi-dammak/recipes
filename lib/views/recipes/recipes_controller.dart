import 'package:get/get.dart';
import 'package:mekla/decorator/decorators.dart';
import 'package:mekla/decorator/decorators/generic_selection_decorator.dart';
import 'package:mekla/helpers/getx_extension.dart';
import 'package:mekla/models/interfaces/model_name.dart';
import 'package:mekla/repositories/recipe_repository.dart';
import 'package:mekla/services/image_service.dart';
import 'package:mekla/services/sharing_service.dart';
import 'package:mekla/views/ingredient_categories/ingredient_categories_page.dart';
import 'package:mekla/views/ingredients/ingredients_page.dart';
import 'package:mekla/views/recipe/recipe_page.dart';
import 'package:mekla/views/recipe_categories/recipe_categories_page.dart';
import 'package:mekla/views/recipes/models/recipe_category_pm_recipes.dart';
import 'package:mekla/views/recipes/models/recipe_pm_recipes.dart';
import 'package:mekla/widgets/project/upsert_element/controllers/upsert_recipe_controller.dart';
import 'package:mekla/widgets/project/upsert_element/upsert_element_dialog.dart';

class RecipesController extends BaseController
    with
        LoadingDecorator,
        DataFetchingDecorator,
        SelectionDecorator,
        GenericSelectionDecorator<RecipePMRecipes, RecipeRepository> {
  RecipesController({this.categoryId});

  static RecipesController get find => Get.find<RecipesController>();
  List<RecipePMRecipes> _recipes = [];
  List<RecipePMRecipes> recipesWithoutCategory = [];
  List<RecipeCategoryPMRecipes> categories = [];
  final int? categoryId;
  bool categorize = false;

  @override
  Future<void> loadData() async {
    await Future.wait([super.loadData(), fetchRecipes()]);
  }

  Future<void> fetchRecipes() async {
    if (categoryId == null) {
      _recipes = (await RecipeRepository.find.findAll())
          .map((recipe) => RecipePMRecipes(recipe: recipe))
          .toList();
    } else {
      _recipes =
          (await RecipeRepository.find.findAllByRecipeCategoryId(categoryId))
              .map((recipe) => RecipePMRecipes(recipe: recipe))
              .toList();
    }
    await ImageService.find.cacheImages(items);
    items.sort(ModelName.nameComparator);
    await _initCategories();
  }

  Future<void> _initCategories() async {
    final Map<int, List<RecipePMRecipes>> recipesByCategoryMap = {};
    recipesWithoutCategory = [];
    for (var recipe in items) {
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
    ImageService.find.cacheMultiImages(categories);
  }

  void goToRecipe(RecipePMRecipes recipe) {
    Get.toNamedWithPathParams(
      RecipePage.routeName,
      pathParameters: {'id': recipe.id.toString()},
    );
  }

  Future<void> add({int? categoryId}) async {
    final created = await UpsertElementDialog<UpsertRecipeController>(
      controller: UpsertRecipeController(
        categoryId: categoryId,
      ),
    ).show(false);
    if (created ?? false) await fetchData();
  }

  Future<void> edit() async {
    if (selectionCount != 1) return;
    final updated = await UpsertElementDialog<UpsertRecipeController>(
      controller: UpsertRecipeController(
        id: selectedItems.first.id,
      ),
    ).show(false);
    if (updated ?? false) await fetchData();
  }

  Future<void> shareRecipes() async {
    await SharingService.find.shareAsFile(
        recipes: selectedItems.map((recipe) => recipe.toMap(false)).toList());
  }

  Future<void> exportRecipes() async {
    await SharingService.find.exportToFile(
        recipes: selectedItems.map((recipe) => recipe.toMap(false)).toList());
  }

  Future<void> selectedItemMenu(int item) async {
    switch (item) {
      case 0:
        await SharingService.find.importFromFile(
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
        await SharingService.find.importFromLibrary(
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
        await await Get.toNamed(IngredientsPage.routeName);
        break;
      case 3:
        await Get.toNamed(RecipeCategoriesPage.routeName);
        break;
      case 4:
        await Get.toNamed(IngredientCategoriesPage.routeName);
        break;
    }
    await fetchData();
  }

  void toggleCategorize() {
    categorize = !categorize;
    update();
  }

  @override
  List<RecipePMRecipes> get items => _recipes;

  @override
  String get itemsName => 'Recipes';
}
