import 'package:get/get.dart';
import 'package:mekla/helpers/form_validators.dart';
import 'package:mekla/widgets/project/upsert_element/controllers/upsert_element_controller.dart';
import 'package:mekla/widgets/project/upsert_element/models/text_upsert_from_field.dart';

class CreateFileNameController extends UpsertElementController {
  static CreateFileNameController get find =>
      Get.find<CreateFileNameController>();
  final Future<void> Function(String fileName)? onConfirm;

  CreateFileNameController({this.onConfirm}) {
    title = 'Pick a file name'.tr;
    formFields = [
      TextUpsertFormField(
          name: 'fileName',
          label: 'File name'.tr,
          maxLines: null,
          validator: FormValidators.notEmptyOrNullValidator)
    ];
    initState(null);
  }

  @override
  Future<void> confirm(
      void Function([bool? result, bool forceClose]) close) async {
    if (formKey.currentState?.validate() ?? false) {
      final fileName =
          getTextFormFieldByName('fileName').controller.text.trim();
      onConfirm?.call(fileName);
      close(true, true);
    }
  }
}
