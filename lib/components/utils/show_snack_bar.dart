import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showInSnackBar(String value, {bool status = false}) {
  Get.snackbar(status ? "Success" : "Error:", value,
      backgroundGradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        stops: const [
          0.1,
          0.9,
        ],
        colors: [
          Theme.of(Get.context!).colorScheme.secondaryVariant,
          Theme.of(Get.context!).colorScheme.secondary
        ],
      ),
      snackPosition: SnackPosition.BOTTOM,
      colorText: status
          ? Theme.of(Get.context!).primaryColor
          : Theme.of(Get.context!).errorColor);
}
