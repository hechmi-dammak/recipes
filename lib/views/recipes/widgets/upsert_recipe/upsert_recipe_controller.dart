import 'package:get/get.dart';
import 'package:recipes/controller_decorator/controller.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/service/repository/recipe_category_repository.dart';
import 'package:recipes/service/repository/recipe_repository.dart';
import 'package:recipes/widgets/project/upsert_element/upsert_element_controller.dart';

class UpsertRecipeController extends UpsertElementController {
  static UpsertRecipeController get find => Get.find<UpsertRecipeController>();

  final int? id;
  final int categoryId;

  UpsertRecipeController(
      {required this.categoryId, this.id, super.controller, super.child});

  Recipe recipe = Recipe();

  factory UpsertRecipeController.create(
      {int? id, required int categoryId, Controller? controller}) {
    final recipesCategoriesController = UpsertRecipeController(
        controller: controller, id: id, categoryId: categoryId);
    recipesCategoriesController.controller.child = recipesCategoriesController;
    recipesCategoriesController.initState(null);
    return recipesCategoriesController;
  }

  @override
  Future<void> loadData({bool callChild = true}) async {
    if (child != null && callChild) {
      await child!.loadData();
      return;
    }
    await Future.wait([super.loadData(callChild: false), fetchRecipe()]);
  }

  Future<void> fetchRecipe() async {
    if (id != null) {
      recipe = await RecipeRepository.find.findById(id) ?? recipe;
      nameController.text = recipe.name;
      descriptionController.text = recipe.description ?? '';
      setPicture(recipe.picture.value);
      return;
    }
    recipe.category.value =
        await RecipeCategoryRepository.find.findById(categoryId);
  }

  @override
  Future<void> confirm(
      void Function([bool? result, bool forceClose]) close) async {
    if (formKey.currentState?.validate() ?? false) {
      final description = descriptionController.text.trim();
      recipe
        ..name = nameController.text.trim()
        ..description = description.isEmpty ? null : description
        ..picture.value = getPicture();
      await RecipeRepository.find.save(recipe);
      close(true, true);
    }
  }
}
