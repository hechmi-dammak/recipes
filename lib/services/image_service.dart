import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img_lib;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mekla/models/entities/picture.dart';
import 'package:mekla/models/interfaces/model_image.dart';
import 'package:mekla/models/interfaces/model_images.dart';
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
    final img_lib.Image? image = img_lib.decodeImage(input);
    if (image == null) return [];
    final int width = image.width;
    final int height = image.height;
    final List<img_lib.Image> parts = [];
    parts.add(img_lib.copyCrop(image,
        x: 0,
        y: (height * 0.2).round(),
        width: width,
        height: (height * 0.4).round()));
    parts.add(img_lib.copyCrop(image,
        x: 0,
        y: (height * 0.6).round(),
        width: width,
        height: (height * 0.2).round()));
    final List<ImageProvider> output = [];
    for (var img in parts) {
      output.add(MemoryImage(img_lib.encodeJpg(img)));
    }
    return output;
  }

  Future<void> cacheImages<T extends ModelImage>(List<T> items) async {
    for (T item in items) {
      if (item.image != null) {
        await precacheImage(item.image!, Get.context!);
      }
    }
  }

  Future<void> cacheMultiImages<T extends ModelImages>(List<T> items) async {
    for (T item in items) {
      if (item.images != null) {
        for (ImageProvider image in item.images!) {
          await precacheImage(image, Get.context!);
        }
      }
    }
  }
}
