import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/widgets/common/custom_dialog.dart';

class DescriptionDialog extends CustomDialog<void> {
  const DescriptionDialog(
      {super.key, required this.description, required this.title});

  final String description;
  final String title;

  @override
  Widget buildChild(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Get.theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(6.5)),
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Get.textTheme.bodyLarge
                ?.copyWith(color: Get.theme.colorScheme.onPrimaryContainer),
          ),
          Divider(
              thickness: 1, height: 25, color: Get.theme.colorScheme.secondary),
          LayoutBuilder(builder: (context, _) {
            return Container(
              constraints: BoxConstraints(maxHeight: Get.height * .45),
              child: SingleChildScrollView(
                child: Text(
                  description,
                  style: Get.textTheme.bodyMedium?.copyWith(
                      color: Get.theme.colorScheme.onPrimaryContainer),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
