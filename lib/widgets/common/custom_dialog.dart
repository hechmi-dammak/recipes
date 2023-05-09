import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/widgets/common/conditional_widget.dart';

abstract class CustomDialog<T> extends StatelessWidget {
  const CustomDialog(
      {super.key, this.dismissible = true, this.withKeyboard = false});

  final bool dismissible;
  final bool withKeyboard;

  Future<T?> show([T? defaultResult]) async {
    return await Get.dialog<T>(Scaffold(
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => close(defaultResult),
            child: GestureDetector(child: this)),
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

  @protected
  Widget buildChild(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, _) {
      return ConditionalWidget(
        condition: Get.height < 450 && withKeyboard,
        child: (context) => Dialog.fullscreen(
            backgroundColor: Colors.transparent, child: buildChild(context)),
        secondChild: (context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: buildChild(context));
        },
      );
    });
  }
}
