import 'package:get/get.dart';
import 'package:mekla/models/isar_models/picture.dart';
import 'package:mekla/repository/repository_service.dart';

class PictureRepository extends RepositoryService<Picture> {
  static PictureRepository get find => Get.find<PictureRepository>();
}
