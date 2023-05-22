import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mekla/decorator/controller.dart';

mixin DataFetchingDecorator on Controller {
  @override
  Future<void> fetchData() async {
    loading = true;
    await loadData();
    loading = false;
  }

  @override
  void initState(GetBuilderState<Controller>? state) {
    fetchData();
  }

  @mustCallSuper
  @override
  Future<void> loadData() async {}
}
