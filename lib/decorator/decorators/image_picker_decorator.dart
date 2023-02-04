import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes/decorator/controller.dart';
import 'package:recipes/decorator/controller_decorator.dart';
import 'package:recipes/models/picture.dart';
import 'package:recipes/service/image_operations.dart';

class ImagePickerDecorator extends ControllerDecorator {
  ImagePickerDecorator({super.controller});

  factory ImagePickerDecorator.create({Controller? controller}) {
    final imagePickerDecorator = ImagePickerDecorator(controller: controller);
    imagePickerDecorator.controller.child = imagePickerDecorator;
    return imagePickerDecorator;
  }

  Picture? _picture;

  @override
  Picture? getPicture({bool callChild = true}) {
    if (child != null && callChild) {
      return child!.getPicture();
    }
    return _picture;
  }

  @override
  void setPicture(Picture? picture, {bool callChild = true}) {
    if (child != null && callChild) {
      child!.setPicture(picture);
      return;
    }
    _picture = picture;
    decoratorUpdate();
  }

  @override
  Future<void> pickImage(ImageSource? imageSource,
      {double aspectRatio = 2, bool callChild = true}) async {
    if (child != null && callChild) {
      child!.pickImage(imageSource, aspectRatio: aspectRatio);
      return;
    }
    if (imageSource == null) return;
    setPicture(await ImageOperations.find.getImage(imageSource,
            crop: CropAspectRatio(ratioX: aspectRatio, ratioY: 1)) ??
        getPicture());
    decoratorUpdate();
  }

  @override
  void clearImage({bool callChild = true}) {
    if (child != null && callChild) {
      child!.clearImage();
      return;
    }
    setPicture(null);
    decoratorUpdate();
  }
}
