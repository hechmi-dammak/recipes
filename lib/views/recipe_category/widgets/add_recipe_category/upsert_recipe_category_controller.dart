import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes/controller_decorator/controller.dart';
import 'package:recipes/controller_decorator/controller_decorator.dart';
import 'package:recipes/models/picture.dart';
import 'package:recipes/models/recipe_category.dart';
import 'package:recipes/service/image_operations.dart';
import 'package:recipes/service/repository/recipe_category_repository.dart';

class UpsertRecipeCategoryController extends ControllerDecorator {
  static UpsertRecipeCategoryController get find =>
      Get.find<UpsertRecipeCategoryController>();
  late TextEditingController nameController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();
  Picture? picture;
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final int? id;

  UpsertRecipeCategoryController(
      {this.id, required super.controller, super.child});

  RecipeCategory recipeCategory = RecipeCategory();

  factory UpsertRecipeCategoryController.create(
      {int? id, required Controller controller}) {
    final recipesCategoriesController =
        UpsertRecipeCategoryController(controller: controller, id: id);
    recipesCategoriesController.controller.child = recipesCategoriesController;
    recipesCategoriesController.initState(null);
    return recipesCategoriesController;
  }

  @override
  Future<void> loadData({bool callChild = true}) async {
    if (child != null && callChild) {
      await child!.loadData();
      return;
    }
    await Future.wait(
        [super.loadData(callChild: false), fetchRecipeCategories()]);
  }

  Future<void> fetchRecipeCategories() async {
    if (id != null) {
      recipeCategory =
          await RecipeCategoryRepository.find.findById(id) ?? recipeCategory;
      nameController.text = recipeCategory.name;
      descriptionController.text = recipeCategory.description ?? '';
      picture = recipeCategory.picture.value;
    }
  }

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
      recipeCategory
        ..name = nameController.text.trim()
        ..description = description.isEmpty ? null : description
        ..picture.value = picture;
      await RecipeCategoryRepository.find.save(recipeCategory);
      close(true, true);
    }
  }

  Future<void> pickImage(ImageSource imageSource) async {
    picture = await ImageOperations.find.getImage(imageSource) ?? picture;
    decoratorUpdate();
  }

  void clearImage() {
    picture = null;
    decoratorUpdate();
  }
}
