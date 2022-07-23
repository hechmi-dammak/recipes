import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackBar {
  CustomSnackBar.success(String text) {
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
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Get.theme.colorScheme.onPrimary);
  }

  CustomSnackBar.error(String text) {
    Get.snackbar('', text,
        backgroundColor: Get.theme.errorColor,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Get.theme.colorScheme.onError);
  }

  CustomSnackBar.warning(String text) {
    Get.snackbar(text, '',
        backgroundGradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: const [
            0.0,
            1,
          ],
          colors: [
            Get.theme.colorScheme.secondaryContainer,
            Get.theme.colorScheme.secondary
          ],
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Get.theme.colorScheme.onSecondary);
  }
}
