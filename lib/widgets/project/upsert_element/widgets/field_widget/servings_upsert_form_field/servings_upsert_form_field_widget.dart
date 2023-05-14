import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/widgets/project/servings_editing_button.dart';
import 'package:mekla/widgets/project/upsert_element/models/servings_upsert_form_field.dart';
import 'package:mekla/widgets/project/upsert_element/widgets/field_title.dart';
import 'package:mekla/widgets/project/upsert_element/widgets/field_widget/servings_upsert_form_field/servings_upsert_form_field_controller.dart';

class ServingsUpsertFormFieldWidget extends StatelessWidget {
  const ServingsUpsertFormFieldWidget({Key? key, required this.formField})
      : super(key: key);
  final ServingsUpsertFormField formField;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServingsUpsertFormFieldController>(
        init: ServingsUpsertFormFieldController(formField: formField),
        tag: formField.name,
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FieldTitle(
                title: formField.label.tr,
                optional: formField.optional,
              ),
              const SizedBox(height: 7),
              Center(
                child: ServingsEditingButton(
                  value: controller.servings,
                  onIncrement: controller.incrementServings,
                  onDecrement: controller.decrementServings,
                ),
              )
            ],
          );
        });
  }
}
