import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class CustomDialog<T> extends StatelessWidget {
  const CustomDialog({
    super.key,
    this.dismissible = true,
  });

  final bool dismissible;

  Future<T?> show([T? defaultResult]) async {
    return await Get.dialog<T>(Scaffold(
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => close(defaultResult),
            child: GestureDetector(onTap: () {}, child: this)),
        backgroundColor: Colors.transparent));
  }

  void close([T? result, bool forceClose = false]) {
    if (dismissible || forceClose) {
      Get.until((route) {
        return route.isCurrent;
      });
      Get.back<T>(result: result);
    }
  }
}
