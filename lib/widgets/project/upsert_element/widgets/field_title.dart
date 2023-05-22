import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldTitle extends StatelessWidget {
  const FieldTitle({super.key, required this.title, this.optional = false});

  final String title;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$title ',
          style: Get.textTheme.bodyLarge,
        ),
        if (optional)
          Text('(optional)'.tr,
              style: Get.textTheme.bodyLarge?.copyWith(fontSize: 10)),
        Text(
          '${optional ? ' ' : ''}:',
          style: Get.textTheme.bodyLarge,
        ),
      ],
    );
  }
}
