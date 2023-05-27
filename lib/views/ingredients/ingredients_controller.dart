import 'package:get/get.dart';
import 'package:mekla/decorator/decorators.dart';
import 'package:mekla/decorator/decorators/generic_selection_decorator.dart';
import 'package:mekla/repositories/ingredient_repository.dart';
import 'package:mekla/services/image_service.dart';
import 'package:mekla/views/ingredients/models/ingredient_pm_ingredients.dart';
import 'package:mekla/widgets/project/upsert_element/controllers/upsert_ingredient_controller.dart';
import 'package:mekla/widgets/project/upsert_element/upsert_element_dialog.dart';

class IngredientsController extends BaseController
    with
        LoadingDecorator,
        DataFetchingDecorator,
        SelectionDecorator,
        GenericSelectionDecorator<IngredientPMIngredients,
            IngredientRepository> {
  static IngredientsController get find => Get.find<IngredientsController>();

  List<IngredientPMIngredients> _ingredients = [];

  @override
  Future<void> loadData() async {
    await Future.wait([super.loadData(), fetchIngredients()]);
  }

  Future<void> fetchIngredients() async {
    _ingredients = (await IngredientRepository.find.findAll())
        .map((ingredient) => IngredientPMIngredients(ingredient: ingredient))
        .toList();
    ImageService.find.cacheImages(items);
  }

  Future<void> add() async {
    final created = await UpsertElementDialog<UpsertIngredientController>(
      init: UpsertIngredientController(),
    ).show(false);
    if (created ?? false) await fetchData();
  }

  Future<void> edit() async {
    if (selectionCount != 1) return;
    final updated = await UpsertElementDialog<UpsertIngredientController>(
      init: UpsertIngredientController(
        id: selectedItems.first.id,
      ),
    ).show(false);
    if (updated ?? false) await fetchData();
  }

  @override
  List<IngredientPMIngredients> get items => _ingredients;

  @override
  String get itemsName => 'Ingredients';
}
