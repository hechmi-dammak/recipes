import 'package:get/get.dart';
import 'package:mekla/models/entities/recipe.dart';
import 'package:mekla/models/entities/step.dart';
import 'package:mekla/repositories/abstracts/repository_service.dart';
import 'package:mekla/repositories/picture_repository.dart';
import 'package:mekla/repositories/recipe_repository.dart';
import 'package:mekla/services/isar_service.dart';

class StepRepository extends RepositoryService<Step> {
  static StepRepository get find => Get.find<StepRepository>();

  @override
  Future<Step?> save(Step? element) async {
    if (element == null) {
      return null;
    }
    return await saveInternal(element);
  }

  @override
  Future<Step> saveInternal(Step element) async {
    element.instruction = element.instruction.trim();
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.steps.put(element);
    });
    await PictureRepository.find.save(element.picture.value);
    if (element.recipe.value?.id == null) {
      await RecipeRepository.find.save(element.recipe.value);
    }
    IsarService.isar.writeTxn(() async {
      await element.picture.save();
      await element.recipe.save();
    });
    return element;
  }

  Future<int> deleteByRecipeId(int recipeId) async {
    final List<Step> steps = await IsarService.isar.steps
        .filter()
        .recipe((recipe) => recipe.idEqualTo(recipeId))
        .findAll();
    for (var step in steps) {
      deleteById(step.id);
    }
    return steps.length;
  }
}
