import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mekla/models/ingredient.dart';
import 'package:mekla/models/ingredient_category.dart';
import 'package:mekla/models/picture.dart';
import 'package:mekla/models/recipe.dart';
import 'package:mekla/models/recipe_category.dart';
import 'package:mekla/models/recipe_ingredient.dart';
import 'package:mekla/models/step.dart';
import 'package:path_provider/path_provider.dart';

class IsarService extends GetxService {
  static IsarService get find => Get.find<IsarService>();

  static Isar get isar => Get.find<IsarService>()._isar;

  late Isar _isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([
      IngredientSchema,
      IngredientCategorySchema,
      StepSchema,
      PictureSchema,
      RecipeSchema,
      RecipeCategorySchema,
      RecipeIngredientSchema
    ], directory: dir.path);
  }
}
