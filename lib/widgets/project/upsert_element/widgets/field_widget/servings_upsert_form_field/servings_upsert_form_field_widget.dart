import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/widgets/common/getx/get_builder_view.dart';
import 'package:mekla/widgets/project/servings_editing_button.dart';
import 'package:mekla/widgets/project/upsert_element/models/servings_upsert_form_field.dart';
import 'package:mekla/widgets/project/upsert_element/widgets/field_title.dart';
import 'package:mekla/widgets/project/upsert_element/widgets/field_widget/servings_upsert_form_field/servings_upsert_form_field_controller.dart';

class ServingsUpsertFormFieldWidget extends StatelessWidget
    with GetBuilderView<ServingsUpsertFormFieldController> {
  const ServingsUpsertFormFieldWidget({super.key, required this.formField});

  final ServingsUpsertFormField formField;

  @override
  String? get tag => formField.name;

  @override
  ServingsUpsertFormFieldController get init =>
      ServingsUpsertFormFieldController(formField: formField);

  @override
  Widget getBuilder(BuildContext context, controller) {
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
  }
}
