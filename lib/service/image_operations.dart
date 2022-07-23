import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recipes/components/snack_bar.dart';
import 'package:recipes/models/picture.dart';
import 'package:recipes/service/repository/picture_repository.dart';

class ImageOperations extends GetxService {
  static ImageOperations get find => Get.find<ImageOperations>();

  final ImagePicker _picker = ImagePicker();

  Future<Picture?> getImage(ImageSource source) async {
    await requestCameraOrStoragePermissions(source);
    final XFile? file =
        await _picker.pickImage(source: source, maxHeight: 480, maxWidth: 640);
    if (file == null) {
      CustomSnackBar.warning('You have to choose an image.');
      return null;
    }
    final CroppedFile? croppedImage = await _cropImage(file.path);
    if (croppedImage == null) {
      CustomSnackBar.warning('Failed to crop the image.');
      return null;
    }
    return await PictureRepository.find
        .create(Picture(image: await croppedImage.readAsBytes()));
  }

  Future<CroppedFile?> _cropImage(path) async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: path,
        aspectRatio: const CropAspectRatio(ratioX: 10, ratioY: 7),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop this image',
            toolbarColor: Get.theme.colorScheme.primary,
            toolbarWidgetColor: Get.theme.colorScheme.onPrimary,
          ),
          IOSUiSettings(
              title: 'Crop this image', showCancelConfirmationDialog: true)
        ]);
      return croppedFile;
  }

  Future<void> requestCameraOrStoragePermissions(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.status;
      if (!status.isGranted) {
        await Permission.camera.request();
      }
    } else {
      final status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    }
  }
}
