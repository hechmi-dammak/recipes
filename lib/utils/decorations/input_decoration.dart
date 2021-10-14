import 'package:flutter/material.dart';
import 'package:get/get.dart';

InputDecoration getInputDecoration(String label) {
  return InputDecoration(
    label: Text(label,
        style: TextStyle(
            fontSize: 20, color: Theme.of(Get.context!).primaryColor)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
          width: 3, color: Theme.of(Get.context!).colorScheme.primary),
      borderRadius: BorderRadius.circular(10),
    ),
    fillColor: Theme.of(Get.context!).backgroundColor,
    filled: true,
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
          width: 3, color: Theme.of(Get.context!).colorScheme.secondary),
    ),
  );
}
