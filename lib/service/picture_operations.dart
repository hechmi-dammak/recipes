import 'package:recipes/models/picture.dart';
import 'package:recipes/service/database.dart';

class PictureOperations {
  static final PictureOperations instance = PictureOperations._init();
  PictureOperations._init();

  final dbProvider = DataBaseRepository.instance;
  Future<Picture> create(Picture picture) async {
    final db = await dbProvider.database;

    final id = await db.insert(tablePictures, picture.toMap(true));
    return picture.copy(id: id);
  }

  Future<Picture?> read(int? id) async {
    if (id == null) return null;
    final db = await dbProvider.database;
    final maps = await db.query(
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
    final db = await dbProvider.database;

    db.update(
      tablePictures,
      picture.toMap(),
      where: '${PictureFields.id} = ?',
      whereArgs: [picture.id],
    );
    return picture;
  }

  Future<int> delete(int? id) async {
    if (id == null) return 0;
    final db = await dbProvider.database;

    return await db.delete(
      tablePictures,
      where: '${PictureFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<Picture>> readAll() async {
    final db = await dbProvider.database;
    List<Picture> pictures = [];
    final maps = await db.query(
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
