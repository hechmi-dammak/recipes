import 'package:flutter/material.dart';

export 'package:mekla/widgets/project/upsert_element/models/picture_upsert_from_field.dart';
export 'package:mekla/widgets/project/upsert_element/models/text_upsert_from_field.dart';

abstract class UpsertFormField {
  String name;
  bool optional;
  String label;

  UpsertFormField(
      {required this.name, this.optional = false, required this.label});

  @mustCallSuper
  void dispose() {}
}
