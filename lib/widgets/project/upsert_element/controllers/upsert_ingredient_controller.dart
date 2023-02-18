import 'package:get/get.dart';
import 'package:recipes/helpers/form_validators.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/recipe_ingredient.dart';
import 'package:recipes/service/repository/recipe_ingredient_repository.dart';
import 'package:recipes/service/repository/recipe_repository.dart';
import 'package:recipes/widgets/project/upsert_element/controllers/upsert_element_controller.dart';
import 'package:recipes/widgets/project/upsert_element/models/upsert_from_field.dart';

class UpsertIngredientController extends UpsertElementController {
  static UpsertIngredientController get find =>
      Get.find<UpsertIngredientController>();

  final int? id;
  final int recipeId;
  RecipeIngredient recipeIngredient = RecipeIngredient();

  UpsertIngredientController({int order = 0, required this.recipeId, this.id}) {
    formFields = [
      TextUpsertFormField(
          name: 'name',
          label: 'Name :'.tr,
          validator: FormValidators.notEmptyOrNullValidator),
      TextUpsertFormField(name: 'amount', label: 'Amount :'.tr),
      TextUpsertFormField(
          name: 'description', label: 'Description :'.tr, maxLines: null),
      PictureUpsertFormField(name: 'picture', aspectRatio: 1)
    ];
    initState(null);
  }

  @override
  Future<void> loadData({bool callChild = true}) async {
    await Future.wait([super.loadData(), fetchStep()]);
  }

  Future<void> fetchStep() async {
    if (id != null) {
      recipeIngredient = await RecipeIngredientRepository.find.findById(id) ??
          recipeIngredient;
      getTextFormFieldByName('name')?.controller.text =
          recipeIngredient.ingredient.value?.name ?? '';
      getTextFormFieldByName('description')?.controller.text =
          recipeIngredient.description ?? '';
      getTextFormFieldByName('amount')?.controller.text =
          recipeIngredient.amount ?? '';
      getPictureFormFieldByName('picture')?.picture =
          recipeIngredient.ingredient.value?.picture.value;
      return;
    }
    recipeIngredient.recipe.value =
        await RecipeRepository.find.findById(recipeId);
  }

  @override
  Future<void> confirm(
      void Function([bool? result, bool forceClose]) close) async {
    if (formKey.currentState?.validate() ?? false) {
      final description =
          getTextFormFieldByName('description')?.controller.text.trim() ?? '';
      recipeIngredient.ingredient.value ??= Ingredient();
      recipeIngredient
        ..ingredient.value!.name =
            getTextFormFieldByName('name')?.controller.text.trim() ?? ''
        ..description = description.isEmpty ? null : description
        ..amount =
            getTextFormFieldByName('amount')?.controller.text.trim() ?? ''
        ..ingredient.value!.picture.value =
            getPictureFormFieldByName('picture')?.picture;
      await RecipeIngredientRepository.find.save(recipeIngredient);
      close(true, true);
    }
  }
}
