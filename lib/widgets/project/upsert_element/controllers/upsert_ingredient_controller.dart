import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/helpers/form_validators.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/recipe_ingredient.dart';
import 'package:recipes/repository/ingredient_repository.dart';
import 'package:recipes/repository/recipe_ingredient_repository.dart';
import 'package:recipes/repository/recipe_repository.dart';
import 'package:recipes/widgets/project/upsert_element/controllers/upsert_element_controller.dart';
import 'package:recipes/widgets/project/upsert_element/models/autocomplete_upsert_from_field.dart';
import 'package:recipes/widgets/project/upsert_element/models/upsert_from_field.dart';

class UpsertIngredientController extends UpsertElementController {
  static UpsertIngredientController get find =>
      Get.find<UpsertIngredientController>();

  final int? id;
  final int recipeId;
  final int servings;
  RecipeIngredient recipeIngredient = RecipeIngredient();
  List<Ingredient> ingredients = [];

  UpsertIngredientController(
      {int order = 0,
      required this.recipeId,
      required this.servings,
      this.id}) {
    title = 'Ingredient'.tr;
    formFields = [
      AutocompleteUpsertFormField<Ingredient>(
          name: 'name',
          label: 'Name'.tr,
          displayLabel: (Ingredient ingredient) {
            return ingredient.name;
          },
          filter: (TextEditingValue textEditingValue) {
            final field =
                getAutocompleteUpsertFormFieldByName<Ingredient>('name');
            if (field.selectedValue != null &&
                field.selectedValue!.name != textEditingValue.text) {
              field.selectedValue = null;
              update();
            }
            if (textEditingValue.text.isEmpty) return [];

            return ingredients.where((ingredient) => ingredient.name
                .toLowerCase()
                .startsWith(textEditingValue.text.toLowerCase()));
          },
          onSelect: (Ingredient ingredient) {
            getAutocompleteUpsertFormFieldByName<Ingredient>('name')
                .selectedValue = ingredient;
            getPictureFormFieldByName('picture').picture =
                ingredient.picture.value;
            update();
          },
          validator: FormValidators.notEmptyOrNullValidator),
      TextUpsertFormField(name: 'amount', label: 'Amount'.tr, optional: true),
      TextUpsertFormField(
          name: 'description',
          label: 'Description'.tr,
          maxLines: null,
          optional: true),
      PictureUpsertFormField(name: 'picture', aspectRatio: 1, optional: true)
    ];
    initState(null);
  }

  @override
  Future<void> loadData() async {
    await Future.wait(
        [super.loadData(), fetchIngredientAndFillData(), fetchIngredients()]);
  }

  Future<void> fetchIngredientAndFillData() async {
    recipeIngredient.recipe.value =
        await RecipeRepository.find.findById(recipeId);
    if (id == null) return;
    recipeIngredient =
        await RecipeIngredientRepository.find.findById(id) ?? recipeIngredient;
    getAutocompleteUpsertFormFieldByName<Ingredient>('name').selectedValue =
        recipeIngredient.ingredient.value;
    getAutocompleteUpsertFormFieldByName<Ingredient>('name').controller.text =
        recipeIngredient.ingredient.value?.name ?? '';
    getTextFormFieldByName('description').controller.text =
        recipeIngredient.description ?? '';
    getTextFormFieldByName('amount').controller.text =
        recipeIngredient.getAmount(servings) ?? '';
    getPictureFormFieldByName('picture').picture =
        recipeIngredient.ingredient.value?.picture.value;
  }

  Future<void> fetchIngredients() async {
    ingredients = await IngredientRepository.find.findAll();
  }

  @override
  Future<void> confirm(
      void Function([bool? result, bool forceClose]) close) async {
    if (formKey.currentState?.validate() ?? false) {
      final description =
          getTextFormFieldByName('description').controller.text.trim();
      final name = getAutocompleteUpsertFormFieldByName<Ingredient>('name');
      if (name.selectedValue == null) {
        recipeIngredient.ingredient.value ??= Ingredient();
        recipeIngredient.ingredient.value!.name = name.controller.text.trim();
      } else {
        recipeIngredient.ingredient.value = name.selectedValue;
      }
      recipeIngredient
        ..ingredient.value!.name = name.controller.text.trim()
        ..description = description.isEmpty ? null : description
        ..setAmount(
            getTextFormFieldByName('amount').controller.text.trim(), servings)
        ..ingredient.value!.picture.value =
            getPictureFormFieldByName('picture').picture;
      await RecipeIngredientRepository.find.save(recipeIngredient);
      close(true, true);
    }
  }
}
