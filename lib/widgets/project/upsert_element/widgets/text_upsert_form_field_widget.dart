import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/helpers/input_decoration.dart';
import 'package:recipes/widgets/project/upsert_element/models/upsert_from_field.dart';

class TextUpsertFormFieldWidget extends StatelessWidget {
  const TextUpsertFormFieldWidget({Key? key, required this.formField})
      : super(key: key);
  final TextUpsertFormField formField;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formField.label,
          style: Get.textTheme.bodyLarge,
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: formField.controller,
          style: Get.textTheme.bodyLarge,
          decoration: CustomInputDecoration(),
          maxLines: formField.maxLines,
          validator: formField.validator,
        ),
      ],
    );
  }
}
