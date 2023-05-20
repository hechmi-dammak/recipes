import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/models/entities/picture.dart';
import 'package:mekla/widgets/project/upsert_element/models/upsert_from_field.dart';

class PictureUpsertFormField extends UpsertFormField {
  PictureUpsertFormField(
      {required super.name,
      super.optional,
      super.label = 'Image',
      this.aspectRatio = 2});

  Picture? _picture;
  double aspectRatio;
  ImageProvider? _image;

  set picture(Picture? picture) {
    _picture = picture;
    updateImage();
  }

  Picture? get picture => _picture;

  ImageProvider? get image => _image;

  Future<void> updateImage() async {
    if (picture != null) {
      _image = MemoryImage(picture!.image);
      await precacheImage(image!, Get.context!);
    } else {
      _image = null;
    }
  }
}
