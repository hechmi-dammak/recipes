import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes/models/picture.dart';
import 'package:recipes/service/image_operations.dart';
import 'package:recipes/widgets/project/upsert_element/models/upsert_from_field.dart';

class PictureUpsertFormFieldController extends GetxController {
  PictureUpsertFormFieldController({required this.formField}) {
    setImage(formField.picture);
  }

  final PictureUpsertFormField formField;

  Picture? get picture => formField.picture;
  ImageProvider? image;

  double get aspectRatio => formField.aspectRatio;

  bool get pictureIsSet => picture != null;

  Future<void> setPicture([Picture? picture]) async {
    formField.picture = picture;
    setImage(picture);
    update();
  }

  Future<void> setImage([Picture? picture]) async {
    if (picture != null) {
      image = MemoryImage(picture.image);
      await precacheImage(image!, Get.context!);
    } else {
      image = null;
    }
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
