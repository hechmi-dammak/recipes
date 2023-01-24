import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/controller_decorator/interfaces/data_fetching_interface.dart';
import 'package:recipes/controller_decorator/interfaces/loading_interface.dart';
import 'package:recipes/controller_decorator/interfaces/selection_interface.dart';

abstract class Controller extends GetxController
    implements LoadingInterface, DataFetchingInterface, SelectionInterface {
  Controller? child;

  Controller({this.child});

  void decoratorUpdate({bool callChild = true}) {
    if (child != null && callChild) {
      child!.decoratorUpdate();
      return;
    }
    update();
  }

  @mustCallSuper
  void initState(GetBuilderState<Controller>? state, {bool callChild = true});
}
