import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogTitle extends StatelessWidget {
  const DialogTitle({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: Get.textTheme.bodyLarge
                ?.copyWith(color: Get.theme.colorScheme.onPrimaryContainer),
          ),
        ),
        Divider(
            height: 1,
            indent: 10,
            endIndent: 10,
            thickness: 0.5,
            color: Get.theme.colorScheme.secondary.withOpacity(0.5))
      ],
    );
  }
}
