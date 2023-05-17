import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mekla/models/isar_models/recipe.dart';
import 'package:mekla/models/isar_models/step.dart';
import 'package:mekla/repository/picture_repository.dart';
import 'package:mekla/repository/recipe_repository.dart';
import 'package:mekla/repository/repository_service.dart';
import 'package:mekla/service/isar_service.dart';

class StepRepository extends RepositoryService<Step> {
  static StepRepository get find => Get.find<StepRepository>();

  @override
  Future<Step> save(Step element) async {
    return await _save(element);
  }

  Future<Step> _save(Step step) async {
    step.instruction = step.instruction.trim();
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.steps.put(step);
    });
    if (step.picture.value != null && step.picture.value?.id == null) {
      await PictureRepository.find.save(step.picture.value!);
    }
    if (step.recipe.value != null && step.recipe.value?.id == null) {
      await RecipeRepository.find.save(step.recipe.value!);
    }
    IsarService.isar.writeTxn(() async {
      await step.picture.save();
      await step.recipe.save();
    });
    return step;
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
