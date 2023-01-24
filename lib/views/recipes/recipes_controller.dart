import 'package:get/get.dart';
import 'package:recipes/controller_decorator/controller.dart';
import 'package:recipes/controller_decorator/controller_decorator.dart';

class RecipesController extends ControllerDecorator {
  RecipesController({required super.controller, super.child});

  static RecipesController get find => Get.find<RecipesController>();

  factory RecipesController.create({required Controller controller}) {
    final recipesCategoriesController =
        RecipesController(controller: controller);
    recipesCategoriesController.controller.child = recipesCategoriesController;
    return recipesCategoriesController;
  }
}
