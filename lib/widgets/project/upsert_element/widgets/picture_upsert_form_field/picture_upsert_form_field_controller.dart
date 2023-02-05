import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes/models/picture.dart';
import 'package:recipes/service/image_operations.dart';
import 'package:recipes/widgets/project/upsert_element/models/upsert_from_field.dart';

class PictureUpsertFormFieldController extends GetxController {
  PictureUpsertFormFieldController({required this.formField});

  final PictureUpsertFormField formField;

  Picture? get picture => formField.picture;

  double get aspectRatio => formField.aspectRatio;

  bool get pictureIsSet => picture != null;

  set picture(Picture? picture) {
    formField.picture = picture;
    update();
  }

  Future<void> pickImage(
    ImageSource? imageSource,
  ) async {
    if (imageSource == null) return;
    picture = (await ImageService.find.getImage(imageSource,
            crop: CropAspectRatio(ratioX: aspectRatio, ratioY: 1)) ??
        picture);
  }

  void clearImage({bool callChild = true}) {
    picture = null;
  }
}
