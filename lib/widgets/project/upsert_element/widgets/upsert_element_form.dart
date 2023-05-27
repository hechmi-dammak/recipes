import 'package:flutter/material.dart';
import 'package:mekla/widgets/common/getx/get_builder_view.dart';
import 'package:mekla/widgets/project/upsert_element/controllers/upsert_element_controller.dart';
import 'package:mekla/widgets/project/upsert_element/widgets/field_widget/upsert_form_field_widget.dart';

class UpsertElementForm<T extends UpsertElementController>
    extends StatelessWidget with GetBuilderView<T> {
  const UpsertElementForm({Key? key}) : super(key: key);

  @override
  Widget getBuilder(BuildContext context, controller) {
    List<Widget> formFields = controller.formFields
        .map((formField) => UpsertFormFieldWidget(formField: formField))
        .toList();
    if (formFields.isNotEmpty) {
      formFields = [formFields.first] +
          formFields
              .sublist(1)
              .map((formField) => Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: formField,
                  ))
              .toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: formFields,
        ),
      ),
    );
  }
}
