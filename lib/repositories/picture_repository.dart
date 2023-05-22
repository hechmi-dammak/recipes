import 'package:get/get.dart';
import 'package:mekla/models/entities/picture.dart';
import 'package:mekla/repositories/abstracts/repository_service.dart';

class PictureRepository extends RepositoryService<Picture> {
  static PictureRepository get find => Get.find<PictureRepository>();
}
