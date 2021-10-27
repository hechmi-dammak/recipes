import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recipes/models/picture.dart';
import 'package:recipes/service/picture_operations.dart';
import 'package:recipes/utils/components/show_snack_bar.dart';

class ImageOperations {
  static final ImageOperations instance = ImageOperations._init();
  final PictureOperations pictureOperations = PictureOperations.instance;
  ImageOperations._init();
  final ImagePicker _picker = ImagePicker();

  Future<Picture?> getImage(ImageSource source) async {
    await requestCameraOrStoragePermssions(source);
    XFile? file =
        await _picker.pickImage(source: source, maxHeight: 480, maxWidth: 640);
    if (file == null) {
      showInSnackBar("You have to choose an image.");
      return null;
    }
    File? croppedImage = await _cropImage(file.path);
    if (croppedImage != null) {
      return await pictureOperations
          .create(Picture(image: croppedImage.readAsBytesSync()));
    }
    return null;
  }

  Future<File?> _cropImage(path) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop this image',
          toolbarColor: Theme.of(Get.context!).colorScheme.primary,
          toolbarWidgetColor: Theme.of(Get.context!).colorScheme.onPrimary,
        ),
        iosUiSettings: const IOSUiSettings(
            title: 'Crop this image', showCancelConfirmationDialog: true));
    if (croppedFile != null) {
      return croppedFile;
    } else {
      showInSnackBar("You have to crop the image.");
    }
    return null;
  }

  requestCameraOrStoragePermssions(ImageSource source) async {
    if (source == ImageSource.camera) {
      var status = await Permission.camera.status;
      if (!status.isGranted) {
        await Permission.camera.request();
      }
    } else {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    }
  }
}
