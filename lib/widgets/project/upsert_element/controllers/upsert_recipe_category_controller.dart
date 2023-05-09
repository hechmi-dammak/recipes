import 'package:get/get.dart';
import 'package:recipes/helpers/form_validators.dart';
import 'package:recipes/models/recipe_category.dart';
import 'package:recipes/repository/recipe_category_repository.dart';
import 'package:recipes/widgets/project/upsert_element/controllers/upsert_element_controller.dart';
import 'package:recipes/widgets/project/upsert_element/models/upsert_from_field.dart';

class UpsertRecipeCategoryController extends UpsertElementController {
  static UpsertRecipeCategoryController get find =>
      Get.find<UpsertRecipeCategoryController>();
  final int? id;
  RecipeCategory recipeCategory = RecipeCategory();

  UpsertRecipeCategoryController({this.id}) {
    title = 'Recipe Category'.tr;
    formFields = [
      TextUpsertFormField(
          name: 'name',
          label: 'Name'.tr,
          validator: FormValidators.notEmptyOrNullValidator),
      TextUpsertFormField(
          name: 'description',
          label: 'Description'.tr,
          maxLines: null,
          optional: true),
      PictureUpsertFormField(name: 'picture', optional: true)
    ];
    initState(null);
  }

  @override
  Future<void> loadData() async {
    await Future.wait([super.loadData(), fetchRecipeCategories()]);
  }

  Future<void> fetchRecipeCategories() async {
    if (id != null) {
      recipeCategory =
          await RecipeCategoryRepository.find.findById(id) ?? recipeCategory;
      getTextFormFieldByName('name').controller.text = recipeCategory.name;
      getTextFormFieldByName('description').controller.text =
          recipeCategory.description ?? '';
      getPictureFormFieldByName('picture').picture =
          recipeCategory.picture.value;
    }
  }

  @override
  Future<void> confirm(
      void Function([bool? result, bool forceClose]) close) async {
    if (formKey.currentState?.validate() ?? false) {
      final description =
          getTextFormFieldByName('description').controller.text.trim();
      recipeCategory
        ..name = getTextFormFieldByName('name').controller.text.trim()
        ..description = description.isEmpty ? null : description
        ..picture.value = getPictureFormFieldByName('picture').picture;
      await RecipeCategoryRepository.find.save(recipeCategory);
      close(true, true);
    }
  }
}
