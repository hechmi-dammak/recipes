import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showInSnackBar(String value, BuildContext context) {
  Get.snackbar("Error:", value,
      backgroundGradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        stops: const [
          0.1,
          0.9,
        ],
        colors: [
          Theme.of(context).colorScheme.secondaryVariant,
          Theme.of(context).colorScheme.secondary
        ],
      ),
      snackPosition: SnackPosition.BOTTOM,
      colorText: Theme.of(context).errorColor);
}
