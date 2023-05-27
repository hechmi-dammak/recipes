import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract mixin class GetBuilderView<T extends GetxController> {
  String? get tag => null;

  T get controller => GetInstance().find<T>(tag: tag);

  T? get init => null;

  void initState(GetBuilderState<T> state) {}

  Widget build(BuildContext context) {
    return getBuilderNotToOverride(context);
  }

  Widget getBuilderNotToOverride(BuildContext context) {
    return GetBuilder<T>(
        init: init,
        tag: tag,
        initState: initState,
        builder: (controller) => getBuilder(context, controller));
  }

  @protected
  Widget getBuilder(BuildContext context, T controller);
}
