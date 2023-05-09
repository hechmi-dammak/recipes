import 'package:get/get.dart';
import 'package:recipes/widgets/project/upsert_element/models/servings_upsert_form_field.dart';

class ServingsUpsertFormFieldController extends GetxController {
  static ServingsUpsertFormFieldController get find =>
      Get.find<ServingsUpsertFormFieldController>();

  ServingsUpsertFormFieldController({required this.formField});

  final ServingsUpsertFormField formField;

  int get servings => formField.servings;

  void incrementServings() {
    formField.servings++;
    update();
  }

  void decrementServings() {
    formField.servings--;
    update();
  }
}
