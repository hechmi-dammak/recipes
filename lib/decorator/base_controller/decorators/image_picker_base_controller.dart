import 'package:image_picker/image_picker.dart';
import 'package:recipes/decorator/base_controller/decorators/selection_base_controller.dart';
import 'package:recipes/models/picture.dart';

abstract class ImagePickerBaseController extends SelectionBaseController {
  @override
  void clearImage({bool callChild = true}) {}

  @override
  Picture? getPicture({bool callChild = true}) {
    throw UnimplementedError();
  }

  @override
  Future<void> pickImage(ImageSource? imageSource,
      {bool callChild = true, double aspectRatio = 2}) {
    throw UnimplementedError();
  }

  @override
  void setPicture(Picture? picture, {bool callChild = true}) {}
}
