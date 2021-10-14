import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showInSnackBar(String value, {bool? status}) {
  Get.snackbar(
      status == null
          ? "Error:"
          : status
              ? "Success"
              : value,
      status == null || status == true ? value : "",
      backgroundColor: Colors.red,
      backgroundGradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        stops: const [
          0.1,
          0.9,
        ],
        colors: status == null
            ? [
                Theme.of(Get.context!).colorScheme.secondaryVariant,
                Theme.of(Get.context!).colorScheme.secondary
              ]
            : [
                Theme.of(Get.context!).colorScheme.primaryVariant,
                Theme.of(Get.context!).colorScheme.primary
              ],
      ),
      snackPosition: SnackPosition.BOTTOM,
      colorText: status == null
          ? Theme.of(Get.context!).colorScheme.onPrimary
          : Theme.of(Get.context!).colorScheme.onSecondary);
}
