import 'package:flutter/material.dart';
import 'package:mekla/widgets/project/upsert_element/models/upsert_from_field.dart';

class TextUpsertFormField extends UpsertFormField {
  int? maxLines;
  String? Function(String? value)? validator;
  TextEditingController controller = TextEditingController();

  TextUpsertFormField(
      {required super.name,
      this.validator,
      super.optional,
      required super.label,
      this.maxLines = 1});

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
