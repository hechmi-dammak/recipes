import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/components/custom_dialog.dart';
import 'package:recipes/decorations/custom_input_decoration.dart';

class InputDialog extends CustomDialog {
  final TextEditingController controller=TextEditingController();
  final String label;
  final String title;
  final void Function(TextEditingController controller) confirm;

   InputDialog(
      {super.key,
      required this.label,
      required this.title,
      required this.confirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      contentPadding:
          const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Get.theme.colorScheme.primaryContainer, width: 3),
          borderRadius: const BorderRadius.all(Radius.circular(32.0))),
      title: Container(
        decoration: BoxDecoration(
            color: Get.theme.colorScheme.primaryContainer,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0))),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Center(
          child: Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Get.theme.colorScheme.onPrimary, fontSize: 25)),
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Get.theme.primaryColor, width: 3),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(32.0))),
              ),
              child: const Text(
                'cancel',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Get.theme.primaryColor, width: 3),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(32.0))),
              ),
              child: const Text(
                'confirm',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () => confirm(controller),
            ),
          ],
        )
      ],
      content: TextField(
        onSubmitted: (String value) => confirm(controller),
        controller: controller,
        decoration: CustomInputDecoration(label),
      ),
    );
  }
}

class ConfirmationDialog extends CustomDialog {
  const ConfirmationDialog(
      {super.key, required this.confirm, required this.title});

  final String title;
  final VoidCallback confirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      contentPadding:
          const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Get.theme.colorScheme.primaryContainer, width: 3),
          borderRadius: const BorderRadius.all(Radius.circular(32.0))),
      title: Container(
        decoration: BoxDecoration(
            color: Get.theme.colorScheme.primaryContainer,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0))),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Center(
          child: Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Get.theme.colorScheme.onPrimary, fontSize: 25)),
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Get.theme.primaryColor, width: 3),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(32.0))),
              ),
              child: const Text(
                'cancel',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Get.theme.primaryColor, width: 3),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(32.0))),
              ),
              child: const Text(
                'confirm',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Get.back();
                confirm();
              },
            ),
          ],
        )
      ],
    );
  }
}
