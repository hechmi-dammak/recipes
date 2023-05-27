import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekla/widgets/common/getx/get_builder_view.dart';

mixin GetLayoutBuilderView<T extends GetxController> on GetBuilderView<T> {
  @override
  Widget getBuilder(BuildContext context, T controller) {
    return LayoutBuilder(builder: (context, constraints) {
      return getLayoutBuilder(context, controller, constraints);
    });
  }

  Widget getLayoutBuilder(
      BuildContext context, T controller, BoxConstraints constraints);
}
