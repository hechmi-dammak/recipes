import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class CustomDialog<T> extends StatelessWidget {
  const CustomDialog({super.key});

  Future<T?> show([T? defaultResult]) async {
    return await Get.dialog<T>(Scaffold(
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: close,
            child: GestureDetector(onTap: () {}, child: this)),
        backgroundColor: Colors.transparent));
  }

  void close([T? defaultResult]) {
    Get.until((route) {
      return route.isCurrent;
    });
    Get.back<T>(result: defaultResult);
  }
}
