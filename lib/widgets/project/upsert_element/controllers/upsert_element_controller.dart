import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/decorator/controller_decorator.dart';
import 'package:recipes/widgets/project/upsert_element/models/upsert_from_field.dart';

abstract class UpsertElementController extends ControllerDecorator {
  static UpsertElementController get find =>
      Get.find<UpsertElementController>();

  UpsertElementController(
      {super.controller, super.child, required this.formFields});

  List<UpsertFormField> formFields;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  UpsertFormField? getFormFieldByName(String name) {
    return formFields.firstWhereOrNull((formField) => formField.name == name);
  }

  TextUpsertFormField? getTextFormFieldByName(String name) {
    final formField = getFormFieldByName(name);
    if (formFields is TextUpsertFormField) {
      return formField as TextUpsertFormField;
    }
    return null;
  }

  PictureUpsertFormField? getPictureFormFieldByName(String name) {
    final formField = getFormFieldByName(name);
    if (formFields is PictureUpsertFormField) {
      return formField as PictureUpsertFormField;
    }
    return null;
  }

  @override
  void dispose() {
    for (var formField in formFields) {
      formField.dispose();
    }
    super.dispose();
  }

  Future<void> confirm(void Function([bool? result, bool forceClose]) close);
}
