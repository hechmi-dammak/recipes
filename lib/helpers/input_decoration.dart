import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomInputDecoration extends InputDecoration {
  CustomInputDecoration({EdgeInsetsGeometry? contentPadding})
      : super(
          isDense: true,
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Get.theme.colorScheme.secondary),
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: Get.theme.colorScheme.primaryContainer,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Get.theme.colorScheme.primary),
          ),
        );
}
