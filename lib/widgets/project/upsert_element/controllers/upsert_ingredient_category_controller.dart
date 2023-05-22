import 'package:get/get.dart';
import 'package:mekla/helpers/form_validators.dart';
import 'package:mekla/models/entities/ingredient_category.dart';
import 'package:mekla/repositories/ingredient_category_repository.dart';
import 'package:mekla/widgets/project/upsert_element/controllers/upsert_element_controller.dart';
import 'package:mekla/widgets/project/upsert_element/models/upsert_from_field.dart';

class UpsertIngredientCategoryController extends UpsertElementController {
  static UpsertIngredientCategoryController get find =>
      Get.find<UpsertIngredientCategoryController>();
  final int? id;
  IngredientCategory ingredientCategory = IngredientCategory();

  UpsertIngredientCategoryController({this.id}) {
    title = 'Ingredient Category'.tr;
    formFields = [
      TextUpsertFormField(
          name: 'name',
          label: 'Name'.tr,
          validator: FormValidators.notEmptyOrNullValidator),
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
      ingredientCategory =
          await IngredientCategoryRepository.find.findById(id) ??
              ingredientCategory;
      getTextFormFieldByName('name').controller.text = ingredientCategory.name;
      getPictureFormFieldByName('picture').picture =
          ingredientCategory.picture.value;
    }
  }

  @override
  Future<void> confirm(
      void Function([bool? result, bool forceClose]) close) async {
    if (formKey.currentState?.validate() ?? false) {
      ingredientCategory
        ..name = getTextFormFieldByName('name').controller.text.trim()
        ..picture.value = getPictureFormFieldByName('picture').picture;
      await IngredientCategoryRepository.find.save(ingredientCategory);
      close(true, true);
    }
  }
}
