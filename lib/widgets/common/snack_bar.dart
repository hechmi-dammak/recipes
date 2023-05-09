import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/service/logger_service.dart';

class CustomSnackBar {
  static const Duration _duration = Duration(milliseconds: 4000);
  static const bool _enabled = false;

  static void info(String text,
      {Duration duration = _duration,
      void Function(GetSnackBar snack)? onTap}) {
    LoggerService.logger?.i(text);
    if (!_enabled) return;
    Get.snackbar('', '',
        onTap: onTap,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
        titleText: Container(),
        messageText: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        duration: duration);
  }

  static void warning(String text,
      {Duration duration = _duration,
      void Function(GetSnackBar snack)? onTap}) {
    LoggerService.logger?.w(text);
    if (!_enabled) return;
    Get.snackbar('', text,
        onTap: onTap,
        margin: const EdgeInsets.all(10),
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
        colorText: Get.theme.colorScheme.onSecondary,
        duration: duration);
  }

  static void success(String text,
      {Duration duration = _duration,
      void Function(GetSnackBar snack)? onTap}) {
    LoggerService.logger?.i(text);
    if (!_enabled) return;
    Get.snackbar('Success', text,
        onTap: onTap,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
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
        duration: duration);
  }

  static void error(String text,
      {Duration duration = _duration,
      bool? isDismissible,
      void Function(GetSnackBar snack)? onTap}) {
    LoggerService.logger?.e(text);
    if (!_enabled) return;
    Get.snackbar('', text,
        onTap: onTap,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: duration,
        isDismissible: isDismissible);
  }
}
