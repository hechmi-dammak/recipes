import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/helpers/form_validators.dart';
import 'package:recipes/helpers/input_decoration.dart';
import 'package:recipes/widgets/common/custom_dialog.dart';
import 'package:recipes/widgets/common/loading_widget.dart';
import 'package:recipes/widgets/project/dialog_bottom.dart';
import 'package:recipes/widgets/project/image_picker_form_dialog.dart';
import 'package:recipes/widgets/project/upsert_element/upsert_element_controller.dart';

class UpsertElementDialog<T extends UpsertElementController>
    extends CustomDialog<bool> {
  const UpsertElementDialog({this.controller, super.key})
      : super(dismissible: false);
  final T? controller;

  @override
  Widget buildChild(BuildContext context) {
    return GetBuilder<T>(
        init: controller,
        builder: (controller) {
          return LoadingWidget(
            loading: controller.getLoading(),
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
                      child: AddElementForm<T>(),
                    ),
                  ),
                ),
                DialogBottom(
                  onConfirm: () => controller.confirm(close),
                  onCancel: () => close(false, true),
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
      return Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Name:'.tr,
              style: Get.textTheme.bodyLarge,
            ),
            const SizedBox(height: 7),
            TextFormField(
              controller: controller.nameController,
              style: Get.textTheme.bodyLarge,
              decoration: CustomInputDecoration(),
              validator: FormValidators.notEmptyOrNullValidator,
            ),
            const SizedBox(height: 15),
            Text(
              'Description:'.tr,
              style: Get.textTheme.bodyLarge,
            ),
            const SizedBox(height: 7),
            TextFormField(
              controller: controller.descriptionController,
              maxLines: null,
              style: Get.textTheme.bodyLarge,
              decoration: CustomInputDecoration(),
            ),
            const SizedBox(height: 15),
            ImagePickerFormDialog<T>()
          ],
        ),
      );
    });
  }
}
