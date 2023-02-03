import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:recipes/models/step.dart';
import 'package:recipes/service/isar_service.dart';

class StepRepository extends GetxService {
  static StepRepository get find => Get.find<StepRepository>();

  Future<Step> save(Step step) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.steps.put(step);
      await step.picture.save();
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
