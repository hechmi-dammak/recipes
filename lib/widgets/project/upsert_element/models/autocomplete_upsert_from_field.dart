import 'package:flutter/material.dart';
import 'package:mekla/widgets/project/upsert_element/models/upsert_from_field.dart';

class AutocompleteUpsertFormField<T extends Object> extends UpsertFormField {
  int? maxLines;
  String? Function(String? value)? validator;
  TextEditingController controller = TextEditingController();
  T? selectedValue;

  Type get genericType => T;
  String Function(T) displayLabel;
  Iterable<T> Function(TextEditingValue) filter;
  void Function(T) onSelect;

  AutocompleteUpsertFormField(
      {required super.name,
      this.validator,
      super.optional,
      required super.label,
      required this.displayLabel,
      required this.filter,
      required this.onSelect,
      this.maxLines = 1});

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
