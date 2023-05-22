import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mekla/models/entities/picture.dart';
import 'package:mekla/services/image_service.dart';
import 'package:mekla/widgets/project/upsert_element/models/upsert_from_field.dart';

class PictureUpsertFormFieldController extends GetxController {
  static PictureUpsertFormFieldController get find =>
      Get.find<PictureUpsertFormFieldController>();

  PictureUpsertFormFieldController({required this.formField});

  final PictureUpsertFormField formField;

  Picture? get picture => formField.picture;

  double get aspectRatio => formField.aspectRatio;

  Future<void> setPicture([Picture? picture]) async {
    formField.picture = picture;
    update();
  }

  Future<void> pickImage(
    ImageSource? imageSource,
  ) async {
    if (imageSource == null) return;
    await setPicture((await ImageService.find.getImage(imageSource,
            crop: CropAspectRatio(ratioX: aspectRatio, ratioY: 1)) ??
        picture));
  }
}
