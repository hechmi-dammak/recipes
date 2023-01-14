import 'package:get/get.dart';
import 'package:recipes/controller_decorator/controller.dart';
import 'package:recipes/controller_decorator/controller_decorator.dart';
import 'package:recipes/service/repository/recipe_category_repository.dart';
import 'package:recipes/views/recipe_category/models/recipe_category_page_model.dart';
import 'package:recipes/views/recipe_category/widgets/add_recipe_category/add_recipe_category_dialog.dart';

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

  Future<void> addRecipeCategory() async {
    final created = await const AddRecipeCategoryDialog().show(false);
    if (created ?? false) await fetchData();
  }

  @override
  Future<void> loadData({bool callChild = true}) async {
    if (child != null && callChild) {
      await child!.loadData();
      return;
    }
    await Future.wait(
        [super.loadData(callChild: false), fetchRecipeCategory()]);
  }

  Future<void> fetchRecipeCategory() async {
    recipeCategories = (await RecipeCategoryRepository.find.findAll())
        .map((recipeCategory) =>
            RecipeCategoryPageModel(recipeCategory: recipeCategory))
        .toList();
  }

  Future<void> selectCategory(RecipeCategoryPageModel recipeCategory) async {
    recipeCategory.selected = !recipeCategory.selected;
    updateSelectionIsActive();
    updateAllItemsSelected();
    decoratorUpdate();
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
}
