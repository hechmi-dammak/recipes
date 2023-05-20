import 'package:get/get.dart';
import 'package:mekla/helpers/form_validators.dart';
import 'package:mekla/models/entities/ingredient.dart';
import 'package:mekla/repositories/ingredient_repository.dart';
import 'package:mekla/widgets/project/upsert_element/controllers/upsert_element_controller.dart';
import 'package:mekla/widgets/project/upsert_element/models/upsert_from_field.dart';

class UpsertIngredientController extends UpsertElementController {
  static UpsertIngredientController get find =>
      Get.find<UpsertIngredientController>();

  final int? id;
  Ingredient ingredient = Ingredient();

  UpsertIngredientController({this.id}) {
    title = 'Ingredient'.tr;
    formFields = [
      TextUpsertFormField(
          name: 'name',
          label: 'Name'.tr,
          validator: FormValidators.notEmptyOrNullValidator),
      PictureUpsertFormField(name: 'picture', aspectRatio: 1, optional: true)
    ];
    initState(null);
  }

  @override
  Future<void> loadData() async {
    await Future.wait([super.loadData(), fetchIngredientAndFillData()]);
  }

  Future<void> fetchIngredientAndFillData() async {
    if (id == null) return;
    ingredient = await IngredientRepository.find.findById(id) ?? ingredient;
    getTextFormFieldByName('name').controller.text = ingredient.name;
    getPictureFormFieldByName('picture').picture = ingredient.picture.value;
  }

  @override
  Future<void> confirm(
      void Function([bool? result, bool forceClose]) close) async {
    if (formKey.currentState?.validate() ?? false) {
      ingredient
        ..name = getTextFormFieldByName('name').controller.text.trim()
        ..picture.value = getPictureFormFieldByName('picture').picture;
      await IngredientRepository.find.save(ingredient);
      close(true, true);
    }
  }
}
