import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:recipes/decorator/controller.dart';

abstract class DataFetchingInterface {
  Future<void> fetchData();

  @protected
  @mustCallSuper
  Future<void> loadData();

  @mustCallSuper
  void initState(GetBuilderState<Controller>? state);
}
