import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes/controller_decorator/interfaces/data_fetching_interface.dart';
import 'package:recipes/controller_decorator/interfaces/loading_interface.dart';

abstract class Controller extends GetxController
    implements LoadingInterface, DataFetchingInterface {
  Controller? child;

  Controller({this.child});

  @mustCallSuper
  void initState(GetBuilderState<Controller> state, {callChild = true});
}
