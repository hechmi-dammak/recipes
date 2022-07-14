import 'package:get/get.dart';
import 'package:recipes/models/picture.dart';
import 'package:recipes/service/data_base_provider.dart';

class PictureRepository extends GetxService {
  static PictureRepository get find => Get.find<PictureRepository>();

  Future<Picture> create(Picture picture) async {
    final id = await (await DataBaseProvider.database)
        .insert(tablePictures, picture.toMap(true));
    return picture.copy(id: id);
  }

  Future<Picture?> read(int? id) async {
    if (id == null) return null;

    final maps = await (await DataBaseProvider.database).query(
      tablePictures,
      columns: PictureFields.values,
      where: '${PictureFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Picture.fromMap(maps.first);
    }
    return Picture();
  }

  Future<Picture> update(Picture picture) async {
    if (picture.id == null) return await create(picture);

    (await DataBaseProvider.database).update(
      tablePictures,
      picture.toMap(),
      where: '${PictureFields.id} = ?',
      whereArgs: [picture.id],
    );
    return picture;
  }

  Future<int> delete(int? id) async {
    if (id == null) return 0;

    return await (await DataBaseProvider.database).delete(
      tablePictures,
      where: '${PictureFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<Picture>> readAll() async {
    final List<Picture> pictures = [];
    final maps = await (await DataBaseProvider.database).query(
      tablePictures,
      columns: PictureFields.values,
    );
    if (maps.isNotEmpty) {
      for (var picture in maps) {
        pictures.add(Picture.fromMap(picture));
      }
    }
    return pictures;
  }
}
