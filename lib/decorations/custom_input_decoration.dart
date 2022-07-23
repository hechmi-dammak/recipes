import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomInputDecoration extends InputDecoration {
  CustomInputDecoration(String label, {EdgeInsetsGeometry? contentPadding})
      : super(
          contentPadding: contentPadding,
          label: Text(label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20, color: Get.theme.primaryColor)),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 3, color: Get.theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: Get.theme.backgroundColor,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 3, color: Get.theme.colorScheme.secondary),
          ),
        );

  CustomInputDecoration.insideCard(String label,
      {required FocusNode focusNode, required String? value})
      : super(
          contentPadding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
          label: Container(
            margin: (focusNode.hasFocus || (value != null && value.isNotEmpty))
                ? const EdgeInsets.only(top: 17)
                : const EdgeInsets.all(0),
            child: Text(label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20, color: Get.theme.primaryColor)),
          ),
          border: OutlineInputBorder(
            borderSide:
                BorderSide(width: 3, color: Get.theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 3, color: Get.theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: Get.theme.backgroundColor,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 3, color: Get.theme.colorScheme.secondaryContainer),
            borderRadius: BorderRadius.circular(10),
          ),
        );

  CustomInputDecoration.insideCardHint(String hint, {Widget? suffix})
      : super(
          prefixIcon: const Icon(Icons.search),
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 20),
          suffixIcon: suffix,
          border: OutlineInputBorder(
            borderSide:
                BorderSide(width: 3, color: Get.theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 3, color: Get.theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: Get.theme.backgroundColor,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 3, color: Get.theme.colorScheme.secondaryContainer),
            borderRadius: BorderRadius.circular(10),
          ),
        );
}
