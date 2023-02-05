import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/widgets/common/custom_dialog.dart';
import 'package:recipes/widgets/common/loading_widget.dart';
import 'package:recipes/widgets/project/dialog_bottom.dart';
import 'package:recipes/widgets/project/upsert_element/controllers/upsert_element_controller.dart';
import 'package:recipes/widgets/project/upsert_element/widgets/upsert_form_field_widget.dart';

class UpsertElementDialog<T extends UpsertElementController>
    extends CustomDialog<bool> {
  const UpsertElementDialog({this.controller, super.key, this.aspectRatio = 2})
      : super(dismissible: false);
  final T? controller;
  final double aspectRatio;

  @override
  Widget buildChild(BuildContext context) {
    return GetBuilder<T>(
        init: controller,
        builder: (controller) {
          return LoadingWidget(
            loading: controller.loading,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Get.theme.colorScheme.primaryContainer,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(6.5),
                            topLeft: Radius.circular(6.5))),
                    padding: const EdgeInsets.all(30),
                    child: SingleChildScrollView(
                      child: AddElementForm<T>(
                        aspectRatio: aspectRatio,
                      ),
                    ),
                  ),
                ),
                DialogBottom(
                  onConfirm: () => controller.confirm(close),
                  onCancel: () => controller.cancel(close),
                )
              ],
            ),
          );
        });
  }
}

class AddElementForm<T extends UpsertElementController>
    extends StatelessWidget {
  const AddElementForm({Key? key, this.aspectRatio = 2}) : super(key: key);
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(builder: (controller) {
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

      return Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: formFields,
        ),
      );
    });
  }
}
