import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/utils/decorations/input_decoration.dart';

void showDialogInput(
    {required TextEditingController controller,
    required String label,
    required String title,
    required Function confirm}) {
  Get.dialog(Scaffold(
    backgroundColor: Colors.transparent,
    body: AlertDialog(
      backgroundColor: Theme.of(Get.context!).colorScheme.secondary,
      title: Text(
        title,
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              child: const Text(
                'cancel',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Get.back();
                controller.clear();
              },
            ),
            TextButton(
              child: const Text(
                'confirm',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () async => confirm(),
            ),
          ],
        )
      ],
      content: TextField(
        onSubmitted: (String value) => confirm(),
        controller: controller,
        decoration: getInputDecoration(label),
      ),
    ),
  ));
}
