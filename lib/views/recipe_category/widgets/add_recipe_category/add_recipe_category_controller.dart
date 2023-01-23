import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes/models/picture.dart';
import 'package:recipes/models/recipe_category.dart';
import 'package:recipes/service/image_operations.dart';
import 'package:recipes/service/repository/recipe_category_repository.dart';

class AddRecipeCategoryController extends GetxController {
  static AddRecipeCategoryController get find =>
      Get.find<AddRecipeCategoryController>();
  late TextEditingController nameController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();
  Picture? picture;
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> confirm(
      void Function([bool? result, bool forceClose]) close) async {
    if (formKey.currentState?.validate() ?? false) {
      final description = descriptionController.text.trim();
      await RecipeCategoryRepository.find.save(RecipeCategory(
          name: nameController.text.trim(),
          description: description.isEmpty ? null : description)
          ..picture.value = picture);
      close(true, true);
    }
  }

  Future<void> pickImage(ImageSource imageSource) async {
    picture = await ImageOperations.find.getImage(imageSource) ?? picture;
    update();
  }

  void clearImage() {
    picture = null;
    update();
  }
}
