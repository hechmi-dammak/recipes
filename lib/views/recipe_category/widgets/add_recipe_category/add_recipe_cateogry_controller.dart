import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes/models/picture.dart';
import 'package:recipes/service/image_operations.dart';

class AddRecipeCategoryController extends GetxController {
  static AddRecipeCategoryController get find =>
      Get.find<AddRecipeCategoryController>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  Picture? picture;

  @override
  void onInit() {
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void confirm(void Function([bool? result, bool forceClose]) close) {}

  Future<void> pickImage(ImageSource imageSource) async {
    picture = await ImageOperations.find.getImage(imageSource) ?? picture;
    update();
  }
}
