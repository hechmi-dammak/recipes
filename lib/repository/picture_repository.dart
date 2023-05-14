import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mekla/models/isar_models/picture.dart';
import 'package:mekla/service/isar_service.dart';

class PictureRepository extends GetxService {
  static PictureRepository get find => Get.find<PictureRepository>();

  Future<Picture> save(Picture picture) async {
    await IsarService.isar
        .writeTxn(() async => await IsarService.isar.pictures.put(picture));
    return picture;
  }

  Future<bool> deleteById(int? id) async {
    if (id == null) return false;
    return await IsarService.isar
        .writeTxn(() => IsarService.isar.pictures.delete(id));
  }

  Future<Picture?> findById(int? id) async {
    if (id == null) return null;
    return await IsarService.isar.pictures.get(id);
  }

  Future<List<Picture>> findAll() async {
    return await IsarService.isar.pictures.where().findAll();
  }
}
