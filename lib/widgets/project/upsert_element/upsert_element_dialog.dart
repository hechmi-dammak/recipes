import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/widgets/common/conditional_widget.dart';
import 'package:recipes/widgets/common/custom_dialog.dart';
import 'package:recipes/widgets/common/loading_widget.dart';
import 'package:recipes/widgets/project/dialog_bottom.dart';
import 'package:recipes/widgets/project/faded_scroll.dart';
import 'package:recipes/widgets/project/upsert_element/controllers/upsert_element_controller.dart';
import 'package:recipes/widgets/project/upsert_element/widgets/dialog_title.dart';
import 'package:recipes/widgets/project/upsert_element/widgets/upsert_element_form.dart';

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
            child: (context) => Container(
              decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6.5),
                  )),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConditionalWidget(
                      child: (context) => DialogTitle(title: controller.title!),
                      condition: controller.title != null),
                  FadedScroll(
                    child: UpsertElementForm<T>(),
                  ),
                  DialogBottom(
                    onConfirm: () => controller.confirm(close),
                    onCancel: () => controller.cancel(close),
                  )
                ],
              ),
            ),
          );
        });
  }
}
