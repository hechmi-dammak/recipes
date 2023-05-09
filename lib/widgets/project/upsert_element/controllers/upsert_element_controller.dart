import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/decorator/decorators.dart';
import 'package:recipes/widgets/project/upsert_element/models/autocomplete_upsert_from_field.dart';
import 'package:recipes/widgets/project/upsert_element/models/upsert_from_field.dart';

abstract class UpsertElementController extends BaseController
    with DataFetchingDecorator, LoadingDecorator {
  static UpsertElementController get find =>
      Get.find<UpsertElementController>();

  List<UpsertFormField> formFields = [];
  String? title = '';

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  UpsertFormField _getFormFieldByName(String name) {
    return formFields.firstWhere((formField) => formField.name == name);
  }

  AutocompleteUpsertFormField<T>
      getAutocompleteUpsertFormFieldByName<T extends Object>(String name) {
    final UpsertFormField formField = _getFormFieldByName(name);
    return formField as AutocompleteUpsertFormField<T>;
  }

  TextUpsertFormField getTextFormFieldByName(String name) {
    final UpsertFormField formField = _getFormFieldByName(name);
    return formField as TextUpsertFormField;
  }

  PictureUpsertFormField getPictureFormFieldByName(String name) {
    final formField = _getFormFieldByName(name);
    return formField as PictureUpsertFormField;
  }

  @override
  void dispose() {
    for (var formField in formFields) {
      formField.dispose();
    }
    super.dispose();
  }

  Future<void> confirm(void Function([bool? result, bool forceClose]) close);

  @mustCallSuper
  Future<void> cancel(
      void Function([bool? result, bool forceClose]) close) async {
    close(false, true);
  }
}
