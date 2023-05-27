import 'package:get/get.dart';
import 'package:mekla/decorator/decorators.dart';
import 'package:mekla/decorator/decorators/generic_selection_decorator.dart';
import 'package:mekla/repositories/ingredient_category_repository.dart';
import 'package:mekla/services/image_service.dart';
import 'package:mekla/views/ingredient_categories/models/ingredient_category_pm_ingredient_categories.dart';
import 'package:mekla/widgets/project/upsert_element/controllers/upsert_ingredient_category_controller.dart';
import 'package:mekla/widgets/project/upsert_element/upsert_element_dialog.dart';

class IngredientCategoriesController extends BaseController
    with
        LoadingDecorator,
        DataFetchingDecorator,
        SelectionDecorator,
        GenericSelectionDecorator<IngredientCategoryPMIngredientCategories,
            IngredientCategoryRepository> {
  static IngredientCategoriesController get find =>
      Get.find<IngredientCategoriesController>();

  List<IngredientCategoryPMIngredientCategories> _ingredientCategories = [];

  @override
  Future<void> loadData() async {
    await Future.wait([super.loadData(), fetchIngredientCategories()]);
  }

  Future<void> add() async {
    final created =
        await UpsertElementDialog<UpsertIngredientCategoryController>(
      init: UpsertIngredientCategoryController(),
    ).show(false);
    if (created ?? false) await fetchData();
  }

  Future<void> edit() async {
    if (selectionCount != 1) return;
    final updated =
        await UpsertElementDialog<UpsertIngredientCategoryController>(
      init: UpsertIngredientCategoryController(id: selectedItems.first.id),
    ).show(false);
    if (updated ?? false) await fetchData();
  }

  Future<void> fetchIngredientCategories() async {
    _ingredientCategories = (await IngredientCategoryRepository.find.findAll())
        .map((ingredientCategory) => IngredientCategoryPMIngredientCategories(
            ingredientCategory: ingredientCategory))
        .toList();
    ImageService.find.cacheImages(items);
  }

  @override
  List<IngredientCategoryPMIngredientCategories> get items {
    return _ingredientCategories;
  }

  @override
  String get itemsName => 'Ingredient Categories';
}
