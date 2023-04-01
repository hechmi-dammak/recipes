import 'package:get/get.dart';
import 'package:recipes/helpers/form_validators.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/service/repository/recipe_category_repository.dart';
import 'package:recipes/service/repository/recipe_repository.dart';
import 'package:recipes/widgets/project/upsert_element/controllers/upsert_element_controller.dart';
import 'package:recipes/widgets/project/upsert_element/models/upsert_from_field.dart';

class UpsertRecipeController extends UpsertElementController {
  static UpsertRecipeController get find => Get.find<UpsertRecipeController>();

  final int? id;
  final int? categoryId;

  UpsertRecipeController({this.categoryId, this.id}) {
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
      PictureUpsertFormField(name: 'picture', aspectRatio: 1, optional: true)
    ];
    initState(null);
  }

  Recipe recipe = Recipe();

  @override
  Future<void> loadData() async {
    await Future.wait([super.loadData(), fetchRecipe()]);
  }

  Future<void> fetchRecipe() async {
    if (id != null) {
      recipe = await RecipeRepository.find.findById(id) ?? recipe;
      getTextFormFieldByName('name')?.controller.text = recipe.name;
      getTextFormFieldByName('description')?.controller.text =
          recipe.description ?? '';
      getPictureFormFieldByName('picture')?.picture = recipe.picture.value;
      return;
    }
    recipe.category.value =
        await RecipeCategoryRepository.find.findById(categoryId);
  }

  @override
  Future<void> confirm(
      void Function([bool? result, bool forceClose]) close) async {
    if (formKey.currentState?.validate() ?? false) {
      final description =
          getTextFormFieldByName('description')?.controller.text.trim() ?? '';
      recipe
        ..name = getTextFormFieldByName('name')?.controller.text.trim() ?? ''
        ..description = description.isEmpty ? null : description
        ..picture.value = getPictureFormFieldByName('picture')?.picture;
      await RecipeRepository.find.save(recipe);
      close(true, true);
    }
  }
}
