import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackBar {
  static void success(String text) {
    Get.snackbar('Success', text,
        backgroundGradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: const [
            0.1,
            0.9,
          ],
          colors: [
            Get.theme.colorScheme.primaryContainer,
            Get.theme.colorScheme.primary
          ],
        ),
        snackPosition: SnackPosition.BOTTOM,
        colorText: Get.theme.colorScheme.onPrimary);
  }

  static void error(String text) {
    Get.snackbar('', text,
        backgroundColor: Get.theme.errorColor,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Get.theme.colorScheme.onError);
  }

  static void warning(String text) {
    Get.snackbar('', text,
        backgroundGradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: const [
            0.1,
            0.9,
          ],
          colors: [
            Get.theme.colorScheme.secondaryContainer,
            Get.theme.colorScheme.secondary
          ],
        ),
        snackPosition: SnackPosition.BOTTOM,
        colorText: Get.theme.colorScheme.onSecondary);
  }
}
