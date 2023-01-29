import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/ingredient_category.dart';
import 'package:recipes/models/step.dart';
import 'package:recipes/models/picture.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/models/recipe_category.dart';
import 'package:recipes/models/recipe_ingredient.dart';

class IsarService extends GetxService {
  static IsarService get find => Get.find<IsarService>();

  static Isar get isar => Get.find<IsarService>()._isar;

  late Isar _isar;

  Future<void> init() async {
    _isar = await Isar.open([
      IngredientSchema,
      IngredientCategorySchema,
      StepSchema,
      PictureSchema,
      RecipeSchema,
      RecipeCategorySchema,
      RecipeIngredientSchema
    ]);
  }
}
