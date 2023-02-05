import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/decorator/decorators.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/service/repository/recipe_repository.dart';
import 'package:recipes/widgets/project/upsert_element/controllers/upsert_step_controller.dart';
import 'package:recipes/widgets/project/upsert_element/upsert_element_dialog.dart';

class RecipeController extends BaseController
    with
        GetSingleTickerProviderStateMixin,
        SelectionDecorator,
        DataFetchingDecorator,
        LoadingDecorator {
  RecipeController({required this.recipeId});

  static RecipeController get find => Get.find<RecipeController>();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 2);
  }

  final int recipeId;
  Recipe? recipe;
  late TabController tabController;

  @override
  Future<void> loadData() async {
    await Future.wait([super.loadData(), fetchRecipe()]);
  }

  Future<void> fetchRecipe() async {
    recipe = await RecipeRepository.find.findById(recipeId);
  }

  void changeTab(int index) {
    tabController.index = index;
    update();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> addStep() async {
    final created = await UpsertElementDialog<UpsertStepController>(
      aspectRatio: 1,
      controller: UpsertStepController(
        recipeId: recipeId,
      ),
    ).show(false);
    if (created ?? false) await fetchData();
  }
}
