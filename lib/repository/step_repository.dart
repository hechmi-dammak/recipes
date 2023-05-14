import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mekla/models/isar_models/step.dart';
import 'package:mekla/repository/picture_repository.dart';
import 'package:mekla/repository/recipe_repository.dart';
import 'package:mekla/service/isar_service.dart';

class StepRepository extends GetxService {
  static StepRepository get find => Get.find<StepRepository>();

  Future<Step> save(Step step) async {
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

  Future<bool> deleteById(int? id) async {
    if (id == null) return false;
    return await IsarService.isar
        .writeTxn(() => IsarService.isar.steps.delete(id));
  }

  Future<Step?> findById(int? id) async {
    if (id == null) return null;
    return IsarService.isar.steps.get(id);
  }

  Future<List<Step>> findAll() async {
    return await IsarService.isar.steps.where().findAll();
  }
}
