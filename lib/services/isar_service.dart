import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mekla/models/entities/ingredient.dart';
import 'package:mekla/models/entities/ingredient_category.dart';
import 'package:mekla/models/entities/picture.dart';
import 'package:mekla/models/entities/recipe.dart';
import 'package:mekla/models/entities/recipe_category.dart';
import 'package:mekla/models/entities/recipe_ingredient.dart';
import 'package:mekla/models/entities/step.dart';
import 'package:path_provider/path_provider.dart';

export 'package:isar/isar.dart';

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
