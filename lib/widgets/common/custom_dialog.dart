import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/widgets/common/conditional_widget.dart';

mixin CustomDialog<T> on StatelessWidget {
  bool get dismissible => true;

  bool get withKeyboard => false;

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
  Widget dialogBuilder(BuildContext context);

  Widget dialogBuilderNotToOverride(BuildContext context) {
    return LayoutBuilder(builder: (context, _) {
      return ConditionalWidget(
        condition: Get.height < 450 && withKeyboard,
        child: (context) => Dialog.fullscreen(
            backgroundColor: Colors.transparent, child: dialogBuilder(context)),
        secondChild: (context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: dialogBuilder(context));
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return dialogBuilderNotToOverride(context);
  }
}
