import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/decoration/input_decoration.dart';

void showDialogInput(
    {required TextEditingController controller,
    required String label,
    required String title,
    required Function confirm}) {
  Get.dialog(Scaffold(
    backgroundColor: Colors.transparent,
    body: AlertDialog(
      title: Text(
        title,
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              child: const Text('cancel'),
              onPressed: () {
                Get.back();
                controller.clear();
              },
            ),
            TextButton(
              child: const Text('confirm'),
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
