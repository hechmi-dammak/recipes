import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/decorator/decorators.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/service/repository/recipe_repository.dart';

class RecipeController extends ControllerDecorator
    with GetSingleTickerProviderStateMixin {
  RecipeController({super.controller, required this.recipeId});

  static RecipeController get find => Get.find<RecipeController>();

  factory RecipeController.create({required int categoryId}) {
    final recipeController = RecipeController(
        controller: SelectionDecorator.create(
          controller: DataFetchingDecorator.create(
            controller: LoadingDecorator.create(),
          ),
        ),
        recipeId: categoryId);
    recipeController.controller.child = recipeController;
    return recipeController;
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 2);
  }

  final int recipeId;
  Recipe? recipe;
  late TabController tabController;

  @override
  Future<void> loadData({bool callChild = true}) async {
    if (child != null && callChild) {
      await child!.loadData();
      return;
    }
    await Future.wait([super.loadData(callChild: false), fetchRecipe()]);
  }

  Future<void> fetchRecipe() async {
    recipe = await RecipeRepository.find.findById(recipeId);
  }
}
