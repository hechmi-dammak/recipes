import 'package:get/get.dart';
import 'package:recipes/controller_decorator/controller.dart';
import 'package:recipes/controller_decorator/controller_decorator.dart';

class RecipeController extends ControllerDecorator {
  RecipeController({super.controller, super.child, required this.recipeId});

  static RecipeController get find => Get.find<RecipeController>();

  factory RecipeController.create(
      {Controller? controller, required int categoryId}) {
    final recipeController =
        RecipeController(controller: controller, recipeId: categoryId);
    recipeController.controller.child = recipeController;
    return recipeController;
  }

  final int recipeId;
}
