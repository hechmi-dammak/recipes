import 'package:get/get.dart';
import 'package:recipes/helpers/form_validators.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/repository/recipe_category_repository.dart';
import 'package:recipes/repository/recipe_repository.dart';
import 'package:recipes/widgets/project/upsert_element/controllers/upsert_element_controller.dart';
import 'package:recipes/widgets/project/upsert_element/models/servings_upsert_form_field.dart';
import 'package:recipes/widgets/project/upsert_element/models/upsert_from_field.dart';

class UpsertRecipeController extends UpsertElementController {
  static UpsertRecipeController get find => Get.find<UpsertRecipeController>();

  final int? id;
  final int? categoryId;

  UpsertRecipeController({this.categoryId, this.id}) {
    title = 'Recipe'.tr;
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
      ServingsUpsertFormField(
          name: 'servings', label: 'Servings'.tr, servings: 4),
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
      getTextFormFieldByName('name').controller.text = recipe.name;
      getTextFormFieldByName('description').controller.text =
          recipe.description ?? '';
      getPictureFormFieldByName('picture').picture = recipe.picture.value;
      getServingsUpsertFormFieldByName('servings').servings = recipe.servings;
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
          getTextFormFieldByName('description').controller.text.trim();
      recipe
        ..name = getTextFormFieldByName('name').controller.text.trim()
        ..description = description.isEmpty ? null : description
        ..picture.value = getPictureFormFieldByName('picture').picture
        ..servings = getServingsUpsertFormFieldByName('servings').servings;
      await RecipeRepository.find.save(recipe);
      close(true, true);
    }
  }
}
