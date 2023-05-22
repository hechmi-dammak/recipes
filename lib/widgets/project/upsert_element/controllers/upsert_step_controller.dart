import 'package:get/get.dart';
import 'package:mekla/helpers/form_validators.dart';
import 'package:mekla/models/entities/step.dart';
import 'package:mekla/repositories/recipe_repository.dart';
import 'package:mekla/repositories/step_repository.dart';
import 'package:mekla/widgets/project/upsert_element/controllers/upsert_element_controller.dart';
import 'package:mekla/widgets/project/upsert_element/models/upsert_from_field.dart';

class UpsertStepController extends UpsertElementController {
  static UpsertStepController get find => Get.find<UpsertStepController>();

  final int? id;
  final int recipeId;
  Step step = Step();

  UpsertStepController({required this.recipeId, this.id}) {
    title = 'Step'.tr;
    formFields = [
      TextUpsertFormField(
          name: 'instruction',
          label: 'Instruction'.tr,
          maxLines: null,
          validator: FormValidators.notEmptyOrNullValidator),
      PictureUpsertFormField(name: 'picture', optional: true)
    ];
    initState(null);
  }

  @override
  Future<void> loadData() async {
    await Future.wait([super.loadData(), fetchStep()]);
  }

  Future<void> fetchStep() async {
    if (id != null) {
      step = await StepRepository.find.findById(id) ?? step;
      getTextFormFieldByName('instruction').controller.text = step.instruction;
      getPictureFormFieldByName('picture').picture = step.picture.value;
      return;
    }
    step.recipe.value = await RecipeRepository.find.findById(recipeId);
  }

  @override
  Future<void> confirm(
      void Function([bool? result, bool forceClose]) close) async {
    if (formKey.currentState?.validate() ?? false) {
      step
        ..instruction =
            getTextFormFieldByName('instruction').controller.text.trim()
        ..picture.value = getPictureFormFieldByName('picture').picture;
      await StepRepository.find.save(step);
      close(true, true);
    }
  }
}
