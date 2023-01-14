import 'package:get/get.dart';
import 'package:recipes/controller_decorator/controller.dart';
import 'package:recipes/controller_decorator/controller_decorator.dart';
import 'package:recipes/models/recipe_category.dart';
import 'package:recipes/service/repository/recipe_category_repository.dart';
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

  List<RecipeCategory> recipeCategories = [];

  Future<void> addRecipeCategory() async {
    await const AddRecipeCategoryDialog().show(false);
  }

  @override
  Future<void> loadData({callChild = true}) async {
    if (child != null && callChild) {
      await child!.loadData();
      return;
    }
    await Future.wait(
        [super.loadData(callChild: false), fetchRecipeCategory()]);
  }

  Future<void> fetchRecipeCategory() async {
    recipeCategories = await RecipeCategoryRepository.find.findAll();
  }
}
