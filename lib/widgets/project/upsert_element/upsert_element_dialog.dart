import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/widgets/common/custom_dialog.dart';
import 'package:recipes/widgets/common/loading_widget.dart';
import 'package:recipes/widgets/project/dialog_bottom.dart';
import 'package:recipes/widgets/project/upsert_element/controllers/upsert_element_controller.dart';
import 'package:recipes/widgets/project/upsert_element/widgets/upsert_form_field_widget.dart';

class UpsertElementDialog<T extends UpsertElementController>
    extends CustomDialog<bool> {
  const UpsertElementDialog({this.controller, super.key})
      : super(dismissible: false, withKeyboard: true);
  final T? controller;

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
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(6.5),
                          topLeft: Radius.circular(6.5)),
                      child: IntrinsicHeight(
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              child: AddElementForm<T>(),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: const [0.4, 1],
                                  colors: [
                                    Get.theme.colorScheme.primaryContainer,
                                    Get.theme.colorScheme.primaryContainer
                                        .withOpacity(0)
                                  ],
                                ),
                              ),
                              width: double.infinity,
                              height: 30,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    stops: const [0.4, 1],
                                    colors: [
                                      Get.theme.colorScheme.primaryContainer,
                                      Get.theme.colorScheme.primaryContainer
                                          .withOpacity(0)
                                    ],
                                  ),
                                ),
                                width: double.infinity,
                                height: 30,
                              ),
                            ),
                          ],
                        ),
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
  const AddElementForm({Key? key}) : super(key: key);

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
      return Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: formFields,
          ),
        ),
      );
    });
  }
}
