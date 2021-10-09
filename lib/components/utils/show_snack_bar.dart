import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showInSnackBar(String value, {bool status = false}) {
  Get.snackbar(status ? "Success" : "Error:", value,
      backgroundColor: Colors.red,
      backgroundGradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        stops: const [
          0.1,
          0.9,
        ],
        colors: status
            ? [
                Theme.of(Get.context!).colorScheme.primaryVariant,
                Theme.of(Get.context!).colorScheme.primary
              ]
            : [
                Theme.of(Get.context!).colorScheme.secondaryVariant,
                Theme.of(Get.context!).colorScheme.secondary
              ],
      ),
      snackPosition: SnackPosition.BOTTOM,
      colorText: status
          ? Theme.of(Get.context!).colorScheme.onPrimary
          : Theme.of(Get.context!).colorScheme.onSecondary);
}
