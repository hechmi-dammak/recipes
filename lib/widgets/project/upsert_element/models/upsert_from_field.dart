import 'package:flutter/material.dart';

export 'package:recipes/widgets/project/upsert_element/models/picture_upsert_from_field.dart';
export 'package:recipes/widgets/project/upsert_element/models/text_upsert_from_field.dart';

abstract class UpsertFormField {
  String name;

  UpsertFormField({required this.name});

  @mustCallSuper
  void dispose() {}
}
