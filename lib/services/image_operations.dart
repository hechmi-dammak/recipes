import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as imglib;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mekla/models/entities/picture.dart';
import 'package:mekla/repositories/picture_repository.dart';
import 'package:mekla/widgets/common/snack_bar.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageService extends GetxService {
  static ImageService get find => Get.find<ImageService>();

  final ImagePicker _picker = ImagePicker();

  Future<Picture?> getImage(ImageSource source,
      {CropAspectRatio crop =
          const CropAspectRatio(ratioX: 2, ratioY: 1)}) async {
    await requestCameraOrStoragePermissions(source);
    final XFile? file = await _picker.pickImage(
        source: source,
        maxHeight: 480,
        maxWidth: 640,
        requestFullMetadata: false);
    if (file == null) {
      CustomSnackBar.warning('You have to choose an image.'.tr);
      return null;
    }
    final CroppedFile? croppedImage = await _cropImage(file.path, crop);
    if (croppedImage != null) {
      return await PictureRepository.find
          .save(Picture(image: await croppedImage.readAsBytes()));
    }
    return null;
  }

  Future<CroppedFile?> _cropImage(String path, CropAspectRatio crop) async {
    final CroppedFile? croppedFile = await ImageCropper()
        .cropImage(sourcePath: path, aspectRatio: crop, uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop this image'.tr,
        toolbarColor: Get.theme.colorScheme.primary,
        toolbarWidgetColor: Get.theme.colorScheme.onPrimary,
      ),
      IOSUiSettings(
          title: 'Crop this image'.tr, showCancelConfirmationDialog: true)
    ]);

    if (croppedFile != null) {
      return croppedFile;
    } else {
      CustomSnackBar.warning('You have to crop the image.'.tr);
    }
    return null;
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

  List<ImageProvider> splitImage(Uint8List input) {
    final imglib.Image? image = imglib.decodeImage(input);
    if (image == null) return [];
    final int width = image.width;
    final int height = image.height;
    final List<imglib.Image> parts = [];
    parts.add(imglib.copyCrop(image,
        x: 0, y: 0, width: width, height: (height * 0.8).round()));
    parts.add(imglib.copyCrop(image,
        x: 0,
        y: (height * 0.8).round(),
        width: width,
        height: (height * 0.2).round()));
    final List<ImageProvider> output = [];
    for (var img in parts) {
      output.add(MemoryImage(imglib.encodeJpg(img)));
    }
    return output;
  }
}
