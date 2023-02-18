import 'package:flutter/material.dart';
import 'package:recipes/widgets/project/upsert_element/models/upsert_from_field.dart';

class TextUpsertFormField extends UpsertFormField {
  String label;
  int? maxLines;
  String? Function(String? value)? validator;
  TextEditingController controller = TextEditingController();

  TextUpsertFormField(
      {required super.name,
      this.validator,
      required this.label,
      this.maxLines = 1});

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
