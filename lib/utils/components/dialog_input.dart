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
      titlePadding: const EdgeInsets.all(0),
      contentPadding:
          const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Theme.of(Get.context!).colorScheme.primaryVariant,
              width: 3),
          borderRadius: const BorderRadius.all(Radius.circular(32.0))),
      backgroundColor: Theme.of(Get.context!).colorScheme.secondary,
      title: Container(
        decoration: BoxDecoration(
            color: Theme.of(Get.context!).colorScheme.primaryVariant,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0))),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Text(title,
              style: TextStyle(
                  color: Theme.of(Get.context!).colorScheme.onPrimary,
                  fontSize: 25)),
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Theme.of(Get.context!).primaryColor, width: 3),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(32.0))),
              ),
              child: const Text(
                'cancel',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Get.back();
                controller.clear();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Theme.of(Get.context!).primaryColor, width: 3),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(32.0))),
              ),
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
