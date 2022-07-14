import 'package:flutter/material.dart';
import 'package:get/get.dart';

InputDecoration getInputDecoration(String label,
    {EdgeInsetsGeometry? contentPadding}) {
  return InputDecoration(
    contentPadding: contentPadding,
    label: Text(label,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 20, color: Get.theme.primaryColor)),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 3, color: Get.theme.colorScheme.primary),
      borderRadius: BorderRadius.circular(10),
    ),
    fillColor: Get.theme.backgroundColor,
    filled: true,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 3, color: Get.theme.colorScheme.secondary),
    ),
  );
}
