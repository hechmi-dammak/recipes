import 'package:get/get.dart';

class FormValidators {
  static String? notEmptyOrNullValidator(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) return 'Field cannot be empty'.tr;
    return null;
  }
}
