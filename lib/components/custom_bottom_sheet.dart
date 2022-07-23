import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class CustomBottomSheet<T> extends StatelessWidget {
  const CustomBottomSheet({super.key});

  Future<T?> show([T? defaultResult]) async {
    return await Get.bottomSheet<T>(
      this,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
    );
  }

  void close([T? defaultResult]) {
    Get.until((route) {
      return route.isCurrent;
    });
    Get.back<T>(result: defaultResult);
  }
}
