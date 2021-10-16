import 'package:flutter/material.dart';
import 'package:get/get.dart';

InputDecoration getInputDecorationInsideCard(String label,
    {required FocusNode focusNode, required String? value}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.only(left: 20),
    label: Container(
      margin: (focusNode.hasFocus || (value != null && value != ""))
          ? const EdgeInsets.only(top: 17)
          : const EdgeInsets.all(0),
      child: Text(label,
          style: TextStyle(
              fontSize: 20, color: Theme.of(Get.context!).primaryColor)),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
          width: 3, color: Theme.of(Get.context!).colorScheme.primary),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
          width: 3, color: Theme.of(Get.context!).colorScheme.primary),
      borderRadius: BorderRadius.circular(10),
    ),
    fillColor: Theme.of(Get.context!).backgroundColor,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
          width: 3, color: Theme.of(Get.context!).colorScheme.secondaryVariant),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

InputDecoration getInputDecorationInsideCardHint(String hint,
    {Widget? suffix}) {
  return InputDecoration(
    hintText: hint,
    suffixIcon: suffix,
    border: OutlineInputBorder(
      borderSide: BorderSide(
          width: 3, color: Theme.of(Get.context!).colorScheme.primary),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
          width: 3, color: Theme.of(Get.context!).colorScheme.primary),
      borderRadius: BorderRadius.circular(10),
    ),
    fillColor: Theme.of(Get.context!).backgroundColor,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
          width: 3, color: Theme.of(Get.context!).colorScheme.secondaryVariant),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
