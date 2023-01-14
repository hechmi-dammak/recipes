import 'package:get/get.dart';
import 'package:recipes/models/picture.dart';
import 'package:recipes/service/data_base_provider.dart';

class PictureRepository extends GetxService {
  static PictureRepository get find => Get.find<PictureRepository>();

  Future<Picture> _create(Picture picture) async {
    final id = await (await DataBaseProvider.database)
        .insert(tablePictures, picture.toJson(database: true, withId: false));
    return picture.copy(id: id);
  }

  Future<Picture> save(Picture picture) async {
    if (picture.id == null) {
      return await _create(picture);
    }

    (await DataBaseProvider.database).update(
      tablePictures,
      picture.toJson(database: true),
      where: '${PictureFields.id} = ?',
      whereArgs: [picture.id],
    );
    return picture;
  }

  Future<int> deleteById(int? id) async {
    if (id == null) return 0;

    return await (await DataBaseProvider.database).delete(
      tablePictures,
      where: '${PictureFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<Picture?> findById(int? id) async {
    if (id == null) return null;

    final queryResult = await (await DataBaseProvider.database).query(
      tablePictures,
      columns: PictureFields.values,
      where: '${PictureFields.id} = ?',
      whereArgs: [id],
    );
    if (queryResult.isNotEmpty) {
      return Picture.fromJson(queryResult.first, database: true);
    }
    return null;
  }

  Future<List<Picture>> findAll() async {
    final List<Picture> pictures = [];
    final queryResult = await (await DataBaseProvider.database).query(
      tablePictures,
      columns: PictureFields.values,
    );
    if (queryResult.isNotEmpty) {
      for (var pictureJson in queryResult) {
        pictures.add(Picture.fromJson(pictureJson, database: true));
      }
    }
    return pictures;
  }
}
