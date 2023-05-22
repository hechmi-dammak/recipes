import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/helpers/input_decoration.dart';
import 'package:mekla/widgets/project/upsert_element/models/upsert_from_field.dart';
import 'package:mekla/widgets/project/upsert_element/widgets/field_title.dart';

class TextUpsertFormFieldWidget extends StatelessWidget {
  const TextUpsertFormFieldWidget({Key? key, required this.formField})
      : super(key: key);
  final TextUpsertFormField formField;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldTitle(
          title: formField.label.tr,
          optional: formField.optional,
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: formField.controller,
          style: Get.textTheme.bodyLarge?.copyWith(fontFeatures: [
            const FontFeature.tabularFigures(),
            const FontFeature.liningFigures()
          ]),
          decoration: CustomInputDecoration(),
          maxLines: formField.maxLines,
          validator: formField.validator,
        ),
      ],
    );
  }
}
