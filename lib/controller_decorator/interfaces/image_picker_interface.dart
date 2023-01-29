import 'package:image_picker/image_picker.dart';
import 'package:recipes/models/picture.dart';

abstract class ImagePickerInterface {
  Picture? getPicture({bool callChild = true});

  void setPicture(Picture? picture, {bool callChild = true});

  Future<void> pickImage(ImageSource? imageSource, {bool callChild = true});

  void clearImage({bool callChild = true});
}
