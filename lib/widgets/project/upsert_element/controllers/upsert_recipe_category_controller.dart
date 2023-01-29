import 'package:get/get.dart';
import 'package:recipes/controller_decorator/base_controller/base_contoller.dart';
import 'package:recipes/controller_decorator/controller.dart';
import 'package:recipes/controller_decorator/decorators/image_picker_decorator.dart';
import 'package:recipes/models/recipe_category.dart';
import 'package:recipes/service/repository/recipe_category_repository.dart';
import 'package:recipes/widgets/project/upsert_element/controllers/upsert_element_controller.dart';

class UpsertRecipeCategoryController extends UpsertElementController {
  static UpsertRecipeCategoryController get find =>
      Get.find<UpsertRecipeCategoryController>();
  final int? id;

  UpsertRecipeCategoryController(
      {this.id, required super.controller, super.child});

  RecipeCategory recipeCategory = RecipeCategory();

  factory UpsertRecipeCategoryController.create(
      {int? id, Controller? controller}) {
    final recipesCategoriesController = UpsertRecipeCategoryController(
        controller: ImagePickerDecorator.create(
          controller: BaseController(),
        ),
        id: id);
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
      setPicture(recipeCategory.picture.value);
    }
  }

  @override
  Future<void> confirm(
      void Function([bool? result, bool forceClose]) close) async {
    if (formKey.currentState?.validate() ?? false) {
      final description = descriptionController.text.trim();
      recipeCategory
        ..name = nameController.text.trim()
        ..description = description.isEmpty ? null : description
        ..picture.value = getPicture();
      await RecipeCategoryRepository.find.save(recipeCategory);
      close(true, true);
    }
  }
}
